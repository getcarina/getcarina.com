---
title: Create and connect to a cluster
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-connect-cluster/
description: Learn how to create and connect to a cluster on Carina so that you can start running your applications in containers
docker-versions:
  - 1.11.2
kubernetes-versions:
  - 1.4.5
topics:
  - docker
  - beginner
---

This tutorial shows you how to create a cluster in Carina and download its credentials so that you can securely connect to the cluster.

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Clusters are secured with Transport Layer Security (TLS) certificates. Each cluster has its own set of credentials, which you can download in a zip file from the Carina Control Panel. The credentials zip file contains the following files, depending on the type of cluster:

* ca.pem: Certificate Authority, used by clients to validate the cluster certificates
* user.pem: Client Certificate, used by clients to identify themselves to the cluster
* user-key.pem: Client Private Key, used by clients to encrypt their requests to the cluster
* docker.env: Shell environment configuration script for Docker Swarm clusters
* docker.ps1: PowerShell environment configuration script for Docker Swarm clusters
* docker.cmd: CMD shell environment configuration script for Docker Swarm clusters
* kubectl.env: Shell environment configuration script for Kubernetes clusters
* kubectl.ps1: PowerShell environment configuration script for Kubernetes clusters
* kubectl.cmd: CMD shell environment configuration script for Kubernetes clusters

**Note**: The credential files are _sensitive_ and should be safe-guarded. Do not check them in to source control.

**Note**: This tutorial uses the website to create a cluster. To use the command-line interface, see [Getting started with Kubernetes and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster-with-cli/) or [Getting started with Docker Swarm and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster-with-cli/).

### Prerequisite

A Carina account. If you do not already have one, create a free account by following the [sign up process](https://app.getcarina.com/app/signup).

### Create a cluster

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. Select a cluster type, such as Kubernetes or Swarm.

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Download the cluster credentials

1. On the Carina Control Panel, click the cluster name.

1. On the Cluster Details page, click the **Actions** button, and then click **Download Credentials**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

To connect to your cluster, use the appropriate instructions for the cluster type:

* [Connect to a Docker Swarm cluster](#connect-to-a-docker-swarm-cluster)
* [Connect to a Kubernetes cluster](#connect-to-a-kubernetes-cluster)

### Connect to a Docker Swarm cluster

Connect to your cluster by first installing the Docker Version Manager (dvm)
and then configuring the Docker client to use the cluster credentials.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. Open an application in which to run commands.
  - On Linux and Mac OS X, open a terminal.
  - On Windows, open PowerShell.

1. Install `dvm`.

    On Mac OS X with Homebrew, run the following commands:

    ```bash
    $ brew update
    $ brew install dvm
    ```

    On Linux and Mac OS X without Homebrew, run the following command:

    ```bash
    $ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
    ```

    On Windows PowerShell, run the following command:

    ```powershell
    > iwr 'https://download.getcarina.com/dvm/latest/install.ps1' -UseBasicParsing | iex
    ```

1. From the output, copy the commands to load `dvm` from the output, and then paste and run them to finalize the installation.

1. Configure the Docker client with `dvm`.

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

### Connect to a Kubernetes cluster

Connect to your cluster by first installing the Kubernetes client (kubectl),
and then configuring it to use the cluster credentials.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. Open an application in which to run commands.
  - On Linux and Mac OS X, open a terminal.
  - On Windows, open PowerShell.

1. Install `kubectl`.

    On Mac OS X with Homebrew, run the following commands:

    ```bash
    $ brew update
    $ brew install kubectl
    ```

    On Mac OS X without Homebrew, run the following commands:

    ```bash
    $ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/darwin/amd64/kubectl
    $ chmod u+x kubectl
    $ mv kubectl ~/bin/kubectl
    ```

    On Linux, run the following commands:

    ```bash
    $ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/linux/amd64/kubectl
    $ chmod u+x kubectl
    $ mv kubectl ~/bin/kubectl
    ```

    On Windows PowerShell, run the following command, and then move `kubectl.exe` to a directory on your `%PATH%`.

    ```powershell
    > (New-Object System.Net.WebClient).DownloadFile("https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/windows/amd64/kubectl.exe", "$pwd\kubectl.exe")
    > mkdir  ~\.kube
    ```

1. Configure `kubectl`.

    On Mac OS X and Linux, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ source kubectl.env
    ```

    On Windows PowerShell, run the following commands:

    ```
    > cd Downloads\mycluster
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    > .\kubectl.ps1
    ```

1. Connect to your cluster and display information about it.

    ```bash
    $ kubectl cluster-info
    Kubernetes master is running at https://172.99.125.8
    KubeDNS is running at https://172.99.125.8/api/v1/proxy/namespaces/kube-system/services/kube-dns

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

When running a `kubectl` command, you may see the following error message,
which occurs when the `.kube` directory is missing. Create the directory in the
location specified by the error message to resolve the error.

```
error: open C:\Users\chole/.kube/config: The system cannot find the path specified.
```

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

If you're new to Carina, Docker, and containers, see the following articles to learn more:

* [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/)
* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
* [Containers 101]({{ site.baseurl }}/docs/concepts/containers-101/)


### Next steps

Run your application in a container. Use the right tutorial for your application from the **Tutorials** section of the [Documentation]({{ site.baseurl }}/docs/) page on the Carina website.
