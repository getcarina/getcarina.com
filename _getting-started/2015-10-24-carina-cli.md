---
title: Getting started with the Carina CLI
author: Anne Gentle <anne.gentle@rackspace.com>
date: 2015-10-24
permalink: docs/getting-started/getting-started-carina-cli/
description: Learn how to get started with the Carina command-line client (CLI) by installing, configuring, and performing commands
topics:
  - carina
  - cli
  - intermediate
---

This tutorial demonstrates how to install and configure the Carina client so that you can use it to launch and control Docker Swarm clusters on a Carina endpoint. The `carina` command-line interface is a self-contained binary written in Go, so installation involves downloading a binary, making it executable, adding it to your path, and then configuring it with credentials.

**Note**: This guide uses the command line interface to create a cluster. To use the graphical user  interface see [Getting started on Carina]({{ site.baseurl }}/docs/getting-started/getting-started-on-carina/).

### Prerequisites

A Carina account. If you do not already have one, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

Your Carina API key. To get it, go to the [Carina Control Panel](https://app.getcarina.com), click your username in the top-right corner, and then click **API Key**.

The Docker client. Use the [Docker Version Manager (dvm)]({{ site.baseurl }}/docs/tutorials/docker-version-manager/).

### Download and install the Carina CLI

1. Download the latest version of the CLI library that matches your operating system from the
   [Carina repository](https://github.com/getcarina/carina/releases/).

2. Move the binary to a permanent location:

    **Bash**

    ```bash
    $ mkdir ~/bin
    $ mv carina-darwin-amd64 ~/bin/carina
    ```

    **PowerShell**

    ```powershell
    > mkdir -f "$env:USERPROFILE\bin"
    > mv -force carina.exe "$env:USERPROFILE\bin"
    ```

3. On Mac OSX and Linux, make the binary executable:

    ```bash
    $ chmod u+x ~/bin/carina
    ```

4. Add the binary to your path with the following command:

    **Bash**

    ```bash
    $ export PATH=$PATH:$HOME/bin
    ```

    **PowerShell**

    ```powershell
    > $env:PATH += ";$env:USERPROFILE\bin"
    ```


### Configure with Carina credentials

1. Gather the required information:
  * Username (CARINA_USERNAME): Your Carina username from the [Carina Control Panel](https://app.getcarina.com).
  * API key (CARINA_APIKEY): Your Carina API key. To find it, see [Prerequsites](#prerequisites).

2. Set your environment variables to contain these credentials. For example:

    **Bash**

    ```bash
    $ export CARINA_USERNAME=fnamelname
    $ export CARINA_APIKEY=ddd1233abcdef4a0bc5da6789123ab45c
    ```

    **PowerShell**

    ```powershell
    > $env:CARINA_USERNAME="fnamelname"
    > $env:CARINA_APIKEY="ddd1233abcdef4a0bc5da6789123ab45c"
    ```

3. Verify that you can issue `carina` commands:

      ```bash
      $ carina list
      ```

      If you have some clusters already running, you see output similar to the following output:

      ```
      ClusterName       Flavor           Nodes    AutoScale    Status
      websocketsrock    container1-2G    2        true         active
      railsanne         container1-4G    4        true         active
      ```

### Manage Carina clusters

1. Create a Carina cluster by using the `carina create` command. Replace `mycluster` with the name of your cluster.

    ```bash
    $ carina create mycluster --wait --nodes=2 --autoscale

    mycluster    container1-4G    2    true    active

    Read more about the parameters below:
    * --wait       wait for swarm cluster completion
    * --nodes=1    number of nodes for the initial cluster
    * --autoscale  Turn autoscale on or off. Turning it on means that Carina automatically adds segments as they are needed.
    ```

2. After the cluster is created, download the credentials for the cluster. Replace `mycluster` with the name of your cluster.

    **Bash**

    ```bash
    $ carina credentials --path=/tmp/mycluster mycluster
    ```

    **PowerShell**

    ```powershell
    > carina credentials --path="$env:TMP\mycluster" mycluster
    ```

    `--path=PATH` indicates the local directory path to write the credentials files to.

3. Load your credentials. Replace `mycluster` with the name of your cluster.

    **Bash**

    ```bash
    $ source /tmp/mycluster/docker.env
    ```

    **PowerShell**

    ```powershell
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    > . "$env:TMP\mycluster\docker.ps1"
    ```

    See [Load a Docker environment from the command line on Windows]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-windows/).

4. Use your credentials to interact with your cluster:

    ```bash
    $ docker info

    Containers: 6
    Images: 4
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 2
    1ca87d26-0d26-48cb-8a34-1b68ce124e6e-n1: 104.120.0.18:42376
     └ Containers: 3
     └ Reserved CPUs: 0 / 12
     └ Reserved Memory: 0 B / 4.2 GiB
     └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy)     (containerized), storagedriver=aufs
    4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n2: 103.140.0.22:42376
     └ Containers: 3
     └ Reserved CPUs: 0 / 12
     └ Reserved Memory: 0 B / 4.2 GiB
     └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    CPUs: 24
    Total Memory: 8.4 GiB
    Name: a1bc2d3456e7
    ```

5. View the Swarm management containers:

    ```bash
    $ docker ps -a

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                      NAMES
    d7cd5d3487a0        swarm               "/swarm manage -H=tcp"   12 minutes ago      Up 12 minutes       2375/tcp, 104.130.0.42:2376->2376/tcp   4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n2/swarm-manager
    1c9ed0342277        swarm               "/swarm join --addr=1"   12 minutes ago      Up 12 minutes       2375/tcp                                4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n2/swarm-agent
    338ec9846bc5        cirros              "/sbin/init"             12 minutes ago                                                                  4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n2/swarm-data
    3f77440215be        swarm               "/swarm manage -H=tcp"   13 minutes ago      Up 13 minutes       2375/tcp, 104.130.0.48:2376->2376/tcp   4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n1/swarm-manager
    06491282ee7b        swarm               "/swarm join --addr=1"   13 minutes ago      Up 13 minutes       2375/tcp                                1ca87d26-0d26-48cb-8a34-1b68ce124e6e-n1/swarm-agent
    62a5e84fa358        cirros              "/sbin/init"             13 minutes ago                                                                  4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n1/swarm-data
    ```

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next step

Learn about all of the features available to you in the [Overview of Carina.]({{ site.baseurl }}/docs/overview-of-carina/)
