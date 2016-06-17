---
title: "Weekly news: Docker 1.11.2 and DockerCon"
date: 2016-06-17
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  We released Docker Engine 1.11.2 today, which includes a key fix for containers that need to restart. We'll also be at DockerCon next week, so if you're attending, drop by the booth to say hi and get a chance to win a Parrot Bebop Quadcopter.
categories:
- News
- Docker
- DockerCon
authorIsRacker: true
---

{{ page.excerpt }}

### Docker 1.11.2 and release notes

We deployed Docker Engine 1.11.2 today.

![Deploy like no on is watching]({% asset_path weekly-news/friday-deploy.jpg %})

For more information, see the [release notes](https://github.com/docker/docker/releases/tag/v1.11.2) and a [side-by-side comparison](https://github.com/docker/docker/compare/v1.11.1...v1.11.2) of the different versions in the Docker Engine repo.

Docker Engine 1.11.2 includes a key fix for [containers that fail to start after a daemon restart if they depend on a containerized cluster store](https://github.com/docker/docker/pull/22561). When you set `restart=always`, your containers should always restart, even if the host reboots.

To stay up-to-date with ongoing release notes, maintenance, and any incidents, see our [status page](https://status.getcarina.com/).

### DockerCon 2016

![Screenshot of DockerCon]({% asset_path "2016-06-03-weekly-news-pycon-and-release-information/DockerCon.png" %})

We're representing at [DockerCon](http://2016.dockercon.com/) next week, so come to the expo and chat with us about Carina and all things containers. You can enter our Carina contest, with a chance to win a Parrot Bebop Quadcopter. Your neighbors will love you.

![Parrot Bebop quadcopter]({% asset_path contest/bebop.jpg %})

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
