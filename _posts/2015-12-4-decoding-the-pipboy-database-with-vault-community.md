---
title: "Decoding Fallout 4's pipboy database with a community of vault dwellers"
date: 2015-11-20 18:00
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  Following on from siphoning traffic from the pipboy app and Fallout 4 game,
  a community of hackers has come together to decode the pipboy data and database.
  There are now libraries for several languages
categories:
 - Fallout 4
 - decoding
 - community
 - libraries
authorIsRacker: true
---

In only a few days, the full protocol from Fallout 4 was decoded and several
packages for interacting with the Fallout 4 server have been posted:

* Node.js - [pipboylib](https://github.com/robcoindustries/pipboylib)
* Go - [pipboygo](https://github.com/nkatsaros/pipboygo)
* Ruby - [pippipe, pipparse](https://github.com/mattbaker/pipboy-explorations)
* Python - [pypipboy](https://github.com/matzman666/PyPipboy), [pipulator](https://github.com/Gavitron/pipulator)
* Java - [PipBoyClient](https://github.com/cpopp/PipBoyClient)
* .NET - [Fallout4-PipBoy](https://github.com/weberph/Fallout4-PipBoy)

Beyond bindings there are a also quite a few documentation efforts to bring
together information about the overall protocol:

* [nimvek/pipboy](https://github.com/NimVek/pipboy)
* [mattbaker/pipboyspec](https://github.com/mattbaker/pipboyspec)

There are also several UI efforts:

* Electron App - [pipboy](https://github.com/robcoindustries/pipboy)
* Nodejs Server - [pipboyclient](https://github.com/AlexanderDzhoganov/pipboyclient)
* Go server - [pipboygo](https://github.com/nkatsaros/pipboygo)

The [pipboylib](https://github.com/robcoindustries/pipboylib) bindings culminated
in the beginnings of an [Electron app](https://github.com/robcoindustries/pipboy):

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Give <a href="https://twitter.com/PhilPlckthun">@PhilPlckthun</a> a minimal prototype and he&#39;ll turn it into something awesome. Localmap crazy good now. <a href="https://twitter.com/hashtag/Fallout4?src=hash">#Fallout4</a> <a href="https://t.co/7XZomcucTb">pic.twitter.com/7XZomcucTb</a></p>&mdash; Kyle Kelley (@rgbkrk) <a href="https://twitter.com/rgbkrk/status/670646978024448000">November 28, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[Phil Plückthun](https://github.com/philplckthun) currently has a
[`react` branch](https://github.com/RobCoIndustries/pipboy/tree/react)
to lay down some foundations for people to build upon.

The intention with pipboy is to create a cross platform pipboy UI for Fallout 4
that you can run on a separate screen which is approachable for others to hack
on together. [Electron](http://electron.atom.io/) forms the foundation for all
this using standard web tech: HTML, CSS, and JavaScript with Chromium and Node.js.
If you're familiar with the Docker suite, [Kitematic](https://kitematic.com/) is
also an electron app.
