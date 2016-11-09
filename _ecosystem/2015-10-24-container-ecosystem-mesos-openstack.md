---
title: 'Container ecosystem: Mesos versus OpenStack'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-24
permalink: docs/best-practices/container-ecosystem-mesos-openstack/
description: Compare Mesos and OpenStack
docker-versions:
topics:
  - best-practices
  - planning
---

*Mesos and OpenStack can run separately or together. OpenStack
splits a cluster across several virtual machines; Mesos can run on bare metal or on Openstack
and combines all resources, whether virtual machines or bare metal,
and presents them as a single entity.*

As Docker's popularity has increased, considering what options to include in your stack
increasingly means exploring the ecosystem of tools built on top of Docker as well as
the tools that empower Docker. Mesos, a cluster manager developed by Apache, is one of the
technologies that has gained importance in the container ecosystem.

Mesos' recent support of Docker containers and the development of
Mesosphere to orchestrate containers on top of Mesos have helped Mesos
increase in popularity. However, there
are some questions about how Mesos compares to other methods of
establishing Platform-as-a-Service from the infrastructure layer:

- Is it best to integrate Mesos into a stack?
- Is OpenStack a better or easier method?
- Is Kubernetes or some other technology a better fit than either Mesos or OpenStack?

People tend to think of Mesos and OpenStack as competitors.
However, Mesos and OpenStack are so different that it isn't completely practical to
compare them. In fact, running Mesos on top of OpenStack is a common operating
model[(1)](#resources), but you can also run Mesos directly on bare metal.

The differentiating factor between Mesos and OpenStack is the way they group resources:

- OpenStack splits up your cluster across several virtual machines for your applications to run on
- Mesos combines all of your resources, whether virtual machines or bare metal, and presents them as a single entity or machine.

Therefore, you can think of Mesos as one
very large machine on which to run your applications.

Promoters of Mesos argue that virtual machines were meant
to solve the issue of
consolidating several differentiated workloads on far fewer machines, ultimately saving money,
simplifying management of resources,
and moving away from traditional virtualization, which was plagued with
horrible turnarounds and bottlenecks. This much is true.
Mesos reverses this pattern to a degree, at the cost of removing full
isolation for your application because of the operational differences between Linux containers
and virtual machines.

Recent attention to Mesos in the Docker ecosystem centers
around the assumption that new projects are more likely to create applications in containers
than in virtual machines, so designing an infrastructure to run and consume OpenStack seems
to add unneeded complexity when you can achieve the same efficiency from Mesos.

You can decide whether to implement Mesos, OpenStack, a combination, or an alternative
based on your current needs and your plans for infrastructure to support future applications.
A key consideration to investigate is the degree to which your datacenter, stack, and
application must be decoupled to accommodate workloads that may be in virtual machines,
containers, or both. Timothy Prickett Morgan suggests that OpenStack may seem most relevant
to those who are most focused on datacenter operation while Mesos and Kubernetes may appeal
most to those most focused on application development:

>OpenStack is gaining traction in the datacenter and Mesos and Kubernetes, while in their relative
> infancy, are drawing attention to the higher layers of the software stack.\[...\]
> It would be natural enough to think that OpenStack would end up being the center of gravity
> for all control functions, at least for those parts of the datacenter where open source software
> is preferred.\[...\] When OpenStack was formed, software containers had been around for a
> long time but had faded for a time as virtual machines and the server consolidation they
> enabled took the datacenter by storm.\[...\] With the advent of software containers, the
> need for OpenStack has not necessarily abated, but the rise of the Mesos and Kubernetes
> schedulers and the idea of containerized application development and deployment has come
> to the forefront, and this naturally begs the question of which kind of controller will
> ultimately be in charge of the application clusters of the future.[(2)](#resources)

### Resources

Numbered citations in this article

1. <https://www.openstack.org/summit/vancouver-2015/summit-videos/presentation/platform-as-a-service-kubernetesmesos-openstack>

2. <http://www.theplatform.net/2015/08/13/will-openstack-kubernetes-or-mesos-control-future-clusters/>

Other recommended reading

- <http://mesos.apache.org/>

- <https://wiki.openstack.org/wiki/Magnum>

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product
organization and is tasked with performing bleeding edge R&D and providing market analysis,
design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as
a Solutions Architect with the intent of helping Openstack become the open standard for cloud
management. At Rackspace, Mike has led the integration effort with strategic partner
Rightscale, aided in the assessment, development, and evolution of Rackspace Private
Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining
Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary
of Lockheed Martin, performing research and development in cybersecurity with regard to
distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
