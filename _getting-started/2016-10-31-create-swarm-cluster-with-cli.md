---
title: Getting started with Docker Swarm and the Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/create-swarm-cluster-with-cli/
description: Learn how to get started with the Carina command-line client (CLI) by installing, configuring, and performing commands
docker-versions:
  - 1.11.2
topics:
  - carina
  - cli
  - beginner
---

This tutorial demonstrates how to install and configure the Carina client so that you can use it to launch and control Carina clusters from the command line. No prior knowledge of containers, Docker, or Kubernetes is necessary.

**Note**: This tutorial uses the command-line interface to create a cluster. To use the website, see [Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

Note your Carina API key. To get it, go to the [Carina Control Panel](https://app.getcarina.com), click your username in the top-right corner, and then click **API Key**.

### Install the Carina CLI
{% include install-carina.md %}

### Configure with Carina credentials

1. Gather the required information:
  * Username (CARINA_USERNAME): Your Carina username from the [Carina Control Panel](https://app.getcarina.com), displayed at the top right. In many cases, your username is your email address.
  * API key (CARINA_APIKEY): Your Carina API key. To find it, see [Sign up for Carina](#sign-up-for-carina).

2. Set your environment variables to contain these credentials. Replace `<username>` with your Carina username and `<apikey>` with your Carina API key.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ export CARINA_USERNAME=<username>
    $ export CARINA_APIKEY=<apiKey>
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > $env:CARINA_USERNAME="<username>"
    > $env:CARINA_APIKEY="<apiKey>"
    ```

3. Verify that you can run `carina` commands:

    ```bash
    $ carina clusters
    ID                                      Name        Status    Template    Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    mycluster   active    swarm-dev   1
    ```

    The output is your list of clusters, if you already have some clusters running.

### Create and connect to your cluster

1. Create a Docker Swarm cluster by running the `carina create` command.
   The `--wait` flag indicates to wait for the cluster to become active before exiting.

    ```bash
    $ carina create --wait --template swarm-dev mycluster
    ID                                      Name        Status    Template    Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    mycluster   active    swarm-dev   1
    ```

1. Configure your shell to connect to your cluster.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ eval $(carina env mycluster)
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > carina env mycluster --shell powershell  | iex
    ```

{% include getting-started-with-docker.md %}

### Next steps

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).