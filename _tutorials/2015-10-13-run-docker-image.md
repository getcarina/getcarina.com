---
title: Find and download a Docker image
author: Nathaniel Archer <nate.archer@rackspace.com>
date: 2015-10-13
permalink: docs/tutorials/run-docker-image/
description: Learn how to find and download a Docker image from Docker hub, and the function of Docker images.
docker-versions: 1.10.1
topics:
  -Docker
  -beginner
  -tutorial
---

This tutorial describes how to find and download any Docker image from Docker Hub.

Docker images are the building blocks of containers. The image can be as simple as running a single command like `run hello-world`, or as complex as an entire database or host operating system. Even if your host cannot run the software in a Docker image, a Docker container can always run that image. This offers a clear advantage over virtual machines(VMs), which are limited to the scope of the hardware running the VMs.

The benefit of Docker images is that anyone can create and share their images through [Docker Hub](https://hub.docker.com/).

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Find and download a Docker image

This section shows you how to find and run a Docker image.

1. List all the images that exist on your Docker host:

    `$ docker images`

    If you don't have any images, the output should look as follows:

    ```
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    ```

2. Search for an image on Docker Hub. Use `docker search` and type the name of the image that you want to find. For this tutorial, search for an Ubuntu image.

    `$ docker search ubuntu`

    Docker pulls a list of Hub repositories that contain an Ubuntu image. The output should look as follows:

    ```
    NAME                           DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
    ubuntu                         Ubuntu is a Debian-based Linux operating s...   2325      [OK]       
    ubuntu-upstart                 Upstart is an event-based replacement for ...   34        [OK]
    ```

3. When you find the image that you want to use, download it by running the following command. Specify the name of the image and the version number.

    **Note:** If you run this command without indicating the version that you want to download, Docker downloads the latest version of that image.

    `$ docker pull ubuntu:12.04`

    Docker downloads the image, in this case Ubuntu version 12.04.

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

4. Run `docker images` again to see your downloaded images.

    The output should look as follows:

    ```
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    ubuntu              12.04               57bca5139a13        5 weeks ago         134.8 MB
    ```

    Docker stores a copy of the image on your host to save time when you run the image. If you no longer need an image, you can delete it by running the `docker rmi` command followed by the image ID. For example:

    `$ docker rmi 57bca5139a13`

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next steps

Run your first containerized application by [Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).
