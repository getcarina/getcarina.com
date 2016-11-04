---
title: Getting started with Kubernetes
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-kubernetes-cluster/
description: Learn how to get your first containerized application up and running on Kubernetes in a minimal amount of time
kubernetes-versions:
  - 1.4.5
topics:
  - docker
  - beginner
---

This tutorial shows you how to get your first containerized application running on Kubernetes in a minimal amount of time.
No prior knowledge of containers, or Kubernetes is necessary.

**Note**: This guide uses the website to create a cluster. To use the command-line interface, see [Getting started with Kubernetes and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster-with-cli/).

### Sign up for Carina

To run applications on Carina, create a free account by following the [sign up process](https://app.getcarina.com/app/signup).

### Install the Kubernetes client
{% include install-kubectl.md %}

### Create a cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. Select Kubernetes for the cluster type.

1. Click **Create Cluster**.

After a few moments, your cluster reaches a status of **active**.

### Download the cluster credentials

The cluster credentials and configuration are a set of files that allow you to securely access your cluster.

1. On the Carina Control Panel, click the cluster name.

1. On the Cluster Details page, click the **Actions** button, and then click **Download Credentials**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

### Connect to your cluster

Connect to your cluster by configuring the Kubernetes client to use the cluster credentials.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. Configure the Kubernetes client (`kubectl`).

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ source kubectl.env
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > cd Downloads\mycluster
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    > .\kubectl.ps1
    ```
1. Use `kubectl` to connect to your cluster and display information about it.

    ```bash
    $ kubectl cluster-info
    Kubernetes master is running at https://172.99.125.8
    KubeDNS is running at https://172.99.125.8/api/v1/proxy/namespaces/kube-system/services/kube-dns

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```

{% include getting-started-with-kubernetes.md %}

### Next steps

Learn how to [install the Carina CLI and use it to manage your Kubernetes clusters]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster-with-cli/).

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
