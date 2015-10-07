---
title: Set up virtual environment with a Docker host
author: Nathaniel Archer <nate.archer@rackspace.com>
date: 2015-10-06
permalink: docs/tutorials/set-up-docker-machine/
description: Instructions on how to set up your virtual environment with Docker Machine using a Docker host.
topics:
  -Docker
  -beginner
  -tutorial
---

In order to use the `docker` client on Mac and Windows computers, you must be using a linux-based virtual environment through a Docker host. The host then allows `docker` to access the Docker daemon, allowing you to interact with your containers with any operating system.

This tutorial will will show you how to create a Docker host inside of a virtual environment.

### Prerequisites

Before you begin this tutorial, be sure that you have fulfilled these prerequisites:

* You have installed `docker-machine` through the Docker toolbox. For installation instructions, go to the installation section of [Docker-101](docker-101-introduction-docker), and click the link for your operating system.

Windows and Mac users should already have `docker-machine` installed. If you are a linux user, you can find instructions to install `docker-machine` for linux here [here](https://docs.docker.com/machine/install-machine/). That being said, `docker-machine` is not required to run virtual environments on Linux.

* [VirtualBox 4.3.28](https://www.virtualbox.org/wiki/Downloads) or later.
* A working terminal application.

### Instructions

1. Run `docker-machine ls`. This command shows all available virtual machines running Docker.

Your output should look as follows:

    ```
    NAME   ACTIVE   DRIVER   STATE   URL
    ```

2. To create a virtual machine with Docker running, run `docker-machine create --driver virtualbox test`.  

   ```
   $ docker-machine create --driver virtualbox test
   Creating VirtualBox VM...
   Creating SSH key...
   Starting VirtualBox VM...
   Starting VM...
   To see how to connect Docker to this machine, run: docker-machine env test
   ```

   The `--driver` flag indicates what type of driver `virtualbox` the machine will run on. The final argument in the command `test`, gives the machine a name.

3. Run `docker-machine ls` again to see the machine you created.

   ```
   $ docker-machine ls
   NAME             ACTIVE   DRIVER       STATE     URL                         SWARM
   test                      virtualbox   Running   tcp://192.168.99.101:2376
   ```

4. Run `eval $(docker-machine env test)`. This command will set environment variables for Docker. You will need to perform this action every time you open a new tab or you restart your machine.

   You can now run `docker` commands on this host.

   You also can load your Rackspace Container Service credentials into your docker environment. For instructions on how you do so, follow the links to your corresponding operating system below:

   * [Load a Docker environment on Linux](docs/tutorials/load-docker-environment-on-linux)
   * [Load a Docker environment on Mac](docs/tutorials/load-docker-environment-on-mac)
   * [Load a Docker environment on Windows](docs/tutorials/load-docker-environment-on-windows)

### Next steps

Once you have a working Docker host, you can continue to the tutorial [Find and pull a Docker image](docs/tutorials/run-docker-image).

If you wish to learn how to create a container, go to [Containers 101](docs/tutorials/containers-101).
