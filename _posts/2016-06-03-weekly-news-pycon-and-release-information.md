---
title: "Weekly news: PyCon and release information"
date: 2016-06-03
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
  A short and sweet weekly update that includes a look at PyCon, information about Docker Engine's 1.11.1 release, and future  appearances by the Carina team.
categories:
- News
- Docker
- PyCon
authorIsRacker: true
---

{{ page.excerpt }}

### PyCon wrap up

![Screenshot of Carina Workshop]({% asset_path "2016-06-03-weekly-news-pycon-and-release-information/Carina Workshop.png" %})

We had a great showing at our Carina workshop and our booth at PyCon.  Everett Toews and Ash Wilson presented a [workshop](https://us.pycon.org/2016/schedule/presentation/2263/) "Deploy an Interactive Data Science Environment With JupyterHub On Docker Swarm" to a captive audience.  If you're thinking "Dang! I wish I had been able to attend," you're in luck!  You can [access the deck](http://getcarina.github.io/jupyterhub-tutorial/slides/#/welcome) to view and follow along with the presentation.  Happy hacking!

### Docker 1.11.1 and release notes

Docker put out a patch release about a month ago and we quickly followed by implementing the changes in Carina on May 23.  The release fixes some bugs that were reported after the 1.11.0 release.  You can find the [change log](https://github.com/docker/docker/releases/tag/v1.11.1) and a [side-by-side comparison](https://github.com/docker/docker/compare/v1.11.0...v1.11.1) of the different versions in the Docker GitHub repo.  Changes include a chunk of runtime fixes and some changes to networking, documentation, the builder, and distribution.

In addition to the Docker updates, we also have improved our error messages related to security restrictions.  You can find more information on our [error codes](https://getcarina.com/docs/reference/error-codes/) page.

To stay up-to-date with ongoing release notes, maintenance, and any incidents, see our [status page](https://status.getcarina.com/).


### Upcoming appearances

![Screenshot of Dockercon]({% asset_path "2016-06-03-weekly-news-pycon-and-release-information/DockerCon.png" %})

We'll be representing at [Dockercon 16](http://2016.dockercon.com/) this year, so come to the expo and chat with us about Carina and all things containers.  You can enter into our Carina contest, with a chance to win a Parrot Bebop Quadcopter Drone. Your neighbors will love you. 


### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
