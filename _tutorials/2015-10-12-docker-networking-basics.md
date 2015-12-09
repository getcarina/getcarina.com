---
title: Docker networking basics
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-12
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
rather than a single container providing many services&mdash;for example, a web application
container that relies upon a caching container. Multiple solutions facilitate
the networking of containers, but this tutorial covers two basic
options: [Docker links](#docker-links) and the [ambassador pattern](#ambassador-pattern).

**Note:** Weave is a commonly recommended solution, but because it requires
privileged access to the Docker host, it is not an option with container as a service
providers, such as Carina.

This tutorial describes how to network Docker containers so that they can communicate
among themselves.

### Docker links
Docker links enable containers that are *on the same host* to communicate.

When you run a container, the `--link` flag connects the new container, the _target_,
to an existing container, the _source_. Docker then provides information to both the
source and target containers so that they are aware of each other. It does so by
defining environment variables on the target container and adding entries to the
**/etc/hosts** file of both the source and target containers.

**Note:** Having all your containers on a single host is useful for development
environments but is not recommended in production. The single-host restriction
limits your topology and hinders scalability and availability.

![Docker links topology]({% asset_path connect-docker-containers-with-links/docker-links-topology.svg %})

### Ambassador pattern
The ambassador pattern uses Docker links with specialized _ambassador_ containers to
enable communication across Docker hosts. Rather than the target container communicating
directly with the source container, the target container communicates with the _target ambassador_
on the same host via a Docker link. The target ambassador forwards messages to the _source ambassador_
container on another Docker host. The source ambassador then relays those messages
to the source container via a Docker link.

![Ambassador pattern topology]({% asset_path connect-docker-containers-ambassador-pattern/ambassador-pattern-topology.svg %})

An application written to take advantage of Docker links does not require modification
in order to use the ambassador pattern, because the ambassador containers transparently forward
messages to the source container. The ambassador application hosted in an ambassador container is not specific to
a single application; it only needs to be capable of forwarding messages and can be used
with any application.

### Resources

* [Docker links documentation](https://docs.docker.com/userguide/dockerlinks/)
* [Docker ambassador pattern documentation](https://docs.docker.com/articles/ambassador_pattern_linking/)
* [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)
* [Service discovery 101]({{ site.baseurl }}/docs/tutorials/service-discovery-101/)
* [Introduction to container technologies: container networking]({{ site.baseurl }}/docs/best-practices/container-technologies-networking/)

### Next steps

* [Connect Docker containers with Docker links]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-with-links/)
* [Connect Docker containers using the ambassador pattern]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-ambassador-pattern/)
