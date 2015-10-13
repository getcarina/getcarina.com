---
title: 'Container ecosystem: Docker Swarm'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/container-ecosystem-docker-swarm/
description: Best practices for container ecosystems, powered by the Rackspace Container Service
topics:
  - best-practices
  - planning
---

*Swarm's usefulness is unclear; wait for it to develop.*

A quick Google search for Docker Swarm primarily reveals discussion about
its announcement, but blogs, articles, and community forums centered on
reviews and/or experience with it are almost non-existent compared to
other container orchestrating tools. Docker founder Solomon Hykes
tweeted this about alignment between Kubernetes and Docker Swarm:

> “Fig [now known as Docker Compose], Kubernetes, Mesos etc. are
> competing orchestration tools. Docker will give devs a standard interface to all 3.
> libswarm [now known as Docker Swarm] is an ingredient of that std interface. The
> glue between Docker and orchestration backends [(1)](#resources)”.

If you are confused by this explanation of Docker Swarm’s added benefit,
you are not alone. Swarm attempts to offer entry-level
orchestration for managing distributed containers, but whenever you’re
ready to adopt another orchestrator that aligns with your goals for
scale, you can easily swap out Swarm’s engine for the one of your
choice. For some ideas about alternative orchestration tools, read
[Introduction to container technologies: orchestration and management of container clusters]
(/container-technologies-orchestration-clusters).

It is possible that the strategy behind Swarm is that
Docker is unwilling to get into the orchestration battle between
frontrunners Kubernetes and Mesosphere (which
runs on top of Mesos). Instead, Docker wanted to use Swarm to extend their
command-line interface, to an extent, but also be able to interact with the
other orchestrating engines. This tactic seems to keep
Docker relevant in terms of managing containers, local or
distributed, with Docker Swarm possibly a vector that Docker can productize
and monetize in some way in the future, so long as the user doesn't switch directly to an orchestration backend.

However, the community hasn’t really shown much
interest in Swarm, and is choosing to consume, learn, interact and
design their stacks for their orchestrator of choice directly. What
the future holds for Swarm is still to be determined, but the gist of
Docker Swarm's added benefits are currently unclear.

<a name="resources"></a>
### Resources

Numbered citations in this article:

1. <https://twitter.com/solomonstre/status/492111054839615488>

Other recommended reading:

- [Introduction to container technologies: orchestration and management of container clusters]
(/container-technologies-orchestration-clusters)

- <https://docs.docker.com/swarm/>

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
