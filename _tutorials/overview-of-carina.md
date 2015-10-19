---
title: Overview of RCS
author: Constanze Kratel <constanze.kratel@rackspace.com>
date: 2015-10-03
permalink: docs/tutorials/overview-of-rcs/
description: How to get started with Rackspace Container Service
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
---

#Before you get started
Before you get started with Rackspace Container Service, you should do the following:

* Watch the [Introduction to Docker](https://sysadmincasts.com/episodes/31-introduction-to-docker) video.
* Ensure that your Rackspace Cloud account is enabled for Rackspace Container Services.
* Familiarize yourself with basic Docker concepts. Read the [Docker documentation](https://docs.docker.com/
) and [Docker 101] (docs/tutorials/docker101).
* Familiarize yourself with the basic container concepts. Read the [Containers 101](docs/tutorials/containers101) document.
* Familiarize yourself with [scheduling strategies](https://docs.docker.com/swarm/scheduler/strategy/) and with [filters](https://docs.docker.com/swarm/scheduler/filter/).
* Learn about the resources and resource limitations of a cluster.
* Install the Docker client on your computer. For installation instructions, see the [Install the Docker client] (link_Install_Docker_Client) section.
* If you already have the Docker client installed, ensure that you have the right version. Rackspace Container Service, currently supports Docker version 1.8.2.

#What is Rackspace Container Service?
**Rackspace Container Service** provides a high-performance service for running and managing Docker containers in a cluster-based infrastructure. Rackspace Container Service gives you a scalable cluster management infrastructure out of the box and allows you to deploy your applications by utilizing one ore more Docker containers across a managed cluster. Rackspace Container Service eliminates the need to install cluster management software and to deploy and operate cluster management hardware. With Rackspace Container Service, you can get started right away and get your containerized application running in a short time.

The following diagram outlines how Carina works.

[Insert the diagram that Nate is working on here]


#Getting Started

##Understanding Carina UI

*Wait until we have the final UI*

##Using the Actions icons

###Download credentials icon
Clicking this icon brings up a dialog box that prompts you to save your cluster credentials on your computer. Choose **Save File**, click **OK**, and then select a location on your computer to save the credentials to.
###Share credentials icon
Clicking this icon brings up a dialog box that lists the URL for your cluster. You can copy this URL and share it with other users.
###Grow cluster icon
Clicking this icon brings up a dialog box the provides you with the option to grow your cluster by 1 node, 2 nodes, or to grow to the maximum, which is 10 nodes.
###Rebuild cluster icon
Clicking this icon lets you choose the option to rebuild your cluster services.
###Delete cluster icon
Clicking this icon lets you choose the option to delete the specific cluster.

## Clusters

Rackspace Container Service is built on the concept of clusters. A cluster represents a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Rackspace Container Service sets up and manages clusters made up of Docker containers for you. It launches and terminates the containers and maintains complete information about the state of your cluster.

A cluster can be in one of the following states:

| Cluster state | Description                                                                                 |
|---------------|---------------------------------------------------------------------------------------------|
| building      | Indicates that the cluster is currently being built. This process may take several minutes. |
| active        | Indicates that the cluster is currently active.                                             |
| growing       | Indicates that the cluster is in the process of adding new nodes.                           |


##Best Practices##

###Requirements and Restrictions###

Rackspace Container Services currently does not support two-factor authentication.
As a workaround you can create a sub-user by following the instructions described in [How do I create a new user in the Cloud Control Panel](https://community.rackspace.com/products/f/54/t/4551)

#Next#

[Download Rackspace Container Service credentials](docs/references/rcs-credentials/)

[MySQL with RCS](docs/tutorials/mysql-with-rcs/)

[Connect containers with Docker links] (docs/tutorials/connect-docker-containers-with-links/)

[MongoDB with RCS] (docs/tutorials/mongodb-with-rcs/)

[Run Magento in a Docker container](docs/tutorials/magento-in-docker/)

[Introduction to Docker Swarm] (docs/tutorials/introduction-docker-swarm/)

[How to use Drupal on Docker Swarm](docs/tutorials/drupal-and-swarm/)
