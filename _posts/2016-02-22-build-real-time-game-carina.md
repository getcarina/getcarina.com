---
title: Build a real-time game on Carina
description: Use Carina by Rackspace and Docker to build a scalable, real-time game server
date: 2016-02-22
comments: true
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
authorIsRacker: true
published: true
excerpt: |
  **TL;DR:** [Play the game](https://tictac.io/)

  Some people might say that using Docker is all the fun you need in your life. OK, maybe no one says that. But for a web developer, building applications in container environments is about as much fun as you can have while still telling your boss that you’re “working”. Members of our community have ported existing game servers like [Minecraft](/blog/deploying-and-building-minecraft-as-a-service/) to Carina, but I wanted to explore the process of building a game from scratch to run on a Docker Swarm cluster from Carina.

  First, the big question: **What game should I build?**
categories:
 - Docker
 - Carina
---

{{ page.excerpt }}

![List of games]({% asset_path 2016-02-22-build-real-time-game-carina/choose-game.jpg %})

Although I could have tried to build the next Fallout 4 or tried to give [AlphaGo](http://deepmind.com/alpha-go.html) a run for its money, I decided to temper my excitement and build a game with simple rules that would still benefit from a real-time multiplayer experience. And when it comes to games, what’s simpler than tic-tac-toe? That’s it, the task is set: **Build a [web-based tic-tac-toe game](https://tictac.io/) where people can play against each other in real-time.** For bonus points, players will also be able to see real-time statistics about all the games currently being played.

### Planning the stack

Let’s start at the front. The technology choices are fairly obvious here: use the **Canvas API** to efficiently draw the game board, and use **WebSockets** to facilitate two-way communications between the player’s web browser and the game server. For the simplicity of the demo, we won’t create a fallback for browsers that don’t support WebSockets, but if you want to support IE9 or IE8, you’ll definitely want a way to gracefully degrade the experience for those users.

The WebSocket clients in the browser need something to talk to, of course. We’ll use **Node.js** and the [`ws`](https://www.npmjs.com/package/ws) library to handle WebSocket communications with players. Now, WebSockets are notorious for slowing down and taking up lots of memory when handling many concurrent connections. To address this potential bottleneck (for when the game inevitably goes viral), let’s plan on having several of these WebSocket handlers available, load-balanced behind **NGINX**. This same Node.js application will also be responsible for storing game data in a database.

Load-balancing WebSockets gets a little tricky, because the connection itself is only stored on the server that initially accepted the connection. This would be problematic when Server A needs to notify all the players in a game of an update, but one of the game’s players is connected to Server B—Server A has no way to directly communicate with the players on other servers. To address this, all the Node.js containers will connect to a shared **Redis** instance and use the [publish-subscribe pattern](http://redis.io/topics/pubsub) to ensure that messages find their way to the right players, regardless of which server each player is connected to.

Finally, we need somewhere to store all of our game data and statistics. Because we want to stream statistics to our players live, the [changefeeds feature](https://rethinkdb.com/docs/changefeeds/javascript/) of **RethinkDB** is particularly appealing.

Here’s a visual recap of all the elements of the full-stack game and how they’ll be communicating with one another.

![Tic-Tac-Toe game technical stack]({% asset_path 2016-02-22-build-real-time-game-carina/game-stack.png %})

### Implementation details

The source code for the entire application is [available on GitHub](https://github.com/ktbartholomew/tic-tac-toe) if you’d like to read through it in more detail. Following are some of the highlights.

#### Standardize WebSocket messages

WebSockets are very easy to use in the browser, and have a very small API. Creating and using a WebSocket connection is a simple as this:

```javascript
var socket = new WebSocket(webSocketURL);

socket.addEventListener('message', function (message) {
  console.log('Server says: %s', message);
});

socket.send('hello');
```

The only event that will be fired when a message is received from the WebSocket server is the `onmessage` event. The contents of the message are completely arbitrary, so we need to create a protocol of some kind for our messages. I’ll borrow an idea from the JavaScript library [Redux](http://redux.js.org/) and standardize all of the messages around a simple, flexible schema:

```json
{
  "action": "actionName",
  "data": {}
}
```

All messages between the client and server will be a JSON document like this one, with an `action` string property and a `data` object property. The WebSocket handler calls a specific function based on the value of `action` and passes `data` as an argument to that function. We’re using this pattern in both the browser and server.

#### WebSocket publish-subscribe

Because the application will have several load-balanced WebSocket handlers, we can’t be certain which individual server is handling a given client’s WebSocket connection. However, we still need to ensure that messages initiated by one server (such as a player’s move in a game) are sent to clients that might be connected to different servers. This situation is a good fit for the [publish–subscribe pattern](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern), which distributes messages to the entire cluster, without knowing which clients are connected to which servers.

When a browser opens a WebSocket connection to one of the game servers, the server assigns that connection a randomly generated UUID. The server then _subscribes_ to a channel on the Redis server by using the player’s UUID, and sends any messages it receives on that channel back to the player:

```javascript
// `this` is an object representing an open WebSocket connection

// Subscribe to (for example) sockets:7100957a-92f6-4c1d-84f5-52c9ac7e0d52
this.redisClient.subscribe('sockets:' + this.id);
this.redisClient.on('message', function (message) {
  // Messages received in this channel are intended specifically for the user
  // with this UUID.
  this.socket.send(message);
});
```

Whenever a game server needs to send a message to a player, it _publishes_ a message to the Redis server by using the UUID of the player it wants to reach:

```javascript
// The server subscribing to sockets:{socketId} will see this message and relay
// it to its connected WebSocket client.
redisClient.publish('sockets:' + socketId, JSON.stringify(message));
```

#### Database “schema”

JSON document stores like [MongoDB](https://www.mongodb.org/) and [RethinkDB](http://rethinkdb.com/) don’t technically have schemas, but we want all of our documents to be consistent so we can reason about the data. Each game that is played on the system is stored as a single JSON document. The document for an in-progress game with two moves looks something like this:

```json
{
  "grid": [
    [
      "x",
      null,
      null
    ],
    [
      null,
      "o",
      null
    ],
    [
      null,
      null,
      null
    ]
  ],
  "id": "00dbd06a-295b-4f83-9feb-bc8e1216d57f",
  "next": "x",
  "players": [
    {
      "socketId": "7100957a-92f6-4c1d-84f5-52c9ac7e0d52",
      "team": "x"
    },
    {
      "socketId": "52d58cad-da9c-417c-9fe0-3346cf5c189e",
      "team": "o"
    }
  ],
  "status": "in-progress",
  "totalMoves": 2,
  "winner": null
}
```

We also have a small table of statistics, in which each document is essentially just a named counter:

```json
{
  "id": "totalGames",
  "value": 470
}
```

As changes are written to this table, they are also streamed to each of the WebSocket servers and then to the connected players. This real-time changefeed is one of the key features of RethinkDB and is trivial to implement on the server. (Seriously, it worked the first time I tried it and I almost fell under my standing desk. [Did I mention I use a standing desk?](https://twitter.com/iamdevloper/status/597794173513834497))

```javascript
r.table('stats').changes().run(conn)
.then(function (cursor) {
  // Do whatever you want, I don’t care, they’re your oats.
});
```

This is what a user sees as the `stats` table is updated and streamed in real-time:

![Game statistics increasing]({% asset_path 2016-02-22-build-real-time-game-carina/tic-tac-toe-stats.gif %})

### Deploy the game to Carina

Finally, the part you’ve been waiting for! Let’s build and run containers so you can run this full-stack, real-time game on your own Docker Swarm cluster. If you’ve been following along in the source code, you might have noticed the `script/` directory, which is [full of Bash scripts](https://github.com/ktbartholomew/tic-tac-toe/tree/master/script). This folder contains all the commands that you need to go from an empty Carina cluster to a running application. We’ll be going through most of them here. All of these commands assume that you’re running them from the root directory of the [GitHub repo](https://github.com/ktbartholomew/tic-tac-toe) and have [configured your terminal environment](https://github.com/ktbartholomew/tic-tac-toe#installation) correctly.

**Before you start:** The application depends on [overlay networks](https://docs.docker.com/engine/userguide/networking/dockernetworks/#an-overlay-network), a feature that was [recently added](/blog/overlay-networks/) to Carina. You need to use a Carina cluster that was created _after_ February 15, 2016, to have this feature and run this application.

1. **Create the overlay network.** Several containers in the application connect to this network, which allows them to communicate across a large Swarm cluster without explicit linking or convoluted `affinity` declarations.

    ```bash
    docker network create \
    --driver overlay \
    --subnet 192.168.0.0/24 \
    tictactoe
    ```

1. **Create data volume containers.** [data volume containers](/docs/tutorials/data-volume-containers/) are used to store RethinkDB data, Redis data, NGINX config files, Let’s Encrypt certificates, NGINX htpasswd files, and the front-end assets. Create all of the containers at once:

    ```bash
    docker run --name ttt_db_data --volume /data rethinkdb /bin/true

    docker run --name ttt_redis_data --volume /data redis /bin/true

    # This is the first container we build that the NGINX container will depend
    # on. The node affinity here will ensure that all the other containers, as
    # well as the running NGINX container, are always scheduled on the same node
    # (and thus the same public IP).
    docker run --name ttt_nginx_config_data --env    constraint:node==/n1/ \
      --volume /etc/nginx/conf.d nginx /bin/true

    # All the containers that NGINX will use need to be on the same Swarm host
    docker run --name ttt_htpasswd_data \
      --env affinity:container==ttt_nginx_config_data \
      --volume /etc/nginx/htpasswd nginx /bin/true

    docker run --name ttt_frontend_data \
      --env affinity:container==ttt_nginx_config_data \
      --volume /usr/share/nginx/html nginx /bin/true
    ```
1. **Set the RethinkDB web password.** The `${NGINX_RETHINKDB_PASS}` environment variable is written to an Apache-style password file and used by the NGINX container to restrict access to the RethinkDB web console. If the password is empty, the NGINX container doesn’t proxy any traffic to RethinkDB. This is the most secure option if you don’t want anyone to access the RethinkDB web console.

    ```bash
    docker run --rm \
      --volumes-from ttt_htpasswd_data \
      httpd \
      htpasswd -bc /etc/nginx/htpasswd/rethinkdb rethinkdb ${NGINX_RETHINKDB_PASS}
    ```

1. **Start the RethinkDB server.** Use `--net tictactoe` to add the container to the overlay network we created earlier.

    ```bash
    docker run \
      --detach \
      --name ttt_db \
      --env affinity:container==ttt_db_data \
      --net tictactoe \
      --restart always \
      --volumes-from ttt_db_data \
      rethinkdb
    ```

1. **Create tables and indexes in RethinkDB.** Create these before the game servers spin up, so that the necessary tables and indexes are already in place.

    ```bash
    docker build -t ttt_db_schema ./db-schema

    docker run --rm -it --net tictactoe --env DB_HOST=ttt_db ttt_db_schema
    ```

1. **Start the Redis server.** `--net tictactoe` connects the container to the overlay network.

    ```bash
    docker run \
      --detach \
      --name ttt_redis \
      --env affinity:container==ttt_redis_data \
      --net tictactoe \
      --volumes-from ttt_redis_data \
      redis
    ```

1. **Compile the front-end assets and copy them to their data volume container.**

    ```bash
    ./frontend/script/compile-assets

    cd ./frontend/src

    docker cp ./ ttt_frontend_data:/usr/share/nginx/html/
    ```

1. **Build the custom images for the game server and NGINX proxy.**

    ```bash
    docker build -t ttt_app ./app/

    docker build \
      --build-arg affinity:container==ttt_nginx_config_data \
      -t ttt_nginx_proxy ./nginx/
    ```

1. **Start a few Node.js containers.** [`script/start-app`](https://github.com/ktbartholomew/tic-tac-toe/blob/master/script/start-app) helps you start multiple containers in a blue/green deployment pattern. Each container is connected to the overlay network with `--net tictactoe` Here’s what it’s doing:

    ```bash
    #!/bin/bash

    # Usage example: script/start-app 3 blue
    scale=${1:-1}
    color=${2}

    for i in $(seq 1 ${scale}); do
      docker run \
      -d \
      --label color=${color} \
      --name=ttt_app_${color}_${i} \
      -e affinity:image==ttt_app \
      -e REDIS_HOST=ttt_redis \
      -e RETHINKDB_HOST=ttt_db \
      --net tictactoe \
      --restart=always \
      ttt_app
    done;
    ```

    Run `script/start-app 2 blue` to start two Node.js containers with the “blue” deployment label.

1. **Add the Node.js containers to the NGINX configuration file.** [`script/update-nginx`](https://github.com/ktbartholomew/tic-tac-toe/blob/master/script/update-nginx), invoked as `script/update-nginx [blue|green]` is a Node.js script that finds all the running game servers (filtering by the color argument if provided), adds them to an `upstream` load-balancing block in the NGINX configuration, and sends a SIGHUP signal to the NGINX container to have it reload the updated configuration.

    Run `script/update-nginx blue` to add all of the “blue” Node.js containers you just created to the NGINX configuration file.

1. **Start the NGINX container.** Add it to the overlay network so it can access all the other running containers. That’s especially important for this container because it proxies traffic to several of the other running containers. It also needs `affinity:container` arguments to ensure that it is scheduled on the same node as all the data volume containers that it needs to access. Publish its ports 80 and 443 (HTTP and HTTPS) on the Swarm host so it’s publicly accessible.

    ```bash
    docker run \
      -d \
      --name ttt_nginx_proxy_1 \
      -p 443:443 \
      -p 80:80 \
      --env affinity:container==ttt_frontend_data \
      --env affinity:container==ttt_nginx_config_data \
      --env affinity:container==ttt_htpasswd_data \
      --env affinity:container==ttt_letsencrypt_data \
      --net tictactoe \
      --restart always \
      --volumes-from ttt_frontend_data \
      --volumes-from ttt_nginx_config_data \
      --volumes-from ttt_htpasswd_data \
      --volumes-from ttt_letsencrypt_data \
      ttt_nginx_proxy
    ```

1. **Get the public IP address of the NGINX proxy container.**

    ```bash
    docker port ttt_nginx_proxy_1
    ```

    After you have the public IP address of that container, visit it in your browser (use two tabs to play against yourself) and [enjoy a game of tic-tac-toe](https://tictac.io/)!

    ![Tic Tac Toe Web UI]({% asset_path 2016-02-22-build-real-time-game-carina/web-ui.png %})

This is probably a bad time to tell you that you could have run `script/setup` from the GitHub repo and done all of that work in about 30 seconds. But if you had just run that one script, you wouldn’t know all the cool stuff happening behind the scenes. Hooray you, for being well-informed!

### Next steps

You’ve just created a fairly complex application on Carina, taking advantage of the new overlay networking feature to make communicating between containers easier than ever. The application as it stands should be able to handle quite a bit of traffic, thanks to the performance characteristic inherent in each of the components. So what’s next?

* [**Improve the bot.**](https://github.com/ktbartholomew/tic-tac-toe/issues/1) The GitHub repo [includes a bot](https://github.com/ktbartholomew/tic-tac-toe/tree/master/bot) to facilitate load testing, or just to prevent you from having to play against yourself. The bot was hastily written, occasionally it just stops playing. Improving this bot could help you test the application under heavy load, or give you a chance to flex your machine-learning muscles.
* [**Scale the database.**](https://github.com/ktbartholomew/tic-tac-toe/issues/2) The single RethinkDB container has its limitations, but RethinkDB clustering and data sharding are fairly easy to implement in a container environment. Try dynamically scaling the database and ensuring data availability as cluster members come and go.
* [**Build a more resilient messaging system.**](https://github.com/ktbartholomew/tic-tac-toe/issues/3) The current messaging system is 100% ephemeral, meaning it’s very likely that a subscriber will not receive a published message, the client will never receive the message, and their game could potentially be stuck forever. Try building a messaging system that’s more resistant to network hiccups and heavy load.
