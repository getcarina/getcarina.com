---
title: Containers 101
slug: containers-101-introduction-containers
description: Introduction to container concepts, and how to create a container using Docker
topics:
  - containers
  - Docker
  - beginner
  - tutorial
---

###What are containers?

Containers package a piece of software with a complete file system that contains everything the software needs to run, such as code, runtime, system tools, and system libraries. Rather than include a full operating system, like virtual machines (VMs), containers share the kernel of the host OS, enabling them to boot in seconds. Because the only space that containers use is the memory and disk space necessary for the software to run, containers are more portable and efficient than VMs.

###How do containers work?

In order to create the environment of a container, the host machine
does two things: isolate namespaces and govern resources.

Namespaces include all of the resources that an application can interact with,
including files and network ports. By isolating namespaces, the host can
give each container a virtualized namespace that includes only the resources
that the container needs. Because the container can’t access any files
outside of its virtualized namespace, the applications in the container behave as if they are
the only applications running on the system, even if there are actually hundreds more.

The host also controls how much of its resources can be used by a container.
By governing resources such as CPU, and RAM, the
host ensures that each container gets the resources that it needs without
impacting the performance of other containers running on the host.

The combination of namespace isolation and governed resources enables
containerized applications to start in seconds.  Because its environment and
resource usage are consistent across systems, a containerized application
that works on a developer’s system will work the same way on any system.

###How to create a container

Before you can create and start working with containers, you need to set up Docker. Docker is an open platform for building, shipping, and running distributed applications. Learn how to download, install, and set up the Docker client in Docker 101. <!--link to Docker 101-->

####Build a Docker Host
Docker Machine lets you create Docker hosts on your computer. It automatically creates the host, installs Docker on it, and configures the Docker client to talk to it.

Build a Docker machine by running the following command:

`docker-machine create --driver virtualbox MACHINE_NAME`

Configure your shell to talk to your Docker host with the following command:

`eval "$(docker-machine env MACHINE_NAME)"`.

####Download an image
To create and run a container, you must first download an image. For example, the following command downloads the Ubuntu 14.04 image:

`docker pull ubuntu:14.04`

It's possible to download the latest release by omitting the release number tag, but it isn't recommended. Build your applications on specific image versions for greater stability. Move new versions in a controlled fashion through your <!--[CI/CD pipeline](link-to-ci-cd-tutorial).-->

####Create a container
To run a container from an ubuntu image, run the following command:

`docker run --interactive --tty ubuntu /bin/bash`

Most of the time, you won't see `--interactive` and `--tty` spelled out.
You can use the shortened versions, `-it` or `-i -t`, to
achieve the same effect. The `-t` flag assigns a pseudo-tty, or terminal, inside your new container and the `-i` flag creates an interactive connection by grabbing the standard in (`STDIN`) of the container.

After you run this command, you will be in your new container.
Following are some actions that you can perform while you are
inside the container to get a feel for running commands inside a containerized environment:

 * `uname -a` returns certain system information. The appended `-a` prints all information.
 * `hostname` displays the host name.
 * `ps` displays the currently running processes associated with the current user and terminal session.

To exit out of the container, run `exit`.
