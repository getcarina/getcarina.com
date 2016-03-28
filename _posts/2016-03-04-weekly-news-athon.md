---
title: "Weekly news: Docker UCP, 1.10.2, glibc, and games"
date: 2016-03-11 13:00
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
  Lots of updates this week!  We talk about Docker 1.10.2, show off the wicked fast Docker Universal Control Plane, provide information about the incidents we had last week, run through how to develop a Python app with Carina, invite you to handle security issues with glibc and SSL (#hugops), build a distributed realtime tic-tac-toe game, edit this post, simulate
  multiplayer users with Observables, and learn how to launch JupyterHub. Whew!
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

Carina: The Spring Break edition!  Get your noodle activated and your learn on.

## Docker 1.10.2
Yesterday, the Carina team rolled out the latest version of Docker, 1.10.2.  [This version] (https://github.com/docker/docker/releases/tag/v1.10.2) includes runtime, distribution, networking, volumes, and security updates.  Some of the [updates](https://github.com/docker/docker/pull/20513) include fixing an issue with multiple volume references with the same name and [keeping a layer reference](https://github.com/docker/docker/pull/20513) if a deletion failed to avoid an inconsistent state. As always, if you do have questions regarding the latest release, [ask us] (https://webchat.freenode.net/?channels=carina).   

## Test drive Docker UCP in under two minutes!
Docker recently acquired a management UI company, [tutum] (https://www.tutum.co/), and the combination of Docker + Tutum = Docker [Universal Control Plane (UCP)] (https://www.docker.com/products/docker-universal-control-plane).  The new Docker UCP exposes an almost one-to-one mapping of the Docker command-line options when you are managing containers, volumes, and networks.  Check out our [blog post] (https://getcarina.com/blog/fastest-test-drive-of-docker-ucp/) to get you up and running with UCP in a couple of minutes.

## Develop a Python application with Carina
Like Python?  Like Carina?  Well we have a treat for you.  Feed your inner nerd by developing a Python app using Carina! This [post](https://getcarina.com/docs/tutorials/develop-a-python-web-application/) by our own Everett Toews shows you how to develop a Python web application locally on VirtualBox and deploy it on Carina with Docker Compose.  You'll have your very own guestbook to show off to friends by completion.  

## Incidents
On March 3, and March 4, we had a couple of incidents that impacted our customers.  This would be a good time to mention our [status page] (https://carinabyrackspace.statuspage.io/) where customers can view our system status as well as past incidents.  

On March 3, we identified a network infrastructure issue that caused duplicate IP addresses to be assigned and we notified our customers via status page and [email](http://us1.campaign-archive2.com/?u=2fe5f69d348829ecc7964ead6&id=ca3c207609).  On March 4, we encountered a cluster build failure related to instance maintenance which was quickly resolved.  

A friendly reminder: If you have any issues please help us help you [by creating an issue.] (https://github.com/getcarina/feedback/issues)

## glibc and OpenSSL

On February 16, Google posted about a [buffer overflow in glibc](https://googleonlinesecurity.blogspot.com/2016/02/cve-2015-7547-glibc-getaddrinfo-stack.html) that can result in remote execution. Additionally, OpenSSL has [released new versions](https://mta.openssl.org/pipermail/openssl-announce/2016-February/000063.html) that address several severe security issues.

For your own security, we recommend pulling new versions of each image that you use and starting new containers.

## Distributed tic-tac-toe

On February 22, Keith taught you how to [build a real-time game on Carina using RethinkDB]({{ site.baseurl }}/blog/build-real-time-game-carina/). Have you played yet?

![Tic Tac Toe]({% asset_path 2016-02-22-build-real-time-game-carina/web-ui.png %})

## Edit on GitHub for blog posts and docs

You can now click **Edit on GitHub** on posts and articles to go straight to the GitHub page for editing, even for this page! Our editor told me that it was completely fine to make typos all over this page on purpose.

## Reactive map building

Last week, Fallout Vault Boy, Kyle, put out another post in a series of posts on RxJS and Fallout, this time on [simulating a multiplayer map]({{ site.baseurl }}/blog/lets-build-a-reactive-map/). If you enjoyed going through it, [let him know](https://twitter.com/rgbkrk) if you would like to see more.

## JupyterHub on Carina

In the last couple of weeks we've put together a [workshop](https://github.com/getcarina/jupyterhub-tutorial) on Docker, Swarm, Carina,
and deploying JuypterHub to Carina. The Rackspace workshop was a hit, and we have reused those exact slides for internal learning and training.  Thanks goes to our great instructors [Everett](https://twitter.com/everett_toews), [Carolyn](https://twitter.com/carolynvs), [Kyle](https://twitter.com/rgbkrk), and [Ash](https://twitter.com/smashwilson). Check it out when you get a chance!

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
