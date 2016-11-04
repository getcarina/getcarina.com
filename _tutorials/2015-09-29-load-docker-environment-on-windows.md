---
title: Load a Docker environment from the command line on Windows
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-29
permalink: docs/tutorials/load-docker-environment-on-windows/
description: Learn how to load a Docker environment on Windows, so that you can work with Docker in the terminal and shell of your choice
docker-versions:
  - 1.10.1
topics:
  - docker
  - windows
  - beginner
---

**Note:** This tutorial is for Windows users. If you are using another operating system, follow
[the tutorial for Linux]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-linux/) or
[the tutorial for Mac OS X]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-mac/) instead.

This tutorial describes how to load a Docker environment on Windows, so that you can work
with Docker in the terminal and shell of your choice. For the purpose of this
tutorial, the term _shell_ refers to a command-line interpreter that executes
text commands and _terminal_ is the graphical window that hosts a shell.

* [Shells](#shells)
  * [CMD](#cmd)
  * [PowerShell](#powershell)
  * [Bash](#bash)
* [Terminals](#terminals)
  * [Windows Command Prompt](#windows-command-prompt)
  * [Mintty](#mintty)
  * [Alternatives](#alternatives)

### Prerequisite

[Install Docker on Windows]({{ site.baseurl }}/docs/tutorials/docker-install-windows/)

### Shells
After installing Docker Toolbox on Windows, you have three shells available for
interacting with Docker: CMD, PowerShell, and Bash. Although each shell provides
different commands and syntax, all are capable of interacting with Docker.

* [CMD](#cmd)
* [PowerShell](#powershell)
* [Bash](#bash)

#### CMD
[CMD][cmd-doc] is the standard Windows shell. To load a Docker environment in
CMD, perform the following steps:

1. Run `cmd.exe`.
2. Load your Docker host environment variables by using one of the following methods:
  * If you are using Carina, [download your credentials and connect to your cluster][create-connect-cluster].
  * Otherwise, run `docker-machine env default --shell cmd`, replacing `default`
    with the name of your Docker host. Copy the command output, and then paste it into the command line.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[cmd-doc]: http://ss64.com/nt/syntax.html
[create-connect-cluster]: {{site.baseurl}}/docs/getting-started/create-connect-cluster/#connect-to-a-docker-swarm-cluster

#### PowerShell
[PowerShell][powershell-doc] is built on Microsoft .NET and is designed to
work with .NET objects instead of raw text. It is distributed with all versions of
Windows supported by Docker. To load a Docker environment in PowerShell, perform the following steps:

1. Run `powershell.exe`.
2. Load your Docker host environment variables by using one of the following methods:
  * If you are using Carina, [download your credentials and connect to your cluster][create-connect-cluster].
  * Otherwise, run `docker-machine env default --shell powershell | Invoke-Expression`,
    replacing `default` with the name of your Docker host.
3. Verify that your Docker environment was initialized properly by running `docker version`.

You might encounter the following error message when loading your Rackspace Container Service credentials:

```powershell
docker.ps1 cannot be loaded because running scripts is disabled on this system.
```

Run the following command to enable running PowerShell scripts. Then, run `docker.ps1` again.

```powershell
> Set-ExecutionPolicy -Scope CurrentUser Unrestricted
```

[powershell-doc]: https://technet.microsoft.com/en-us/library/ms714469.aspx

#### Bash
[Bash][bash-doc] is a UNIX shell installed with [Git for Windows][git-for-windows],
which is included with Docker Toolbox. If you are using Bash from another source, such as Cygwin or MinGW,
the Docker environment setup remains the same.

**Note:** Even when running on Windows, Bash uses UNIX paths and is case-sensitive. For example,
the Windows path **C:\Users\Bob** would be translated to the UNIX path **/C/Users/Bob**.

To load a Docker environment in Bash, perform the following steps:

1. Start the Bash shell by performing one of the following actions:
    * Open the Git Bash application from the Windows Start menu.
    * In Windows Explorer, right-click a directory and select **Git Bash Here**.
    * From a terminal, run `"C:\Program Files\Git\bin\bash.exe" --login -i`.
2. Load your Docker host environment variables by using one of the following methods:
  * If you are using Carina, [download your credentials and connect to your cluster][create-connect-cluster].
  * Otherwise, run `eval $(docker-machine env default --shell bash)`,
    replacing `default` with the name of your Docker host.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[git-for-windows]: https://git-for-windows.github.io
[bash-doc]: http://www.gnu.org/software/bash/manual/bash.html

### Terminals
After installing Docker Toolbox on Windows, you have two terminals available:
Windows Command Prompt and mintty. If you do not want to use either of those terminals,
some alternatives are available to you.

* [Windows Command Prompt](#windows-command-prompt)
* [Mintty](#mintty)
* [Alternatives](#alternatives)

#### Windows Command Prompt
The Command Prompt is the standard Windows terminal. By default all console applications, including cmd.exe,
are hosted in the Windows Command Prompt.

![Windows Command Prompt Screenshot]({% asset_path load-docker-environment-on-windows/cmd.png %})

#### Mintty
[Mintty][mintty] is the terminal used by the Git Bash application installed with [Git for Windows][git-for-windows],
which is included with Docker Toolbox. With mintty, you can perform the following actions:

* Resize or maximize the window.
* Copy text by highlighting it with your mouse.
* Paste text by pressing the **Shift + Insert** keys. You may optionally
  configure it to paste when you right-click the mouse.

Although it is simple to configure, mintty lacks the advanced settings that other
terminals provide. Mintty doesn't provide full TTY support so a
[workaround is necessary to run an interactive Docker shell][troubleshooting-tty].

The default shell used when running Git Bash is [Bash](#bash), which will be familiar
to Linux or Mac OS X users. To take advantage of the mintty terminal and also continue using CMD or PowerShell,
open Git Bash and then run `cmd.exe` or `powershell.exe`. Then, follow the steps
in the [CMD](#cmd) or [PowerShell](#powershell) section of this tutorial to set up your Docker environment.

![Git Bash Screenshot]({% asset_path load-docker-environment-on-windows/gitbash.png %})

[mintty]: https://mintty.github.io
[troubleshooting-tty]: {{site.baseurl}}/docs/troubleshooting/troubleshooting-cannot-enable-tty-mode-on-windows/#use-ssh-to-connect-to-the-docker-host

#### Alternatives
Some alternative terminals provide useful features, such as improved copy and paste,
window resizing, and tabs. Overall they are more customizable than the standard
Windows terminal used by CMD and PowerShell.

* [ConsoleZ](#consolez)
* [ConEmu](#conemu)

##### ConsoleZ
[ConsoleZ][consolez] is a terminal emulator that can be used with any shell.

1. [Download ConsoleZ from GitHub][consolez-downloads].
2. Unzip the files to any location, such as **C:\Program Files\ConsoleZ**.
3. Open `console.exe`.
4. To customize ConsoleZ, right-click and select **Edit > Settings**. You can
    set the default shell, configure tabs, appearance, and so on.

In the following screenshot, ConsoleZ is configured with tabs for each shell (CMD, Bash and PowerShell).

![ConsoleZ Screenshot]({% asset_path load-docker-environment-on-windows/consolez.png %})

[consolez]: https://github.com/cbucher/console/wiki
[consolez-downloads]: https://github.com/cbucher/console/wiki/Downloads

##### ConEmu
[ConEmu][conemu], short for Console Emulator, is a terminal emulator that can be used with any shell.
A unique feature of ConEmu is that it can be configured to replace the [default terminal
in Windows][conemu-default-terminal], such that cmd.exe or any console application will
be automatically hosted in ConEmu.

1. [Download ConEmu from GitHub][conemu-releases].
2. Run the installer.
3. Open ConEmu.

    On startup, you will see a one-time configuration prompt where you can choose a default shell
    and perform other configuration tasks. It is safe to accept the defaults and customize later.
5. To customize ConEmu, right-click the title bar and select **Settings**. You
    can set the default shell, configure tasks, appearance, and so on.
    See [ConEmu Settings][conemu-settings] for an explanation of the available settings.

In the following screenshot, ConEmu is configured with tabs for each shell (CMD, Bash and PowerShell).

![ConEmu Screenshot]({% asset_path load-docker-environment-on-windows/conemu.png %})

[conemu]: https://conemu.github.io/
[conemu-releases]: https://github.com/Maximus5/ConEmu/releases
[conemu-settings]: https://conemu.github.io/en/Settings.html
[conemu-default-terminal]: https://conemu.github.io/en/DefaultTerminal.html

### References
* [CMD syntax][cmd-doc]
* [PowerShell syntax](http://ss64.com/ps/syntax.html)
* [Bash syntax](http://ss64.com/bash/syntax.html)
* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
