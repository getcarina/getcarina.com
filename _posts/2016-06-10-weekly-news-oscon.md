---
title: "Weekly news: Think outside the container"
date: 2016-06-10
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  Think outside the container with Carolyn Van Slyck and friends at OSCON 2016. Build and deploy applications effectively on Docker Swarm with Everett Toews at OSCON 2016. And finally, learn how to build a simple SaaS with jclouds and Carina with Zack Shoylev.
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

{{ page.excerpt }}

### Think outside the container

There is much more to Docker than just deploying your flagship application. Carolyn Van Slyck, Ash Wilson, and Nick Silkey look at three use cases for Docker that go beyond the typical software development pipeline: running a Hubot-based ChatOps bot, powering a GitHub based content management system, and teaching Docker with zero setup from the comfort of your web browser.

<iframe width="560" height="315" src="https://www.youtube.com/embed/B9bAWsCslqg" frameborder="0" allowfullscreen></iframe>

[View on YouTube](https://www.youtube.com/watch?v=B9bAWsCslqg)

### Effective Docker Swarm

Swarm—Docker’s answer to clustering—treats a group of Docker hosts as a single host. It uses the native Docker API, so you can use it with the whole ecosystem of Docker tooling. If you’re already familiar with Docker, you can take everything you’ve already learned and immediately apply it to Swarm. If you’re unfamiliar with Docker, it's easy to get started.

But how do you use Swarm effectively?

<iframe width="560" height="315" src="https://www.youtube.com/embed/FOs7UrGJnx8" frameborder="0" allowfullscreen></iframe>

[View on YouTube](https://www.youtube.com/watch?v=FOs7UrGJnx8)

### Build Simple SaaS with jclouds and Carina

Traditionally, creating and monetizing an online software solution has been a difficult process. With Docker and Carina, it has become much easier to set up software as a service (SaaS) solutions online. This post provides an example of a Tomcat application that directly controls Carina by using the Docker API to instantly start up user-specific software services on demand. The goal is to deploy an example Tomcat web application that can, on demand, provide a Mumble server to a user online. Mumble is a server/client VOIP telecommunication application.

[Build Simple SaaS with jclouds and Carina]({{ site.baseurl }}/blog/simple-saas-with-jclouds-and-carina/)

![Mumble]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/mumble_client.png %})

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
