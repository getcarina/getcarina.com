---
title: "Weekly news: DockerCon 2016, Docker 1.12.0, and cluster build issue"
date: 2016-07-01
comments: true
author: Thomas Maddox <thomas.maddox@rackspace.com>
published: true
excerpt: >
  We had an awesome time at DockerCon 2016. Our booth was buzzing with discussions daily about the future of Carina and Docker. We've also been working behind the scenes looking at Docker Swarm Mode support, which will be included in the Docker 1.12.0 release. Other than that, we resolved a cluster build issue, and users shouldn't have any more trouble creating clusters.
categories:
- DockerCon
- Swarm
- Carina
- Rackspace
- News
authorIsRacker: true
---

{{ page.excerpt }}

### DockerCon 2016

![Screenshot of DockerCon]({% asset_path "2016-06-03-weekly-news-pycon-and-release-information/DockerCon.png" %})

We had a great time at [DockerCon](http://2016.dockercon.com/) this year in Seattle. We enjoyed discussing Carina with the steady flow of folks coming by to see what this Carina thing was and how to use it. Thank you all for coming by and catching up on Carina. And congratulations to the winner of our Parrot Bebop Quadcopter from the contest at the booth!

### Docker 1.12.0 Swarm Mode

One of the many topics at DockerCon 2016 was around the new Swarm Mode in Docker 1.12.0, where the Swarm services come with the Docker daemon. We are looking at supporting this in the future, so stay tuned!

### Resolved erroring clusters

On Thursday evening, we began experiencing an issue with new clusters immediately going to "error" on create. This [issue](https://status.getcarina.com/incidents/f00dpl1vkzm9) was resolved ~30 minutes later, and you should no longer see this problem. If you do see any problems, please let us know!

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
