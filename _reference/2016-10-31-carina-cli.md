---
title: Carina CLI
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-10-31
featured: true
permalink: docs/reference/carina-cli/
description: Manage your Carina clusters with the Carina CLI
topics:
  - carina
  - cli
  - beginner
---

The Carina client is a cross-platform command-line tool for managing your Carina
clusters. The client can communicate with both Rackspace Public Cloud and Private Cloud.

This is the full documentation for the Carina client. For specific information about
getting started, see [Getting started with Docker swarm and the Carina CLI]({{ site.base_url }}/docs/getting-started/create-swarm-cluster-with-cli/)
or [Getting started with Kubernetes and the Carina CLI]({{ site.base_url }}/docs/getting-started/create-kubernetes-cluster-with-cli/).
The source code is located at [https://github.com/getcarina/carina](https://github.com/getcarina/carina).
Feedback, bug reports, and pull requests are welcome!

* [Install](#install)
* [Upgrade](#upgrade)
* [Configure](#configure)
* [List templates](#list-templates)
* [Create a cluster](#create-a-cluster)
* [List clusters](#list-clusters)
* [Download credentials](#download-credentials)
* [Load a cluster environment](#load-a-cluster-environment)
* [Resize a cluster](#resize-a-cluster)
* [Delete a cluster](#delete-a-cluster)
* [View a cluster](#view-a-cluster)
* [View user quotas](#view-user-quotas)
* [Generate bash completion](#generate-bash-completion)

### Install
{% include install-carina.md %}

### Upgrade
If you installed the `carina` CLI with a package manager, use the appropriate upgrade command.
Otherwise, repeat the manual installation instructions in the preceding section.

### Configure
You can configure the Carina client to authenticate to Carina in multiple ways:
command-line [flags](#flags), [environment variables](#environment_variables), and [profiles](#profiles).
In addition, the client can communicate with both Rackspace Public Cloud and Private Cloud.
The user credentials are used to automatically detect the cloud.

In the following example, the public cloud is detected because `--apikey` is specified:

```
$ carina --username bob --apikey abc123 ls
```

In the following example, the private cloud is detected because `--password` is specified:

```
$ carina --username bob --password ilovepuppies --project admin --auth-endpoint https://example.com/auth/v3 ls
```

In the following example, the private cloud is used, even when the Rackspace Public Cloud environment variables are present, because `--cloud` is specified:

```
$ carina --cloud private ls
```

#### Flags
Command-line flags take higher precedence over environment variables and profiles.

Use the `--cloud` flag to explicitly specify the cloud type: `public` or `private`.
For a limited period of time, you can specify the original Carina beta by using `--cloud make-swarm`.

When you specify `--cloud public`, you use the following flags:
* `--username`
* `--apikey`

When you specify `--cloud private`, you use the following flags:
* `--username`
* `--password`
* `--auth-endpoint`
* `--project`
* `--domain`
* `--region`

#### Environment variables
Environment variables are a safe way to specify sensitive credentials without having them
captured in your shell session history.

The client first looks for the Rackspace Public Cloud environment variables.
If it does not find them, it looks for the Rackspace Private Cloud environment variables.
For your convenience, the client also recognizes the environment variables used by the Rackspace
command-line tool, `rack`. Use the `--cloud` flag to explicitly select a cloud.

Set and use the following environment variables for public cloud:
* `CARINA_USERNAME`, or `RS_USERNAME`
* `CARINA_APIKEY`, or `RS_API_KEY`

Set and use the following environment variables for private cloud.
You can quickly set them by sourcing the [openrc file
for your private cloud installation](https://developer.rackspace.com/docs/private-cloud/rpc/v10rpc-v10-op-user-guide/environment-variables/).
* `OS_USERNAME`
* `OS_PASSWORD`
* `OS_AUTH_URL`
* `OS_PROJECT_NAME`
* `OS_PROJECT_DOMAIN_NAME`, `OS_USER_DOMAIN_NAME`, or `OS_DOMAIN_NAME`
* `OS_REGION_NAME`

#### Profiles
You can save credentials under a profile name in the `~/.carina/config.toml` file, and
then specify that profile name with the `--profile`, or by setting the `CARINA_PROFILE`
environment variable. The file is in the [TOML file format](https://github.com/toml-lang/toml)
and is not encrypted.

**Note**: When using profiles, other authentication flags and ambient environment
variables are ignored.

Following is a sample configuration file:

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
that profile is used if no command-line flags are provided. The default
profile takes precedence over environment variables.

```toml
[default]
cloud="public"
username="alicia"
apikey="abc123"
```

You can use environment variables in the configuration file by appending `-var`
to the setting key—for example `username-var`.

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
The configuration file path can be overridden with the `--config` flag.

### List templates
List the cluster templates that you can use to create a cluster. A cluster template
defines a cluster topology and configuration.

```bash
$ carina templates
Name              COE         Host
Kubernetes LXC    kubernetes  lxc
Swarm LXC         swarm       lxc
```

### Create a cluster
Create a cluster by using a cluster template.

```bash
$ carina create --template <templateName> <clusterName>
ID        b5c2858a-ec65-4c05-b9a4-4d2db70b183e
Name      mycluster
Status    creating
Template  Kubernetes LXC
Nodes     1
Details
```

* `--template <templateName>`: The name of the template, which defines the cluster topology and configuration.
* `--nodes <nodes>`: (_Optional_). The number of nodes for the initial cluster (defaults to 1).
* `--wait`: (_Optional_) Wait for the cluster to become active before exiting.

### List clusters
List information about your clusters.

```bash
$ carina clusters
ID                                    Name       Status    Template          Nodes
b5c2858a-ec65-4c05-b9a4-4d2db70b183e  mycluster  active    Kubernetes LXC    1
```

### Download credentials
Download a cluster's credentials to your local file system.

```bash
$ carina credentials <clusterName>
#
# Credentials written to "/Users/chloe/.carina/clusters/public-chloe/mycluster"
# To see how to connect to your cluster, run: carina env mycluster
#
```

* `--path <path>`: (_Optional_) The full path to the directory where the credentials should be saved.

### Load a cluster environment
Connects the `docker` or `kubectl` client to a cluster by setting
environment variables in the current shell session. After loading the cluster
environment, you can test the connection by running `docker info` or `kubectl cluster-info`.

The following environment variables are set when you load an environment:

* `CARINA_CLUSTER_NAME` helps you remember which cluster is currently connected
* `DOCKER_HOST`, `DOCKER_CERT_PATH` and `DOCKER_TLS_VERIFY` are used by `docker` to connect to your cluster.
* `DOCKER_VERSION` is designed to work with the Docker Version Manager (dvm). Run `dvm use` and it will use that environment variable to load the right Docker client binary into the current session.
* `KUBECONFIG` is used by `kubectl` to connect to your cluster.

**Mac OS X and Linux**

```bash
$ eval $(carina env <clusterName>)
```

**Windows**

On Windows, you must include the `--shell` flag and specify whether the command
outputs in `powershell` or `cmd` syntax.

* PowerShell
    ```powershell
    > carina env <clusterName> --shell powershell | iex
    ```
* CMD
    Copy, paste, and then run the output of the following command:
    ```
    > carina env <clusterName> --shell cmd
    ```

### Resize a cluster
Change the number of nodes in the cluster.

```bash
$ carina resize --nodes <nodes> <clusterName>
ID        b5c2858a-ec65-4c05-b9a4-4d2db70b183e
Name      mycluster
Status    resizing
Template  Kubernetes LXC
Nodes     1
Details
```

* `--nodes <nodes>`: The desired number of nodes in the cluster.
* `--wait`: (_Optional_) Wait for the cluster to become active before exiting.

### Delete a cluster
Delete a cluster and any downloaded credentials for the cluster.

```bash
$ carina delete <clusterName>
Deleting cluster (mycluster)
```

* `--wait`: (_Optional_) Wait for the cluster to be deleted before exiting.

### View a cluster
Show information about a cluster

```bash
$ carina get <clusterName>
ID        b5c2858a-ec65-4c05-b9a4-4d2db70b183e
Name      mycluster
Status    active
Template  Kubernetes LXC
Nodes     1
Details
```

* `--wait`: (_Optional_) Wait for the cluster to become active before exiting.

### View user quotas
Display the maximum number of clusters and the maximum number of nodes per cluster.

```bash
$ carina quotas
Max Clusters           3
Max Nodes per Cluster  1
```

### Generate bash completion
Generate a bash completion file for use with the Bash shell. After generating the file,
you must source it in your current shell session, or source it in your Bash profile.

```bash
$ carina bash-completion > ~/.carina/bash-completion.sh
$ source ~/.carina/bash-completion.sh
```
