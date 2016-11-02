---
title: Getting started with Docker Swarm
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-swarm-cluster/
description: Learn how to get your first containerized application up and running on Carina in a minimal amount of time
docker-versions:
  - 1.11.2
topics:
  - docker
  - beginner
---

This tutorial shows you how to get your first containerized application up and running on Carina in a minimal amount of time.

No prior knowledge of containers, or Docker is necessary. This tutorial works on Linux, Mac, and Windows.

**Note**: This guide uses the website to create a cluster. To use the command-line interface, see [Getting started with Docker Swarm and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster-with-cli/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

### Create a cluster

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. Select Docker Swarm for the cluster type.

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Download the cluster credentials

1. On the Carina Control Panel, click the cluster name.

1. On the Cluster Details page, click the **Actions** button, and then click **Download Credentials**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

### Connect to the cluster

Connect to your cluster by first downloading the Docker Version Manager (dvm),
and then configuring `docker` to use the cluster credentials.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. Open an application in which to run commands.
  - On Linux and Mac OS X, open a terminal.
  - On Windows, open PowerShell.

1. Install the Docker Version Manager (dvm).

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

1. Copy the command to load `dvm` from the output, and then paste and run them to finalize the installation.

1. Configure the Docker client.

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

{% include getting-started-with-docker.md %}

### Next steps

Learn how to [install the Carina CLI and use it to manage your Swarm clusters]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster-with-cli/).

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
