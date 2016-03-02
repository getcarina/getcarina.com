---
title: Error running interactive Docker shell on Windows
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-25
permalink: docs/troubleshooting/troubleshooting-cannot-enable-tty-mode-on-windows/
description: Learn how to workaround the "cannot enable tty mode on non tty input" error when running an interactive Docker shell on Windows
docker-versions:
  - 1.10.1
topics:
  - docker
  - troubleshooting
  - windows
---

When you try to run an interactive shell on a Docker container via the Windows
Docker client, as shown in the following example, you might receive the following error message:

```bash
$ docker run --interactive --tty ubuntu sh
cannot enable tty mode on non tty input
```

This error is caused by the Git Bash terminal, MinTTY, because it does not have full support for TTY.
Cygwin users might also encounter this problem.

This article provides some possible workarounds.

* [Use the CMD terminal with the Bash shell](#use-the-cmd-terminal-with-the-bash-shell)
* [Use the CMD terminal with the Windows shell](#use-the-cmd-terminal-with-the-windows-shell)
* [Use PowerShell](#use-powershell)
* [Use an alternative terminal](#use-an-alternative-terminal)

### Use the CMD terminal with the Bash shell
Switch to the CMD terminal with the Bash shell, which is similar to using Git Bash.

1. [Load your Docker environment in the Bash shell]({{site.baseurl}}/docs/tutorials/load-docker-environment-on-windows/#bash),
    using the following command to launch the CMD terminal:

    ```bash
    "C:\Program Files\Git\bin\bash.exe" --login -i
    ```

1. Connect to the container:

    ```bash
    $ docker run --interactive --tty ubuntu sh
    ```

### Use the CMD terminal with the Windows shell
Switch to the CMD terminal with the standard Windows shell.

1. [Load your Docker environment in the Windows shell]({{site.baseurl}}/docs/tutorials/load-docker-environment-on-windows/#cmd).

1. Connect to the container:

    ```batch
    $ docker run --interactive --tty ubuntu sh
    ```

### Use PowerShell

1. [Load your Docker environment in PowerShell]({{site.baseurl}}/docs/tutorials/load-docker-environment-on-windows/#cmd).

1. Connect to the container:

    ```powershell
    $ docker run --interactive --tty ubuntu sh
    ```

### Use an alternative terminal
Use an alternative terminal, such as [ConEmu][conemu] or [ConsoleZ][consolez] and your preferred shell (Bash, CMD, or PowerShell).

[run-shell-docs]: https://docs.docker.com/articles/basics/#running-an-interactive-shell
[conemu]: https://conemu.github.io/
[consolez]: https://github.com/cbucher/console/wiki
