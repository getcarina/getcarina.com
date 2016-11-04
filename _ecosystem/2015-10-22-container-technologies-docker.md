---
title: 'Introduction to container technologies: Docker'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-22
permalink: docs/best-practices/container-technologies-docker/
description: Explore Docker
topics:
  - best-practices
  - planning
---

*Docker automates the deployment of applications within containers. Each container has a much smaller resource footprint than a comparable conventional virtual machine. Containers are most likely to be most immediately helpful in new projects, where work can begin in a containerized environment rather than requiring conversion from other configurations.*

Docker is an open-source project primarily focused on automating the deployment
of applications within containers.

### Background

Container technology has been around for many years, but its popularity has recently
increased following the release of Docker in 2013.

Docker was developed by Docker, Inc., formerly known as
dotCloud. Docker has benefited from a massive amount of community development
contribution and has amassed an immense following from people in various
roles such as developers, DevOps, CIOs, and CTOs.

The success of the Docker project has even gone as far as to accumulate
several millions of dollars in funding for Docker Inc. providing them
with an estimated valuation of between 200 and 400 million dollars at the time of
this report [(1)](#resources).

Docker and the ecosystem being built around it,
primarily the container orchestration and management tools, are providing
a popular and open-source means for companies of all sizes to adapt
to the scalable, dynamic, and agile technologies that similarly power the
infrastructure and applications at technology giants such as Facebook, Google,
and Amazon. You can read more about the ecosystem of orchestration tools
for containers at
[Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/).

### Overview

Docker is based on Linux Containers (LXC) [(2)](#resources). LXC is a simplified
virtualization environment that allows you to run multiple, isolated
Linux systems on a single Linux host.

In a traditional virtual machine, the instance is allocated its own set of resources to give it
true isolation on the host, but that isolation comes with a heavy price in
terms of the resources required to run the machine. Another problem is the lack of
portability of the virtual machine across different virtualization platforms:
think
of the difficulty of trying to share a virtual machine image in a mixed environment combining Amazon AWS, Rackspace Cloud, Microsoft Azure, and Oracle VirtualBox. Now think
about the size of the image in addition to the image format, and how
transferring it from one platform to another does not always prove to
be the most time- and cost-effective. These two issues only begin to
scratch the surface of the difficulties of managing virtual machines in
complex environments today.

Compared to virtual machines, containers running
on the same host are less isolated from each other. Each container has a much smaller resource footprint
than a comparable conventional virtual machine.
This allows for far more efficient usage of your resources, and because containers are
much lighter, they can be instantiated much more quickly than non-containerized
virtual machines.

The one key functionality that the hypervisor hosting virtual machines provides today
that a container does not provide is the ability to co-locate different operating
systems or kernels on the same platform. Therefore, if you have decided to run
instances of Windows alongside instances of Debian, Ubuntu, or Red Hat,
then containers are not applicable to your use case. This is because
hypervisors abstract an entire machine, whereas containers only
abstract the physical host’s operating system kernel. However, in
October 2014, Microsoft and Docker announced a partnership to invest in
enabling the Windows Server container in the Docker engine, in addition to
other Docker support in the suite of Microsoft products at a future date [(3)](#resources).

In its simplest form, you can think of Docker as a wrapper
for LXC. However, Docker provides much more functionality through a layer
of abstraction and automation of LXC, as well as a high-level API and a
booming ecosystem that is actively being built around it.

Docker primarily focuses on providing the following features:

* Ease of portability through
  its format and bundling capabilities
* Optimization for the deployment
  of applications rather than machines
* A philosophy that components, including containers themselves,
  should be reusable as
  base images for other containers

You can also share Docker images through
an image repository, enabling communal use of
applications. Applications can be fabricated once, uploaded into an image repository, and then downloaded by many consumers who did not participate in the image creation effort.

For example, you can
download a Docker image and, in a matter of seconds, run in that Docker container
the latest MySQL
Server, Redis, Apache, Golang Environment, or OpenVPN Server without
having to go through the full setup and configuration process for each
tool or worrying about whether it will function on your virtualization platform.

You can learn more about image repositories at
[Docker best practices: image repository]({{ site.baseurl }}/docs/best-practices/docker-best-practices-image-repository/).

Prefabricated container images are possible because Docker enables you to easily and quickly snapshot your application and its operating system components into a
common image that can be deployed on other hosts that also run the Docker engine. This capability
is a true benefit to a technical community that is familiar
with a multitude of different virtual machine image formats and hypervisors that otherwise do not
work well together.

In short, Docker is about being able to consistently deploy an
application environment in an easy and reproducible manner. In doing so,
Docker has started a forward progression of IT infrastructure and how we
construct the applications that run on the infrastructure to truly be
more flexible than ever before.

### Basic concepts

You will encounter these ideas in almost every discussion of Docker:

- **Container**: The technology that allows the deployment and
  execution of an application and includes its dependencies, user files
  settings, and the operating system.

- **Docker daemon, engine, or server**: Responsible for managing and
  instantiating Docker containers.

- **Docker command-line client**: Allows a user to communicate and
  control the Docker server daemon.

- **Dockerfile**: A set of instructions to run over a
  base image. Docker follows these instructions to build a customized image.

- **Docker image**: Blueprint or template used to launch the Docker
  container.

- **Docker index / image repository**: Registry of Docker images that
  can be browsed and downloaded. The public Docker image repository is
  at <https://hub.docker.com/explore/>, but you can also create your own private, local repository if needed.

### Operational concepts

Recall that containers share a common operating system kernel.
The following concepts allow each container to
be lightweight and fast while
having some form of isolation and
proper resource allocation:

- **cgroups (container groups)**: Kernel feature that accounts for
  and isolates the resource usage (CPU, memory, disk, I/O, and network)
  of a collection of processes [(4)](#resources).

- **namespaces**: Kernel feature that enables a group of processes
  to be separated such that they cannot see resources in other groups [(5)](#resources).

- **unionfs**: Filesystem service that allows for actions to be done
  to the base image.
  By this method, layers are created and documented with a full description of how to recreate an action.
  This strategy enables the lightweight nature of Docker's images, as only layer updates
  need to be propagated
  from one environment to another, much like the "small and fast" code repository system
  on which Git operates [(6)](#resources).

### Current container philosophy

Because Docker and the Docker ecosystem are still an emerging field, it is
worth noting that containers are not intended to be a replacement for all
virtual machines or bare metal machines, let alone be applied to all use cases.
Containers are certainly providing a solution to some painful problems
for developers, operations, and DevOps with regard to the
lifecycle of applications and managing their environments, but they are most likely to be most immediately helpful in new projects, where work can begin in a containerized environment rather than requiring conversion from other configurations.

Also, there is a lot of competition and overlap
within the Docker ecosystem, and it is difficult to pinpoint which one is better than the other. That being said, not all use cases can be adapted perfectly into containers
today. This is particularly true of stateful applications, but work in this space is
being addressed by several technologies and should be in a much better
state at a future date. For more on this, read
[Docker best practices: data and stateful applications]({{ site.baseurl }}/docs/best-practices/docker-best-practices-data-stateful-applications/).

### Resources

Numbered citations in this article:

1. <http://www.forbes.com/sites/benkepes/2014/09/16/the-rumors-were-true-docker-funding-confirmed-and-40-million-enters-the-coffers/>

2. <https://linuxcontainers.org/>

3. <http://azure.microsoft.com/blog/2014/10/15/new-windows-server-containers-and-azure-support-for-docker/>

4. <http://en.wikipedia.org/wiki/Cgroups>

5. <http://en.wikipedia.org/wiki/Cgroups#NAMESPACE-ISOLATION>

6. <https://git-scm.com/about/small-and-fast>

Other recommended reading:

- [Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/).

- <https://hub.docker.com/explore/>

- [Docker best practices: data and stateful applications]({{ site.baseurl }}/docs/best-practices/docker-best-practices-data-stateful-applications/)

- [Docker best practices: image repository]({{ site.baseurl }}/docs/best-practices/docker-best-practices-image-repository/)

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
