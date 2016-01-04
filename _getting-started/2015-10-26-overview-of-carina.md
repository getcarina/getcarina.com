---
title: Overview of Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-26
featured: true
permalink: docs/overview-of-carina/
description: Definition and introduction to Carina including key concepts and next steps for implementation.
docker-versions:
  - 1.8.3
topics:
  - docker
  - beginner
---

### What is Carina?

Carina is a container runtime environment (currently in Beta) that offers performance, container-native tools, and portability without sacrificing ease of use. You can get started in minutes by using open-source software on managed infrastructure to run your containerized applications.

Your containers run in a bare-metal environment, which avoids the "hypervisor tax" on performance. Applications in this environment launch as much as 20 percent faster and run as much as 60 percent faster. This environment builds on the standard restrictions set out by libcontainer by using an AppArmor profile as an additional security layer to keep your resources isolated.

Carina is built on the open-source Docker Swarm project.  It exposes the Docker API, which gives you maximum portability for easily moving applications from development to test and production environments, thus reducing errors and saving time. In the future, other container orchestration environments will be available to you.

You also have access to an intuitive user interface (UI), a command-line interface (CLI), and Carina specific developer tooling, in addition to the ecosystem of tools already compatible with the Docker API. You also have access to a wealth of documentation, from getting started guides to detailed tutorials and best practices. If you need help, you can access community support directly from other developers.

The path from creating a free account (no credit card required) to running a containerized application on a cluster takes under two minutes. You will use open-source software like Docker to compose your applications. And because the infrastructure is managed by Carina, you can take advantage of features like autoscaling. Now you can focus on what's important to you, your business, and your applications.

### How does Carina work?

Carina provisions Docker Swarm clusters for you to run your containerized applications on.

The following diagram shows a high level overview of Carina's architecture and key components.

![Carina overview]({% asset_path overview-of-carina/carina-cluster.svg %})

#### Docker

Docker is an open source project that automates the deployment of applications into containers. Docker provides an API that makes building, running, and sharing container images easy.

#### Clusters

Clusters are created by Carina. You use the Carina UI or the Carina CLI to issue create commands to the _control plane_. The control plane creates and configures the cluster for you.

Clusters are composed of segments. One segment contains the cluster's Swarm manager. The Swarm manager orchestrates and schedules containers across the entire cluster. It assigns your containers to the segments via the Swarm agent.

#### Segments

Segments are created by Carina. You use the Carina UI or the Carina CLI to issue grow commands to the control plane. The control plane creates and configures the segments for you and adds them to the cluster.

Segments are composed of a Swarm agent, a Docker Engine, and your Docker containers. The Swarm agent accepts commands from the Swarm manager to run containers on its segment. It then communicates with the Docker Engine to actually run the containers. The Docker Engine is a container runtime that builds and runs your Docker containers.

#### Docker containers

Containers are created by Docker. You can use the Docker CLI or other Docker ecosystem tools to issue any Docker commands to the Swarm manager. The Swarm manager passes those commands to the appropriate Swarm agent which in turn passes them to the Docker Engine to take action.

Containers are composed of your applications, their configuration, and anything else you need to build into them. They are created from Docker images. A Docker image is a template that contains the instructions that will run your application. It includes everything necessary to run your containerized applications.

#### Autoscaling

Because the infrastructure is managed by Carina, you can choose to turn on autoscaling for your clusters. If you do, every cluster is monitored on a ten-minute interval. If a cluster needs resources, additional segments are automatically added.

If you want to control this behavior more closely, you can provide Carina with scheduler hints like reserving memory for your containers. The automated scaling action is triggered when either 80 percent of either reserved memory or CPU is being consumed. To avoid data loss, the cluster is never scaled down and segments are never deleted automatically.

Alternatively, you can manually scale a cluster through the control interfaces.

### The control interfaces

You can interact with Carina through a UI or a CLI.

#### The UI

Carina has an intuitive UI that you can use to control clusters from your web browser or mobile device. Go to [app.getcarina.com](https://app.getcarina.com) to get started.

#### The CLI

Carina has a CLI that you can use to control clusters from a terminal or scripts. You can easily automate cluster creation and growth from the command line. The CLI is available on all operating systems as a single file executable which makes installation easy and painless. Go to [Getting started with the Carina CLI]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/) to learn more.

### Resources

* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
* [Carina documentation]({{ site.baseurl }}/docs/)
* [Carina community forums](https://community.getcarina.com)
* [Understanding how Carina uses Docker Swarm]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/)
* [Autoscaling resources in Carina]({{ site.baseurl }}/docs/reference/autoscaling-carina/)
* [Glossary]({{ site.baseurl }}/docs/reference/glossary/)

### Next step

Run your first containerized application by [getting started on Carina]({{ site.baseurl }}/docs/getting-started/getting-started-on-carina/).
