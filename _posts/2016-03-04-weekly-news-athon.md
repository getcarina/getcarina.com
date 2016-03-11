---
title: "Weekly news: Get glib, game GitHub"
date: 2016-03-11 13:00
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
  Lots of updates this week!  We talk about Docker 1.10.2, show off the wicked fast Docker Universal Control Plane, provide information about our incidents we had last week, run through how to develop a Python App with Carina, we invite you to handle security issues with glibc and SSL (#hugops), build a distributed realtime tic-tac-toe game, edit this post, simulate
  multiplayer users with Observables, and learn how to launch JupyterHub.
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

Carina: The Spring Break edition!  Get your noodle activiated and your learn on.

## Docker 1.10.2
Yesterday, the Carina team rolled out the latest version of Docker, 1.10.2.  [This version includes runtime, distribution, networking, volumes, and security updates.] (https://github.com/docker/docker/releases/tag/v1.10.2) Some of the updates include [fixing issue with multiple volume references with same name] (https://github.com/docker/docker/pull/20513) and [keep layer reference if deletion failed to avoid a badly inconsistent state] (https://github.com/docker/docker/pull/20513). As always, if you do have questions regarding the latest release, [ask us] (https://webchat.freenode.net/?channels=carina).   

## Test Drive Docker UCP In Under 2 Minutes!
Docker recently aquired a management UI company, [tutum] (https://www.tutum.co/), and the combo punch of Docker + Tutum = [Docker UCP] (https://www.docker.com/products/docker-universal-control-plane).  The new Docker UCP exposes an almost one-to-one mapping of the Docker command-line options when you are managing containers, volumes, and networks.  Check out our [blog post] (https://getcarina.com/blog/fastest-test-drive-of-docker-ucp/) and you can be up and running with UCP in a couple minutes.

## Develop A Python Application With Carina
Like Python?  Like Carina?  Well we have the solution for you.  Feed your inner nerd by developing a Python App using Carina! This [post by our own Everett Toews] (https://getcarina.com/docs/tutorials/develop-a-python-web-application/) shows you how to develop a Python web application locally on VirtualBox and deploy it on Carina with Docker Compose.  You'll have your very own guestbook to show off to friends by completion.  

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

Last week, Fallout Fan Boy Kyle put out another post in a series of posts on RxJS and Fallout, this time on [simulating a multiplayer map]({{ site.baseurl }}/blog/lets-build-a-reactive-map/). If you enjoyed going through it, [let him know](https://twitter.com/rgbkrk) if you would like to see more.

## JupyterHub on Carina

In the last couple of weeks we've [put together a workshop on Docker, Swarm, Carina,
and deploying JuypterHub to Carina](https://github.com/getcarina/jupyterhub-tutorial). The Rackspace workshop was a hit and we have reused those exact slides for internal learning and training.  Props to our great instructors [Everett](https://twitter.com/everett_toews), [Carolyn](https://twitter.com/carolynvs), [Kyle](https://twitter.com/rgbkrk), and [Ash](https://twitter.com/smashwilson). Check it out when you get a chance!

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
