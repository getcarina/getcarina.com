---
title: "Let's build a multiplayer Fallout 4 map using RxJS!"
date: 2016-03-02 14:30
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  We've done Pip-Boy discovery and relay, creating new libraries in the process.
  Now it's time to put them to good use by building a multiplayer map. To get us
  there, I will show you how to use Observables to handle streams of player data
  and render them onto a map.
categories:
 - nodejs
 - RxJS
 - browserify
 - Observables
 - Fallout 4
authorIsRacker: true
---

![reactive map](https://cloud.githubusercontent.com/assets/836375/11960060/5b49ac9c-a896-11e5-8e50-da9ce4330e1d.gif)

We've done [Pip-Boy discovery and relay]({{site.baseurl}}/blog/fallout-4-service-discovery-and-relay/) and
[created new libraries]({{site.baseurl}}/blog/decoding-the-pipboy-database-with-vault-community/).
Now let's put them to good use. The first half of this tutorial does *not* require having
a copy of Fallout 4 because we'll start by simulating data.

Things we'll cover:

* Simulating data
* Observables and RxJS
* Bundling code for the browser via `browserify` and `babel`
* Drawing on canvas

## Tools required

You need [node 5+ and npm 3](https://nodejs.org/en/) to follow this
tutorial. If you're gripping tightly to an older node version, try out
[nvm](https://github.com/creationix/nvm) or [n](https://github.com/tj/n) for all
your node environment switching needs.

## Generating Random Players

Set up a new project for this, by creating a new directory, changing to that
directory, and running `npm init`. You can accept the defaults if you like, or
mix it up.

```bash
mkdir multi-pip-fun
cd multi-pip-fun
npm init
```

We're making a map of players, so let's start by generating some
random players. We're going to get the list of player names that [codsworth can
speak](http://www.themarysue.com/fallout-4-names/) from.

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

Now, create `fakes.js`, setting up new players and where they are on the map.

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

Give each of these players a unique ID and provide
an adjective for their name (for example, Crazy Dave) by relying on
two more packages: `uuid` (for unique IDs) and `adjectives` (like it says on the tin)

```bash
npm install --save uuid adjectives
```

Now we'll `require` these libraries and modify `newPlayer`:

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
    id: uuid.v4(),
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

## Go on a random walk

How can we simulate players moving?

By taking them on a [random walk](https://en.wikipedia.org/wiki/Random_walk).
On each iteration of the simulation, we'll add 1, 0, or -1 to the player's x
and y positions.

![let's go on a stroll](http://i.imgur.com/LeTMQV9.png)

There are a few ways to do this and we'll rely on some mathematical properties to
make this fast.

We can randomly acquire 0 and 1 by using `Math.round(Math.random())`. To get -1,
use the mathematical property that `cos(π) = -1` and `cos(0) = 1`. Multiply
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

Try it out on one of the characters by appending this to the end of fakes.js:

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
npm install --save @reactivex/rxjs
```

### Down the observable rabbit hole

![Join the rabbit](http://i.imgur.com/dXkeqKA.png)

If you've worked with JavaScript in the front end (or the back end for that matter),
you've gotten used to these core Objects:

<table>
   <th></th><th>Single return value</th><th>Multiple return values</th>
   <tr>
      <td>Pull/Synchronous/Interactive</td>
      <td>Object</td>
      <td>Iterables (Array | Set | Map | Object)</td>
   </tr>
   <tr>
      <td>Push/Asynchronous/Reactive</td>
      <td>Promise</td>
      <td>????</td>
   </tr>
</table>

One of my favorite additions to JavaScript is the `Promise`. It makes a lot of
asynchronous code really clean, especially with `Promise` chains.

```javascript
fetch('/players.json')
  .then((resp) => response.json())
  .then(action)
  .catch(whoa)
```

What about cases where we want a promise to yield multiple values? Do we wait
for all the values to get computed, relying on `Promise.all()`? Not if we want
the intermediate values. In the end we'd have to fall back on `createEvent`/`EventEmitter`.

On top of that, we usually want to perform filtering and routing based on those
messages for separate consumers of the data. What we really need is a stream
of messages that we can operate on like an `Array`, similar to how we
created new players:

```
const players = codsworthNames.map(newPlayer)
```

There just *has* to be something to fill that missing piece of the table. Turns out,
there's one more data type to come to a JavaScript near you: `Observable`

<table>
   <th></th><th>Single return value</th><th>Multiple return values</th>
   <tr>
      <td>Pull/Synchronous/Interactive</td>
      <td>Object</td>
      <td>Iterables (Array | Set | Map | Object)</td>
   </tr>
   <tr>
      <td>Push/Asynchronous/Reactive</td>
      <td>Promise</td>
      <td>Observable</td>
   </tr>
</table>

Observables are asynchronous data streams, [*from the future*](https://zenparsing.github.io/es-observable/).

Technically, this pattern has been around for a while. People have been using Observables
[in Ruby](http://ruby-doc.org/stdlib-1.9.3/libdoc/observer/rdoc/Observable.html), across
languages through [Reactive Extensions](https://github.com/ReactiveX),
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

Let's learn more about Observables so you can do real-time apps like this too.

### Learn some Rx

We're going to go a little crazy in learning how to work with these. Pop open a
node terminal and `require('rx')`:

```javascript
> var Rx = require('rx')
```

Start with a simple `Observable` that emits a new value on each interval.

```javascript
> var obs = Rx.Observable.interval(10)
```

To subscribe to the event stream from this `Observable`, we use `subscribe`.
To make sure that we don't get overwhelmed with the stream, we'll chain with the
`take` operator, making our resulting subscription only get a few values.

```javascript
> var o = obs.take(4).subscribe(console.log)
0
1
2
3
```

We can operate on this stream, too, mapping the values. This interval `Observable`
is giving us an incrementing counter over time. Let's map the values
to something new that we'll subscribe to.

```javascript
> o = obs.map(x => x*10).take(4).subscribe(console.log)
0
10
20
30
```

Since we use `take`, the stream completes after 4 elements are emitted, which
allows us to perform a reduction:

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

## Generate player data with RxJS

Let's start by creating a single live player who updates themselves on
an interval. Add this to `fakes.js`:

```javascript
function livePlayer(player, period) {
  if(!player) {
    throw new Error('need a player');
  }
  if(!period) {
    period = 500;
  }
  return Rx.Observable.interval(period)
            .scan((p) => {
              return {
                name: p.name,
                id: p.id,
                x: walk(p.x),
                y: walk(p.y),
              };
            }, player);
}
```

To create this for all the players, we'll use the `merge` operator to bring
lots of live players together. `merge` takes N many Observables and combines
them into one Observable stream.

```javascript
// create a set of players with coordinates
const defaultPlayers = codsworthNames.map(newPlayer)

function livePlayers(players, period) {
  if(!players) {
    players = defaultPlayers;
  }
  if(!period) {
    period = 500;
  }

  return Rx.Observable.merge(...players.map(p => livePlayer(p, period)))
}
```

Let's export this function for use by node. Try this out by appending this to the bottom of `fakes.js`:

```
livePlayers(players).take(4).subscribe(x => console.log(x))
```

Then, run `fakes.js` to get output like the following:

```
{ name: 'Robust Aaliyah',
  id: 'dbfb8fdc-6930-4c59-a849-144f47a5fd93',
  x: 900,
  y: 1198 }
{ name: 'Alleged Aaron',
  id: '8bb2734c-8699-493a-bf57-fecf1a135077',
  x: 1648,
  y: 484 }
{ name: 'Tremendous Abigail',
  id: '749744d2-5e8e-4737-bd57-2aef0c1dae23',
  x: 829,
  y: 450 }
{ name: 'Womanly Abram',
  id: '7e6b1614-efc9-4549-8673-4ddc0ea62531',
  x: 920,
  y: 131 }
```

Now our players are being generated. It's time to put them on the screen.

![](https://camo.githubusercontent.com/e19e230a9371a44a2eeb484b83ff4fcf8c824cf7/687474703a2f2f737562737461636b2e6e65742f696d616765732f62726f777365726966795f6c6f676f2e706e67)

To convert our command line scripts to something we can put up on the
web for everyone, we're going to use a bundler called `browserify` to package
all the JavaScript goodness into one file, and then ensure that all of the
JavaScript works on all the various browsers by using `babel` via `babelify`.

```bash
npm install --save-dev browserify babelify babel-preset-es2015
```

In your `package.json`, add one more line to your `scripts` section and create a
`babel` section:

```json
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "build": "browserify index.js -t babelify --outfile bundle.js"
},
"babel": { "presets": ["es2015"] },
```

Next, write an `index.html`:

```html
<html>
    <head>
        <meta charset="utf-8">
    </head>
    <body>
        <script type="text/javascript" src="bundle.js" charset="utf-8"></script>
    </body>
</html>
```

This sets up loading the bundle within the main page. For the `index.js` file, start with something fairly simple:

```javascript
const fakes = require('./fakes');

fakes.livePlayers()
     .take(1)
     .subscribe(player => {
       console.log(player);
       document.write(JSON.stringify(player));
     });
```

Now run `npm run build`. That should build your sources. To see your work in action,
open up `index.html` in the browser. You should see a generated player.

```
{"name":"Robust Aaliyah","id":"dbfb8fdc-6930-4c59-a849-144f47a5fd93","x":900,"y":1198}
```

Great! Now let's build that map.

## Build the map

The steps, roughly:

* Create a canvas
* Paint a background image
* Plot our points

### Create a canvas

We're going to start small and simply put the canvas right in the `index.html` file.

```html
<html>
    <head>
        <meta charset="utf-8">
    </head>
    <body>
        <canvas id='map' width=2048 height=2048></canvas>
        <script type="text/javascript" src="bundle.js" charset="utf-8"></script>
    </body>
</html>
```

### Paint an image onto the canvas

Let's create a file called `mapping.js`. We'll start it off by drawing an image
onto a provided canvas:

```javascript
const MAP_SIZE = 2048;

function paint(canvas, image, players) {
  const context = canvas.getContext('2d');
  context.save();

  if(image) {
    context.globalCompositeOperation = 'source-over';
    context.drawImage(image, 0, 0);
  }
  else {
    context.clearRect(0, 0, MAP_SIZE, MAP_SIZE);
  }

  // Note: we're not painting players yet

  context.restore();
}

module.exports = {
  paint,
};
```

Now call `paint` to display our image:

```javascript
const fakes = require('./fakes');
const paint = require('./mapping').paint;

const mapCanvas = document.getElementById('map');

var image;

const imageEl = new Image();
imageEl.src = 'CompanionWorldMap.png';
imageEl.onload = () => {
  image = imageEl;
  paint(mapCanvas, image);
};
```

We'll need the world map for loading, so [download the companion world map](https://raw.githubusercontent.com/rgbkrk/lets-rxjs5/acebf65cb206258b0ec022c8287015eefb5728a6/CompanionWorldMap.png)
to your workspace.

Run `npm run build` again and open `index.html` again. You'll see that friendly
commonwealth.

![commonwealth](https://raw.githubusercontent.com/rgbkrk/lets-rxjs5/acebf65cb206258b0ec022c8287015eefb5728a6/CompanionWorldMap.png)

Now take all that player data and show it on screen. Within `index.js`,
after the setup for the image let's start taking that fake player data.

```javascript
fakes.livePlayers(fakes.defaultPlayers, 10)
     .scan((players, player) => {
       // collect the latest data for each player over time
       return players.set(player.id, player);
     }, new Map())
     // To render at approximately 60fps, we need to throttle by 16.66667 ms
     // 1 second = 1000 ms => 1000/60 = 16.6667 ms between frames
     .throttleTime(17)
     .subscribe(players => {
       paint(mapCanvas, image, players);
     });
```

Now, the only thing we have to add to our `mapping.js` is plotting those players

```javascript
function paint(canvas, image, players) {
  const context = canvas.getContext('2d');
  context.save();

  if(image) {
    context.drawImage(image, 0, 0);
  }
  else {
    context.clearRect(0, 0, MAP_SIZE, MAP_SIZE);
  }

  // Each player gets plotted with a unique color
  for(var player of players.values()) {
    context.fillStyle = '#' + player.id.slice(0, 6);
    context.fillRect(player.x, player.y, 2, 2);
  }
  context.restore();
}
```

There you have it, a live updating map!

![animated dots](https://cloud.githubusercontent.com/assets/836375/11960060/5b49ac9c-a896-11e5-8e50-da9ce4330e1d.gif)

### Be friendly with the browser render cycle

Browsers provide a global function called `requestAnimationFrame` that lets you
call a function to update an animation before the next browser repaint. We need
to rely on this to trigger the actual call to `paint`.

```javascript
fakes.livePlayers(fakes.defaultPlayers, 10)
     .scan((players, player) => {
       // collect the latest data for each player over time
       return players.set(player.id, player);
     }, new Map())
     .throttleTime(10) // We can lower our throttle since we're using rAF
     .subscribe(players => {
       window.requestAnimationFrame(paint.bind(null, mapCanvas, image, players));
     });
```

## Summary

We've learned how to simulate data through the use of RxJS Observables, rely on
`browserify`, `babel`, and `npm` to package our app, and draw points on a canvas.
If you liked this, let me know if you want to learn how to build [the full
multiplayer map](https://github.com/rgbkrk/multipipboy).

---------------------------------------------------------------------

Follow me on Twitter [@rgbkrk](https://twitter.com/rgbkrk) to get more updates!
