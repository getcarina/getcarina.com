---
title: Carina glossary
date: 2015-10-21
permalink: docs/references/glossary/
description: Provides a glossary of the terms used in Carina documentation
topics:
  - docker
  - containers
---

The following terms are used in the documentation for Carina.

##### ambassador pattern

A pattern for linking containers. The ambassador pattern uses Docker links with specialized ambassador containers to enable communication between containers across Docker hosts. 

##### AppArmor profile

A security layer in Carina that keeps conatiner resources isolated. It denies access to sensitive file paths on the hosts, whitelists expected mount calls for the container file system, and restricts the device capabilities of the Docker process.

##### Carina

A hosted container runtime environment provided by Rackspace. Carina is built on the open-source Docker Swarm project and provides bare-metal speeds, security, and portability for running yor applications in containers. 

##### cluster

A pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Carina provisions Docker Swarm clusters for running containers.

##### container

An userspace instance that packages a piece of software with a complete file system that contains everything that the software needs to run, such as code, system tools, and system libraries. Each container is an isolated and secure application platform. A container is created from an *image*. Containers can be run, started, stopped, moved, and deleted.

##### credentials

A set of TLS certificates and environment configuration files that you need to download and use to authenticate to your Carina cluster. 

##### Docker

An open-source, client-server platform for building, shipping, and running distributed applications in containers. Also referred to as the Docker Engine. 

##### Docker client	

The primary user interface to Docker. The client accepts commands from users and communicates with the Docker *daemon*, which runs in the Docker host. In Carina, the client is configured to communicate with the segments in a cluster.

##### Docker Compose

A tool used to define and run multicontainer applications with Docker. With Compose, you use a YAML file to define a multicontainer application, and then start the application with a single command.

##### Docker daemon	

Runs in a Docker host and builds, runs, and distributes containers. Users interact with the daemon through the Docker *client*. Sometimes referred to as the Docker *server* or *engine*.  	

##### Docker host

Runs in a virtual machine built by the *Docker Machine*. The host contains the daemon, and it is where images are built and containers are created. In Carina, the equivalent of a Docker host is a *segment*.

##### Docker Hub

The public Docker *registry* from which you can upload or download images.
 
##### Docker image

A read-only template that is used to create Docker containers. For example, an image could contain an Ubuntu operating system with Apache and your web application installed. You can download public images or create your own. Images are stored in *registries*.   	

##### Docker links

A pattern for linking containers that enables containers that are on the same host to communicate. 

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

A portion of the resources available in a cluster. Containers are housed in segments on the cluster. A Carina segment is an LXC container provisioned by libvirt.

##### service discovery

The process of discovering what services are available for an application. Service discovery is a two-part process. *Registration* is the process of a service registering its location with a central directory. *Discovery* occurs when a client application asks the directory for the location of a service. 

##### scheduler

A mechanism that is responsible for the life cycle of a container. The scheduler chooses the best *segment* to put the container in, and starts, stops, and destroys the container when requested. Different scheduler strategies can be used to pick the best segment to hold a container. In Carina, the spread scheduler strategy is used.
