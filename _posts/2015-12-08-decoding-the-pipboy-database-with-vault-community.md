---
title: "Decoding Fallout 4's Pip-Boy database with a community of vault dwellers"
date: 2015-12-08 13:00
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  Following the siphoning of traffic from the Pip-Boy mobile app and Fallout 4 game,
  a community of hackers has come together to decode the Pip-Boy data and database.
  There are now libraries for several languages and several alternative UIs to
  the mobile app.
categories:
 - Fallout 4
 - decoding
 - community
 - libraries
authorIsRacker: true
---

After making a post about [discovering running Fallout 4 servers and relaying them]({{site.baseurl}}/blog/fallout-4-service-discovery-and-relay/),
in only a few days, the full protocol from Fallout 4 was decoded. Several
packages for interacting with the Fallout 4 server have been posted:

* Node.js - [pipboylib](https://github.com/robcoindustries/pipboylib)
* Go - [pipboygo](https://github.com/nkatsaros/pipboygo)
* Ruby - [pippipe, pipparse](https://github.com/mattbaker/pipboy-explorations)
* Python - [pypipboy](https://github.com/matzman666/PyPipboy), [pipulator](https://github.com/Gavitron/pipulator)
* Java - [PipBoyClient](https://github.com/cpopp/PipBoyClient)
* .NET - [Fallout4-PipBoy](https://github.com/weberph/Fallout4-PipBoy)

Beyond bindings, there are a also several documentation efforts to bring
together information about the overall protocol:

* [nimvek/pipboy](https://github.com/NimVek/pipboy)
* [mattbaker/pipboyspec](https://github.com/mattbaker/pipboyspec)

And several UI efforts:

* Electron app - [pipboy](https://github.com/robcoindustries/pipboy)
* Node.js server - [pipboyclient](https://github.com/AlexanderDzhoganov/pipboyclient)
* Go server - [pipboygo](https://github.com/nkatsaros/pipboygo)

The [pipboylib](https://github.com/robcoindustries/pipboylib) bindings culminated
in the beginnings of the [Electron app, pipboy](https://github.com/robcoindustries/pipboy):

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Give <a href="https://twitter.com/_philpl">@_philpl</a> a minimal prototype and he&#39;ll turn it into something awesome. Localmap crazy good now. <a href="https://twitter.com/hashtag/Fallout4?src=hash">#Fallout4</a> <a href="https://t.co/7XZomcucTb">pic.twitter.com/7XZomcucTb</a></p>&mdash; Kyle Kelley (@rgbkrk) <a href="https://twitter.com/rgbkrk/status/670646978024448000">November 28, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The intention with the `pipboy` Electron app is to create a cross-platform
Pip-Boy UI for Fallout 4 that for running on a separate screen that is approachable
for others to add on to. [Electron](http://electron.atom.io/) forms the foundation for all
this by using standard web tech: HTML, CSS, and JavaScript with Chromium and Node.js.
If you're familiar with the Docker suite, [Kitematic](https://kitematic.com/) is
also an Electron app.

Having this basis makes it really easy to build things like a Pip-Boy database viewer:

![Database View]({% asset_path 2015-12-08-decoding-the-pipboy-database/db-viewer.png %})

![Deathclaw Search]({% asset_path 2015-12-08-decoding-the-pipboy-database/deathclaw-search.png %})


We'd welcome your contributions in pull requests, patches, and issues over at
[RobCoIndustries/pipboy](https://github.com/RobCoIndustries/pipboy).
