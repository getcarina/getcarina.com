---
title: Container design philosophy
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/container-design-philosophy/
description: Best practices for container design, powered by the Rackspace Container Service
topics:
- best-practices
- planning
---

*Run one process per container; manage containers as roles; listen to advice from Docker but don't blindly follow.*

Creating new containers is easy. What can be difficult is deciding how to divide your workload most effectively among many containers.

### Initial design suggestions

As a general rule of thumb, the author believes that authoritative recommendations about container design and development come directly from Docker, Inc., primarily from Docker CTO Solomon Hykes. Though there are several voices in the container industry, Hykes' opinions and suggestions tend to be well received. The relationship between Solomon Hykes and the Docker community is similar to that of Linus Torvalds with the Linux kernel community: Hykes is respected as a visionary and a technical leader. However, since Docker, Inc. is in fact a business, one can expect that Hykes has a responsibility to his investors and himself to position all of Docker’s offerings as the preferred methodology. As one can imagine in any scenario in which advice comes from a
profit-motivated entity, you should take this advice as a starting point and then do your own investigation to find the approach that works best for you.

### One process per container

Docker’s “Best Practices” guide suggests that you “run only one process per container [(1)](#resources).” Though this initially seems to be a simple design decision that you could easily overlook, this concept has been met with various opinions, discussions, and interpretation in the community.

Though you can actually run more than one process per Docker container, some believe that this diverges from the simple packaging and ease-of-use that containers are supposed to provide. Confusion about this philosophy stems primarily from newcomers to the field who want to find a sensible way to use containers. A beginner's natural instinct is to treat a container as a virtual machine that they would SSH into, creating a necessity for multiple processes representing at least the machine's true workload (such as a database)
and the tools (such as networking and security tools) that
enable productive access to that workload. However,
once one realizes that there are other methods of working with a
container (such as enforcing proper logs and using development containers with
a TTY for shell interaction) this hurdle of
packing many different processes into a container is no longer needed.

With insight into the alternative approaches that are practical in containers, the benefit that containers provide really
shines through and the instinct to create monolithic packages, such as
one would do with a virtual machine, becomes less relevant. Thus, the adoption of a
microservice architecture becomes prominent as its relationship to
containers not only appears as a better and clearer fit, but as a concept
that is now synonymous with using containers.

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
methodology when it comes to building your application’s stack. It
enables software to not only become more modular, but it
intrinsically advocates for loose coupling of dependencies. This aids
in alleviating the pain points of continuous integration and continuous deployment
and ultimately aids in
creating better software.

### Containers as roles

From both a mental and a technical
standpoint, it is easier to manage and use Docker containers as
roles rather than by the names of
individual processes such as nginx, apache2, or sshd.
Referring to Docker containers by their roles such as
app, database, cache, or load balancer
takes advantage of the flexibility and strengths of a container + microservice
architecture for your application’s stack.

<a name="resources"></a>
### Resources

Numbered citations in this article

1. <https://docs.docker.com/articles/dockerfile_best-practices/#run-only-one-process-per-container>

2. <http://martinfowler.com/articles/microservices.html>

Other recommended reading

- <http://www.forbes.com/sites/alexkonrad/2015/07/01/meet-docker-founder-solomon-hykes/>

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations, explore the *tutorials* collection.
* For detailed descriptions of reference architectures designed
  for specific use cases,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, as well as served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
