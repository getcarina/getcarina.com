---
title: How to install Docker with Linux
slug: docker-101-installation-linux
description: Instructions on how to install Docker on Linux (Ubuntu, Debain)
topics:
  -docker
  -beginner
  -tutorial
---

#How to install Docker with Linux

This tutorial covers how to install and set up Docker with Linux distributions like Ubuntu and Debain.

##Prerequisites
* A working Terminal application

##Instructions

1. Log into an Ubuntu installation as a user with `sudo` privileges.

2. Make sure that you have `wget` installed.
   `$ which wget`

   If `wget` isn't installed, run these commands.

   ```sudo apt-get update
    sudo apt-get install wget
   ```

3. Use `wget` to install the latest Docker package.
   `$ wget -qO- https://get.docker.com/ | sh`

   You will be prompted to enter your `sudo` password. After, it will download and install Docker.


   > The `apt-key` command may fail if your network is behind a filtering proxy. To fix this, add the key directly:

     `$ wget -qO- https://get.docker.com/gpg | sudo apt-key add -`

4. Check that `docker` is installed by running `docker run hello-world`.

   ```$ docker run hello-world
   Unable to find image 'hello-world:latest' locally
   latest: Pulling from library/hello-world
   535020c3e8ad: Pull complete
   af340544ed62: Pull complete
   Digest: sha256:a68868bfe696c00866942e8f5ca39e3e31b79c1e50feaee4ce5e28df2f051d5c
   Status: Downloaded newer image for hello-world:latest


   Hello from Docker.
   This message shows that your installation appears to be working correctly.


   To generate this message, Docker took the following steps:
    1. The Docker client contacted the Docker daemon.
    2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
    4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.


    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash


    Share images, automate workflows, and more with a free Docker Hub account:
     https://hub.docker.com


    For more examples and ideas, visit:
     https://docs.docker.com/userguide/


    To try something more ambitious, you can run an Ubuntu container with:
     $ docker run -it ubuntu bash


    For more examples and ideas, visit:
     https://docs.docker.com/userguide/
   ```
