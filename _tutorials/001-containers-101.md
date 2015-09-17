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

Containers house applications and everything needed to run them. Because the only space that containers use is the memory and disk space necessary for the application to run, containers can be created much faster and run more efficiently than virtual machines (VMs). While a VM might use several gigabytes of space, a container might use only several megabytes, allowing for a greater number of containers that can run on a single host.

Containers virtualize an operating system and contain logic that treat them as guests of the operating system. Applications that run in containers act as though they have full, unshared access to their own copy of the OS; however, there
is actually only one copy of the OS on the host server system.

Containers are often described as "lightweight." Unlike virtual machines (VM),
which have their own copies of OS files, libraries, and application code, along
with a full in-memory instance of an OS, containers share the host OS kernel, so that they don't need to boot an OS every time they run.

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

####Build a Docker machine
Docker Machine lets you create Docker hosts on your computer. It automatically creates the host, installs Docker on it, and configures the Docker client to talk to it.

Build a Docker machine by running the following command:

`docker-machine create --driver virtualbox MACHINE_NAME`

Start the new machine with the following command:

`eval "$(docker-machine env MACHINE_NAME)"`.

####Download an image
To create and run a container, you must first download an image. For example, the following command downloads the latest relesase of the `ubuntu` Docker image:

`docker pull ubuntu`

We recommend always specifying a release number, such as 12.02 or 14.04.
If you don't specify a release number, the latest release is downloaded, but Docker doesn't display which release you are running.

`docker pull ubuntu:14.04`

####Create a container
To run a container from an ubuntu image, run the following command:

`docker run --interactive --tty ubuntu /bin/bash`

Most of the time, you won't see `--interactive` and `--tty` spelled out.
You can use the shortened versions, `-it` or `-i -t`, to
achieve the same effect. The `-i` flag starts an interactive container. The `-t` flag creates a pseudo-TTY that
attaches standard input (stdin) and standard output (stdout).

After you run this command, you will be in your new container.
Following are some actions that you can perform while you are
inside the container:

 * `uname -a` returns certain system information. The appended `-a` prints all information.
 * `hostname` displays the host name.
 * `ps` displays the currently running processes associated with the current user and terminal session.

To exit out of the container, run `exit`.
