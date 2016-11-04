---
title: Manage Docker client versions with dvm
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-06
featured: true
permalink: docs/reference/docker-version-manager/
description: Manage your Docker clients with the Docker Version Manager (dvm)
topics:
  - Carina
  - Docker
  - beginner
---

The Docker Version Manager (dvm) is a cross-platform command-line tool that helps you install and
switch between Docker clients. It also helps both avoid and address the following
Docker client/server API mismatch error message:

```bash
Error response from daemon: client is newer than server (client API version: 1.21, server API version: 1.20)
```

**Note:** dvm manipulates the PATH variable of the current shell
session, and so the changes that dvm makes are temporary.

### Install dvm
{% include install-dvm.md %}

After dvm is installed, you can use it with [Carina](#carina) or [stand-alone](#stand-alone).

### Upgrade dvm
If you installed the `carina` CLI with a package manager, use the appropriate upgrade command.
Otherwise, run the following command:

```bash
dvm upgrade
```

<a id="carina"></a>
### Use dvm with Carina
Carina's credentials are designed to work with dvm. After you [connect to your cluster][carina-credentials],
run `dvm use` and dvm will switch to the version of Docker used by your cluster.
It automatically knows the Docker version for your cluster because the Carina
credentials set the `DOCKER_VERSION` environment variable. If you are just working with Carina,
then you are done; `dvm use` is all you need to know.

Following are examples of how to use dvm with the [Carina CLI][carina-cli]:

**Mac OS X and Linux**

```bash
$ eval "$( carina env mycluster )"
$ dvm use
Now using Docker 1.8.3
```

**Windows PowerShell**

```powershell
> Set-ExecutionPolicy -Scope CurrentUser Unrestricted
> carina credentials mycluster
#
# Credentials written to C:\Users\carolynvs\carina\clusters\carolynvs\mycluster\
#
"C:\Users\carolynvs\carina\clusters\carolynvs\mycluster\docker.cmd"

> C:\Users\carolynvs\carina\clusters\carolynvs\mycluster\docker.ps1
> dvm use
Now using Docker 1.8.3
```

[carina-credentials]: {{site.baseurl}}/docs/getting-started/create-connect-cluster/#connect-to-a-docker-swarm-cluster
[carina-cli]: {{site.baseurl}}/docs/reference/carina-cli/

<a id="stand-alone"></a>
### Use dvm stand-alone
If you are just using Carina, then `dvm use` is all you need to know. However, if
you are working with other Docker hosts, then read this section to learn about the functionality
that dvm provides.

This section describes the dvm commands. You can also run `dvm help` at any time
to view the available commands. You can use the following global flags with any
of the commands. Global flags should be specified before the command,
for example: `dvm --silent install 1.9.0`.

* `--silent` suppresses the commands normal output. Errors are still displayed.
* `--debug` prints additional debug information.

#### Install
Installs the specified version of the Docker client.

```bash
$ dvm install <version>
```

If `<version>` is omitted, dvm uses the value of the `DOCKER_VERSION` environment variable, if present.
The Carina credentials set the `DOCKER_VERSION` environment variable.
Run `dvm install experimental` to install the latest, nightly build.

#### Use
Switches to the specified version of the Docker client. If the version is not installed,
dvm installs it automatically.

```bash
$ dvm use <version>
```

If `<version>` is omitted, dvm uses the value of the `DOCKER_VERSION` environment variable, if present.
The Carina credentials set the `DOCKER_VERSION` environment variable.
You can also use an alias in place of the version, either a built-in alias such as `system` or `experimental`,
or a [user-defined alias](#alias).

#### List
Lists all installed versions of the Docker client, including the versions
installed by dvm and the system installation.

```bash
$ dvm ls
```

The output highlights the currently selected version. In the following example,
`1.9.0` is the currently selected version.

![Sample dvm ls output]({% asset_path 049-docker-version-manager/dvm-ls.png %})

#### List remote
Lists all available versions of the Docker client, excluding pre-releases.

```bash
$ dvm ls-remote
```

#### Alias
Creates an alias for a version of the Docker client. You can then use this alias
in the `dvm use` command.

```bash
$ dvm alias <alias> <version>
```

#### List alias
Lists all user-defined aliases.

```bash
$ dvm ls-alias
```

#### Current
Prints the version of the currently selected Docker client.

```bash
$ dvm current
```

#### Which
Prints the path to the currently selected Docker client.

```bash
$ dvm which
```

#### Version
Prints the currently installed version of dvm.

```bash
$ dvm --version
```

#### Uninstall
Removes the specified version of the Docker client.

```bash
$ dvm uninstall <version>
```

#### Unalias
Removes a user-defined alias.

```bash
$ dvm unalias <alias>
```

#### Deactivate
Undoes the effect of dvm on the current shell, restoring the PATH environment
variable to its original value.

```bash
$ dvm deactivate
```
