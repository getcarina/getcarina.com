---
title: Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
permalink: docs/tutorials/carina-cli/
description: Manage your Carina clusters with the Carina CLI
topics:
  - Carina
  - beginner
---

The Carina client is a cross-platform command-line tool for managing your Carina
clusters, capable of communicating with the original Carina beta, the Rackspace Public Cloud,
and Rackspace Private Cloud.

This is the full documentation for the Carina client, see [Getting started with the Carina CLI]({{ site.base_url }}/docs/getting-started/getting-started-carina-cli/) for the quickstart guide.

### Install
To download and install the Carina client, use the appropriate instructions for your operating system.

Open an application in which to run commands.

* On Linux and Mac OS X, open a terminal.
* On Windows, open PowerShell.

#### Mac OS X with Homebrew

Open a terminal and execute the following command:

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

Open PowerShell and execute the following command:

```powershell
> choco install carina
```

#### Windows without Chocolatey

PowerShell performs the initial installation; you can use `carina` with PowerShell
or CMD after it is installed. Open PowerShell and execute the following command:

```powershell
> wget 'https://download.getcarina.com/carina/latest/Windows/x86_64/carina.exe' -OutFile carina.exe
```

Now move `carina.exe` to a directory on your `%PATH%`.

### Upgrade
To upgrade carina to the latest version, if you are using a package manager,
use the appropriate `upgrade` command, otherwise repeat the manual installation instructions above.

### Configure
The Carina client can be configured to authenticate to Carina in multiple ways:
command-line [flags](#flags), [environment variables](#environment_variables), and [profiles](#profiles).
In addition, the client can communicate with multiple clouds: the original Carina beta,
Rackspace Public Cloud and Rackspace Private Cloud. The user credentials are used to automatically
detect the cloud.

In the following example, private cloud is detected because `--password` is specified:

```
carina --username bob --password ilovepuppies --project admin --auth-endpoint https://example.com/auth/v3 ls
```

In the following example, public cloud is detected because `--apikey` is specified:

```
carina --username bob --apikey abc123 ls
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

#### Environment Variables
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

#### List Templates
List the cluster templates that you can use to create a cluster.

```bash
$ carina templates
```

#### Create
Create a cluster using a cluster template.

```bash
$ carina create --template <template-name> <cluster-name>
```

**Optional Flags**
* `--nodes <nodes>`: Specify the initial number of nodes in the cluster.
* `--wait`: Wait for the cluster to become active.

#### List Clusters
List information about your clusters.

```bash
$ carina clusters
```

#### Download Credentials
Download a cluster's credentials to your local file system.

```bash
$ carina credentials <cluster-name>
```

**Optional Flags**
* `--path <path>`: Specify an alternate full path where the credentials should be saved.
