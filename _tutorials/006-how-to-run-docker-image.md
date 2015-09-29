---
title: How to find and run a Docker Image.
slug: docker-101-run-images
description: Instructions on how to find and run a Docker Image from Docker hub, and the function of Docker Images.
topics:
  -Docker
  -beginner
  -tutorial
---

# How to find and run a Docker Image.

Docker Images serve as the building blocks for containers. The image acts
as software you load into the container. They can be as simple as running a single command like `run hello-world`, or as complex as an entire database or host operating system.

This is the benefit of Docker Images. Anyone can create and share their images through [Docker hub](https://hub.docker.com/). Even if your computer cannot run the software in a Docker Image, Docker containers will always be able to run that image. This offers a clear advantage over virtual machines(VMs), which are limited to the scope of the hardware running the VMs.

This tutorial describes how to find and run any image from Docker hub, as well as creating your own customizable Docker image.

## Before you begin

Before you can begin this tutorial, be sure that you have fulfilled these prerequisites:

* You have installed `docker`. For installation instructions, go to the installation section of [Docker-101](docker-101-introduction-docker), and click the link for your operating system.
* A terminal application.
* A virtual machine, such as Kitematic or [VirtualBox 4.3.28](https://www.virtualbox.org/wiki/Downloads)

To ensure the you fulfill these prerequisites run the command `docker version` in your terminal application:

```$ docker version
 Client:
 Version:      1.8.2
 API version:  1.20
 Go version:   go1.4.2
 Git commit:   0a8c2e3
 Built:        Thu Sep 10 19:10:10 UTC 2015
 OS/Arch:      darwin/amd64

Server:
 Version:      1.8.1
 API version:  1.20
 Go version:   go1.4.2
 Git commit:   d12ea79
 Built:        Thu Aug 13 02:49:29 UTC 2015
 OS/Arch:      linux/amd64
 ```

If you received an output similar to the one above, move on to the section "How to find and run a docker image". If you received a different output, move on to the next section.

## Set-up your Docker machine and virtual environment

Sometimes, when using the command `docker version`, you will receive this output:

```$ docker info
Get http:///var/run/docker.sock/v1.20/info: dial unix /var/run/docker.sock: no such file or directory.
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```
In order to use the `docker` client, you must be using a linux-based virtual environment through a Docker host. This section will show you how to set-up this virtual environment.

When you installed Docker Toolbox, the toolbox installed an additional client called Docker Machine. Docker Machine allows you to create Docker hosts on your computer or on your cloud, while also allowing the `docker` client to interact with them.

For the purposes of this tutorial, we will create a Docker host inside of VirtualBox. Make sure that [VirtualBox 4.3.28](https://www.virtualbox.org/wiki/Downloads) is installed before beginning these steps:

> Windows and Mac users should already have `docker-machine` installed. If you are a linux user, you can find instruction to install `docker-machine` [here](https://docs.docker.com/machine/install-machine/).

1. Run `docker-machine ls`. This command shows all available virtual machines running Docker. ```$ docker-machine ls NAME   ACTIVE   DRIVER   STATE   URL```

2. To create a virtual machine with Docker running, run `docker-machine create --driver virtualbox test`.  ```$ docker-machine create --driver virtualbox test
   Creating VirtualBox VM...
   Creating SSH key...
   Starting VirtualBox VM...
   Starting VM...
   To see how to connect Docker to this machine, run: docker-machine env test```

   The `--driver` flag indicates what type of driver `virtualbox` the machine will run on. The final argument in the command `test`, gives the machine a name.

3. Run `docker-machine ls` again to see the machine you created. ```$ docker-machine ls
   NAME             ACTIVE   DRIVER       STATE     URL                         SWARM
   test                      virtualbox   Running   tcp://192.168.99.101:2376```

4. Run `eval $(docker-machine env test)`. This command will set environment variables for Docker. You will need to perform this action every time you open a new tab or you restart your machine.

5. Verify the environment variables for your machine. You can do this by running `docker-machine env test`. ```export DOCKER_TLS_VERIFY="1"
   export DOCKER_HOST="tcp://172.16.62.130:2376"
   export DOCKER_CERT_PATH="/Users/<your username>/.docker/machine/machines/dev"
   export DOCKER_MACHINE_NAME="test"
   # Run this command to configure your shell:
   # eval "$(docker-machine env dev)"```

You can now run `docker` commands on this host.

## 
