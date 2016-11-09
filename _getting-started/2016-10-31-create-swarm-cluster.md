---
title: Getting started with Docker Swarm
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-swarm-cluster/
description: Learn how to get your first containerized application running on Docker Swarm in a minimal amount of time
docker-versions:
  - 1.11.2
topics:
  - docker
  - beginner
---

This tutorial demonstrates how to run your first containerized application on Docker Swarm in a minimal amount of time.
No prior knowledge of containers or Docker is necessary.

**Note**: This tutorial uses the website to create a cluster. To use the command-line interface, see [Getting started with Docker Swarm and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster-with-cli/).

### Sign up for Carina

To run applications on Carina, create a free account by following the [sign up process](https://app.getcarina.com/app/signup).

### Install the Docker Version Manager
{% include install-dvm.md %}

### Create a cluster

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. For the cluster type, select **Swarm**.

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Download the cluster credentials
{% include manual-credentials-download.md %}

### Connect to the cluster

Connect to your cluster by configuring the Docker client to use the cluster credentials.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. Configure the Docker client (`docker`).

    On Linux and Mac OS X, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ source docker.env
    $ dvm use
    Now using Docker 1.11.2
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > cd Downloads\mycluster
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    > .\docker.ps1
    > dvm use
    Now using Docker 1.11.2
    ```
1. Use `docker` to connect to your cluster and display information about it.

    ```bash
    $ docker info
    Containers: 3
     Running: 2
     Paused: 0
     Stopped: 1
    Images: 2
    Server Version: swarm/1.2.5
    Role: primary
    Strategy: spread
    Filters: health, port, containerslots, dependency, affinity, constraint
    Nodes: 1
     c2f86a90-4de6-4024-afb3-47358aa17136-production-master-00: 10.223.64.23:42376
      └ ID: 7IBR:NYLQ:2P3A:IM2N:LMTY:6UBN:R7Y4:Y2OP:VXXN:R2BV:2NAY:YTHY
      └ Status: Healthy
      └ Containers: 3 (2 Running, 0 Paused, 1 Stopped)
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 8.4 GiB
      └ Labels: kernelversion=3.18.21-24-rackos, operatingsystem=Debian GNU/Linux 8 (jessie) (containerized), storagedriver=aufs
      └ UpdatedAt: 2016-11-03T20:24:50Z
      └ ServerVersion: 1.11.2
    Plugins:
     Volume:
     Network:
    Kernel Version: 3.18.21-24-rackos
    Operating System: linux
    Architecture: amd64
    CPUs: 12
    Total Memory: 8.4 GiB
    Name: c2f86a90-4de6-4024-afb3-47358aa17136-production-master-00
    ```

### Run your first application on Docker Swarm
{% include getting-started-with-docker.md %}

### Next steps

Learn how to [install the Carina CLI and use it to manage your Swarm clusters]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster-with-cli/).

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
