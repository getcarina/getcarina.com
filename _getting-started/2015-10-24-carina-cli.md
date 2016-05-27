---
title: Getting started with the Carina CLI
author: Anne Gentle <anne.gentle@rackspace.com>
date: 2015-10-24
featured: true
permalink: docs/getting-started/getting-started-carina-cli/
description: Learn how to get started with the Carina command-line client (CLI) by installing, configuring, and performing commands
topics:
  - carina
  - cli
  - intermediate
---

This tutorial demonstrates how to install and configure the Carina client so that you can use it to launch and control Docker Swarm clusters on a Carina endpoint. The `carina` command-line interface (CLI) is a self-contained binary written in Go, so installation involves downloading a binary, making it executable, adding it to your path, and then configuring it with credentials.

**Note**: This guide uses the command-line interface to create a cluster. To use the graphical user interface, see [Getting started on Carina]({{ site.baseurl }}/docs/getting-started/getting-started-on-carina/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

Note your Carina API key. To get it, go to the [Carina Control Panel](https://app.getcarina.com), click your username in the top-right corner, and then click **API Key**.

### Download and install the CLI

To download and install the `carina` CLI, use the appropriate instructions for your operating system.

#### OS X with Homebrew

If you're using [Homebrew](http://brew.sh/), run the following commands:

```bash
$ brew update
$ brew install carina
```

#### Linux and OS X without Homebrew

Downloads for the latest release of `carina` are available in [releases](https://github.com/getcarina/carina/releases/latest) for 64-bit Linux and OS X. You can use `curl` to download the binary, move it to a directory on your `$PATH`, and make it executable:

```bash
$ curl -L https://download.getcarina.com/carina/latest/$(uname -s)/$(uname -m)/carina -o carina
$ mv carina ~/bin/carina
$ chmod u+x ~/bin/carina
```

#### Windows with Chocolatey

If you are using [Chocolatey](http://chocolatey.org/), run the following command:

```powershell
> choco install carina
```

#### Windows (without Chocolatey)

Downloads for the latest release of `carina` are available in [releases](https://github.com/getcarina/carina/releases/latest). For quick installation, open PowerShell and run the following command:

```powershell
> wget 'https://download.getcarina.com/carina/latest/Windows/x86_64/carina.exe' -OutFile carina.exe
```

Be sure to move `carina.exe` to a directory on your `%PATH%`.

### Configure with Carina credentials

1. Gather the required information:
  * Username (CARINA_USERNAME): Your Carina username from the [Carina Control Panel](https://app.getcarina.com).
  * API key (CARINA_APIKEY): Your Carina API key. To find it, see [Sign up for Carina](#sign-up-for-carina).

2. Set your environment variables to contain these credentials. For example:

    **Bash**

    ```bash
    $ export CARINA_USERNAME=fnamelname
    $ export CARINA_APIKEY=ddd1233abcdef4a0bc5da6789123ab45c
    ```

    **PowerShell**

    ```powershell
    > $env:CARINA_USERNAME="fnamelname"
    > $env:CARINA_APIKEY="ddd1233abcdef4a0bc5da6789123ab45c"
    ```

3. Verify that you can issue `carina` commands:

      ```bash
      $ carina ls
      ```

      If you have some clusters already running, you see output similar to the following output:

      ```
      ClusterName       Flavor           Nodes  AutoScale    Status
      websocketsrock    container1-2G    2         true         active
      ```

### Create and connect to your cluster

1. Create a Carina cluster by using the `carina create` command.

    The `--wait` flag will wait for Swarm cluster to be active before returning.

    ```bash
    $ carina create --wait mycluster
    ClusterName         Flavor              Nodes               AutoScale           Status
    mycluster           container1-4G       1                   false               active
    ```

1. Configure your shell to connect to your cluster.

    **Bash**

    ```bash
    $ eval $(carina env mycluster)
    ```

    **PowerShell**

    ```powershell
    > carina env --shell powershell mycluster | iex
    ```

{% include getting-started.md %}

### Next steps

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).

Try another one of our [tutorials]({{ site.baseurl }}/docs/#tutorials).
