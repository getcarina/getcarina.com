---

title: Create and connect to a cluster
author: Kelly Holcomb <kelly.holcomb@rackspace.com>
date: 2015-10-16
permalink: docs/tutorials/create-connect-cluster/
description: Learn how to create and connect to a cluster in Carina so that you can start running your applications in containers
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner

---

This tutorial shows you how to create a cluster in Carina and then download its credentials so that you can securely connect to the cluster. 

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Clusters are secured with Transport Layer Security (TLS) certificates. Each cluster has its own set of credentials, which you can download in a zip file from the Carina control panel. The credentials zip file contains the following files:

* ca.pem - Certificate Authority, used by clients to validate servers
* cert.pem - Client Certificate, used by clients to identify themselves to servers
* key.pem - Client Private Key, used by clients to encrypt their requests
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates
* docker.env - Shell environment configuration script

**Note:** The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

### Prerequisite

A Carina account. If you do not already have one, follow the [sign up process](https://mycluster.rackspacecloud.com/managed).

### Create a cluster

1. Log in to [http://mycluster.rackspacecloud.com](http://mycluster.rackspacecloud.com).
1. In the **Create New** field, enter a name for the cluster.
1. Click **Create Cluster**.
1. Click the **Refresh** button until your cluster reaches a status of **active**.

### Connect to your cluster

Connect to your cluster by loading the cluster credentials and downloading the Docker client.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. On the Carina control panel, click **Download credentials** [insert-download-icon-here] in the **Actions** column for your cluster.

1. Save the zip file to a location on your computer.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster.

1. If you are using Windows and use CMD or PowerShell, follow the instructions in the [Create a Windows script](#windows) section and then precede to the next step.

1. Open a terminal application.

1. Change to the credentials directory. For example:

    ```bash
    $ cd /Users/octopus/Downloads/mycluster
    ```

1. Download the Docker 1.8.2 client for your OS into the credentials directory.
 * [Linux](https://get.docker.com/builds/Linux/x86_64/docker-1.8.2)
 * [Mac](https://get.docker.com/builds/Darwin/x86_64/docker-1.8.2)
 * [Windows](https://get.docker.com/builds/Windows/x86_64/docker-1.8.2.exe)

1. Rename the client to `docker`.

    ```bash
    $ mv docker-1.8.2 docker
    ```

1. On Linux and Mac OS X, ensure that the client is executable.

    ```bash
    $ chmod u+x docker
    ```

1. Load the cluster credentials and configuration.
    * (_Linux and Mac OSX users_) Run `source docker.env`.
    * (_Windows CMD users_) Run `docker.cmd`.
    * (_Windows PowerShell users_) Run `docker.ps1`.

1. Connect to your cluster and display information about it.

    ```bash
    $ ./docker info
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

    **Note:** A newly created cluster contains three containers that are necessary for cluster management. For more information about these containers, see [Introduction to Docker Swarm](/docs/tutorials/005-docker-swarm-intro).  

### <a name="windows"></a> Create a Windows script
The cluster credentials zip file includes a Bash script, **docker.env**, that defines the environment variables necessary for authenticating to your cluster. Use the following instructions to create an equivalent script in CMD or PowerShell.

1. Open **docker.env** and note the IP address of your cluster. It is on the line that defines the DOCKER_HOST variable.

2. To create a CMD script, create a file named **docker.cmd** in the credentials directory, and populate it with the following content. Replace `<ipAddress>` with the IP address of your cluster.

    ```batch
    set DOCKER_HOST=tcp://<ipAddress>:2376
    set DOCKER_TLS_VERIFY=1
    set DOCKER_CERT_PATH=%~dp0
    ```

3. To create a PowerShell script, create a file named **docker.ps1** in the credentials directory, and populate it with the following content. Replace `<ipAddress>` with the IP address of your cluster.

    ```powershell
    $env:DOCKER_HOST="tcp://<ipAddress>:2376"
    $env:DOCKER_TLS_VERIFY=1
    $env:DOCKER_CERT_PATH=$PSScriptRoot
    ```

### Troubleshooting

* If you get the following error message,  read the [version conflict](/docs/references/version-conflict) guide: 

    `Error response from daemon: client and server don't have same version (client : x.xx, server: x.xx)` 

* If you're behind a firewall or VPN and it's blocking port 2376 (a port used by Docker), you will get the following error message:

    `Cannot connect to the Docker daemon. Is "docker - d" running on this host?` 

    To resolve this error, request your network administrator to open that port or try this tutorial from a location where port 2376 isn't blocked.

### Resources

If you're new to Carina, Docker, and containers, see the following articles to learn more: 

* [Overview of Carina](/docs/tutorials/overview-of-carina)
* [Docker 101](/docs/tutorials/002-docker-101)
* [Container 101](/docs/tutorials/001-containers-101)

### Next step

Run your applications in containers. Use the right tutorial for your application:

* [provide links to all the tutorials that are relevant]