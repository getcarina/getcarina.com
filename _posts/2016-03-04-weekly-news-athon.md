---
title: "Weekly news: Get glib, game GitHub"
date: 2016-03-11 13:00
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
  In this week's update we talk about Docker 1.10.2, provide information about our incidents we had last week, we invite you to handle security issues with glibc and SSL (#hugops), build a distributed realtime tic-tac-toe game, edit this post, simulate
  multiplayer users with Observables, and learn how to launch JupyterHub.
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

The latest and greatest from the Carina team!

## Docker 1.10.2

## Incidents
On March 3rd and March 4th we had a couple incidents which impacted our customers.  This would be a good time to mention our [status page] (https://carinabyrackspace.statuspage.io/) where customers can view our system status as well as past incidents.  

March 3rd we identified a network infrastructure issue causing duplicate IP addresses being assigned and notified our customers via status page and [email](http://us1.campaign-archive2.com/?u=2fe5f69d348829ecc7964ead6&id=ca3c207609).  March 4th we encountered a cluster build failure related to instance maintenance which was quickly resolved.  

A friendly reminder: If you do have any issues please help us help you and [create an issue.] (https://github.com/getcarina/feedback/issues)

## glibc and OpenSSL

On February 16, Google [posted about a buffer overflow in glibc that can result in remote execution](https://googleonlinesecurity.blogspot.com/2016/02/cve-2015-7547-glibc-getaddrinfo-stack.html). The post itself is a great read, check it out. Additionally, OpenSSL has [released new versions that address several severe security issues](https://mta.openssl.org/pipermail/openssl-announce/2016-February/000063.html).

For your own security, we recommend pulling new versions of each image that you use and starting new containers.

## Distributed tic-tac-toe

Last week, Keith taught you how to [build a real-time game on Carina using RethinkDB]({{ site.baseurl }}/blog/build-real-time-game-carina/). Have you played yet?

<img class="right" src="{% asset_path 2016-02-22-build-real-time-game-carina/web-ui.png %}" alt="Tic Tac Toe UI"/>

## Edit on GitHub for blog posts and docs

You can now click **Edit on GitHub**, on posts and articles to go straight to the GitHub page for editing, even for this page! Our editor told me that it was completely fine to make typos all over this pge on purpose.

loose fragment

pineapples

## Reactive map building

Yesterday, I put out another post in a series of posts on RxJS and Fallout, this time on [simulating a multiplayer map]({{ site.baseurl }}/blog/lets-build-a-reactive-map/). If you enjoyed going through it, [let me know](https://twitter.com/rgbkrk) if you would like to see more.

## JupyterHub on Carina

In the last couple of weeks we've [put together a workshop on Docker, Swarm, Carina,
and deploying JuypterHub to Carina](https://github.com/getcarina/jupyterhub-tutorial). Check it out when you get a chance!

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
