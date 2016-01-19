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

We've done [Pip-Boy discovery and relay]({{site.baseurl}}/blog/fallout-4-service-discovery-and-relay/) and
[created new libraries]({{site.baseurl}}/blog/decoding-the-pipboy-database-with-vault-community/). Now let's put them to good use. The first half of this tutorial does *not* require having
a copy of Fallout 4, since we'll start by simulating data.

Things we'll cover:

* RxJS
* Drawing on canvas
* React
* Socket.io
* Turning many datapoints into a PNG

## Down the observable rabbit hole

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

There's one more coming to a JavaScript near you: `Observable`

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

Observables are Asynchronous data streams, [*from the future*](https://zenparsing.github.io/es-observable/).

If you've been using

Promises made JavaScript much better, up until I realized that I actually had
more than one value to pass on over time.

The way this typically gets handled is with events via EventEmitter or Streams
in Node.js.

To kick this off

We're going to use RxJS, an implementation of Observables that works well across
browsers, node.js, and [even Rhino](https://twitter.com/ReactiveX/status/350360077305253889).

They fall under the vein of Reactive Programming.

* Create an Observable

## Generating Random Players

Go ahead and setup a new project for this, by creating a new directory, changing to that directory, and running `npm init`. You can accept the defaults if you like, or mix it up.

```
mkdir multi-pip-fun
cd multi-pip-fun
npm init
```

We're here to make a map of players, so let's start off by generating some
random players. We're going to get the list of player names that codsworth can
speak from.

For this tutorial, I'll use the package `clean-codsworth-names`. You can install
it too:

```
npm install --save clean-codsworth-names
```

You can also use the raw list, which has plenty of words to make the juvenile in
us giggle.

```
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
console.log(players.slice(0,4))
```

```bash
$ node fakes.js
[ { name: 'Aaliyah', x: 533, y: 81 },
  { name: 'Aaron', x: 612, y: 1091 },
  { name: 'Abigail', x: 422, y: 1918 },
  { name: 'Abram', x: 210, y: 541 } ]
```

While we're at it, let's give each of these players a unique ID and provide
an adjective for their name:

```
npm install --save uuid adjectives
```

Go ahead and `require` these libraries




For a more thorough introduction to Reactive Programming, check out the [Introduction to RP you've been missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754).





Follow me on Twitter [@rgbkrk](https://twitter.com/rgbkrk) to get more updates!
