---

title: Create and connect to a cluster
author: Kelly Holcomb <kelly.holcomb@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/create-connect-cluster/
description: Learn how to create and connect to a cluster in Carina so that you can start running your applications in containers
docker-versions:
  - 1.8.2
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

**Note:** The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

### Prerequisite

A Carina account. If you do not already have one, follow the [sign up process](https://app.getcarina.com/signup).

### Create a cluster

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Connect to your cluster

Connect to your cluster by loading the cluster credentials and downloading the Docker client.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. On the Carina Control Panel, click the gear icon associated with your cluster and click **Get access**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

1. Download the Docker 1.8.3 client into the credentials directory.
  - On Linux, download the [Linux client](https://get.docker.com/builds/Linux/x86_64/docker-1.8.3) to `Downloads/mycluster`.
  - On Mac OS X, download the [Mac client](https://get.docker.com/builds/Darwin/x86_64/docker-1.8.3) to `Downloads/mycluster`.
  - On Windows, download the [Windows client](https://get.docker.com/builds/Windows/x86_64/docker-1.8.3.exe) to `Downloads/mycluster`.

1. Open an application in which to run commands.
  - On Linux and Mac OS X, open a terminal.
  - On Windows, open a PowerShell.

1. Configure the client.

    **Note:** If you already have the Docker client in your home bin directory, make a backup of it first.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ mkdir $HOME/bin
    $ mv docker-1.8.3 $HOME/bin/docker
    $ chmod u+x $HOME/bin/docker
    $ export PATH=$HOME/bin:$PATH
    $ if [ -f ~/.bash_profile ]; then echo 'export PATH=$HOME/bin:$PATH' >> $HOME/.bash_profile; fi
    $ source docker.env
    ```

    On Windows PowerShell, run the following commands:

    ```
    $ cd Downloads\mycluster
    $ mkdir "$env:USERPROFILE\bin"
    $ mv docker-1.8.3.exe "$env:USERPROFILE\bin\docker.exe"
    $ $env:PATH += ";$env:USERPROFILE\bin"
    $ [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
    $ Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    $ .\docker.ps1
    ```

1. Connect to your cluster and display information about it. If you are using Windows PowerShell, use `docker.exe` instead of `docker`.

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

    **Note:** A newly created cluster contains three containers that are necessary for cluster management. For more information about these containers, see [Introduction to Docker Swarm](/docs/tutorials/introduction-docker-swarm/).  

### Troubleshooting

* If you are behind a firewall or VPN and it's blocking port 2376 (a port used by Docker), you will get the following error message:

    `Cannot connect to the Docker daemon. Is "docker - d" running on this host?` 

    To resolve this error, request your network administrator to open that port or try this tutorial from a location where port 2376 isn't blocked.
    
* You might encounter the following error message when loading your credentials in PowerShell:

    ```powershell
    docker.ps1 cannot be loaded because running scripts is disabled on this system.
    ```

    Run the following command to enable running PowerShell scripts. Then, run `docker.ps1` again.

    ```powershell
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    ```

### Resources

If you are new to Carina, Docker, and containers, see the following articles to learn more: 

* [Overview of Carina](/docs/overview-of-carina/)
* [Docker 101](/docs/tutorials/docker-101/)
* [Container 101](/docs/tutorials/containers-101/)

### Next steps

On Linux, Mac OS X, or Windows, put the Docker client somewhere on your system's path.

Run your application in a container. Use the right tutorial for your application from the **Tutorials** section of the Dcoumentation page on the Carina website. 
