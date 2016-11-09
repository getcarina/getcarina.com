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

This tutorial demonstrates how to run your first containerized application on Kubernetes in a minimal amount of time.
No prior knowledge of containers or Kubernetes is necessary.

**Note**: This tutorial uses the website to create a cluster. To use the command-line interface, see [Getting started with Kubernetes and the Carina CLI]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster-with-cli/).

### Sign up for Carina

To run applications on Carina, create a free account by following the [sign up process](https://app.getcarina.com/app/signup).

### Install the Kubernetes client
{% include install-kubectl.md %}

### Create a cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. For the cluster type, select **Kubernetes**.

1. Click **Create Cluster**.

After a few moments, your cluster reaches a status of **active**.

### Download the cluster credentials
{% include manual-credentials-download.md %}

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

### Run your first application on Kubernetes
{% include getting-started-with-kubernetes.md %}

### Next steps

Learn how to [install the Carina CLI and use it to manage your Kubernetes clusters]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster-with-cli/).

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
