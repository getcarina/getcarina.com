---
title: How to find and run a Docker Image.
slug: docker-101-run-images
description: Instructions on how to find and run a Docker Image from Docker hub, and the function of Docker Images.
topics:
  -Docker
  -beginner
  -tutorial
---

# How to find and run a Docker Image.

Docker Images serve as the building blocks for containers. The image acts
as software you load into the container. They can be as simple as running a single command like `hello-world`, or as complex as an entire database or host operating system.

This is the benefit of Docker Images. Anyone can create and share their images through [Docker hub](https://hub.docker.com/). Even if an image you wish to use cannot run the software contained in a Docker Image, Docker containers will always be able to run that image. This offers a clear advantage over virtual machines(VMs), which are limited to the scope of the hardware running the VMs.

This tutorial describes how to find and run any image from Docker hub, as well as creating your own customizable Docker image.

## Before you begin

Before you can begin this tutorial, be sure that you have fulfilled these prerequisites:

* You have installed `docker`. For installation instructions, go to the installation section of [Docker-101](docker-101-introduction-docker), and click the link for your operating system.
* A terminal application.
* A virtual environment 
