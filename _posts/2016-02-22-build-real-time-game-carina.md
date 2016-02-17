---
title: Build a Real-time Game on Carina
description: Use Carina by Rackspace and Docker to build a scalable, real-time game server
date: 2016-02-22
comments: true
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
authorIsRacker: true
published: true
excerpt: |
  **TL;DR:** [Play the game](https://tictac.io/)

  Some would say that using Docker is all the fun a person needs in their life. OK, maybe they don’t say that. But as a web developer, building applications in container environments is about as much fun as you can have while still telling your boss that you’re “working”. We’ve seen existing game servers like [Minecraft](/blog/deploying-and-building-minecraft-as-a-service/) get ported to Carina, but I wanted to explore the process of building a game from scratch to run on a Docker Swarm cluster from Carina.

  First, the big question: **what game should we build?**
categories:
 - Docker
 - Carina
---

{{ page.excerpt }}

![List of games]({% asset_path 2016-02-22-build-real-time-game-carina/choose-game.jpg %})

While I could have set off to build the next Fallout 4 or tried to give [AlphaGo](http://deepmind.com/alpha-go.html) a run for its money, I decided to temper my excitement and build a game with simple rules that would still benefit from a real-time multiplayer experience. When it comes to games, what’s simpler than tic-tac-toe? That's it, the task is set: **We’re going to build a web-based tic-tac-toe game where people can play against each other in real-time.** For bonus points, players will also be able to see real-time stats about all the games currently being played.

### Planning the stack

Let's start at the front. The technology choices are fairly obvious here: We’ll use the **Canvas API** to efficiently draw the game board. We’ll use **WebSockets** to facilitate two-way communications between the player’s web browser and the game server. For the simplicity of the demo, we’re not going to worry about creating a fallback for browsers that don’t support WebSockets, but if you want to support IE9 or IE8, you’ll definitely want a way to gracefully degrade the experience for those users.

The WebSocket clients in the browser need something to talk to, of course. We’ll be using **Node.js** and the [`ws`](https://www.npmjs.com/package/ws) library to handle WebSocket communications with players. Now, WebSockets are sort of notorious for slowing down and taking up lots of memory when handling many concurrent connections. To address this potential bottleneck (for when our game inevitably goes viral), let’s plan on having several of these WebSocket handlers available, load-balanced behind **NGINX**. This same Node.js application will also be responsible for storing game data in our database.

Load-balancing WebSockets gets a little tricky, because WebSockets can only be stored in memory on whichever server initially opened the connection. This would be problematic when _Server A_ needs to notify all the players in a game of an update. If one of the game’s players is connected to _Server B_, _Server A_ has no way to directly communicate with that player. To address this, we’ll have all the game servers connect to a shared **Redis** instance and use the [Pub/Sub pattern](http://redis.io/topics/pubsub) to ensure messages find their way to the player, regardless of which server they’re connected to.

Finally, we need somewhere to store all of our game data and statistics. Because we want to stream statistics to our players live, the [Changefeeds functionality](https://rethinkdb.com/docs/changefeeds/ruby/) of **RethinkDB** is particularly appealing. Decision made.

Whew, that was a lot of decisions to make! Here’s a visual recap of all the elements of our full-stack game and how they’ll be communicating with one another.

![Tic-Tac-Toe game technical stack]({% asset_path 2016-02-22-build-real-time-game-carina/game-stack.png %})

### Implementation details

The source code for the entire application is [available on GitHub](https://github.com/ktbartholomew/tic-tac-toe) if you’d like to read through it in more detail. Here are some of the highlights.

#### Standardize WebSocket messages

WebSockets are _super_-easy to use in the browser, and have a very small API. Creating and using a WebSocket connection is a simple as:

```javascript
var socket = new WebSocket(webSocketURL);

socket.addEventListener('message', function (message) {
  console.log('Server says: %s', message);
});

socket.send('hello');
```

The only event that will ever be fired when receiving a message from the WebSocket server is the `onmessage` event. The contents of the message are completely arbitrary, so we need to create a protocol of some kind for our messages. We’re going to borrow an idea from the JavaScript library [Redux](http://redux.js.org/) and standardize all of our messages around a simple, flexible schema:

```json
{
  "action": "actionName",
  "data": {}
}
```

All messages between the client and server will be a JSON document like the above, with an `action` string property and a `data` object property. The WebSocket handler calls a specific function based on the value of `action`, and passes `data` as an argument to that function. We’re using this pattern in both the browser and server.

#### WebSocket Pub/Sub

Because our application will have several load-balanced WebSocket handlers, we can’t be certain which individual server is handling a given client’s WebSocket connection. However, we still need to be able to ensure that messages initiated by one server (such as a player’s move in a game) is sent to clients that may be connected to a different server. This situation is a good fit for the [Publish–subscribe pattern](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern), which relieves us of the burden of needing to know exactly which clients are connected to which servers.

When a browser opens a WebSocket connection to one of our game servers, the server assigns that connection a randomly-generated UUID. The server then _subscribes_ to a channel on the Redis server using the player's UUID and sends any messages it receives on that channel back to the player:

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

Whenever a game server needs to send a message to a player, it _publishes_ a message to Redis server using the UUID of the player it wants to reach:

```javascript
// The server subscribing to sockets:{socketId} will see this message and relay
// it to its connected WebSocket client.
redisClient.publish('sockets:' + socketId, JSON.stringify(message));
```

#### Database “schema”

JSON document stores like [MongoDB](https://www.mongodb.org/) and [RethinkDB](http://rethinkdb.com/) don’t technically have schemas, but in our case we want all of our documents to be consistent so we can reason about the data. Each game that is played on the system is stored as a single JSON document. The document for an in-progress game with 2 moves looks something like this:

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

We also have a small table of stats, in which each document is essentially just a named counter:

```json
{
  "id": "totalGames",
  "value": 470
}
```

As changes are written to this table, they are also streamed to each of the WebSocket servers and then to the connected players. This real-time “changefeed” is one of the key features of RethinkDB and is trivial to implement on the server (seriously, it worked the first time I tried it and I almost fell under my standing desk. [Did I mention I use a standing desk?](https://twitter.com/iamdevloper/status/597794173513834497))

```javascript
r.table('stats').changes().run(conn)
.then(function (cursor) {
  // Do whatever you want, I don't care, they're your oats.
});
```

### Deploy the game to Carina
