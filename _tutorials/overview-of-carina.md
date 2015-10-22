---
title: Overview of Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-28
permalink: docs/overview-of-carina/
description: An overview of Carina
docker-versions:
  - 1.8.3
topics:
  - docker
  - beginner
---

### What is Carina?

Carina is a container runtime environment (currently in Beta) that offers performance, container-native tools, and portability without sacrificing ease of use. You can get started in minutes using open source software on managed infrastructure to run your containerized applications.

Your containers will run in a bare-metal environment avoiding the "hypervisor tax" on performance and run applications as much as 20% faster. That environment builds on the standard restrictions set out by libcontainer by using an AppArmor profile as an additional security layer to keep your resources isolated.

Carina is built on the open source Docker Swarm project. It exposes the native Docker/Swarm API so you get maximum portability to easily move applications from development to test and production environments, reducing errors, and saving time.

You'll also have access to an intuitive user interface and Carina specific developer tooling in addition to the entire ecosystem of tools already compatible with the Docker API. There is also a wealth of documentation, from getting started guides to detailed tutorials and best practices. If you need help, there's community support directly from other developers.

Creating an account to running a containerized application on a cluster takes under 2 minutes. You'll be using open source software like Docker to compose your applications. The infrastructure is managed by Rackspace so you can focus on what's important to you, your business and your applications.

### How does Carina even work?

Intro paragraph
![Carina overview]({% asset_path overview-of-carina/carina-cluster.svg %})

Details

### Key Concepts

#### Docker

TODO

#### Clusters

TODO

#### Segments

TODO

#### Containers

TODO

### The Control Surfaces

The GUI

The CLI [Getting started with the Carina CLI](/docs/tutorials/getting-started-carina-cli/)

### Resources

* [Understanding how Carina uses Docker Swarm](/docs/tutorials/docker-swarm-carina/)
* [Documentation](/docs/)
* [Community Forums](https://getcarina.com/community/)

### Next steps

1. Run your first containerized application by [Getting started on Carina](/docs/tutorials/getting-started-on-carina/)
