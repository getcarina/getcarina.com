---
title: Install Docker on Windows
author: Constanze Kratel <constanze.kratel@rackspace.com>
date: 2015-10-10
permalink: docs/tutorials/docker-install-windows/
description: Learn how to install Docker on Linux Windows
docker-version:
  -1.8.2
topics:
  -docker
  -beginner
  -tutorial
---

This tutorial describes how to install Docker on Windows.

### Prerequisites
* A working terminal application.
* Windows 7.1, 8/8.1 or higher

###Installing Docker Toolbox on Windows

To successfully run Docker on Windows, you need to install the Docker Toolbox software and several “helper” applications:
​
  * Docker Client for Windows
  * Docker Toolbox management tool and ISO
  * Oracle VM VirtualBox
  * Git MSYS-git UNIX tools
​

If you have a previous version of VirtualBox installed, do not reinstall it with the Docker Toolbox installer. When prompted, uncheck it.
​
If you have Virtual Box running, you must shut it down before running the installer.
​
To install the Docker Toolbox:
​
1. Go to the [Docker Toolbox](https://www.docker.com/toolbox) page.

2. Click the **Download (Windows)** button.

3. Install Docker Toolbox by double-clicking the installer. The installer launches the **Setup - Docker Toolbox** dialog box.

5. Click **Next** to accept all the defaults and then **Install**.

6. Accept all the installer defaults. The installer takes a few minutes to install all the components:

7. When notified by Windows Security, allow the installer to make the necessary changes.

8. When it completes, the installer reports it was successful: <add screenshot here>

9. Uncheck **View Shortcuts in File Explorer** and click **Finish**.

###Verify your installation
The installer places Docker Toolbox and VirtualBox in your Applications folder.
​
To start Docker Toolbox and run a simple Docker command:
​
1. On your Desktop, locate the Docker Toolbox icon.

2. Click the icon to launch a Docker Toolbox terminal.

3. If the system displays a User Account Control prompt to allow VirtualBox to make changes to your computer, choose **Yes**.

   After setting up the toolbox, the terminal displays the ``$`` prompt. The terminal runs a special bash environment instead of the standard Windows command prompt.

4. Make the terminal active by click your mouse next to the ``$`` prompt.

5. Type the docker run ``hello-world`` command and press RETURN. If the command completes successfully, you receive the following output:
​
```
$ docker run hello-world
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

### Next step

[Set up your virtual environment with Docker host](docs/tutorials/set-up-docker-machine)
