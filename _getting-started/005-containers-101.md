---
title: Containers 101
author: Stephanie Fillmon <stephanie.fillmon@rackspace.com>
date: 2015-09-30
permalink: docs/tutorials/containers-101/
description: Learn about what containers are and how they work and how to create a container using Docker.
docker-versions:
  - 1.8.1
  - 1.8.2
topics:
  - containers
  - Docker
  - beginner
  - tutorial
---

###What are containers?

Containers package a piece of software with a complete file system that contains everything that the software needs to run, such as code, runtime, system tools, and system libraries. Rather than include a full operating system, like virtual machines (VMs) do, containers share the kernel of the host OS, enabling them to boot in seconds. Because the only space that containers use is the memory and disk space necessary for the software to run, containers are more portable and efficient than VMs.

![Containers are more lightweight and efficient than virtual machines]({% asset_path containers-101/containers-vs-vms.svg %})

###How do containers work?

In order to create the environment of a container, the host machine
does two things: isolates namespaces and governs resources.

Namespaces include all of the resources that an application can interact with,
including files and network ports. By isolating namespaces, the host can
give each container a virtualized namespace that includes only the resources
that the container needs. Because the container can’t access any files
outside of its virtualized namespace, the applications in the container behave as if they are
the only applications running on the system, even if there are actually hundreds more.

The host also controls how much of its resources can be used by a container.
By governing resources such as CPU and RAM, the
host ensures that each container gets the resources that it needs without
impacting the performance of other containers running on the host.

The combination of namespace isolation and governed resources enables
containerized applications to start in seconds.  Because its environment and
resource use are consistent across systems, a containerized application
that works on a developer’s system will work the same way on any system.

###How to create a container

Before you can create and start working with containers, you need to set up Docker. Docker is an open platform for building, shipping, and running distributed applications. Learn how to download, install, and set up the Docker client in [Docker 101](002-docker-101.md).

####Build a Docker host
Docker Machine enables you to create Docker hosts on your computer. It automatically creates the host, installs Docker on it, and configures the Docker client to talk to it.

Build a Docker host by running the following command, choosing anything you want for *dockerHostName*:

`docker-machine create --driver virtualbox <dockerHostName>`

Configure your shell to talk to your Docker host with the following command:

`eval "$(docker-machine env <dockerHostName>)"`.

####Download an image
To create and run a container, you must first download an image. For example, the following command downloads the Ubuntu 14.04 image:

`docker pull ubuntu:14.04`

You can download the latest release by omitting the release number tag, but we don't recommend it. Build your applications on specific image versions for greater stability. Move new versions in a controlled fashion through your CI/CD pipeline.

####Run a container
To create a container from an Ubuntu image, you use the following command. The `run` command creates the container and then starts it.

`docker run --interactive --tty ubuntu /bin/bash`

Most of the time, you won't see `--interactive` and `--tty` spelled out.
You can use the shortened versions, `-it` or `-i -t`, to
achieve the same effect. The `-t` flag assigns a pseudo-tty, or terminal, inside your new container. The `-i` flag creates an interactive connection by getting the standard input (`STDIN`) of the container.

After you run this command, your prompt changes and you are in your new container. Example:
`root@b6734565b373:/# `
You can perform the following actions while you are inside the container to become familiar with running commands inside a containerized environment:

 * `uname -a` returns certain system information. The appended `-a` prints all information.
   Example output:

   `Linux b6734565b373 4.0.9-boot2docker #1 SMP Thu Aug 13 03:05:44 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux`

 * `hostname` displays the host name.
   Example output:

   `b6734565b373`

 * `ps` displays the currently running processes associated with the current user and terminal session.
   Example output:

   ```
      PID TTY          TIME CMD
        1 ?        00:00:00 bash
       19 ?        00:00:00 ps
   ```

**Note**: This is not an exhaustive list of actions that you can perform while inside a container.

To exit out of the container, run `exit`. Your prompt returns to the previous prompt.
