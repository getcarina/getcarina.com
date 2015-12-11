---
title: Docker on Windows
author: Constanze Kratel <constanze.kratel@rackspace.com>
date: 2015-10-05
permalink: docs/tutorials/docker-on-windows/
description: Learn how to get started with Docker on Windows
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

1. Under **CPU**, verify that the value for **Virtualization** is **Enabled**.   

    ![Windows Control Panel screenshot]({% asset_path 003-docker-on-windows/window-8-virtualization-enabled_360.png %})

1. If virtualization is *not* enabled, follow the manufacturer’s instructions for enabling it.

####For Windows 7

Download the [Microsoft Hardware-Assisted Virtualization Detection Tool] (http://www.microsoft.com/en-us/download/details.aspx?id=592) and follow the instructions.

###Getting started
To get started with Docker on Windows, you perform the following tasks:

1. [Install Docker Toolbox on Windows]({{ site.baseurl }}/docs/tutorials/docker-install-windows/)
2. [Load a Docker environment on Windows]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-windows/)

###Troubleshooting Docker on Windows
To troubleshoot Docker on Windows, read the following articles:

* [Error running interactive Docker shell on Windows]({{ site.baseurl }}/docs/troubleshooting/troubleshooting-cannot-enable-tty-mode-on-windows/)
* [Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10]({{ site.baseurl }}/docs/troubleshooting/troubleshooting-windows-docker-vm-startup/)

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).
