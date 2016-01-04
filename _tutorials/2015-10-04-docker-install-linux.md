---
title: Install Docker on Linux
author: Nathaniel Archer <nate.archer@rackspace.com>
date: 2015-10-04
permalink: docs/tutorials/docker-install-linux/
description: Learn how to install Docker on Linux (Ubuntu, Debian)
topics:
  -docker
  -beginner
  -tutorial
---

This tutorial describes how to install and set up Docker on Linux distributions, such as Ubuntu or Debian.

### Install Docker
The following steps use Ubuntu. If you are not using Ubuntu, you can find installation
instructions for your Linux distribution on [the Docker website](https://docs.docker.com/installation/).

1. Log in to an Ubuntu installation as a user with `sudo` privileges.

2. Ensure that `wget` is installed.

    ```bash
    which wget
    ```

     If `wget` isn't installed, run the following commands:

     ```bash
     sudo apt-get update
     sudo apt-get install wget
     ```

3. Use `wget` to install the latest Docker package:

     ```bash
     wget -qO- https://get.docker.com/ | sh
     ```

     You are prompted to enter your `sudo` password. After you do so, Docker is downloaded and installed.

     **Note**: If your network is behind a filtering proxy, any `apt` commands might fail. To fix this, add an `apt-key` directly:

     ```bash
     wget -qO- https://get.docker.com/gpg | sudo apt-key add -
     ```

4. Check that `docker` is installed by running the following command:

     ```bash
     sudo docker run hello-world
     ```

     The output should look as follows:

     ```bash
     $ docker run hello-world
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
     ````

### Configure Docker to run without sudo
If you want to use the `docker` command without always prefixing it with `sudo`, follow
these instructions. For more information about the security impacts of adding a user
to the docker group, see [Docker daemon attack surface][daemon-security].

1. Create a group named `docker` and add your user to it.

    ```bash
    sudo usermod -aG docker ubuntu
    ```

2. Restart the Docker service.

    ```bash
    sudo service docker restart
    ```

3. Log out of your current shell or desktop session, and then log in again so that your
    user is recognized as a member of the docker group.

4. Verify that you are able to execute `docker` commands without `sudo`.

    ```bash
    $ docker version
    ```

[daemon-security]: https://docs.docker.com/articles/security/#docker-daemon-attack-surface

### Troubleshooting

If the `docker run hello-world` command fails, enter the following command:

```bash
sudo service docker start
```

This command starts Docker and enables you to run any `docker` commands.

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next step

[Load a Docker environment from the command line on Linux]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-linux/)
