---
title: Docker on Windows
author: Constanze Kratel <constanze.kratel@rackspace.com>
date: 2015-10-03
permalink: docs/tutorials/docker-on-windows/
description: How to get started with Docker on Windows
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
  - windows
---

Docker supports running the Docker Toolbox on Windows systems. You can use a Docker client directly from your Windows machine to manage containers that are running on Linux hosts.

###Prerequisites
To run Docker on Windows, your system must be running Windows 7.1 or later.

Ensure that your Windows system supports Hardware Virtualization Technology and that virtualization is enabled. Use the following instructions.

####For Windows 8 or Windows 8.1

1. Select **Start** > **Task Manager** and click the **Performance** tab. 
2. Under **CPU**, verify that the value for **Virtualization** is **Enabled**. 
![Windows Control Panel screenshot]({% asset_path 003-docker-on-windows/window-8-virtualization-enabled-highlighted-360.png %})

3.	If virtualization is *not* enabled, follow the manufacturer’s instructions for enabling it.

####For Windows 7

Download the [Microsoft® Hardware-Assisted Virtualization Detection Tool] (http://www.microsoft.com/en-us/download/details.aspx?id=592) and follow the instructions.

###Getting started
To get started with Docker on Windows, you perform the following tasks:

1. [Install Docker Toolbox on Windows](/docs/tutorials/docker-install-windows/)
2.	[Set up a virtual environment with a Docker host](/docs/tutorials/set-up-docker-machine/)
3. [Load a Docker environment on Windows](/docs/tutorials/load-docker-environment-on-windows/)


###Troubleshooting Docker on Windows
To troubleshoot Docker on Windows, read the follwoing articles:

* [Error running interactive Docker shell on Windows](/docs/references/troubleshooting-cannot-enable-tty-mode-on-windows/)
* [Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10](/docs/tutorials/troubleshooting-the-docker-toolbox-setup-on-windows-7-8-1-and-10/)






