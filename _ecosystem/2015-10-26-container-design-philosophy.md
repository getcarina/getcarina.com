---
title: 'Container design philosophy'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-26
permalink: docs/best-practices/container-design-philosophy/
description: Explore container design philosophy
featured: true
topics:
- best-practices
- planning
---

*Run one process per container, manage containers as roles, and listen to advice from Docker but don't follow it blindly.*

Creating new containers is easy after you learn the basic technology. What can be difficult is deciding how to divide your workload most effectively among many containers.

### One process per container

Docker’s “Best Practices” guide suggests that you “run only one process per container [(1)](#resources).” Although such a design decision seems simple, this concept has been met with various opinions, discussions, and interpretation in the community.

Though you can actually run more than one process per Docker container, some believe that this practice diverges from the simple packaging and ease-of-use that containers are supposed to provide. Confusion about this philosophy stems primarily from newcomers to the field who want to find a sensible way to use containers. A beginner's natural instinct is to treat a container as a virtual machine that they would SSH into, creating a necessity for multiple processes representing at least the machine's true workload (such as a database) and the tools (such as networking and security tools) that
enable productive access to that workload. However,
when you realize that there are other methods of working with a
container--such as enforcing proper logs and using development containers with
a TTY for shell interaction--you can overcome this habit of
packing many different processes into a container.

As a result, the adoption of a
microservice architecture becomes prominent because its relationship to
containers is a clear fit, and as a concept
it is now synonymous with using containers.

Martin Fowler describes this approach:

> The term "Microservice Architecture" has sprung up over the last few
> years to describe a particular way of designing software applications
> as suites of independently deployable services. While there is no
> precise definition of this architectural style, there are certain
> common characteristics around organization around business capability,
> automated deployment, intelligence in the endpoints, and decentralized
> control of languages and data [(2)](#resources).

If one is willing to accept the concept of one process per container, then
it is safe to state that microservices are emerging as the preferred
methodology for building your application’s stack. This methodology not only
enables software to become more modular, but it also
intrinsically advocates for loose coupling of dependencies. This aids
in alleviating the pain of continuous integration and continuous deployment
and ultimately aids in
creating better software.

### Containers as roles

From both a mental and a technical
standpoint, it is easier to manage and use Docker containers as
*roles* rather than by the names of
individual processes such as nginx, apache2, or sshd.
Referring to Docker containers by their roles, such as
app, database, cache, or load balancer,
takes advantage of the flexibility and strengths of a container plus microservice
architecture for your application’s stack.

### Recommendation and caution

In general, authoritative recommendations about container design and development come directly from Docker, Inc., primarily from Docker CTO Solomon Hykes. Though there are several voices in the container industry, Hykes' opinions and suggestions tend to be well received. The relationship between Solomon Hykes and the Docker community is similar to that of Linus Torvalds with the Linux kernel community: Hykes is respected as a visionary and a technical leader. However, because Docker, Inc., is in fact a business, one can expect that Hykes has a responsibility to his investors and himself to position all of Docker’s offerings as the preferred methodology. As one can imagine in any scenario in which advice comes from a
profit-motivated entity, you should take Docker's advice as a starting point and then do your own investigation to find the approach that works best for you.

### Resources

Numbered citations in this article:

1. <https://docs.docker.com/articles/dockerfile_best-practices/#run-only-one-process-per-container>

2. <http://martinfowler.com/articles/microservices.html>

Other recommended reading:

- <http://www.forbes.com/sites/alexkonrad/2015/07/01/meet-docker-founder-solomon-hykes/>

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product
organization and is tasked with performing bleeding edge R&D and providing market
analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace
in 2012 as a Solutions Architect with the intent of helping OpenStack become the open
standard for cloud management. At Rackspace, Mike has led the integration effort with
strategic partner RightScale; aided in the assessment, development, and evolution of
Rackspace Private Cloud; and served as the Chief Architect of the Service Provider
Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National
Laboratories, a subsidiary of Lockheed Martin, performing research and development in
cybersecurity with regard to distributed systems, cloud, and mobile computing.
Follow Mike on [Twitter](https://twitter.com/@mikemetral).
