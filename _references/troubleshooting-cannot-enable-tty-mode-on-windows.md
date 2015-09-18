---
title: Error Running Interactive Docker Shell on Windows
topics:
  - docker
  - troubleshooting
  - windows
---

`cannot enable tty mode on non tty input`

When attempting to run an interactive shell on a Docker container via the Windows
Docker client, you may receive the following error:

```bash
$ docker run --interactive --tty ubuntu sh
cannot enable tty mode on non tty input
```

This is caused by the Git Bash terminal, MinTTY, as it does not have full support for TTY.
Below are some possible workarounds:

* Continue in Git Bash and use `docker-machine` to SSH into the Docker host,
  then start an interactive shell.

    ```bash
    # Start the container with a name specified so that it is easy to connect to later
    docker run --name test --detach --interactive --tty ubuntu

    # SSH into the active Docker host
    docker-machine ssh $(docker-machine active)

    # Connect to the container using its name from the first step
    docker exec --interactive --tty test sh
    ```
* Switch to the CMD terminal with the bash shell which will be a very similar experience to Git Bash.
  The script below will start a bash shell and then load the 'default' Docker environment.
  If you were working with a different Docker environment, replace 'default' with the appropriate name.

    ```bash
    "C:\Program Files\Git\bin\bash.exe" --login -i
    eval $(docker-machine env default --shell bash)

    docker run --interactive --tty ubuntu sh
    ```
* Switch to the CMD terminal with the standard Windows shell. Run the script below and
  then copy/paste the output into the command prompt. This will load the 'default'
  Docker environment. If you were working with a different Docker environment,
  replace 'default' with the appropriate name.

    ```text
    docker-machine env default --shell cmd

    docker run --interactive --tty ubuntu sh
    ```
* Use PowerShell. Run the script below to load the 'default' Docker environment.
  If you were working with a different Docker environment, replace 'default' with the appropriate name.

    ```powershell
    docker-machine env default --shell powershell | Invoke-Expression

    docker run --interactive --tty ubuntu sh
    ```
* Use an alternate terminal such as [ConEmu][conemu] or [ConsoleZ][consolez] and your preferred shell (bash, cmd or PowerShell).

[run-shell-docs]: https://docs.docker.com/articles/basics/#running-an-interactive-shell
[conemu]: https://conemu.github.io/
[consolez]: https://github.com/cbucher/console/wiki
