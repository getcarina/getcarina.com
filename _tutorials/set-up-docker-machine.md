---
title: Set up a virtual environment with a Docker host
author: Nathaniel Archer <nate.archer@rackspace.com>
date: 2015-10-06
permalink: docs/tutorials/set-up-docker-machine/
description: Learn how to set up your virtual environment with a Docker host using a Docker Machine.
docker-versions:
  -1.8.2
topics:
  -Docker
  -beginner
  -tutorial
---

This tutorial describes how to use Docker Machine to create a Docker host inside of a virtual environment.

To use the Docker client on Mac OS X and Windows computers, you must set up a Linux-based virtual environment that contains a Docker host. The host enables the client to access the Docker daemon, which enables you to interact with your containers with any operating system.

**Note**: Linux users do not have to perform the steps outlined in this tutorial, although the commands described within the tutorial are useful for navigating between Docker hosts.

### Prerequisites

Before you begin this tutorial, be sure that you have fulfilled these prerequisites:

* You have installed Docker Machine through the Docker Toolbox. For Docker Toolbox installation instructions for Windows and Mac OS X, go to the installation section of [Docker 101](docker-101-introduction-docker) and click the link for your operating system.

Docker Machine is not required to run virtual environments on Linux. However, if you are a Linux user, you can find instructions for installing Docker Machine [the Docker website](https://docs.docker.com/machine/install-machine/).

* You have installed [VirtualBox 4.3.28](https://www.virtualbox.org/wiki/Downloads) or later.

* You have a working terminal application.

### Create a VM running a Docker host

1. Show all the available virtual machines (VMs) that are running Docker:

   `$ docker-machine ls`

   If you have not created any VMs yet, your output should look as follows:

   ```
   NAME   ACTIVE   DRIVER   STATE   URL
   ```

2. Create a VM that is running Docker:

   `$ docker-machine create --driver virtualbox test`.  

   The `--driver` flag indicates what type of driver the machine will run on. In this case, `virtualbox` indicates that the driver is Oracle VirtualBox. The final argument in the command gives the VM a name, in this case, `test`.

   The output should as follows

   ```
   Creating VirtualBox VM...
   Creating SSH key...
   Starting VirtualBox VM...
   Starting VM...
   To see how to connect Docker to this machine, run: docker-machine env test
   ```

3. Run `docker-machine ls` again to see the VM that you created. The output should look as follows:

   ```
   NAME             ACTIVE   DRIVER       STATE     URL                         SWARM
   test                      virtualbox   Running   tcp://192.168.99.101:2376
   ```

4. Run the following command to set environment variables for Docker:

   `$ eval $(docker-machine env test)`

   You have to perform this action every time you open a new tab or restart your VM.

   You can now run `docker` commands on this host.

   You also can load your Rackspace Container Service credentials into your Docker environment. For instructions, click the following link for your operating system:

   * [Load a Docker environment on Linux](docs/tutorials/load-docker-environment-on-linux)
   * [Load a Docker environment on Mac](docs/tutorials/load-docker-environment-on-mac)
   * [Load a Docker environment on Windows](docs/tutorials/load-docker-environment-on-windows)

### Next steps

 After you have a working Docker host, you can continue to the tutorial [Find and download a Docker image](docs/tutorials/run-docker-image).

If you wish to learn how to create a container, go to [Containers 101](docs/tutorials/containers-101).
