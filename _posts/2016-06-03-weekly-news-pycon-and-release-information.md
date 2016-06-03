---
title: "Weekly news: PyCon and Release Information"
date: 2016-06-03
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
  A short and sweet weekly update. This week's weekly includes a look at PyCon, information about Docker Engine's 1.11.1 release, and future appearanced by the Carina team.
categories:
- News
- Docker
- PyCon
authorIsRacker: true
---

{{ page.excerpt }}

### Pycon Wrap Up

![Screenshot of Carina Workshop]({% asset_path 2016-06-03-weekly-news-pycon-and-release-information/Carina Workshop.png %})

We had a great showing at our Carina workshop and our booth at PyCon.  Everett Toews and Ash Wilson provided a [workshop](https://us.pycon.org/2016/schedule/presentation/2263/) "Deploy an Interactive Data Science Environment With Jupyterhub On Docker Swarm" to a captive audience.  If you're thinking "Dang! I wish I had been able to attend," you're in luck!  You can view and follow along with the presentation by accessing the deck [here](http://getcarina.github.io/jupyterhub-tutorial/slides/#/welcome).  Happy hacking!

### Docker 1.11.1 and Release Notes

Docker put out a patch release about a month ago and we had a quick follow by implementing these changes into Carina on May 23rd.  The release fixes some bugs that were reported after the 1.11.0 release.  The change log can be found [here](https://github.com/docker/docker/releases/tag/v1.11.1) and a side by side comparison of the different versions can be found [here](https://github.com/docker/docker/compare/v1.11.0...v1.11.1).  Changes include a chunk of runtime fixes and also includes aspect concerning networking, documentation, builder, and distribution.

Along with Docker we also have improved our error messages related to security restrictions.  More information can be found on our [error codes](https://getcarina.com/docs/reference/error-codes/) page.

To stay up to date with ongoing release notes, maintanences and any incidents, head over to our [status page](https://carinabyrackspace.statuspage.io/).


### Upcoming appearances

![Screenshot of Dockercon]({% asset_path 2016-06-03-weekly-news-pycon-and-release-information/DockerCon.png %})

We'll be representing at [Dockercon 16](http://2016.dockercon.com/) this year so come on through the expo and chat us up about Carina and all things containers.  You can enter into our Carina contest where you get a chance to win a Parrot Bebop Quadcopter Drone. Your neighbors will love you. 


### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
