---
title: Getting started with Docker Swarm and the Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-swarm-cluster-with-cli/
description: Learn how to use the command line to get your first containerized application running on Docker Swarm in a minimal amount of time
docker-versions:
  - 1.11.2
topics:
  - carina
  - cli
  - beginner
---

This tutorial shows you how to use the command line to get your first containerized application running on Docker Swarm in a minimal amount of time. No prior knowledge of containers, or Docker is necessary.

**Note**: This tutorial uses the command-line interface to create a cluster. To use the website, see [Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

Note your Carina API key. To view your API key, go to the [Carina Control Panel](https://app.getcarina.com), click your username in the top-right corner, and then click **Settings**.

### Install the Carina CLI
{% include install-carina.md %}

### Install the Docker Version Manager
{% include install-dvm.md %}

### Configure with Carina credentials

1. Gather the required information:
  * Username (CARINA_USERNAME): Your Carina username from the [Carina Control Panel](https://app.getcarina.com), displayed at the top right. In many cases, your username is your email address.
  * API key (CARINA_APIKEY): Your Carina API key. To find it, see [Sign up for Carina](#sign-up-for-carina).

2. Set your environment variables to contain these credentials. Replace `<username>` with your Carina username and `<apikey>` with your Carina API key.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ export CARINA_USERNAME=<username>
    $ export CARINA_APIKEY=<apiKey>
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > $env:CARINA_USERNAME="<username>"
    > $env:CARINA_APIKEY="<apiKey>"
    ```

3. Verify that you can run `carina` commands:

    ```bash
    $ carina clusters
    ID                                      Name        Status    Template              Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    mycluster   active    Swarm 1.11.2 on LXC   1
    ```

    The output is your list of clusters, if you already have some clusters running.

### Create and connect to your cluster

1. View the available cluster templates with `carina templates`.

    ```bash
    $ carina templates
    Name                     COE         Host
    Kubernetes 1.4.4 on LXC  kubernetes  lxc
    Swarm 1.11.2 on LXC      swarm       lxc
    ```

1. Create a Docker Swarm cluster by running the `carina create` command.

    ```bash
    $ carina create --wait --template "Swarm 1.11.2 on LXC" mycluster
    ID                                      Name        Status    Template              Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    mycluster   active    Swarm 1.11.2 on LXC   1
    ```

    The `--wait` flag indicates that the client should wait for the cluster to become active before exiting.

1. Configure the Docker client (`docker`).

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ eval $(carina env mycluster)
    $ dvm use
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > carina env mycluster --shell powershell  | iex
    > dvm use
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

{% include getting-started-with-docker.md %}

### Next steps

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
