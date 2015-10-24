---
title: Carina glossary
author: Kelly Holcomb <kelly.holcomb@rackspace.com>
date: 2015-10-22
permalink: docs/references/glossary/
description: Provides a glossary of the terms used in Carina documentation
topics:
  - docker
  - containers
---

The following terms are used in the documentation for Carina.

##### autoscaling

A process that monitors your cluster resources and automatically grows a cluster if needed. A scaling action is triggered when either the average CPU or average memory consumption exceeds 80 percent across the cluster.

##### ambassador pattern

A pattern for linking containers. The ambassador pattern uses Docker links with specialized ambassador containers to enable communication between containers across Docker hosts. 

##### AppArmor profile

A security layer in Carina that keeps container resources isolated. AppArmor is a Linux kernel security module. The profile denies access to sensitive file paths on the hosts, whitelists expected mount calls for the container file system, and restricts the device capabilities of the Docker process.

##### Carina

A hosted container runtime environment provided by Rackspace. Carina is built on the open-source Docker Swarm project and provides bare-metal speeds, security, and portability for running your applications in containers. 

##### Carina CLI

A command-line interface for Carina that you can use to launch and control Docker Swarm clusters on a Carina endpoint.

##### cluster

A pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Carina provisions Docker Swarm clusters for running containers.

##### container

A userspace instance that packages a piece of software with a complete file system that contains everything that the software needs to run, such as code, system tools, and system libraries. Each container is an isolated and secure application platform. A container is created from an *image*. Containers can be run, started, stopped, moved, and deleted.

##### control plane

The component of Carina that takes the commands that you input in the UI or CLI and performs functions such as creating clusters and adding segments to clusters. 

##### credentials

A set of TLS certificates and environment configuration files that you need to download and use to authenticate to your Carina cluster. 

##### data volume

A directory within a container that stores data and is meant to persist beyond the life cycle of the container. Data volumes can be shared and reused among containers, and they can be created in special *data volume containers*. 

##### data volume container (DVC)

A container that houses one or more volumes and whose sole aim is to store data in a persistent way. DVCs are often used as a centralized data store across multiple containers on the same Docker host. Other containers can mount the volume inside a DVC and save their data to it, providing non-persistent containers with a way to handle persistent storage.

##### Docker

An open-source, client-server platform for building, shipping, and running distributed applications in containers. Also referred to as the Docker Engine. 

##### Docker client	

The primary user interface to Docker. The client accepts commands from users and communicates with the Docker *daemon*, which runs in the Docker host. In Carina, the client is configured to communicate with the segments in a cluster.

##### Docker Compose

A tool used to define and run multicontainer applications with Docker. With Compose, you use a YAML file to define a multicontainer application, and then start the application with a single command.

##### Docker daemon	

Runs in a Docker host and builds, runs, and distributes containers. Users interact with the daemon through the Docker *client*. Sometimes referred to as the Docker *server* or *engine*.  	

##### Docker host

A machine that runs the *Docker daemon*. The host is also where images are built and containers are created. When Docker is run locally on Windows and Mac OS X machines, the host runs in a virtual machine built by the *Docker Machine*. In Carina clusters, the equivalent of a Docker host is a *segment*.

##### Docker Hub

The public Docker *registry* from which you can upload or download images.
 
##### Docker image

A read-only template that is used to create Docker containers. For example, an image could contain an Ubuntu operating system with Apache and your web application installed. You can download public images or create your own. Images are stored in *registries*.   	

##### Docker links

A Docker configuration option that connects containers. Links enable containers that are on the same host to communicate. 

##### Docker Machine	

Software that enables you to create Docker hosts on your computer or in the cloud. It creates hosts, installs Docker on them, and configures the Docker client to talk to them. A machine is the combination of a Docker *host* and a Docker *client*. Docker Machine uses the `docker-machine` binary.  	

##### Docker Swarm	

A clustering tool for Docker. Swarm enables you to host and schedule a cluster of Docker containers. Carina uses Docker Swarm clusters. 

##### Docker Toolbox

Installs and sets up a Docker environment on a computer. Toolbox is available for Windows and Mac OS X, and it installs the Docker client, Docker Machine, Docker Compose (Mac only), Kitematic, and Oracle VM VirtualBox.

##### Dockerfile

A text document that contains all of the commands that a user would call on the command line to assemble an *image*.	

##### microservices

A software architecture style in which complex applications comprise small, independent processes that communicate with each other through APIs. 

##### registry	

An open-source service application that stores and distributes Docker images. You can run your own registry or use one of the publicly available registries. The public Docker registry is called *Docker Hub*. 

##### segment

A portion of the resources available in a cluster. Containers are housed in segments on the cluster. A Carina segment is an LXC container provisioned by libvirt. Segments are composed of a Swarm agent, a Docker Engine, and containers. 

##### service discovery

The process of discovering what services are available for an application. Service discovery is a two-part process. *Registration* is the process of a service registering its location with a central directory. *Discovery* occurs when a client application asks the directory for the location of a service. 

##### scheduler

A mechanism that is responsible for the life cycle of a container. The scheduler chooses the best *segment* to put the container in, and starts, stops, and destroys the container when requested. Different scheduler strategies can be used to pick the best segment to hold a container. In Carina, the spread scheduler strategy is used.

##### Swarm agent

The component on a segment that accepts commands from the *Swarm manager*. The agent communicates with the Docker Engine to perform the commands, such as running containers.

##### Swarm manager

The component that orchestrates and schedules containers across an entire cluster. The Swarm manager assigns your containers to the segments in the cluster via the *Swarm agent*.
