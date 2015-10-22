---
title: 'Introduction to container technologies: market analysis'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/container-technologies-market-analysis/
description: Explore the ecosystem of container-related tools
topics:
  - best-practices
  - planning
---

*Begin thinking about containers by comparing a container to a hypervisor; explore the ecosystem of container tools; focus on one major tool, Docker; investigate detailed recommendations relevant to your use case.*

This is an introduction to the various
technologies emerging in and around the container space; as an introduction, it does not
dive deeply into the details of any one
technology. Instead, this introduction provides some starting points from which you can begin to explore
containers and prepare for the architecture
decisions that you face in adapting containers into both your
infrastructure and toolbox. In addition, this introduction links to detailed analyses that highlight which container systems
and utilities serve as the best solutions depending on the use case, as
well as which of these options compete with and overlap one another.

The container ecosystem is one of the fastest evolving technology trends
that we’ve seen since the virtualized movement of the previous
decade. As such, bear in mind that the findings and
opinions expressed in this report are *extremely* time sensitive.
A timespan as small as six months can rapidly shift what
the community has come to consider as a viable option.

Much of the information discussed in this introduction and the detailed analyses is a
result of personal experience using technologies related to containers, but this is not
meant to take away from the influence of various other sources such as community
discussions, articles, and blog posts. You can see some of those sources listed in the [Resources](#resources) section of this and other articles on best practices for containers.

### How containers differ from the hypervisor

The excitement about containers in the recent two years becomes understandable
when you think of IT infrastructure from a traditional virtualization
perspective and consider the potential for even more elasticity and capability utilizing
computing resources.

In short, the virtualization we’ve all come to know and use today is
possible because of the development and rise of the hypervisor. If virtualization as enabled by hypervisors has been so ubiquitous and successful, why has the focus changed to containers and Docker? James Bottomley, leading Linux kernel
developer and CTO of server virtualization for Parallels, explained that VM hypervisors, such as Hyper-V, KVM, and Xen, are all "based on emulating virtual hardware. That means
they’re fat in terms of system requirements."

Containers, however, use shared operating systems. That means they are
much more efficient than hypervisors in system resource terms. Instead
of virtualizing hardware, containers rest on top of a single Linux
instance on the host. This in turn means you can “leave behind
the useless 99.9% VM junk, leaving you with a small, neat capsule
containing your application,” said Bottomley.

Therefore, according to Bottomley, with a perfectly tuned container
system, you can have as many as four-to-six times the number of
server application instances as you can using Xen or KVM VMs on the same
hardware [(1)](#resources).

### An evolving ecosystem

The immense evolution that containers are bringing forth has created a
space for a slew of technologies and tools to emerge, particularly at
the orchestration level.

Being somewhat of the Wild West right now in terms of competition does
not mean that one tool is the be-all and end-all to enable a
container offering.

Viewing the ecosystem as a complimentary vertical stack rather than a
horizontal one where tools are constantly bumping heads helps alleviate
the confusion between choosing one tool over the other, as many tools
are interoperable. This
ultimately enables and offers a new stack to power and operate your applications
and services.

Some tools do compete with each other
directly, and some step into areas that blur the lines. Because containerization is
such a fast-paced movement, it is expected that the messaging,
functionality, and roadmap for all tools in this domain will constantly
fluctuate.

To take advantage of ongoing evolution, you should closely track and survey the container tools ecosystem and
implement the tools most suited to your use case, based not only on the requirements of your container offering, but more importantly, the
popularity of the tool and its reception in the strong community that
serves as its driving force.

All container-related tools are not only young, but are also moving at a rapid pace.
For some, their statements of what they’re meant
to aid with and which technologies they respectively
interoperate with lack clarity or are still to be determined. It is the author’s opinion
that throughout 2015 the community will make it known which
technologies are meant to stick and which should be shelved.

### Docker

Of all the container-related tools available, Docker is the best known and most popular; Docker's wide adoption has spawned a slew of technical opportunities to revamp and
reconstitute how datacenters and application stacks should look and
operate. There are varying degrees of features and capabilities
that span and even spill over from one technology to the other, and
noticing these subtleties is a very complex and tedious task. Figuring
out which set of technologies will help you establish your future
roadmap comes down to understanding the types of users you’re trying to enable, as
well as the classes of workloads that you wish to manage across your resources.

Whether or not you intend to work directly with Docker, learning about Docker will help you develop the vocabulary and understand the concepts to make sense of other container tools.
[Docker's documentation](http://docs.docker.com/) is a good place to begin that effort.

### Recommendations

For specific observations and suggestions that you may wish to implement as you begin working with containers, we have developed a collection of best-practices articles about tools and practices in the container ecosystem. After the title of each article here, it's key recommendations are summarized; for details explaining a recommendation, follow the link to the article.

* [Introduction to container technologies: Docker](/container-technologies-docker/)

> Docker automates the deployment of applications within containers. Each container has a much smaller resource footprint than a comparable conventional virtual machine. Containers are most likely to be most immediately helpful in new projects, where work can begin in a containerized environment rather than requiring conversion from other configurations.

* [Introduction to container technologies: container operating systems](/container-technologies-operating-systems/)

> Use container-oriented operating systems CoreOS or Project Atomic for the functionality required to deploy applications along with self-updating and healing properties.

* [Introduction to container technologies: registration and discovery of container services](/container-technologies-registration-discover/)

> For service discovery and shared configuration, use the etcd distributed key-value store.

* [Introduction to container technologies: scheduling and management of services and resources](/container-technologies-scheduling-management/)

> For efficient isolation of resources facilitating different types of workloads and frameworks, use the Mesos distributed systems kernel.

* [Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/)

> The best tool for orchestration and management of container clusters varies with the size of the cluster: Kubernetes and Marathon excel with thousands of hosts while Compose is ideal for a single host.

* [Introduction to container technologies: container networking](/container-technologies-networking/)

> Use Weave to create a network in which Docker containers are part of the same virtual network switch no matter where they are running.

* [Introduction to container technologies: market analysis](/container-technologies-market-analysis/)

> *This article:* Begin thinking about containers by comparing a container to a hypervisor; explore the ecosystem of container tools; focus on one major tool, Docker; investigate detailed recommendations relevant to your use case.

* [Container design philosophy](/container-design-philosophy/)

> Run one process per container, manage containers as roles, and listen to advice from Docker but don't follow it blindly.

* [Docker best practices: Dockerfile](/docker-best-practices-dockerfile/)

> Create and customize your container images with a Dockerfile.

* [Docker best practices: image repository](/docker-best-practices-image-repository/)

> Create containers consistently and rapidly from saved container images.

* [Docker best practices: data and stateful applications](/docker-best-practices-data-stateful-applications/)

> Never store data or logs in a container. Instead, use Docker volume mounts to create either a data volume or a data volume container.

* [Docker best practices: container linking](/docker-best-practices-container-linking/)

> Use a service registration and discovery tool instead of Docker container linking.

* [Container ecosystem: Kubernetes](/container-ecosystem-kubernetes/)

> Use Kubernetes with Docker to manage and orchestrate containers in your stack.

* [Container ecosystem: Mesos versus OpenStack](/container-ecosystem-mesos-openstack/)

> Mesos and OpenStack can run separately or together. OpenStack
splits a cluster across several virtual machines; Mesos runs on bare metal or on Openstack; Mesos
combines all resources, whether virtual machines or bare metal,
and presents them as a single entity.

* [Container ecosystem: Docker Swarm](/container-ecosystem-docker-swarm/)

> Swarm's usefulness is unclear; wait for it to develop.

* [Container ecosystem: OpenShift](/container-ecosystem-openshift/)

> OpenShift can integrate with both OpenStack and Project Atomic, but OpenShift Enterprise may require top-to-bottom adoption of RedHat’s container and virtualization products.

<a name="resources"></a>
### Resources

Numbered citations in this article:

1. <http://www.zdnet.com/article/what-is-docker-and-why-is-it-so-darn-popular/>

Other recommended reading:

- [Virtualisation: the rise of the hypervisor](http://www.economist.com/node/10534566)

- [Docker's documentation](http://docs.docker.com/)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
