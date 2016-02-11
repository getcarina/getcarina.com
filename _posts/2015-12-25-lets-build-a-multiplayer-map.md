---
title: "Fallout 4 Service Discovery and Relay"
date: 2015-11-20 18:00
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  Let's make a multi-player map for Fallout 4!
categories:
 - nodejs
 - React
 - RxJS
 - Webpack
 - socket.io
 - Fallout 4
authorIsRacker: true
---

<!-- TODO: show the final multiplayer map -->

We've done [Pip-Boy discovery and relay]({{site.baseurl}}/blog/fallout-4-service-discovery-and-relay/) and
[created new libraries]({{site.baseurl}}/blog/decoding-the-pipboy-database-with-vault-community/). Now let's put them to good use. The first half of this tutorial does *not* require having
a copy of Fallout 4, since we'll start by simulating data.

Things we'll cover:

* Simulating data
* Observables and RxJS
* Drawing on canvas
* React
* Socket.io
* Deployment

## Generating Random Players

Go ahead and setup a new project for this, by creating a new directory, changing to that directory, and running `npm init`. You can accept the defaults if you like, or mix it up.

```bash
mkdir multi-pip-fun
cd multi-pip-fun
npm init
```

We're here to make a map of players, so let's start off by generating some
random players. We're going to get the list of player names that codsworth can
speak from.

For this tutorial, I'll use the package `clean-codsworth-names`. You can install
it too:

```bash
npm install --save clean-codsworth-names
```

You can also use the raw list, which has plenty of words to make the juvenile in
us giggle.

```bash
npm install --save codsworth-names
```

We can go ahead and create `fakes.js` now, setting up new players and where they
are on the map.

```javascript
const codsworthNames = require('clean-codsworth-names')
const mapSize = 2048

// newPlayer creates a new player with a name and some random coordinates
function newPlayer(name) {
  return {
    name: name,
    x: Math.round(Math.random() * (mapSize - 1)),
    y: Math.round(Math.random() * (mapSize - 1)),
  }
}

// create a set of players with coordinates
const players = codsworthNames.map(newPlayer)

// Just to try this out, print out a few of these
console.log(players.slice(0, 4))
```

```bash
$ node fakes.js
[ { name: 'Aaliyah', x: 533, y: 81 },
  { name: 'Aaron', x: 612, y: 1091 },
  { name: 'Abigail', x: 422, y: 1918 },
  { name: 'Abram', x: 210, y: 541 } ]
```

While we're at it, let's give each of these players a unique ID and provide
an adjective for their name (e.g. Crazy Dave):

```bash
npm install --save uuid adjectives
```

Go ahead and `require` these libraries and modify `newPlayer`:

```javascript
const uuid = require('uuid')
const adjectives = require('adjectives')

// Upper case the names
const Adjectives = adjectives.map(adj => {
  return adj.charAt(0).toUpperCase() + adj.slice(1)
})

function newPlayer(name) {
  const adj = Adjectives[Math.floor(Math.random() * Adjectives.length)];

  return {
    name: `${adj} ${name}`,
    x: Math.round(Math.random() * (mapSize - 1)),
    y: Math.round(Math.random() * (mapSize - 1)),
  }
}
```

We've got some interesting characters already

```javascript
$ node fakes.js
[ { name: 'Exultant Aaliyah', x: 113, y: 403 },
  { name: 'Responsible Aaron', x: 1840, y: 1228 },
  { name: 'Impartial Abigail', x: 704, y: 1093 },
  { name: 'Small Abram', x: 223, y: 1163 } ]
```

## Going on a Random Walk

How could we simulate players moving?

By taking our players on a [random walk](https://en.wikipedia.org/wiki/Random_walk).
On each iteration of our simulation, we'll add 1, 0, or -1 to the player's x
and y positions.

![let's go on a stroll](http://i.imgur.com/LeTMQV9.png)

There are a few ways to do this and we'll rely on some mathematical properties to
make this fast.

We can randomly acquire 0 and 1 by using `Math.round(Math.random())`. To get -1,
we can use the mathematical property that `cos(π) = -1` and `cos(0) = 1`. Multiply
that by `Math.round(Math.random())` and we have a nice little formula for generating
-1, 0, and 1.

```javascript
const change = Math.cos(Math.PI * Math.round(Math.random())) // -1 or 1
               * Math.round(Math.random()); // 0 or 1
```

Now we just have to apply it to a given point

```javascript
// Random walk -1, 0, 1
function walk(pt) {
  const change = Math.cos(Math.PI * Math.round(Math.random())) // -1 or 1
                 * Math.round(Math.random()) // 0 or 1
  const newPt = pt + change
  if (newPt < 0 || newPt >= mapSize) {
    return pt
  }
  return newPt
}
```

Try it out on one of the characters by appending this to the end of fake.js:

```javascript
const player = players[0]
console.log(player)
player.x = walk(player.x)
player.y = walk(player.y)
console.log(player)
```

```
$ node fakes.js
{ name: 'Mountainous Aaliyah', x: 312, y: 1506 }
{ name: 'Mountainous Aaliyah', x: 311, y: 1506 }
```

## Keep those players moving!

To generate a continuous stream of player data, we're going to create and learn
about Observables through RxJS.

```
npm install --save rx
```

### Down the observable rabbit hole

![Join the rabbit](http://i.imgur.com/dXkeqKA.png)

If you've worked with JavaScript in the frontend (or the backend for that matter),
you've gotten used to these core Objects:

<table>
   <th></th><th>Single return value</th><th>Mutiple return values</th>
   <tr>
      <td>Pull/Synchronous/Interactive</td>
      <td>`Object`</td>
      <td>Iterables (`Array` | `Set` | `Map` | `Object`)</td>
   </tr>
   <tr>
      <td>Push/Asynchronous/Reactive</td>
      <td>`Promise`</td>
      <td>????</td>
   </tr>
</table>

One of my favorite additions to JavaScript was the Promise. It made a lot of
asynchronous code really clean, especially with Promise chains.

```javascript
fetch('/players.json')
  .then((resp) => response.json())
  .then(action)
  .catch(whoa)
```

What about cases where I wanted a promise to yield multiple values? Do I wait
for all the values to get computed, relying on `Promise.all()`? Not if I want
the intermediate values. In the end I'd have to fall back on `createEvent`/`EventEmitter`.

On top of that, I usually wanted to perform filtering and routing based on those
messages for separate consumers of the data. What I really wanted was a stream
of messages that I could operate on like an Array, similar to how we
created new players:

```
const players = codsworthNames.map(newPlayer)
```

There just had to be something to fill that missing piece of the table:

<table>
   <th></th><th>Single return value</th><th>Mutiple return values</th>
   <tr>
      <td>Pull/Synchronous/Interactive</td>
      <td>`Object`</td>
      <td>Iterables (`Array` | `Set` | `Map` | `Object`)</td>
   </tr>
   <tr>
      <td>Push/Asynchronous/Reactive</td>
      <td>`Promise`</td>
      <td>????</td>
   </tr>
</table>

Turns out, there's one more hoping to come to a JavaScript near you: `Observable`

<table>
   <th></th><th>Single return value</th><th>Mutiple return values</th>
   <tr>
      <td>Pull/Synchronous/Interactive</td>
      <td>`Object`</td>
      <td>Iterables (`Array` | `Set` | `Map` | `Object`)</td>
   </tr>
   <tr>
      <td>Push/Asynchronous/Reactive</td>
      <td>`Promise`</td>
      <td>`Observable`</td>
   </tr>
</table>

Observables are asynchronous data streams, [*from the future*](https://zenparsing.github.io/es-observable/).

Technically, this pattern has been around for a while. People have been using Observables
[in Ruby](http://ruby-doc.org/stdlib-1.9.3/libdoc/observer/rdoc/Observable.html), across
languages through [Reactive Extensions](https://github.com/Reactive-Extensions),
libraries like [Bacon](https://baconjs.github.io/), and many more. Where it
*really* shines in Javascript is with RxJS.

Both node's EventEmitter and RxJS's Observable are implementations of the
Observer design pattern. The one big difference you'll see is how you can operate
on Observables like core primitives. While working on [pipboylib](https://github.com/RobCoIndustries/pipboylib),
several contributors highlighted how wonderful it would be if our interface was
based on RxJS.

Here's an example of what it looks like to get the player position continuously:

```javascript
pipboydb
  .map(x => x.Map.World.Player)
  .map(x => ({
    x: x.X,
    y: x.Y,
    deg: x.Rotation
  }))
  .distinctUntilChanged()
  .subscribe(x => {
    console.log('Player Position:', x)
  })
```

As the game updates, we see the change come into our subscription callback and
display our position over time. You can even use this to write out your
[localmap](https://github.com/RobCoIndustries/pipboylib/blob/master/examples/localmap.js).

![](https://cloud.githubusercontent.com/assets/836375/11534784/277a8f3c-98d6-11e5-8d80-a1213dd3adf3.png)

In [pipboy](https://github.com/RobCoIndustries/pipboy) we use this to display
your local map continuously like some sort of crazy sonar.

![localmap cray cray](https://cloud.githubusercontent.com/assets/2737108/11907104/8dd9d7da-a5d1-11e5-91de-400307f54a53.gif)

Let's bring you over to grokking Observables so you can do realtime apps like
this too.

### Learn you some Rx

We're going to go a little crazy in learning how to work with these. Pop open a
node terminal and `require('rx')`:

```javascript
> var Rx = require('rx')
```

Let's start off with a simple `Observable` that emits a new value on each interval.

```javascript
> var obs = Rx.Observable.interval(10)
```

To subscribe to the event stream from this `Observable`, we

To make sure that we don't get overwhelmed with the stream, we'll chain with the
`take` operator, making our resulting subscription only get a few values.

```javascript
> var o = obs.take(4).subscribe(console.log)
0
1
2
3
```

We can operate on this stream too, mapping the values. This interval observable
is just giving us an incrementing counter over time. Let's map the values
to something new then subscribe to that.

```javascript
> o = obs.map(x => x*10).take(4).subscribe(console.log)
0
10
20
30
```

We can also `reduce` on a completed stream after the `take` operation since otherwise we're
operating on an infinite stream.

```javascript
> var o = obs.take(4).reduce((x,y) => x + y, 0).subscribe(console.log)
6
> // 0 + 1 + 2 + 3
```

How could we operate on an *infinite* stream? For this, Rx provides the `scan`
operator to emit intermediates.

```javascript
> var o = obs.scan((x,y) => x + y, 0).take(4).subscribe(console.log)
0
1
3
6
```

This is enough tooling for us to start generating simulated player data. We'll
also use this to great effect when aggregating multiplayer data. For a more
thorough introduction to Reactive Programming, check out the
[Introduction to RP you've been missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754).

## Build the map

Let's go ahead and build the map.

* Create a canvas
* Paint a background image
* Display the image
* Plot our points

## Connect the backend



---------------------------------------------------------------------

Follow me on Twitter [@rgbkrk](https://twitter.com/rgbkrk) to get more updates!
