---
title: Docker networking basics
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-08
permalink: docs/tutorials/docker-networking-basics/
description: Learn how to connect Docker containers over a network
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - networking
---

Docker encourages an application architecture with multiple interdependent containers,
rather than a single container providing many services. For example, a web application
container that relies upon a caching container. There are multiple solutions which
facilitate networking containers, in this tutorial we will cover two basic
options: [Docker links](#links) and [Weave](#weave).

This tutorial describes how to network Docker containers so that they can communicate
among themselves.

### <a name="links"></a> Docker links
Docker links enable containers that are *on the same host* to communicate. This is useful
for development environments but is not recommended in production, as the single-host
restriction limits your topology and hinders scalability and availability.

When you run a container, the `--link` flag connects the new container, the _target_,
to an existing container, the _source_. Docker then provides information to both the
source and target containers so that they are aware of each other. It does so by
defining environment variables on the target container and adding entries to both
the source and target containers' **/etc/hosts** file.

This is useful for container isolation, not just service discovery. When containers are run with `--icc` and `--iptables`,
then they cannot communicate unless explicitly allowed by a Docker link.

### <a name="weave"></a> Weave
[Weave][weave] is a suite of products for managing a multi-container
applications. This tutorial will focus on Weave Net, which creates a network
capable of spanning Docker hosts.

what does a command look like?
* install on host vs remote

what is the topology? ip addresses and ports, tunnels, security, environment variables

using it from the dependent container

[weave]: http://weave.works/
<!--
List the steps required for users to get to your concept's equivalent of "Hello, world!"

Use a single numbered list for detailed steps when possible.

A single numbered list might be impractical for topics with a good amount of supporting information at each step. If a single numbered list of steps is not useful:

* Identify the main steps with H2-level headings.

    Omit numbering from headings. For example: "Install the latest version of Docker" is OK. "Step One: Install ..." is not OK.

    Include as many sections as needed to logically explain the idea.

* Limit subheadings to H3.

    Headings requiring further depth deserve their own tutorial. Create a separate tutorial, then link to it.

* In each section, provide a numbered list of substeps.

    Also provide paragraphs for explanations, bullet lists, code samples, and examples.
-->

### Resources

* [Docker links documentation](https://docs.docker.com/userguide/dockerlinks/)
* [Weave documentation](http://docs.weave.works/weave/latest_release/index.html)
* [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)
* [Service Discovery 101]({{ site.baseurl }}/tutorials/005-service-discovery-101/)
* [Introduction to container technologies: container networking]({{ site.baseurl }}/best-practices/container-technologies-networking/)

### Next

* [Connect Docker containers with Docker links]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-with-links/)
* [Connect RCS containers with Weave]({{ site.baseurl }}/docs/tutorials/connect-rcs-containers-with-weave/)
