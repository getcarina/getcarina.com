---
title: Getting started with Kubernetes and the Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-kubernetes-cluster-with-cli/
description: Learn how to use the command line to get your first containerized application running on Kubernetes in a minimal amount of time
kubernetes-versions:
  - 1.4.5
topics:
  - carina
  - cli
  - beginner
---

This tutorial demonstrates how to use the command line to run your first containerized application on Kubernetes in a minimal amount of time. No prior knowledge of containers or Kubernetes is necessary.

**Note**: This tutorial uses the command-line interface to create a cluster. To use the website, see [Getting started with Kubernetes]({{ site.baseurl }}/docs/getting-started/create-kubernetes-cluster/).

### Sign up for Carina

To run applications on Carina, create a free account by following the [sign up process](https://app.getcarina.com/app/signup).

Note your Carina API key. To view your API key, go to the [Carina Control Panel](https://app.getcarina.com), click your username in the top-right corner, and then click **Settings**.

### Install the Carina CLI
{% include install-carina.md %}

### Install the Kubernetes client
{% include install-kubectl.md %}

### Configure the Carina CLI
{% include configure-cli.md %}

### Create and connect to your cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

1. View the available cluster templates by running the `carina templates` command.

    ```bash
    $ carina templates
    Name                     COE         Host
    Kubernetes 1.4.4 on LXC  kubernetes  lxc
    Swarm 1.11.2 on LXC      swarm       lxc
    ```

1. Create a Kubernetes cluster by running the `carina create` command
    specifying a template name from the previous step, and a name for the cluster.

    ```bash
    $ carina create --wait --template "Kubernetes 1.4.4 on LXC" mycluster
    ID                                      Name        Status    Template                  Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    mycluster   active    Kubernetes 1.4.4 on LXC   1
    ```

    The `--wait` flag indicates that the client should wait for the cluster to become active before exiting.

1. Configure the Kubernetes client (`kubectl`).

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ eval $(carina env mycluster)
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > carina env mycluster --shell powershell  | iex
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

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
