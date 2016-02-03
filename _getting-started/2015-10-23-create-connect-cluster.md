---
title: Create and connect to a cluster
author: Kelly Holcomb <kelly.holcomb@rackspace.com>
date: 2015-10-23
featured: true
permalink: docs/tutorials/create-connect-cluster/
description: Learn how to create and connect to a cluster in Carina so that you can start running your applications in containers
docker-versions:
  - 1.9.0
topics:
  - docker
  - beginner
---

This tutorial shows you how to create a cluster in Carina and then download its credentials so that you can securely connect to the cluster.

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Clusters are secured with Transport Layer Security (TLS) certificates. Each cluster has its own set of credentials, which you can download in a zip file from the Carina Control Panel. The credentials zip file contains the following files:

* ca.pem - Certificate Authority, used by clients to validate servers
* cert.pem - Client Certificate, used by clients to identify themselves to servers
* key.pem - Client Private Key, used by clients to encrypt their requests
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates
* docker.env - Shell environment configuration script
* docker.ps1 - PowerShell environment configuration script
* docker.cmd - CMD shell environment configuration script

**Note**: The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

**Note**: This guide uses the graphical user interface to create a cluster. To use the command line interface see [Getting started with the Carina CLI]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).

### Prerequisite

A Carina account. If you do not already have one, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

### Create a cluster

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. To scale your cluster, select **Enable Autoscale**.

    For more information, see [Autoscaling resources in Carina]({{ site.baseurl }}/docs/reference/autoscaling-carina/).

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Connect to your cluster

Connect to your cluster by loading the cluster credentials and downloading the Docker client.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. On the Carina Control Panel, click the **Get Access** button associated with your cluster and click **Download File**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

1. Download the Docker 1.9.0 client into the credentials directory.
  - On Linux, download the [Linux client](https://get.docker.com/builds/Linux/x86_64/docker-1.9.0) to `Downloads/mycluster`.
  - On Mac OS X, download the [Mac client](https://get.docker.com/builds/Darwin/x86_64/docker-1.9.0) to `Downloads/mycluster`.
  - On Windows, download the [Windows client](https://get.docker.com/builds/Windows/x86_64/docker-1.9.0.exe) to `Downloads/mycluster`.

1. Open an application in which to run commands.
  - On Linux and Mac OS X, open a terminal.
  - On Windows, open a PowerShell.

1. Configure the client.

    **Note:** If you already have the Docker client in your home bin directory, make a backup of it first.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ mkdir -p $HOME/bin
    $ mv docker-1.9.0 $HOME/bin/docker
    $ chmod u+x $HOME/bin/docker
    $ export PATH=$HOME/bin:$PATH
    $ if [ -f ~/.bash_profile ]; then echo 'export PATH=$HOME/bin:$PATH' >> $HOME/.bash_profile; fi
    $ source docker.env
    ```

    On Windows PowerShell, run the following commands:

    ```
    $ cd Downloads\mycluster
    $ mkdir "$env:USERPROFILE\bin"
    $ mv docker-1.9.0.exe "$env:USERPROFILE\bin\docker.exe"
    $ $env:PATH += ";$env:USERPROFILE\bin"
    $ [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
    $ Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    $ .\docker.ps1
    ```

1. Connect to your cluster and display information about it. If you are using Windows PowerShell, use `docker.exe` instead of `docker`.
    If you autoscaled your cluster, you see more containers, images, nodes, and CPUs than are shown in the following example.

    ```bash
    $ docker info
    Containers: 3
    Images: 2
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 1
     57d513b9-ed36-487d-8415-4ac65b6d41a8-n1: 104.130.0.124:42376
      └ Containers: 3
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 4.2 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    CPUs: 12
    Total Memory: 4.2 GiB
    Name: 3e867f7a955f
    ```

    **Note**: A newly created cluster contains containers that are necessary for cluster management. For more information about these containers, see [Introduction to Docker Swarm]({{ site.baseurl }}/docs/concepts/introduction-docker-swarm/).  

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

If you're new to Carina, Docker, and containers, see the following articles to learn more:

* [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/)
* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
* [Container 101]({{ site.baseurl }}/docs/concepts/containers-101/)

If you're likely to be running multiple versions of Docker, use the [Docker Version Manager (dvm)]({{ site.baseurl }}/docs/tutorials/docker-version-manager/).

### Next steps

Run your application in a container. Use the right tutorial for your application from the **Tutorials** section of the [Documentation]({{ site.baseurl }}/docs/) page on the Carina website.
