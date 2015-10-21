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

#Prerequisites
To run Docker on Windows, your system must be running Windows 7.1, 8/8.1 or newer to run Docker Toolbox. 

Make sure your Windows system supports **Hardware Virtualization Technology** and that virtualization is enabled. 

####For Windows 8 or Windows 8.1

1. Choose **Start** > **Task Manager** and navigate to the **Performance** tab. In **Task Manager**, under **CPU**, you should see **Virtualization: Enabled**.   
![Windows Control Panel screenshot](/_assets/img/003-docker-on-windows/window-8-virtualization-enabled-highlighted-360.png)

2. If virtualization is **not** enabled on your system, follow the manufacturer’s instructions for enabling it.

####For Windows 7

Run the [Microsoft® Hardware-Assisted Virtualization Detection Tool] (http://www.microsoft.com/en-us/download/details.aspx?id=592) and follow the on-screen instructions.

#Getting Started
To get started with Docker on Windows, you need to do the following:

* [Install Docker Toolbox on Windows](docs/tutorials/docker-install-windows/)
* [Load a Docker environment on Windows](docs/tutorials/load-docker-environment-on-windows/)
* [Download Carina credentials](docs/references/rcs-credentials/)


#Troubleshooting Docker on Windows
To troubleshoot Docker on Windows, read the follwoing articles:

* [Error running interactive Docker shell on Windows](docs/references/troubleshooting-cannot-enable-tty-mode-on-windows/)

* [Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10](docs/references/troubleshooting-windos-docker-vm-startup)

#Next
[Preview a Jekyll site with Docker on Windows](docs/tutorials/preview-jekyll-with-docker-on-windows/)




