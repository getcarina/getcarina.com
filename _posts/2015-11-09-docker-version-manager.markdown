---
layout: post
title: "Juggling Docker clients with the Docker Version Manager"
date: 2015-11-09 23:59
comments: true
author: Carolyn Van Slyck
bio: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
authorIsRacker: true
authorAvatar: https://secure.gravatar.com/avatar/8b96f8872eb3f398809daf017ee3a8ab
published: true
categories:
    - Carina
    - Docker
    - Tools
---

New services exposing hosted Docker and other container systems are coming online all the time. Our recent Carina launch is a prime example.
Combine that with existing tools like Docker Machine, and it is easier than ever to spin up Docker hosts.
This is great but can introduce a new problem when each may be using a
different version of Docker. Keeping track and switching between them can become juggling act.
But not anymore!

Docker Version Manager (dvm) is a cross-platform command-line tool that helps you install and
switch between Docker clients.

<!-- more -->

Let's install dvm and take it for a spin. Copy, paste, and run the commands from your
installation output to finalize the installation.

** Mac OS X and Linux **

```bash
$ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
```

** Windows **

PowerShell performs the initial installation; you can use `dvm` with PowerShell or CMD once installed.
Open a PowerShell command prompt and execute the following:

```powershell
> iex (wget https://download.getcarina.com/dvm/latest/install.ps1)
```

Once installed, we can list all installed versions of the Docker client.

```bash
$ dvm ls
->  system (1.8.1)
```

Hmm, that's a bit old, so let's install a newer version of Docker.

```bash
$ dvm install 1.9.0
Installing 1.9.0...
Now using Docker 1.9.0

$ docker --version
Docker version 1.9.0, build 76d6bc9
```

Switching between versions is simple. In fact, if the requested version is not already
installed, dvm installs it for you.

```bash
$ dvm use 1.8.3
1.8.3 is not installed. Installing now...
Installing 1.8.3...
Now using Docker 1.8.3

$ docker --version
Docker version 1.8.3, build f4bf5c7
```

At any time, I can undo the changes that dvm has made to my current session. After
deactivating, I am back to using the system installation of the Docker client.

```bash
$ dvm deactivate
$ docker --version
Docker version 1.8.1, build d12ea79
```

Now, let's use dvm with Carina! First, I will load my cluster credentials.
Then dvm will use them to automatically detect the right version for my cluster.

** Mac OS X and Linux **

```bash
$ eval "$( carina env mycluster )"
$ dvm use
Now using Docker 1.8.3
```

** Windows PowerShell **

```powershell
> Set-ExecutionPolicy -Scope CurrentUser Unrestricted
> carina credentials mycluster
> C:\Users\carolynvs\carina\clusters\carolynvs\mycluster
> dvm use
Now using Docker 1.8.3
```

You can also define an alias for a version, or use one of the built-in aliases
`system` and `experimental`. The `system` alias is used to switch to the system
installation of Docker and `experimental` is an alias for the latest, nightly Docker build.

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

So what are you waiting for? Stop juggling, and start using dvm today!
For more information on dvm, the project is available at https://github.com/getcarina/dvm.
