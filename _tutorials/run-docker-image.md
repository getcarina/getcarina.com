---
title: Find and pull a Docker image
author: Nathaniel Archer <nate.archer@rackspace.com>
date: 2015-10-06
permalink: docs/tutorials/run-docker-image/
description: Instructions on how to find and run a Docker Image from Docker hub, and the function of Docker Images.
topics:
  -Docker
  -beginner
  -tutorial
---

Docker Images serve as the building blocks for containers. The image acts as software you load into the container. The image can be as simple as running a single command like `run hello-world`, or as complex as an entire database or host operating system.

The benefit of Docker images is that anyone can create and share their images through [Docker hub](https://hub.docker.com/). Even if your computer cannot run the software in a Docker Image, Docker containers will always be able to run that image. This offers a clear advantage over virtual machines(VMs), which are limited to the scope of the hardware running the VMs.

This tutorial describes how to find and run any image from Docker hub.

### Before you begin

Before you can begin this tutorial, be sure that you have fulfilled these prerequisites:

* You have installed `docker`. For installation instructions, go to the installation section of [Docker-101](docker-101-introduction-docker), and click the link for your operating system.
* You have performed the steps in the tutorial, [Set up Docker machine and your virtual environment](docs/tutorials/set-up-docker-machine).
* A terminal application.
* A virtual machine, such as Kitematic or [VirtualBox 4.3.28](https://www.virtualbox.org/wiki/Downloads)

To ensure that you fulfill these prerequisites run the command `docker version` in your terminal application:

```
$ docker version
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

If you received an output similar to the one above, continue to the next section. If your output was different, please review the steps in the tutorial [Create a Docker host](docs/tutorials/set-up-docker-machine) to ensure you are running on a Docker host.

### Find and pull a Docker Image

This section shows you how to find and run a Docker Image.

1. Run `docker images`. This command lists all images downloaded onto your Docker machine.


The output should look as follows:

   ```
   REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
   ```

2. Because you currently have no images on your machine, you need to search and find an image. To search for an image on Docker hub, use `docker search` and type the name of the image you wish to use. For this tutorial, we'll search for an Ubuntu image. Run `docker search ubuntu`.

The output should look as follows:

   ```
   NAME                           DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
   ubuntu                         Ubuntu is a Debian-based Linux operating s...   2325      [OK]       
   ubuntu-upstart                 Upstart is an event-based replacement for ...   34        [OK]
   ```

   Docker will pull a list of Docker hub repositories containing an Ubuntu image.

3. Now that you have found the image you wish to use, run `docker pull ubuntu:12.04`. Docker will download Ubuntu version 12.04.


The output should look as follows:

   ```
   12.04: Pulling from library/ubuntu
   ba2b457ecfb2: Pull complete
   26180b0fe8fb: Pull complete
   edd7c1974a70: Pull complete
   57bca5139a13: Pull complete
   library/ubuntu:12.04: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
   Digest: sha256:b6055621e534009eb9cddbfbb5766a983d99a73fb9d170cc224209a628f91804
   Status: Downloaded newer image for ubuntu:12.04
   ```

   > If you run `docker pull <name of image>` without indicating the version you wish to download, Docker will download the latest version of that image.

4. Run `docker images` again to see your downloaded images.

The output should look as follows:

   ```
   REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
   ubuntu              latest              91e54dfb1179        5 weeks ago         188.4 MB
   ubuntu              12.04               57bca5139a13        5 weeks ago         134.8 MB
   ```

   Docker stores a copy of the image onto your computer to save time when you run the image. If you find that you no longer need an image, you can delete the image yourself using the command `docker rmi` followed by the image id.

### Next step

To learn how to create and share your own Docker image, go to [Make and share a Docker image](docs/tutorials/make-docker-image).

To learn how to create a container from an image, go to [Containers 101](docs/tutorials/containers-101).
