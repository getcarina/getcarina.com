---
title: Install Docker on Windows
author: Nathaniel Archer <nate.archer@rackspace.com>
date: 2015-10-10
permalink: docs/tutorials/docker-install-windows/
description: Learn how to install Docker on Windows
docker-version:
  -1.8.2
topics:
  -docker
  -beginner
  -tutorial
---

This tutorial describes how to install Docker on Windows.

### Prerequisites

* To run Docker on Windows, your system must be running Windows 7.1, 8/8.1 or newer to run Docker Toolbox.

* Make sure your Windows system supports **Hardware Virtualization Technology** and that virtualization is enabled.

###Installing Docker Toolbox on Windows

You install Docker on Windows by installing Docker Toolbox. Docker Toolbox comes packaged with the following components:

* Oracle VM VirtualBox
* The `docker` client for Windows
* The `docker-machine` binary, which helps create Docker hosts

To install the Docker Toolbox, perform the following steps:


1. If you have a previous installation of VirtualBox running, shut it down before running the installer.

2. Go to the [Docker Toolbox](https://www.docker.com/toolbox) page.

3. Click the **Download (Windows)** button, and save the installer file to your computer.

4. Double click the installer file, the installer launches the Docker Toolbox Setup Wizard.

5. On the welcome page, click **Next**.

6. Accept the default folder, the click **Next**.

7. If you have a previous version of VirtualBox installed, clear the VirtualBox check box (do not reinstall it). Otherwise, accept all the defaults and click **Next**.

8. Click **Install**. The installer takes a few minutes to install all the components.

9. When notified by Windows Security, allow the installer to make the necessary changes.

10. When it completes, the installer reports it was successful.

    ![When it completes, the installer reports it was successful.](/_assets/img/docker-install-windows/windows-install-complete.png)

11. Clear the **View Shortcuts in File Explorer** and then click **Finish**.

###Verify your installation

To verify the installation, start Docker Toolbox and run a simple Docker command.

The installer places shortcuts to the Docker Quickstart Terminal and VirtualBox on your desktop.

1. On your Desktop, click the Docker Quickstart Terminal to launch the terminal application.

2. If the system displays a User Account Control prompt to allow VirtualBox to make changes to your computer, choose **Yes**.

   After setting up the toolbox, the terminal displays the ``$`` prompt. The terminal runs a special bash environment instead of the standard Windows command prompt.

3. Make the terminal active by click your mouse next to the ``$`` prompt.

5. Enter the following command:

   `$ docker run hello-world`
​
   ```
   Unable to find image 'hello-world:latest' locally
   Pulling repository hello-world
   91c95931e552: Download complete
   a8219747be10: Download complete
   Status: Downloaded newer image for hello-world:latest
   Hello from Docker.
   This message shows that your installation appears to be working correctly.
​
​
   To generate this message, Docker took the following steps:
    1. The Docker client contacted the Docker daemon.
    2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (Assuming it was not already locally available.)
    3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
    4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
​
​
   To try something more ambitious, you can run an Ubuntu container with:
    $ docker run -it ubuntu bash
​
​
    For more examples and ideas, visit:
    https://docs.docker.com/userguide/
   ```

### Troubleshooting

Sometimes, when you use a `docker` command such as `docker run hello-world`, you receive the following output:

```
$ docker run hello-world
Post http:///var/run/docker.sock/v1.20/containers/create: dial unix /var/run/docker.sock: no such file or directory.
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

If you receive this output, your VM is not running on a Docker host. For instructions on how to fix this issue, perform the steps in [Set up a virtual environment with a Docker host](docs/tutorials/set-up-docker-machine).

Lastly, Docker Toolbox may have have conflicts with some of your existing applications such as VirtualBox and Git Bash. For solutions on how to handle these conflicts, go to [Troubleshooting the Docker Toolbox setup on Windows](/_references/002-toubleshooting-windos-docker-vm-startup).

### Next step

[Load a Docker environment on Windows](/docs/tutorials/load-docker-environment-on-windows)
