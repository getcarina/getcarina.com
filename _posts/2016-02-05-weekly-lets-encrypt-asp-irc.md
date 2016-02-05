---
title: "Weekly news"
date: 2016-02-05 13:00
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  In this week's roundup: Let's encrypt ASP.NET and IRC.
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

Let's encrypt ASP.NET and IRC. Oops, that came out wrong. We've got some excellent new tutorials on using NGINX with Let's Encrypt, getting started with ASP.NET with Visual Studio, publishing an ASP.NET website from the command line, and using Quassel (distributed IRC client). Also news from the world of Docker.

## NGINX with Let's Encrypt

<img class="right" src="{% asset_path weekly-news/nginx.svg %}" alt="NGINX"/>This tutorial describes how to acquire free TLS certificates from [Let's Encrypt](https://letsencrypt.org/) and use them to secure a website that is served using NGINX. Following this process encrypts all traffic to and from your site with a certificate that's trusted by your browser and that provides strong enough encryption to get an A+ rating from SSL Labs.

[NGINX with Let's Encrypt]({{ site.baseurl }}/docs/tutorials/nginx-with-lets-encrypt/)

## Getting started with ASP.NET on Carina with Visual Studio

<img style="max-height: 200px; width: auto;" src="{% asset_path publish-aspnet-to-carina-with-visual-studio/carina-and-visual-studio.png %}" alt="ASP.NET"/>

The upcoming version of ASP.NET is a major evolution of the .NET platform. The name churn alone hints at its complete redesign: first ASP.NET vNext, then ASP.NET 5, and now ASP.NET Core 1.0. One very welcome feature is official cross-platform support, enabling you to develop on Windows with Visual Studio and deploy to Linux. If you are most familiar with the Microsoft stack, a great way to get started is to develop your website just as you do today and publish directly to Carina with Visual Studio, where deploying to Docker containers is just a wizard away.

[Getting started with ASP.NET on Carina with Visual Studio]({{ site.baseurl }}/docs/getting-started/aspnet-on-carina-with-visual-studio/)

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
