---
title: Error running interactive Docker shell on Windows
permalink: /docs/references/troubleshooting-cannot-enable-tty-mode-on-windows/
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

* [Use SSH to connect to the Docker host](#ssh)
* [Use the CMD terminal with the Bash shell](#cmd-with-bash)
* [Use the CMD terminal with the Windows shell](#cmd)
* [Use PowerShell](#powershell)
* [Use an alternative terminal](#other-terminals)

## <a name="ssh"></a> Use SSH to connect to the Docker host
Continuing in Git Bash, use the `docker-machine ssh` command to connect to the Docker host,
and then start an interactive shell:

1. Start the container with a name specified so that it is easy to connect to later:

    ```bash
    docker run --name test --detach --interactive --tty ubuntu
    ```

2. Use SSH to connect to the active Docker host:

    ```bash
    docker-machine ssh $(docker-machine active)
    ```

3. Connect to the container using its name from step 1:

    ```bash
    docker exec --interactive --tty test sh
    ```

## <a name="cmd-with-bash"></a> Use the CMD terminal with the Bash shell
Switch to the CMD terminal with the Bash shell, which is similar to using Git Bash.

1. Run the following commands, which start a Bash shell and then loads the Docker environment named `default`.
  If you are working with a different Docker environment, replace `default` with the appropriate name.

    ```bash
    "C:\Program Files\Git\bin\bash.exe" --login -i
    eval $(docker-machine env default --shell bash)
    ```

2. Connect to the container:

    ```bash
    docker run --interactive --tty ubuntu sh
    ```

## <a name="cmd"></a>Use the CMD terminal with the Windows shell
Switch to the CMD terminal with the standard Windows shell.

1. Run the following command, copy the output, and then paste it into the command prompt.
    This command loads the Docker environment named `default`. If you are working
    with a different Docker environment, replace `default` with the appropriate name.

    ```batch
    docker-machine env default --shell cmd
    ```

2. Connect to the container:

    ```batch
    docker run --interactive --tty ubuntu sh
    ```

## <a name="powershell"></a> Use PowerShell

1. Run the following command to load the Docker environment named `default`.
  If you are working with a different Docker environment, replace `default` with the appropriate name.

    ```powershell
    docker-machine env default --shell powershell | Invoke-Expression
    ```

2. Connect to the container:

    ```powershell
    docker run --interactive --tty ubuntu sh
    ```

## <a name="other-terminals"></a>Use an alternative terminal
Use an alternative terminal, such as [ConEmu][conemu] or [ConsoleZ][consolez] and your preferred shell (Bash, CMD, or PowerShell).

[run-shell-docs]: https://docs.docker.com/articles/basics/#running-an-interactive-shell
[conemu]: https://conemu.github.io/
[consolez]: https://github.com/cbucher/console/wiki
