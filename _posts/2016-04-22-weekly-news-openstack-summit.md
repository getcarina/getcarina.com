---
title: "Weekly news: Rackspace Cantina & OpenStack Summit"
date: 2016-04-22
comments: true
author: Ken Perkins <ken.perkins@rackspace.com>
published: true
excerpt: >
  It's almost OpenStack Summit time! That means we're gearing up for our Containers meetup and the Rackspace Cantina. We also have a new tutorial about push-based continuous deployment on Docker Swarm and a Video Session about migrating from Parse to ObjectRocket and Carina.
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

{{ page.excerpt }}

### Next Week: Containers meetup at OpenStack Summit Austin

The Carina team is [hosting a containers meetup](https://getcarina.com/blog/container-day-austin-summit/) next Tuesday,  April 26 during the OpenStack Summit in Austin. The meetup will be a great time to see demos and discussions from early Carina users and other leaders in the containers ecosystem. The meetup is _not exclusive_ to summit attendees—anyone is welcome to come and meet with our team and other Carina users.

In addition to the meetup, members of the Carina team will be present throughout the summit in the [Rackspace Cantina](http://blog.rackspace.com/relax-recharge-rackspace-cantina-openstack-summit-austin/). If you’re attending the summit, come and see us on the rooftop patio at Micheladas to relax and recharge!

### Migrating from Parse and using Carina for the Parse Server Tier

Erik Nakagawa from Parse and Andy Woodward from ObjectRocket have published a video addressing how to migrate from Parse, including an option to migrate services to Carina.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HJ-iI-OiGCY" frameborder="0" allowfullscreen></iframe>

View the [Parse session on Youtube](https://youtu.be/HJ-iI-OiGCY).

### Docker EOF bug with Docker 1.10.3 deployments

We recently fixed a bug that was causing errors with `EOF` in the error message. If you ran into this problem, you'll need to create a new cluster to get the updated image. More information is available in the [Carina Feedback GitHub issue](https://github.com/getcarina/feedback/issues/65).

### Setting up push-based continuous deployment tutorial

Continuous deployment is the process of releasing new versions of software in a reliable and automatic way. Jamie's new tutorial will walk you through [how to set up an environment for continuous deployment](https://getcarina.com/docs/tutorials/push-based-cd/) on Docker Swarm

Read the [Tutorial on push based continuous deployment](https://getcarina.com/docs/tutorials/push-based-cd/).

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
