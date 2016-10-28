---
title: Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
permalink: docs/reference/carina-cli/
description: Manage your Carina clusters with the Carina CLI
topics:
  - carina
  - cli
  - beginner
---

The Carina client is a cross-platform command-line tool for managing your Carina
clusters, capable of communicating with both Rackspace Public and Private Cloud.

This is the full documentation for the Carina client, see [Getting started with the Carina CLI]({{ site.base_url }}/docs/getting-started/getting-started-carina-cli/) for the quickstart guide.
The source code is located at [https://github.com/getcarina/carina](https://github.com/getcarina/carina),
feedback, bug reports and pull requests are welcome!

* [Install](#install)
* [Upgrade](#upgrade)
* [Configure](#configure)
* [List templates](#list-templates)
* [Create a cluster](#create-a-cluster)
* [List clusters](#list-clusters)
* [Download credentials](#download-credentials)
* [Load a cluster environment](#load-a-cluster-environment)
* [Delete a cluster](#delete-a-cluster)
* [View a cluster](#view-a-cluster)
* [View user quotas](#view-user-quotas)
* [Generate bash completion](#generate-bash-completion)

### Install
To download and install the Carina client, use the appropriate instructions for your operating system.

#### Mac OS X with Homebrew

If you're using [Homebrew](http://brew.sh/), open a terminal, and then run the following commands:

```bash
$ brew update
$ brew install carina
```

#### Mac OS X and Linux without Homebrew

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

### Upgrade
If you installed `carina` with a package manager, use the appropriate upgrade command.
Otherwise, repeat the manual installation instructions above.

### Configure
The Carina client can be configured to authenticate to Carina in multiple ways:
command-line [flags](#flags), [environment variables](#environment_variables), and [profiles](#profiles).
In addition, the client can communicate with multiple clouds: Rackspace Public Cloud and Rackspace Private Cloud.
The user credentials are used to automatically detect the cloud.

In the following example, public cloud is detected because `--apikey` is specified:

```
carina --username bob --apikey abc123 ls
```

In the following example, private cloud is detected because `--password` is specified:

```
carina --username bob --password ilovepuppies --project admin --auth-endpoint https://example.com/auth/v3 ls
```

In the following example, the private cloud is used, even when the Rackspace Public Cloud environment variables are present, because `--cloud` is specified:

```
carina --cloud private ls
```

#### Flags
Command-line flags take higher precedence over environment variables or profiles.

Use the `--cloud` flag to explicitly specify the cloud type: public, private. For a limited period of time,
the original Carina beta can be specified by using `--cloud makeswarm`.

**Public Cloud**

* `--username`
* `--apikey`

**Private Cloud**

* `--username`
* `--password`
* `--auth-endpoint`
* `--project`
* `--domain`
* `--region`

#### Environment variables
Environment variables are a safe way to specify sensitive credentials without having them
captured in your shell session history.

First, `carina` looks for the Rackspace Public Cloud environment variables,
then if not found, looks for the Rackspace Private Cloud environment variables.
For your convenience, the client also recognizes the environment variables used by the Rackspace
command-line tool, `rack`. Use the `--cloud` flag to explicitly select a cloud.

**Public Cloud**

* `CARINA_USERNAME`, or `RS_USERNAME`
* `CARINA_APIKEY`, or `RS_API_KEY`

**Private Cloud**

You can quickly set these environment variables by sourcing the [openrc file
for your private cloud installation](https://developer.rackspace.com/docs/private-cloud/rpc/v10rpc-v10-op-user-guide/environment-variables/).

* `OS_USERNAME`
* `OS_PASSWORD`
* `OS_AUTH_URL`
* `OS_PROJECT_NAME`
* `OS_PROJECT_DOMAIN_NAME`, `OS_USER_DOMAIN_NAME`, or `OS_DOMAIN_NAME`
* `OS_REGION_NAME`

#### Profiles
Credentials can be saved under a profile name in `~/.carina/config.toml`, and
then used with the `--profile` flag, for example, `carina --profile dev`. The
file is in the [TOML file format](https://github.com/toml-lang/toml) and is not encrypted.

The following is a sample configuration file:

```toml
[cloud1]
cloud="public"
username="alicia"
apikey="abc123"

[cloud2]
cloud="private"
username="devon"
password="abc123"
auth-endpoint="https://example.com/v3"
project="admin"
domain="Default"
region="RegionOne"
```

When `--profile` is not specified and the configuration file contains a profile named `default`,
that profile will be used when no command-line flags are provided. The default
profile takes precedence over environment variables.

```toml
[default]
cloud="public"
username="alicia"
apikey="abc123"
```

You can use environment variables in the configuration file by appending `-var`
to the setting key, for example `username-var`.

```toml
[cloud1]
cloud="public"
username-var="CARINA_USERNAME"
apikey-var="CARINA_APIKEY"

[cloud2]
cloud="private"
username-var="OS_USERNAME"
password-var="OS_PASSWORD"
auth-endpoint-var="OS_AUTH_URL"
project-var="OS_PROJECT_NAME"
domain-var="OS_PROJECT_DOMAIN_NAME"
region-var="OS_REGION_NAME"
```

**Note**: By default, the client stores its configuration in the  `~/.carina` directory.
You can change the configuration directory by setting the `CARINA_HOME` environment variable.
The configuration file path can be overriden with the `--config` flag.

### List templates
List the cluster templates that you can use to create a cluster. A cluster template
defines a cluster topology and configuration.

```bash
$ carina templates
```

### Create a cluster
Create a cluster using a cluster template.

```bash
$ carina create --template <template-name> <cluster-name>
```

* `--template <template-name>`: Name of the template, defining the cluster topology and configuration.
* `--nodes <nodes>`: Optional. Number of nodes for the initial cluster (defaults to 1).
* `--wait`: Optional. Wait for the cluster to become active.

### List clusters
List information about your clusters.

```bash
$ carina clusters
```

### Download credentials
Download a cluster's credentials to your local file system.

```bash
$ carina credentials <cluster-name>
```

* `--path <path>`: Optional. Full path to the directory where the credentials should be saved.

### Load a cluster environment
Displays the command to connect `docker` or `kubectl` to a cluster by setting
environment variables in the current shell session. After loading the cluster
environment, you can test the connection by running `docker info` or `kubectl cluster-info`.

**Mac OS X and Linux**

```bash
$ eval $(carina env <cluster-name>)
```

**Windows**

On Windows, you must include the `--shell` flag and specify if the command should
output in `powershell` or `cmd` syntax.

**PowerShell**

```powershell
> carina env <cluster-name> --shell powershell | iex
```

**CMD**

Copy, paste, and then run the output of the following command:

```
> carina env <cluster-name> --shell cmd
```

### Delete a cluster
Delete a cluster and any downloaded credentials for the cluster.

```bash
$ carina delete <cluster-name>
```

* `--wait`: Optional. Wait for the cluster to be deleted.

### View a cluster
Show information about a cluster

```bash
$ carina delete <cluster-name>
```

* `--wait`: Optional. Wait for the cluster to become active.

### View user quotas
Display the maximum number of clusters and the maximum number of nodes per cluster.

```bash
$ carina quotas
```

### Generate bash completion
Generate a bash completion file for use with the Bash shell. After generating the file,
you must source it into your current shell session, or source it in your Bash profile.

```bash
$ carina bash-completion > ~/.carina/bash-completion.sh
$ source ~/.carina/bash-completion.sh
```
