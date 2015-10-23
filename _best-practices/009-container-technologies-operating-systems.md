---
title: 'Introduction to container technologies: container operating systems'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/container-technologies-operating-systems/
description: Compare container-oriented operating systems
topics:
  - best-practices
  - planning
---

*Use container-oriented operating systems CoreOS or Project Atomic for the functionality required to deploy applications along with self-updating and healing properties.*

With the success and popularity of Docker containers, modern operating systems have emerged that embrace the container culture and are designed to work optimally with a container ecosystem. These operating systems tend to provide the minimal functionality required to deploy applications along with self-updating and healing properties that are different from today's standard maintenance-intensive operating systems. Container-oriented operating systems have evolved the traditional operating model by moving toward deploying applications inside containers and away from deploying applications at the application layer. More simply put, applications are self-contained binaries that you can move around in your container environments based on criteria such as quality of service, affinity, and replication.

### CoreOS’s CoreOS

CoreOS, the operating system from the company of the same name, is a new Linux distribution that provides the features needed to run modern infrastructure stacks via containers with a hands-off approach to operating system updates. CoreOS' update philosophy is that "frequent, reliable updates are critical to good security [(1)](#resources)." Updates to CoreOS are distributed as they are available and can be installed immediately and automatically, much like the automated update process for browsers such as Firefox. The strategies and architectures that influence CoreOS are similar to the mechanisms that allow companies like Google, Facebook, and Twitter to run their services at scale with high resilience.

In addition to self-updating, the CoreOS operating system
integrates seamlessly with CoreOS' other flagship products:

- **etcd**: a highly-available key-value store for shared configuration
  and service discovery.

- **fleet**: a distributed init system that uses etcd as its manifest
  and systemd as its mechanism for instantiating units. Units are
  configuration files that describe the properties of the process
  that you want to run. You can think of fleet as an extension of
  Debian's systemd that operates at the cluster level instead of the machine
  level, so it functions as a simple orchestration system for systemd
  units across your cluster.

You can learn more about
etcd at [Introduction to container technologies: registration and discovery of container services](../container-technologies-registration-discover/)
and more about
fleet at [Introduction to container technologies: scheduling and management of services and resources](../container-technologies-scheduling-management/).

### Red Hat's Project Atomic

Red Hat’s Project Atomic facilitates application-centric IT architecture
by providing an end-to-end solution for deploying containerized
applications quickly and reliably. Atomic update and rollback for applications and hosts enables implementation of frequent, small improvements.

The core of Project Atomic is the Project Atomic Host. This is a
lightweight operating system that has been assembled from upstream RPM Package Manager (RPM) content. Project Atomic Host is designed to run applications in Docker containers.

Project Atomic hosts inherit the full features and advantages of their
base distributions [(2)](#resources). Hosts can be based on several Linux distributions:

- Red Hat Enterprise Linux (RHEL)
- Fedora
- CentOS [(3)](#resources)

Project Atomic takes advantage of key Linux capabilities:

- *systemd*: a system and service manager, which provides
container dependency management and fault recovery
- *journald*: a system logging method, which provides secure aggregation and attribution of container
logs

<a name="resources"></a>
### Resources

Numbered citations in this article:

1. <https://coreos.com/using-coreos/updates/>

2. <http://www.projectatomic.io/docs/introduction/>

3. <http://www.projectatomic.io/blog/2015/06/centos-atomic-host-rebuild-released/>

Other recommended reading:

- <https://wiki.debian.org/systemd>

- <http://www.rpm.org/>

- [Introduction to container technologies: registration and discovery of container services](../container-technologies-registration-discover/)

- [Introduction to container technologies: scheduling and management of services and resources](../container-technologies-scheduling-management/)

In addition to *best-practices* articles such as this one,
Carina documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
