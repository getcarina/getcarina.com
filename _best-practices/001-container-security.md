---
title: Container security
author: Major Hayden <major.hayden@rackspace.com>
date: 2015-09-11
permalink: docs/best-practices/001-container-security/
description: Security best practices for safely deploying Docker applications
topics:
  - best-practices
  - security
featured: true
---

**tl;dr:** [Introduction to Container Security](https://d3oypxn00j2a10.cloudfront.net/assets/img/Docker%20Security/WP_Intro_to_container_security_03.20.2015.pdf)

# Research Paper: Securing Linux Containers
For very detailed reading on the security of Linux containers inside and out, review the [Securing Linux Containers](https://major.io/2015/08/14/research-paper-securing-linux-containers/) research paper.  It covers container security within the Linux kernel, including Linux Security Modules and cgroups.  There are also best practices for keeping containers updated and how Dev/Ops teams can work together to improve security.

# Trusted Software
Retrieving images is easy with Docker's `docker pull` command.  Developers can quickly add their automation on top of the base image and begin deploying it to environments.  However, do you **really** know the source of all the software within your container?

Most containers are built using an operating system's trusted package manager, like yum, dnf, or apt.  The default configuration of most package managers will enforce a cryptographic check of some sort, usually via GPG, for the package.  If the package has been altered on the remote server or during transit, the package manager will find that the signatures don't match.  That package won't be installed.

Some operating system and application vendors already have [official repositories](https://hub.docker.com/explore/) on [Docker Hub](https://hub.docker.com).  Most of these vendors update their container images frequently and enable best practice security controls for their containers.  After all, it's in their best interest to ensure that their containers and applications are running properly.

The only way to truly trust a container image is to build the container image yourself.  You will have full control of the build system and you can verify that your package manager is configured to verify the signature on each package.

# Keeping Containers Updated
For physical servers or virtual machines, many users are accustomed to routinely applying package updates via their package manager.  Some users may configure automatic updates for all packages or just for packages with security vulnerability fixes.  Keeping containers updated is a different battle.

First, containers should really only one run daemon.  This means that a typical LAMP stack should be split into at least two containers: one for Apache/PHP and another for MySQL.  This reduces the number of packages needing potential updates in either container.

Second, containers should be rebuilt when developers update configuration files, packages, or other software.  Containers are, by nature, ephemeral.  Also, if they are running a single daemon, there's no need to run an ssh daemon within the container.  If you run a LAMP stack and a critical PHP vulnerability is released, build a new container with updated packages, and replace existing production containers with the new one.

# DevOps and Shared Security Responsibility
Developers appreciate containers because they can package their application, test it alongside its libraries, and verify that it will work in production. Operations teams appreciate containers because they get the applications in a cohesive package along with their dependencies and configurations. However, who owns the security of the container operating system, configuration files, and the application in this new world of containers?

The responsibility of securing the operating system normally falls onto the operations team. However, if developers are writing applications and building a container with their application in it, how do operations teams ensure that the base operating system is secure?

This is where frameworks with layered images, including Docker, can help. Operations teams can carefully maintain a base image with appropriate security controls, configurations, and package updates. As part of that configuration, they can specify where the package manager will receive trusted packages. Development teams can use that base image as the foundation for their containers and then add packages from those trusted repositories. If a serious vulnerability appears, the operations team would quickly update the base image and let the development team know that a container rebuild and redeployment is needed.

# Use Version Control
All of your Dockerfiles, configuration files, and deployment code should all be kept in a version control repository of some sort.  There are several benefits to making this a standard practice in your organization.

Keeping files in version control adds a gate for contributions.  Developers must have permission to commit to the repository and there is an audit trail for commits made to the repository.  This reduces the change of unwanted or unauthorized changes to containers.  Also, if something goes wrong in production, teams can go through the log of commits to review the changes.  Tagging individual commits with version numbers helps teams understand which changes are present in each version of a container.

In an emergency, you may need to rebuild containers very quickly to get back online.  Storing all of your container deployment code in a repository allows for quick rebuilds of containers.
