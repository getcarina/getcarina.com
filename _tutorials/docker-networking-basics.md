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
facilitate networking containers; in this tutorial we will cover two basic
options: [Docker links](#links) and the [Ambassador pattern](#ambassador).

**Note:** Weave is a commonly recommended solution, however since it requires
privileged access to the Docker host, it is not an option with container as a service
providers, such as Rackspace Container Service.

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

{%comment%}
<!-- ![Docker links topology]({% asset_path connect-docker-containers-with-links/docker-links-topology.svg %}) -->
{%endcomment%}

### <a name="ambassador"></a> Ambassador pattern
The Ambassador pattern uses Docker links with specialized _ambassador_ containers to
enable communicating across Docker hosts. Rather than having the target container communicate
directly with the source container, the target container communicates with the _target ambassador_
via a Docker link. The target ambassador forwards messages to the _source ambassador_ on another Docker host.
The source ambassador then relays those messages to the source container via a Docker link.

{%comment%}
<!-- ![Ambassador pattern topology]({% asset_path connect-docker-containers-ambassador-pattern/ambassador-pattern-topology.svg %}) -->
{%endcomment%}

An application written to take advantage of Docker links does not require modification
in order to use the Ambassador pattern, as the ambassador containers transparently forward
messages to the source container. The ambassador application hosted in an ambassador Container is not specific to
a single application; it only needs to be capable of forwarding messages and can be used
with any application.

### Resources

* [Docker links documentation](https://docs.docker.com/userguide/dockerlinks/)
* [Docker Ambassador pattern documentation](https://docs.docker.com/articles/ambassador_pattern_linking/)
* [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)
* [Service discovery 101]({{ site.baseurl }}/tutorials/005-service-discovery-101/)
* [Introduction to container technologies: container networking]({{ site.baseurl }}/best-practices/container-technologies-networking/)

### Next

* [Connect Docker containers with Docker links]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-with-links/)
* [Connect Docker containers using the Ambassador pattern]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-ambassador-pattern/)
