---
title: Getting started with the Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/getting-started/getting-started-carina-cli/
description: Learn how to get started with the Carina command-line client (CLI) by installing, configuring, and performing commands
topics:
  - carina
  - cli
  - beginner
---

This tutorial demonstrates how to install and configure the Carina client so that you can use it to launch and control Carina clusters from the command line. No prior knowledge of containers, Docker or Kubernetes is necessary.

**Note**: This guide uses the command-line interface to create a cluster. To use the graphical user interface, see [Getting started on Carina]({{ site.baseurl }}/docs/getting-started/getting-started-on-carina/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

Note your Carina API key. To get it, go to the [Carina Control Panel](https://app.getcarina.com), click your username in the top-right corner, and then click **API Key**.

### Download and install the CLI

To download and install the `carina` CLI, use the appropriate instructions for your operating system.

#### OS X with Homebrew

If you're using [Homebrew](http://brew.sh/), open a terminal, and then run the following commands:

```bash
$ brew update
$ brew install carina
```

#### Linux and OS X without Homebrew

Open a terminal and execute the following command:

```bash
$ curl -L https://download.getcarina.com/carina/latest/$(uname -s)/$(uname -m)/carina -o carina
$ mv carina ~/bin/carina
$ chmod u+x ~/bin/carina
```

#### Windows with Chocolatey

If you are using [Chocolatey](http://chocolatey.org/), open PowerShell, and then run the following command:

```powershell
> choco install carina
```

#### Windows without Chocolatey

PowerShell performs the initial installation; you can use `carina` with PowerShell
or CMD after it is installed. Open PowerShell, execute the following command,
and then move `carina.exe` to a directory on your `%PATH%`.

```powershell
> iwr 'https://download.getcarina.com/carina/latest/Windows/x86_64/carina.exe' -OutFile carina.exe
```

**Note**: The download URL 32-bit systems is `https://download.getcarina.com/carina/latest/Windows/i686/carina.exe`.

### Configure with Carina credentials

1. Gather the required information:
  * Username (CARINA_USERNAME): Your Carina username from the [Carina Control Panel](https://app.getcarina.com), displayed at the top right. In many cases, your username is your email address.
  * API key (CARINA_APIKEY): Your Carina API key. To find it, see [Sign up for Carina](#sign-up-for-carina).

2. Set your environment variables to contain these credentials. Replace `<username>` with your Carina username and `<apikey>` with your Carina password.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ export CARINA_USERNAME=<username>
    $ export CARINA_APIKEY=<apikey>
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > $env:CARINA_USERNAME="<username>"
    > $env:CARINA_APIKEY="<apikey>"
    ```

3. Verify that you can issue `carina` commands:

    ```bash
    $ carina clusters
    ID                                      Name        Status    Template    Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    mycluster   active    swarm-dev   1
    ```

    The output is your list of clusters, if you already have some clusters already running.

### Create and connect to your cluster

1. Create a Docker Swarm cluster by using the `carina create` command.
   The `--wait` flag will wait for the cluster to become active before returning.

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

{% include getting-started.md %}

### Next steps

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
