---
title: Overview of Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-28
permalink: docs/overview-of-carina/
description: Definition and introduction to Carina including key concepts and next steps for implementation.
docker-versions:
  - 1.8.3
topics:
  - docker
  - beginner
---

### What even is Carina?

Carina is a container runtime environment (currently in Beta) that offers performance, container-native tools, and portability without sacrificing ease of use. You can get started in minutes using open source software on managed infrastructure to run your containerized applications.

Your containers will run in a bare-metal environment avoiding the "hypervisor tax" on performance and run applications as much as 20% faster. That environment builds on the standard restrictions set out by libcontainer by using an AppArmor profile as an additional security layer to keep your resources isolated.

Carina is built on the open source Docker Swarm project. It exposes the native Docker/Swarm API so you get maximum portability to easily move applications from development to test and production environments, reducing errors, and saving time.

You'll also have access to an intuitive user interface (UI), a command line interface (CLI), and Carina specific developer tooling in addition to the entire ecosystem of tools already compatible with the Docker API. There is also a wealth of documentation, from getting started guides to detailed tutorials and best practices. If you need help, there's community support directly from other developers.

Creating an account to running a containerized application on a cluster takes under 2 minutes. You'll be using open source software like Docker to compose your applications. Because the infrastructure is managed by Rackspace you can take advantage of features like auto-scaling. Now you can focus on what's important to you, your business and your applications.

### How does Carina even work?

Carina provisions Docker Swarm clusters for you to deploy your containerized applications on.

![Carina overview]({% asset_path overview-of-carina/carina-cluster.svg %})

#### Docker

Docker is an open source project that automates the deployment of applications into containers. Docker provides an API that makes building, running, and sharing container images easy.

#### Clusters

Clusters are created by Carina. You use the Carina UI or the Carina CLI to issue create commands to the control plane. The control plane creates and configures the cluster for you.

Clusters are composed of Segments. One Segment contains the cluster Swarm manager. The Swarm manager orchestrates and schedules containers across the entire Cluster. It assigns your containers to the Segments via the Swarm agent.

#### Segments

Segments are created by Carina. You use the Carina UI or the Carina CLI to issue grow commands to the control plane. The control plane creates and configures the segments for you and adds them to the cluster.

Segments are composed of a Swarm agent, a Docker Engine, and your Docker containers. The Swarm agent accepts commands from the Swarm master to run containers on its Segment. It then communicates with the Docker Engine to actually run the containers. The Docker Engine is a container runtime that builds and runs your Docker containers.

#### Docker Containers

Containers are created by Docker. You can use the Docker CLI or other Docker ecosystem tools to issue any Docker commands to the Swarm master. The Swarm master passes those commands along to the appropriate Swarm agent which in turn passes them along to the Docker Engine to take action.

Containers are composed of your applications, configuration, and anything else you need to build into them. They are created from Docker images. A Docker image is a template containing the instructions that will run your application. It includes everything necessary to run your containerized applications.

#### Auto-Scaling

Because the infrastructure is managed by Rackspace you can choose to turn on auto-scaling for your clusters. If you do, every cluster will be monitored on a five minute interval. If we find that a cluster needs resources, we automatically add additional Segments.

If you want to control this behavior more closely, you can provide Carina with scheduler hints like reserving memory for your containers. Our automated scaling action will trigger when either 50% of memory or CPU is being consumed. To avoid data-loss, we will never scale down or delete one of your nodes automatically.

Alternatively, you can manually scale the cluster through the the control surfaces.

### The Control Surfaces

#### The user interface

Carina has an intuitive UI that you can use to control clusters from your web browser or mobile device. Go to [app.getcarina.com](https://app.getcarina.com) to get started.

#### The command line interface

Carina has a CLI that you can use to control clusters from your terminal or scripts. Easily automate cluster creation and growth on the command line. It's available on all operating systems as a single file executable which makes installation easy and painless. Go to [Getting started with the Carina CLI](/docs/tutorials/getting-started-carina-cli/) to learn more.

### Resources

* [Docker 101](/docs/tutorials/docker-101/)
* [Carina Documentation](/docs/)
* [Carina Community Forums](https://getcarina.com/community/)
* [Understanding how Carina uses Docker Swarm](/docs/tutorials/docker-swarm-carina/)

### Next step

1. Run your first containerized application by [Getting started on Carina](/docs/tutorials/getting-started-on-carina/)
