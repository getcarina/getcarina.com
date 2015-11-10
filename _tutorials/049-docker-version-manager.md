---
title: Docker Version Manager
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-11-12
permalink: docs/tutorials/docker-version-manager/
description: Manage your Docker clients with the Docker Version Manager (dvm)
topics:
  - Carina
  - Docker
  - beginner
---

The Docker Version Manager (dvm) is a cross-platform command-line tool that helps you install and
switch between Docker clients.

**Note:** dvm manipulates the PATH variable of the current shell
session and so the changes made by dvm are temporary.

## Installation
Run the following installation commands for your operating system, and then copy, paste and
run the commands from the output to finalize the installation.

**Mac OS X and Linux**

```bash
$ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
```

**Windows**

PowerShell performs the initial installation; you can use dvm with PowerShell
or CMD after it is installed. Open a PowerShell command prompt and execute the following:

```powershell
> iex (wget https://download.getcarina.com/dvm/latest/install.ps1)
```

## Carina and dvm
Carina's credentials are designed to work with dvm. After [loading your cluster credentials][carina-credentials],
run `dvm use` (omitting the version number) and dvm will switch to the version of Docker used by your cluster.
Dvm automatically knows the Docker version for your cluster because the Carina
credentials set the `DOCKER_VERSION` environment variable. If you are just working with Carina,
then you are done, `dvm use` is all you need to know.

The following are examples of how to use dvm with the [Carina CLI][carina-cli]:

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

[carina-credentials]: {{site.baseurl}}/docs/references/carina-credentials/
[carina-cli]: {{site.baseurl}}/docs/getting-started/getting-started-carina-cli/

## Usage
If you are just using Carina, then `dvm use` is all you need to know. However if
you are working with other Docker hosts, then read on to learn about all the functionality
that dvm provides.

Run `dvm help` to view available commands. The following are global flags which
can be used with any command. Global flags should be specified before the command,
for example: `dvm --silent install 1.9.0`.

* `--silent` suppresses the commands normal output. Errors are still displayed.
* `--debug` prints additional debug information.

### Install
Install the specified version of the Docker client.

```bash
$ dvm install <version>
```

If `<version>` is omitted, dvm uses the value of the `DOCKER_VERSION` environment variable, if present.
The Carina credentials set the `DOCKER_VERSION` environment variable.
Run `dvm install experimental` to install the latest, nightly build.

### Use
Switch to the specified version of the Docker client. If the version is not installed,
dvm will install it automatically.

```bash
$ dvm use <version>
```

If `<version>` is omitted, dvm uses the value of the `DOCKER_VERSION` environment variable, if present.
The Carina credentials set the `DOCKER_VERSION` environment variable.
You can also use an alias in place of the version, either a built-in alias such as `system` or `experimental`,
or a [user-defined alias](#alias).

### List
List all installed versions of the Docker client. This includes both those versions
installed by dvm and the system installation.

```bash
$ dvm ls
```

The output will be colored and indicate the currently selected version. In the following example,
`1.9.0` is the currently selected version.

![Sample dvm ls output]({% asset_path 049-docker-version-manager/dvm-ls.png %})

### List Remote
List all available versions of the Docker client, excluding pre-releases.

```bash
$ dvm ls-remote
```

### Alias
Create an alias for a version of the Docker client. You can then use this alias
in the `dvm use` command to switch the Docker version represented by the alias.

```bash
$ dvm alias <alias> <version>
```

### List Alias
List all user-defined aliases.

```bash
$ dvm ls-alias
```

### Current
Print the version of the currently selected Docker client.

```bash
$ dvm current
```

### Which
Print the path to the currently selected Docker client.

```bash
$ dvm which
```

### Version
Print the currently installed version of dvm.

```bash
$ dvm --version
```

### Uninstall
Remove the specified version of the Docker client.

```bash
$ dvm uninstall <version>
```

### Unalias
Remove a user-defined alias.

```bash
$ dvm unalias <alias>
```

### Deactivate
Undo the effect of dvm on the current shell, restoring the PATH environment
variable to its original value.

```bash
$ dvm deactivate
```
