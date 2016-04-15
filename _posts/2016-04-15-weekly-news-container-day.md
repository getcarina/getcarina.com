---
title: "Weekly news: Reboot day, Meetup day, Tax&nbsp;day"
date: 2016-04-15
comments: true
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
published: true
excerpt: >
  As the saying goes, “Nothing is certain but death and taxes.” Or is it “death and reboots”? Either way, we’re filing this week under “busy”! We completed a reboot of all Carina instances to patch a vulnerability, shared a great recap of Everett's “Effective Docker Swarm” talk at the Docker Austin meetup, and announced a Carina meetup during this month's OpenStack Summit in Austin. Let's itemize everything that happened this week!
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

{{ page.excerpt }}

### Containers meetup at OpenStack Summit Austin

The Carina team will be [hosting a containers meetup](https://getcarina.com/blog/container-day-austin-summit/) on April 26 during the OpenStack Summit in Austin. The meetup will be a great time to see demos and discussions from early Carina users and other leaders in the containers ecosystem. The meetup is _not exclusive_ to summit attendees—anyone is welcome to come and meet with our team and other Carina users.

In addition to the meetup, members of the Carina team will be present throughout the summit in the [“Rackspace Cantina”](http://blog.rackspace.com/relax-recharge-rackspace-cantina-openstack-summit-austin/). If you’re attending the summit, come and see us on the rooftop patio at Micheladas to relax and recharge!

### Carina reboots completed

Our team completed the process of rebooting all Carina instances on Tuesday, April 12, to patch a [Linux kernel bug](https://tech.vijayp.ca/linux-kernel-bug-delivers-corrupt-tcp-ip-data-to-mesos-kubernetes-docker-containers-4986f88f7a19) that delivered corrupt network data to containers. The reboots went smoothly, and all Carina clusters are up and running again. All containers that were configured to [restart automatically](https://docs.docker.com/engine/reference/commandline/run/#restart-policies-restart) should have done so, but please reach out to us in [the forums](https://community.getcarina.com/) or in [#carina on freenode](https://botbot.me/freenode/carina/) if you’re seeing any issues with your clusters following the reboot.

### Replay and slides of “Effective Docker Swarm”

<figure class="right">
  <img src="{% asset_path 2016-04-15-weekly-news/swarmnado.gif %}" />
  <figcaption>
    Image source: <a href="https://goto.docker.com/swarm-week.html">Docker, Inc.</a>
  </figcaption>
</figure>

Everett shared the [video recording and slides](https://getcarina.com/blog/docker-austin-how-do-i-even-swarm/) of the great presentation he gave at last week’s Docker Austin meetup. Everett’s audience was very engaged and asked lots of great, detailed questions about Carina and Swarm in general. Watch the video if you missed the talk—you’ll learn almost as much from all the audience’s questions as you will from the talk itself!

<div class="clearfix"></div>

### Use ObjectRocket’s MongoDB with Carina

Databases are often a critical component for applications, but managing them yourself can be time-consuming and disaster-prone.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Databases will soon join mail servers on the list of things you don&#39;t ever want to host or manage yourself.</p>&mdash; Kelsey Hightower (@kelseyhightower) <a href="https://twitter.com/kelseyhightower/status/718291374798450688">April 8, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Everett shows you how to heed [@kelseyhightower](https://twitter.com/kelseyhightower)’s advice and let ObjectRocket host MongoDB for you. [Using Carina with MongoDB from ObjectRocket](https://getcarina.com/docs/tutorials/data-stores-mongodb-prod/) gives you the best of both worlds: the speed and ease of development and deployment on Carina, plus the simplicity and reliability of ObjectRocket's managed MongoDB service.

### Docker releases Engine 1.11 and Compose 1.7

Docker has released [version 1.11 of Docker Engine and version 1.7 of Docker Compose](https://blog.docker.com/2016/04/docker-engine-1-11-runc/) with a lot of exciting changes under the hood and a few exciting user-facing changes, including DNS round-robin load balancing for simple service discovery. Coming soon to a cluster near you!

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
