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

Carina is built on the open-source Docker Swarm and Kubernetes projects.  It exposes native APIs, which gives you maximum portability for easily moving applications from development to test and production environments, thus reducing errors and saving time. In the future, other container orchestration environments will be available to you.

You also have access to an intuitive user interface (UI), a command-line interface (CLI), and Carina specific developer tooling, in addition to the ecosystem of tools already compatible with the Docker and Kubernetes APIs. You also have access to a wealth of documentation, from getting started guides to detailed tutorials and best practices. If you need help, you can access community support directly from other developers.

The path from creating a free account to running a containerized application on a cluster takes under two minutes. You will use open-source software to compose your applications. Now you can focus on what's important to you, your business, and your applications.

### How does Carina work?

Carina provisions Docker Swarm and Kubernetes clusters for you to run your containerized applications on.

The following diagram shows a high level overview of Carina's architecture and key components.

![Docker Swarm overview]({% asset_path overview-of-carina/swarm-cluster.svg %})
![Kubernetes overview]({% asset_path overview-of-carina/kubernetes-cluster.svg %})

#### Docker

Docker is an open source project that automates the deployment of applications into containers. Docker provides an API that makes building, running, and sharing container images easy.

#### Kubernetes

Kubernetes is an open source project by Google that allows users to automate application deployments, handle scaling, and manage their containerized applications with a simple API.

#### Clusters

Clusters are created by Carina. You use the Carina UI or the Carina CLI to issue create commands to the _control plane_. The control plane creates and configures the cluster for you.

Clusters are composed of nodes. One node contains the cluster's Swarm manager. The Swarm manager orchestrates and schedules containers across the entire cluster. It assigns your containers to the nodes via the Swarm agent.

#### Nodes

Nodes are created by Carina. You use the Carina UI or the Carina CLI to issue grow commands to the control plane. The control plane creates and configures the nodes for you and adds them to the cluster.

For Docker Swarm clusters, nodes are composed of a Swarm agent, a Docker Engine, and your Docker containers. The Swarm agent accepts commands from the Swarm manager to run containers on its node. It then communicates with the Docker Engine to actually run the containers. The Docker Engine is a container runtime that builds and runs your Docker containers.

For Kubernetes clusters, masters are composed of the Kubernetes API, the scheduler and the controller. Nodes are composed of the kubelet and kube-proxy services that allows them to host Pods and other Kubernetes resources. For now, new Kubernetes clusters will be configured on a single node, so that the master and node are on the same LXC instance.

#### Docker containers

Containers are created by Docker. You can use the Docker CLI or other Docker ecosystem tools to issue any Docker commands to the Swarm manager. The Swarm manager passes those commands to the appropriate Swarm agent which in turn passes them to the Docker Engine to take action.

Containers are composed of your applications, their configuration, and anything else you need to build into them. They are created from Docker images. A Docker image is a template that contains the instructions that will run your application. It includes everything necessary to run your containerized applications.

#### Overlay networks

An overlay network provides isolation for containers to communicate across all of the nodes in your cluster on Carina. Overlay networks add another layer of security to your application deployments and make it easier for your containers to communicate with one another. An isolated network for containers that ensures only the services of your choice are exposed outside of your system reduces the attack surface for your applications.

### The control interfaces

You can interact with Carina through a UI or a CLI.

#### The UI

Carina has an intuitive UI that you can use to control clusters from your web browser or mobile device. Go to [app.getcarina.com](https://app.getcarina.com) to get started.

#### The CLI

Carina has a CLI that you can use to control clusters from a terminal or scripts. You can easily automate cluster creation and growth from the command line. The CLI is available on all operating systems as a single file executable which makes installation easy and painless. Go to [Getting started with Docker Swarm and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster-with-cli/) to learn more.

### Resources

* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
* [Kubernetes 101]({{ site.baseurl }}/docs/concepts/kubernetes-101/)
* [Carina documentation]({{ site.baseurl }}/docs/)
* [Carina community forums](https://community.getcarina.com)
* [Understanding how Carina uses Docker Swarm]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)
* [Glossary]({{ site.baseurl }}/docs/reference/glossary/)

### Next step

Run your first containerized application by [Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/) or [Getting started with Kubernetes]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster/).
