---
title: Getting started on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-25
featured: true
permalink: docs/getting-started/getting-started-on-carina/
description: Learn how to get your first containerized application up and running on Carina in a minimal amount of time
docker-versions:
  - 1.10.3
topics:
  - docker
  - beginner
---

This tutorial shows you how to get your first containerized application up and running on Carina in a minimal amount of time.

No prior knowledge of containers or Docker is necessary. This tutorial works on Linux, Mac, and Windows.

**Note**: This guide uses the graphical user interface to create a cluster. To use the command line interface, see [Getting started with the Carina CLI]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

### Create your cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Connect to your cluster

Connect to your cluster by loading the cluster credentials and installing the Docker Version Manager (dvm). The cluster credentials and configuration are a set of files that allow you to securely access your cluster.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. On the Carina Control Panel, click the **Get Access** button associated with your cluster and click **Download File**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

1. Open an application in which to run commands.
    - On Linux and Mac OS X, open a terminal.
    - On Windows, open a PowerShell.

1. Configure your shell to communicate with the cluster.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ source docker.env
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > cd Downloads\mycluster
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    > .\docker.ps1
    ```

{% include getting-started.md %}

### Next step

Learn how to [install the Carina CLI and use it to manage your clusters]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).
