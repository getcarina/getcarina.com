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

## Find and run a Docker Image

This section shows you how to find and run a Docker Image.

1. Run `docker images`. This command lists all images downloaded onto your current Docker machine. ```$ docker images
   REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE```

2. Because you currently have no images on your machine, you need to search and find an image. To search for an image use `docker search` and than the name of the image you wish to use. For this tutorial, we'll search for an Ubuntu image. Run `docker search ubuntu`. ```$ docker search ubuntu
   NAME                           DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
   ubuntu                         Ubuntu is a Debian-based Linux operating s...   2325      [OK]       
   ubuntu-upstart                 Upstart is an event-based replacement for ...   34        [OK]```

   Docker will pull a list of Docker hub repositories containing an Ubuntu image.

3. Now that you have found the image you wish to use, run `docker pull ubuntu:12.04`. Docker will download Ubuntu version 12.04. ```$ docker pull ubuntu:12.04
   12.04: Pulling from library/ubuntu
   ba2b457ecfb2: Pull complete
   26180b0fe8fb: Pull complete
   edd7c1974a70: Pull complete
   57bca5139a13: Pull complete
   library/ubuntu:12.04: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
   Digest: sha256:b6055621e534009eb9cddbfbb5766a983d99a73fb9d170cc224209a628f91804
   Status: Downloaded newer image for ubuntu:12.04```

   > If you run `docker pull <name of image>` without indicating the version you wish to download, Docker will download the latest version of that image.

4. Run `docker images` again to see your downloaded images. ```$ docker images
   REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
   ubuntu              latest              91e54dfb1179        5 weeks ago         188.4 MB
   ubuntu              12.04               57bca5139a13        5 weeks ago         134.8 MB```

   Docker stores a copy of the image onto your computer to save time when you run the image. If you find that you no longer need an image, you can delete the image yourself using the command `docker rmi` followed by the image id.

## Make and share your own Docker Image
