---
title: Introduction to container technologies: container operating systems
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/container-technologies-operating-systems/
description: Introduction to container technologies, powered by the Rackspace Container Service
docker-versions:
topics:
  - best-practices
  - planning
---

*To provide the minimal functionality required to deploy applications along with self-updating and healing properties, use container-oriented operating systems CoreOS or Project Atomic.*

With the success and popularity of containers made by Docker, modern operating systems have emerged that embrace the container culture and are designed to work optimally with it. These operating systems tend to provide the minimal functionality required to deploy applications along with self-updating and healing properties which are different from today's standard maintenance-intensive operating systems. These container-oriented operating systems have evolved the operating model that users are accustomed to by moving away from deploying applications at the application layer to deploying applications inside containers operated by Docker. More simply put, applications can be thought of as self-contained binaries that you can move around in your container environments based on your requirements such as quality of service, affinity, and replication.

### CoreOS’s “CoreOS”

CoreOS, the operating system from the company of the same name, is a new Linux distribution that has been architected to provide features needed to run modern infrastructure stacks via containers with a hands-off approach to keeping the operating system up to date. This means that updates to CoreOS are pushed out as they are available, much like the manner in which browsers such as Firefox are automatically updated. The strategies and architectures that influence CoreOS are similar to the mechanisms that allow companies like Google, Facebook, and Twitter to run their services at scale with high resilience.

In addition to the self-updating nature of the CoreOS operating system, the real value lies in
its integration with CoreOS' other flagship products:

- **etcd** highly-available key value store for shared configuration
  and service discovery.

- **fleet**: distributed init system that uses etcd as its manifest
  and systemd as its mechanism for instantiating units. Units are
  configuration files that describe the properties of the process
  that you want to run. One could think of it as an extension of
  Debian's systemd that operates at the cluster level instead of the machine
  level, so it functions as a simple orchestration system for systemd
  units across your cluster.

### Red Hat's "Project Atomic"

Red Hat’s Project Atomic facilitates application-centric IT architecture
by providing a end-to-end solution for deploying containerized
applications quickly and reliably, with atomic update and rollback for
application and host alike.

The core of Project Atomic is the Project Atomic Host. This is a
lightweight operating system that has been assembled from upstream RPM Package Manager (RPM) content. Project Atomic Host is designed to run applications in Docker containers. Hosts based on Red Hat Enterprise Linux and Fedora are available now. Hosts based on CentOS will be available soon.

Project Atomic hosts inherit the full features and advantages of their
base distributions. This includes systemd, which provides
container dependency management and fault recovery. It also includes
journald, which provides secure aggregation and attribution of container
logs [(1)](#resources).

<a name="resources"></a>
### Resources

Numbered citations in this article

1. <http://www.projectatomic.io/docs/introduction/>

Other recommended reading

- <https://wiki.debian.org/systemd>

- <http://www.rpm.org/>

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
