---
title: Introduction to container technologies: Docker
permalink: docs/best-practices/container-technologies-docker/
description: Introduction to container technologies, powered by the Rackspace Container Service
author: Mike Metral
date: 2015-10-01
topics:
  - best-practices
  - planning
---

*Docker automates the deployment of applications within containers. Each container has a much smaller resource footprint than a comparable conventional virtual machine. Containers are most likely to be most immediately helpful in greenfield projects, where work can begin in a containerized environment rather than requiring conversion from other configurations.*

Docker is an open-source project primarily focused on automating the deployment
of applications within containers.

## Background

Container technology has been around for many years but its popularity
increased along with the popularity of Docker.

Docker was released in early 2013 by Docker, Inc., formerly known as
dotCloud. Docker has benefited from a massive amount of community development
contribution and has amassed an immense following from people in various
roles such as developers, devops, CIOs and CTOs.

The success of the Docker project has even has gone as far to accumulate
several millions of dollars in funding for Docker Inc. providing them
with an estimated valuation of between 200 and 400 million dollars at the time of
this report [(1)](#resources).

Docker and the ecosystem being built around it,
primarily the container orchestration and management tools, are providing
a popular and open-source means for companies of all sizes to adapt
to the scalable, dynamic, and agile technologies that similarly power the
infrastructure and applications at technology giants such as Facebook, Google
and Amazon. You can read more about the ecosystem of orchestration tools
for containers at
[Introduction to container technologies: orchestration and management of container clusters]
(/container-technologies-orchestration-clusters/).

## Overview

Docker is based on Linux Containers (LXC) [(2)](#resources). LXC is a simplified
virtualization environment that allows you to run multiple, isolated
Linux systems on a single Linux host.

In a traditional virtual machine, the instance is allocated its own set of resources that
provide it with true isolation on the host, but that isolation comes with a heavy price in
terms of the resources required to run the machine. Another problem is the lack of
portability of the virtual machine across different virtualization platforms:
think
of the difficulty of trying to share a virtual machine image in a mixed environment combining Amazon AWS, Rackspace Cloud, Microsoft Azure, and Oracle VirtualBox. Now think
about the size of the image in addition to the image format, and how
transferring it from one platform to another doesn’t always prove to
be the most time- and cost-effective. These two issues just begin to
scratch the surface of the difficulties of managing virtual machines in
complex environments today.

In a container, you experience less isolation from other containers running
on the same host. Each container has a much smaller resource footprint
than a comparable conventional virtual machine.
This allows for far more efficient usage of your resources, and because containers are
much lighter they can be instantiated much more quickly than non-containerized
virtual machines.

Unfortunately, the one key functionality that the hypervisor hosting virtual machines provides today
that a container does not provide is that you can co-locate different operating
systems or kernels on the same platform. Therefore, if you have decided to run
instances of Windows alongside instances of Debian, Ubuntu, or Red Hat,
then containers aren’t applicable to your use case. This is due to the fact
that hypervisors abstract an entire machine whereas containers only
abstract the physical host’s operating system kernel. Nevertheless, as of
October 2014 Microsoft and Docker announced a partnership to invest in
enabling the Windows Server container in the Docker engine, in addition to
other Docker support in the suite of Microsoft products at a future date [(3)](#resources).

In its simplest form, you can think of Docker as a wrapper
for LXC. However, Docker provides much more functionality through a layer
of abstraction and automation of LXC, as well as a high-level API and a
booming ecosystem that is actively being built around it.

Docker’s main features center on:

* providing ease of portability through
  its format and bundling capabilities
* being optimized for the deployment
  of applications rather than machines
* a philosophy that components, including containers themselves,
  should be reusable as
  base images for other containers

In addition to the core features of Docker, sharing Docker images through
what is known as an image repository allows for the communal use of
applications. Applications can be fabricated once, uploaded into an image repository, and then downloaded many times by many consumers who did not participate in the image creation effort. For example, one can easily
download a Docker image and in a matter of seconds, run in that Docker container
the latest MySQL
Server, Redis, Apache, Golang Environment, or OpenVPN Server without
having to go through the full setup and configuration process for each
tool, let alone worrying about whether it will function on your virtualization platform.

You can learn more about image repositories at
[Docker best practices: image repository](/docker-best-practices-image-repository/).

The benefits provided by prefabricated container images are possible because Docker provides the ability to easily and quickly snapshot your application and its operating system components into a
common image that can be deployed on other hosts that also run the Docker engine. This capability
resonates in the technical community that is unfortunately familiar
with a sea of different virtual machine image formats and hypervisors that otherwise don’t
play well together without some heavy lifting, if at all.

In short, Docker is about being able to consistently deploy an
application environment in an easy and reproducible manner. In doing so,
Docker has started a forward progression of IT infrastructure and how we
construct the applications that run on the infrastructure to truly be
more flexible than ever before.

## Basic concepts

You will encounter these ideas in almost every discussion of Docker:

- **container**: The technology that allows the deployment and
  execution of an application and includes its dependencies, user files
  settings and the operating system.

- **Docker daemon or engine or server:** Responsible for managing and
  instantiating Docker containers.

- **Docker command-line client:** Allows a user to communicate and
  control the Docker server daemon.

- **Dockerfile**: A set of instructions to run over a
  base image. Docker follows these instructions to build a customized image.

- **Docker **mage**: Blueprint or template used to launch the Docker
  container.

- **Docker index / image repository:** Registry of Docker images that
  can be browsed and downloaded. The public Docker image repository is
  at <https://hub.docker.com/explore/> but you can also create your own private, local repository if needed.

## Operational concepts

Recall that containers share a common operating system kernel.
The following concepts allow each container to
be lightweight and fast while
having some form of isolation and
proper resource allocation

- **cgroups (container groups)**: Kernel feature which accounts for
  and isolates the resource usage (CPU, memory, disk, I/O, network)
  of a collection of processes [(4)](#resources).

- **namespaces**: Kernel feature that allows for a group of processes
  to be separated such that they cannot see resources in other groups [(5)](#resources).

- **unionfs**: Filesystem service which allows for actions to be done
  to the base image. By this method, layers are created and documented, such
  that each layer fully describes how to recreate a action. This
  strategy enables the lightweight nature of Docker's images, as only layer updates
  need to be propagated
  from one environment to another, much like the "small and fast" code repository system
  that git operates [(6)](#resources).

## Current container philosophy

Since Docker and the Docker ecosystem is currently a emerging field, it is
worth noting that containers are not intended to be a replacement for all
virtual machines or bare metal machines, let alone be applied to all use cases.
Containers are certainly providing a solution to some painful problems
for developers, operations and devops with regard to the
lifecycle of applications and managing their environments, but they are most likely to be most immediately helpful in greenfield projects, where work can begin in a containerized environment rather than requiring conversion from other configurations.

Also, there is a lot of competition and overlap across several of the
options within the Docker ecosystem and it is difficult to pinpoint which one is better than the other. That being said, not all use cases can be adapted perfectly into containers
today. This is particularly true of stateful applications, but work in this space is
being addressed by several technologies and should be in a much better
state at a future date. For more on this, read
[Docker best practices: data and stateful applications](/docker-best-practices-data-stateful-applications).

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <http://www.forbes.com/sites/benkepes/2014/09/16/the-rumors-were‐true-docker-funding-confirmed-and-40-million-enters-the-coffers/>

2. <https://linuxcontainers.org/>

3. <http://azure.microsoft.com/blog/2014/10/15/new-windows-server-containers-and-azure-support-for-docker/>

4. <http://en.wikipedia.org/wiki/Cgroups>

5. <http://en.wikipedia.org/wiki/Cgroups#NAMESPACE-ISOLATION>

6. <https://git-scm.com/about/small-and-fast>

*Other recommended reading*

- [Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/).

- <https://hub.docker.com/explore/>

- [Docker best practices: data and stateful applications](/docker-best-practices-data-stateful-applications)

- [Docker best practices: image repository](/docker-best-practices-image-repository/)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations, explore the *tutorials* collection.
* For detailed descriptions of reference architectures designed
  for specific use cases,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

## About the author

Mike Metral is a Product Architect at Rackspace. You can follow him in GitHub at https://github.com/metral and at http://www.metralpolis.com/.
