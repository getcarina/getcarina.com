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
$ docker run -it ubuntu /bin/bash
cannot enable tty mode on non tty input
```

This is caused by the Git Bash terminal, MinTTY, as it doesn't have full support for TTY.
Below are some possible workarounds:

* Use `docker-machine` to SSH into the Docker host, then start an interactive shell.

    ```bash
    # Start the container
    docker run --name test -dit ubuntu

    # SSH into the active Docker host
    docker-machine ssh $(docker-machine active)

    # Connect to the container
    docker exec -it test /bin/bash
    ```
* Use an alternate terminal such as CMD, PowerShell, [ConEmu][conemu] or [ConsoleZ][consolez].
  Once you have opened the terminal, run the following commands to use the Bash
  shell and load the default Docker environment. If you were working with a
  different Docker environment, replace 'default' to the appropriate name.

    ```
    "C:\Program Files\Git\bin\bash.exe" --login -i
    eval $(docker-machine env default --shell bash)
    ```
* Use the Docker QuickStart Terminal, which is really just a shortcut to CMD
  which also loads the default Docker environment.

[run-shell-docs]: https://docs.docker.com/articles/basics/#running-an-interactive-shell
[conemu]: https://conemu.github.io/
[consolez]: https://github.com/cbucher/console/wiki
