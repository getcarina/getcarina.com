---
title: "Weekly news"
date: 2016-01-22 13:00
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  In this week's roundup: Users users users
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

This week we hear from the most important people of all, our users. Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.

## Deploying and building Minecraft as a Service on Carina

<img class="right" style="max-height: 50; width: auto;"  src="{% asset_path 2016-01-17-deploying-and-building-minecraft-as-a-service/mccy-deployment.svg %}" alt="MCCY"/>Both of my kids have loved Minecraft since the beta days and what they love almost as much are adventure maps and mods -- customizations/hacks of the official engine to give new features, creatures, or entire virtual economies. Over the past year though I have dreamed of having a way for them (or any Minecrafters) to fire up a custom server with all kinds of specific nuances without having to know anything about Docker. My first attempt at the idea fizzled out since managing multiple Docker daemons was complicated and tedious. But now the stars have aligned, and I have been able to create and deploy [Minecraft Container Yard (MCCY)](https://github.com/itzg/minecraft-container-yard).

[Deploying and building Minecraft as a Service on Carina]({{ site.baseurl }}/blog/deploying-and-building-minecraft-as-a-service/)

## Free Cloud9 IDE with Docker and Rackspace Carina

![Cloud9]({% asset_path 2016-01-22-weekly-news-users-users-users/cloud9.png %})

So I’ve been flirting with the idea of using a Chromebook for development and relying on remote servers for the place to do all my development. This has lead me down the path of looking at many different browser based IDEs and it’s clear that Cloud9 and Eclipse Che are two of today’s winners. Then I went to the The 12 Clouds of Christmas in Austin, TX where I was introduced to Rackspace Carina. And then I was inspired to see if I could get either of the IDEs running on Carina.

[Free Cloud9 IDE with Docker and Rackspace Carina](http://continuousfailure.com/post/carina_cloud9/)

## Using Carina to Mimic IRCcloud

Using Open Source software you get used to being on IRC freenode be exact, more or less 24 hours a day 7 days a week. People talk/collaborate/work together there and it’s important to stay informed.

[Using Carina to Mimic IRCcloud](http://jjasghar.github.io/blog/2015/11/15/using-carina-to-mimic-irccloud/)

## Releases

We also did releases of a couple of tools our user community depends on:

* [Carina CLI v1.1.1](https://github.com/getcarina/carina/blob/master/README.md)
 * We're on [Choclatey](https://chocolatey.org/) now! Run `choco install carina` to install and `choco upgrade carina` to upgrade to the latest release.
 * Rename: nodes --> nodes
 * Autoscale can be enabled with `carina autoscale <clustername> [on|off]`
* [Docker Version Manager v0.3.0](https://github.com/getcarina/dvm/blob/master/README.md)
 * Authenticate GitHub API calls to avoid rate limit. If the `GITHUB_TOKEN` environment variable is set, requests to the GitHub API will be authenticated and the rate limit will be much higher.
 * Fixed a bug where dvm use did not properly validate that the requested version exists.

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
