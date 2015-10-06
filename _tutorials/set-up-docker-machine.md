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

Sometimes, when using a `docker` command such as `docker info`, you will receive the following output:

```
$ docker info
Get http:///var/run/docker.sock/v1.20/info: dial unix /var/run/docker.sock: no such file or directory.
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

You receive the above output when you are attempting to run `docker` commands with a Docker host. In order to use the `docker` client, you must be using a linux-based virtual environment through a Docker host.

This tutorial will will show you how to create a Docker host inside of a virtual environment.

### Prerequisites

Before you begin this tutorial, be sure that you have fulfilled these prerequisites:

* You have installed `docker-machine` through the Docker toolbox. For installation instructions, go to the installation section of [Docker-101](docker-101-introduction-docker), and click the link for your operating system.

> Windows and Mac users should already have `docker-machine` installed. If you are a linux user, you can find instructions to install `docker-machine` for linux here [here](https://docs.docker.com/machine/install-machine/).

* [VirtualBox 4.3.28](https://www.virtualbox.org/wiki/Downloads) or later.
* A working terminal application.

### Instructions

1. Run `docker-machine ls`. This command shows all available virtual machines running Docker.

    ```
    $ docker-machine ls
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

5. Verify the environment variables for your machine. You can do this by running `docker-machine env test`.

   ```
   $ docker-machine env test
   export DOCKER_TLS_VERIFY="1"
   export DOCKER_HOST="tcp://172.16.62.130:2376"
   export DOCKER_CERT_PATH="/Users/<your username>/.docker/machine/machines/dev"
   export DOCKER_MACHINE_NAME="test"
   # Run this command to configure your shell:
   # eval "$(docker-machine env dev)"
   ```

You can now run `docker` commands on this host.

### Next steps

Once you have a working Docker host, you can continue to the tutorial [Find and pull a Docker image](docs/tutorials/run-docker-image).

You can also load Rackspace Container Service into your Docker environment. Follow the link for your operating system to find out more:

* [Load a Docker environment on Linux](docs/tutorials/load-docker-environment-on-linux)
* [Load a Docker environment on Mac](docs/tutorials/load-docker-environment-on-mac)
* [Load a Docker environment on Windows](docs/tutorials/load-docker-environment-on-windows)
