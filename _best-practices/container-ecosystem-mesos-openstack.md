---
title: Container ecosystem: Mesos versus OpenStack
slug: container-ecosystem-mesos-openstack
description: Best practices for container ecosystems, powered by the Rackspace Container Service
author: Mike Metral
topics:
  - best-practices
  - planning
---

# Container ecosystem: Mesos versus OpenStack

*Mesos and OpenStack can run separately or together. OpenStack
splits a cluster across several virtual machines; Mesos can run on bare metal or on Openstack; Mesos combines all resources, whether virtual machines or bare metal,
and presents them as a single entity.*

With Docker’s rise in fame, the ecosystem built on top of it as well as
the one that empowers it has introduced technologies, both new and
existing, to be considered as options in the stack. Mesos is one of the
technologies that have gotten traction in the container ecosystem.
Mesos' recent support of Docker containers and the development of
Mesosphere to orchestrates containers on top of Mesos have helped Mesos
increase in popularity. However, there
is confusion about whether one should integrate Mesos into their
stack or should alternatively be using OpenStack
or even some other technology to empower
the Platform-as-a-Service offering from the infrastructure layer.

People tend to think of Mesos and OpenStack as competitors.
However, Mesos and OpenStack are so different that,
like the apples versus oranges debate, it isn't completely practical to
compare them. In fact, one can run Mesos on top of OpenStack [(1)](#resources); this tends
to be a very common operating model but, if you choose to, you can also
just run Mesos directly on bare metal.

The differentiating factor between Mesos and OpenStack is that OpenStack
splits up your cluster across several virtual machines
for your applications to run on, and Mesos
combines all of your resources, whether virtual machines or bare metal,
and presents them as a
single entity or machine.
Therefore, one could think of Mesos as one
very large machine on which to run your applications.

The promoters of Mesos argue that virtual machines were meant
to solve the issue of
consolidating several differentiated workloads on far fewer machines
than they once needed, ultimately saving money,
simplifying management of resources,
and moving away from traditional virtualization which was plagued with
horrible turnarounds and bottlenecks. This much is true. In contrast,
Mesos to a degree reverses this pattern at the cost of removing full
isolation for your application due to the nature of how Linux containers
operate differently from virtual machines.

In particular, recent attention to Mesos in the Docker ecosystem centers
around the concept that greenfield projects expect to create more
of their applications in containers rather than virtual machines,
so designing your
infrastructure to run and consume OpenStack seems like overkill and an
added complexity when you can achieve the same efficiency from Mesos.

At the end of the day, it really comes down to necessity and planning
for the future infrastructure that your applications will consume.
Whether that is Mesos, OpenStack, or a mix of the two, will highly
depend on how decoupled you want to create your
datacenter, stack, and application to accommodate the nature of varying
workloads from different user bases whether they be in virtual machines,
containers,
or both.

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <https://www.openstack.org/summit/vancouver-2015/summit-videos/presentation/platform-as-a-service-kubernetesmesos-openstack>

*Other recommended reading*

- <http://mesos.apache.org/>

- <https://wiki.openstack.org/wiki/Magnum>

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
