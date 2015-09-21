---
title: How to install Docker with Mac OS X
slug: docker-101-installation-mac
description: Instructions on how to install Docker on a Mac Operating System.
topics:
  -docker
  -beginner
  -tutorial
---

#How to install Docker with Mac OS X

This tutorial covers how to install and set up Docker on Mac OS X.

##Prerequisites
* A working Terminal application, such as iTerm or Terminal.

##Instructions

Docker on Mac OS X is installed using Docker Toolbox. Docker toolbox comes packaged
with these components:

* Kitematic, the GUI client for Docker
* Oracle VM VirtualBox
* `docker` binary
* `docker-machine`, a binary which helps create Docker hosts.

You can install Docker by following these steps:

1. Be sure that your Mac is running OS X 10.8 "Mountain Lion" or newer. You can
   find out buy clicking the Apple icon on the top-left of your screen. The version
   number can be found below the words "OS X".
   ![Be sure that your running OS X 10.8 or higher](/_assets/img/002-docker-101/mac-version.png)

2. Go to the [Docker Toolbox](https://www.docker.com/toolbox) page.

3. Click **Download (Mac)** to download the toolbox.

4. Double-click the installer. This launches the Docker Toolbox.

5. On the welcome page, click Continue. Follow the instructions on the installer
   until you arrive on the page "Installation Type".

6. The Installer will give you the option to customize your installation. This
   can be done by clicking **Customize**. For now, make sure that every component
   is selected.
   ![Make sure all boxes are selected](/_assets/img/002-docker-101/mac-toolbox-install-type.png)

7. Click **Install**. By default, the binaries will be installed to `/usr/local/bin`.

8. When installation is complete, the installer will provide you with shortcuts. Ignore
   these and click **Continue**.
   ![The installer will provide you with shortcuts. Ignore these and click continue.](/_assets/img/002-docker-101/mac-toolbox-install-apps.png)

9. Once the installer has confirmed the installation was successful, click **Close**.

##How to set-up Docker (Mac OS X)

In order to run a Docker container, you need to create a new Docker virtual machine(VM),
switch to the VM's environment where you'll be able to use the `docker` client to manage your
containers.

1. Open Launchpad and find the Docker Quickstart Terminal icon. Click the icon and a terminal window  
   will launch. The terminal will set up Docker for you.

   `. '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
   Last login: Wed Sep 16 11:17:16 on ttys001
   MPM1XEDV30:~ $ bash
   bash-3.2$ . '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'

   Machine default already exists in VirtualBox.
   Starting machine default...
   Starting VM...
   Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.
   Setting environment variables for machine default...



                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______


   docker is configured to use the default machine with IP 192.168.99.101
   For help getting started, check out the docs at https://docs.docker.com`

2. In terminal, type the command `docker run hello-world`. You should receive the following output:
   `bash-3.2$ docker run hello-world

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
    https://docs.docker.com/userguide/`

    If you received the above output, Docker is up and running. Next, we will find
    and run a Docker image.
