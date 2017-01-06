---
title: "Manage Docker clients with the Docker Version Manager"
date: 2015-11-09 23:59
comments: true
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
authorIsRacker: true
authorAvatar: https://secure.gravatar.com/avatar/8b96f8872eb3f398809daf017ee3a8ab
published: true
categories:
    - Carina
    - Docker
    - Tools
---

All it takes is an old Docker Machine instance, installing the latest version
of the Docker client, or creating a new cluster to trigger the dreaded
Docker client/server API mismatch error message:

```bash
Error response from daemon: client is newer than server (client API version: 1.21, server API version: 1.20)
```

With the Docker Version Manager, you can banish that error message entirely*.
Docker Version Manager (dvm) is a cross-platform command-line tool that helps you install and
switch between Docker clients. Let's install dvm and see what it can do.

<!-- more -->

Run the following installation commands for your OS, and then copy, paste and
run the commands from the output to finalize the installation.

**Mac OS X with Homebrew**

```bash
$ brew update
$ brew install dvm
```

**Mac OS X and Linux**

```bash
$ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
```

**Windows**

PowerShell performs the initial installation; you can use `dvm` with PowerShell
or CMD after it is installed. Open a PowerShell command prompt and execute the following:

```powershell
> iwr 'https://download.getcarina.com/dvm/latest/install.ps1' -UseBasicParsing | iex
```

After dvm is installed, list all installed versions of the Docker client:

```bash
$ dvm ls
->  system (1.8.1)
```

That version is a bit old, so let's install a newer version of Docker:

```bash
$ dvm install 1.9.0
Installing 1.9.0...
Now using Docker 1.9.0

$ docker --version
Docker version 1.9.0, build 76d6bc9
```

Switching between versions is just a short command: `dvm use <version>`. If the requested version is not already
installed, dvm installs it for you.

```bash
$ dvm use 1.8.3
1.8.3 is not installed. Installing now...
Installing 1.8.3...
Now using Docker 1.8.3

$ docker --version
Docker version 1.8.3, build f4bf5c7
```

At any time, you can undo the changes that dvm has made to your current session. After
deactivating, you are back to using the system installation of the Docker client.

```bash
$ dvm deactivate
$ docker --version
Docker version 1.8.1, build d12ea79
```

Now, let's use dvm with Carina! First, load your cluster credentials.
Then dvm will use them to automatically detect the right Docker version for your cluster.

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

You can also define an alias for a version, or use one of the built-in aliases,
`system` and `experimental`. The `system` alias is used to switch to the system
installation of Docker, and `experimental` is an alias for the latest, nightly Docker build.

```bash
$ dvm ls
->  1.8.3
    1.9.0
    experimental (1.10.0-dev, build c920895)
    system (1.8.1)

$ dvm use system
Now using system version of Docker: 1.8.1

$ dvm use experimental
Now using Docker experimental
```

So what are you waiting for? Stop juggling Docker clients, and start using dvm today!
For more information about dvm, see the project at https://github.com/getcarina/dvm.

\* **Note:** If you are not using Carina, you may still encounter the Docker
client/server API mismatch error. If that happens, you need to figure out the appropriate
Docker client version and run `dvm use <version>`.
