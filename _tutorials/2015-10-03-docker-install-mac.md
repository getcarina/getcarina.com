---
title: Install Docker on Mac OS X
author: Nathaniel Archer
date: 2015-10-03
permalink: docs/tutorials/docker-install-mac/
description: Learn how to install Docker on Mac OS X
docker-versions:
  -1.10.1
topics:
  -docker
  -beginner
  -tutorial
---

This tutorial describes how to install and set up Docker on Mac OS X.

**Note** [Docker for Mac](https://www.docker.com/products/docker#/mac) is availble for Apple macOS Yosemite 10.10.3 and above. Follow the instructions below to install docker on previous versions of Mac OS X.

###Prerequisites
* A working Terminal application.
* A Mac running OS X version 10.8 (Mountain Lion) or later. Display the version by clicking the Apple icon the top-left of your screen, and then selecting **About this Mac**.

###Install Docker

You install Docker on Mac OS X by installing Docker Toolbox. Docker Toolbox comes packaged with the following components:

* Kitematic, the GUI client for Docker
* Oracle VM VirtualBox
* The `docker` binary
* The `docker-machine` binary, which helps create Docker hosts

Follow these steps to install Docker:

1. Go to the [Docker Toolbox](https://www.docker.com/toolbox) page.

2. Click **Download (Mac)** to download the toolbox.

3. Double-click the installer file.

4. On the welcome page, click **Continue**, and follow the instructions until you get to the Installation Type page.

    The installer gives you the option to customize your installation. However, we recommend keeping the defaults.

5. Ensure that every component is selected and then click **Install**.

    ![Make sure all boxes are selected]({% asset_path 002-docker-101/mac-toolbox-install-type.png %})

    By default, the binaries are installed to `/usr/local/bin`.

    After the installation is completed, the installer provides you with shortcuts, which you can ignore.

    ![The installer will provide you with shortcuts. Ignore these and click continue.]({% asset_path 002-docker-101/mac-toolbox-install-apps.png %})

6. Click **Continue**

7. After the installer has confirmed that the installation was successful, click **Close**.

###Set up Docker (Mac OS X)

To run a Docker container, you must create a new Docker virtual machine (VM) and switch to the VM's environment. From that environment, you can use the `docker` client to manage your containers.

1. Open Launchpad and click the Docker Quickstart Terminal icon.

    A terminal window opens and sets up Docker for you. Successful output should look as follows:

    ```
    Last login: Sat Sep 25 15:15:45 on ttys002
    bash '/Applications/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
    Get http:///var/run/docker.sock/v1.19/images/json?all=1&filters=%7B%22dangling%22%3A%5B%22true%22%5D%7D: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS?
    Get http:///var/run/docker.sock/v1.19/images/json?all=1: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS?
    -bash: lolcat: command not found


    mary at meepers in ~
    $ bash '/Applications/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
    Creating Machine dev...
    Creating VirtualBox VM...
    Creating SSH key...
    Starting VirtualBox VM...
    Starting VM...
    To see how to connect Docker to this machine, run: docker-machine env dev
    Starting machine dev...
    Setting environment variables for machine dev...


                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/


    The Docker Quick Start Terminal is configured to use Docker with the “default” VM.
    ```

2. In terminal, type the command `docker run hello-world`. You should receive the following output:

    ```
    bash-3.2$ docker run hello-world

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
    ```

If you received preceding output, Docker is up and running.

**Note:** If the `hello-world` image is not already on your local system, the Docker
client might take up to a minute to pull the image from Docker Hub. If this occurs, you will
receive this output when you enter `docker run hello-world`.

```
bash-3.2$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world

535020c3e8ad: Pull complete
af340544ed62: Pull complete
library/hello-world:latest: The image you are pulling has been verified. Important: image verification is a tech preview feature and should not be relied on to provide security.
Digest: sha256:02fee8c3220ba806531f606525eceb83f4feb654f62b207191b1c9209188dedd
Status: Downloaded newer image for hello-world:latest
```

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

###Next step

[Load a Docker environment from the command line on Mac OS X]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-mac/)
