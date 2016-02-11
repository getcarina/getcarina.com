---
title: "Weekly news - Docker Affinity, Mumble and Feedback!"
date: 2016-02-11 13:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  In this week's roundup:
categories:
 - Docker
 - Affinity
 - Carina
 - News
authorIsRacker: true
---

Let's encrypt ASP.NET and IRC. Oops, that came out wrong. We've got some excellent new tutorials on using NGINX with Let's Encrypt, getting started with ASP.NET with Visual Studio, publishing an ASP.NET website from the command line, and using Quassel (distributed IRC client). Also news from the world of Docker.

## Error running a container using a custom image

<img class="right" src="{% asset_path weekly-news/affinity.png %}" alt="affinity"/> This new troubleshooting guide by the excellent [Carolyn Van Slyck](https://twitter.com/carolynvs) covers something *everyone* gets confused by at once dealing with multiple independent Docker Swarm hosts/nodes (Carina Clusters & Segments). "Error response from daemon: Error: image library/<custom-image> not found" is a fairly cryptic error. <img class="left" src="{% asset_path weekly-news/confused.gif %}" alt="confused"/>

Carolyn gives you plenty of options to fix / work around this in the tutorial including:

* Use image affinity scheduling with Docker Swarm
* Use Docker Hub (cheater!)
* Use another public Docker registry
* Use a private Docker registry

Check it out: [Running a container using a custom image]({{ site.baseurl }}/troubleshooting/run-container-using-custom-image/)

## Use Mumble on Carina

<img class="right" src="{% asset_path weekly-news/mumble.png %}" alt="mumble"/>

Next up; Mumble is a low-latency, multiplatform voice chat software. I remember using it mostly for... well World of Warcraft (don't ask) and Counter Strike but Zack Shoylev shows us how to use it in Docker making it easy to run Murmur in a portable way.

If you like talking with people (it's a life-choice) then check it out - mumble is encrypted voice communications, and if you mesh it with magically renewing TLS certificates via [NGINX with Let's Encrypt]({{ site.baseurl }}/docs/tutorials/nginx-with-lets-encrypt/) it should get you +10 points to house tinfoil! <img class="left" src="{% asset_path weekly-news/tinfoil.jp %}" alt="tinfoil"/>

[Use Mumble on Carina]({{ site.baseurl }}/tutorials/2016-02-05-mumble-on-carina/)

## Publish an ASP.NET website to Carina from the command line

<img class="right" style="max-height: 200px; width: auto;" src="{% asset_path publish-aspnet-to-carina/aspnet-powered-by-carina.png %}" alt="ASP.NET"/>One very welcome feature of ASP.NET is official cross-platform support, no longer requiring Visual Studio, Windows, or even the Mono framework. Now that you can develop ASP.NET on any platform using free tools and deploy to Linux, hosting on Carina is a smart next step, whether you are new to ASP.NET or a veteran who wants to take it to the next level by deploying to containers.

[Publish an ASP.NET website to Carina from the command line]({{ site.baseurl }}/docs/tutorials/publish-aspnet-to-carina/)

## Use Quassel on Carina

<img class="left" src="{% asset_path weekly-news/quassel.png %}" alt="Quassel"/>Quassel IRC is a multiplatform distributed IRC client. In some ways, it behaves like a very smart and advanced IRC bouncer.

Quassel has two parts, core and client. The core is an always-on service that stays permanently connected to your IRC channels online and preserves your chat history and settings. You can connect to your core by using a Quassel client from multiple devices, thus keeping your history and settings in sync across all of them.

In the past, you had to run Quassel core on an always-on machine you own, or rent one in the cloud. But now, Docker makes it possible to run Quassel in a container. And Carina enables you to run that container in the cloud, at no cost. This tutorial describes how to run a Quassel core instance on Carina.

[Use Quassel on Carina]({{ site.baseurl }}/docs/tutorials/quassel-on-carina/)

## Docker 1.10 released

On February 4th, Docker released Engine 1.10, Compose 1.6, and Swarm 1.1. It was a release notable for security, networking, and improvements to the image format. You can read more about it at [Docker 1.10: New Compose file, improved security, networking and much more!](http://blog.docker.com/2016/02/docker-1-10/). The Carina team is currently hard at work on improved reliability and overlay networks for Carina. We'll be evaluating 1.10 in the future and will upgrade when ready.

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
