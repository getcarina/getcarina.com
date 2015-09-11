---
title: Containers 101
slug: containers-101-introduction-containers
description: Introduction to container concepts, and how to create a container using Rackspace Container Service
topics:
  - containers
  - os virtualization
  - namespace isolation
  - governed resources
  - tutorial
---

##What are containers?##

Containers virtualize an operating system, tricking applications into believing
that they have full, unshared access to their own copy of the OS. However, there
is actually only one copy of the OS on the host server system.

Containers are often described as "lightweight" because unlike virtual machines,
which have their own copies of OS files, libraries, and application code, along
with a full in-memory instance of an OS, containers share the host OS,
including the kernel and libraries, so that they don't need to boot an OS or
load libraries.

Because the only space they take up on the host is any memory and disk space
necessary for the application to run, containers can be spun up much faster and run
more efficiently than VMs. While a VM might take up several gigabyes of
space, a container might only use several megabytes instead, allowing for a
much greater number of containers that can run on a single host.

##How do containers work?##

In order to create the sandbox environment of a container, the host machine
does two things: namespace isolation and resource governance.

Namespaces include all of the resources that an application can interact with,
including files and network ports. With namespace isolation, the host can
give each container a virtualized namespace that includes only the resources
that container should see. Because the container can’t access any files
outside of its virtualized namespace, applications behave as if they are
the only applications running on the system, even if there are actually hundreds.

The host also controls how much of its resources can be used by a container.
By governing resources such as CPU, RAM, and network bandwidth, the
host ensures that each container gets the resources it needs without
impacting the performance of other containers running on the host.

The combination of namespace isolation and governed resources enables
containerized applications start in seconds.  Because its environment and
resource usage are consistent across systems, a containerized application
that works on a developer’s system will work the same way on any system.

##How to create a container##
