---
title: Build a Real-time Game on Carina
description: Use Carina by Rackspace and Docker to build a scalable, real-time game server
date: 2016-02-22
comments: true
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
authorIsRacker: true
published: true
excerpt: |
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

Finally, we need somewhere to store all of our game data and statistics. Because we want to stream statistics to our players live, the [Changefeeds functionality](https://rethinkdb.com/docs/changefeeds/ruby/) of **RethinkDB** are particularly appealing. Decision made.

Whew, that was a lot of decisions to make! Here’s a visual recap of all the elements of our full-stack game and how they’ll be communicating with one another.

![Tic-Tac-Toe game technical stack]({% asset_path 2016-02-22-build-real-time-game-carina/game-stack.png %})

### Show me some code!
