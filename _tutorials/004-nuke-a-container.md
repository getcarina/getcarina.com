---
title: How to stop a runaway container
slug: containers-101-introduction-containers
description: How to stop an accidentally attached non-interactive container
topics:
  - containers
  - Docker
  - tutorial
  - troubleshooting

---
If you accidentally launch a container without the `--detach` (`-d`) flag, that container will run in the foreground of the terminal. Usually, you can stop the running container by using `Ctrl-C` or `Ctrl-D`. Sometimes, however, the process doesn't respond to `Ctrl-C` or `Ctrl-D`, and the container continues running without response to any input.

![Runaway Container]({% asset_path runaway-container.gif %})

In this situation, you can stop the container by opening a separate terminal and terminating the container. If you terminate a container, you remove both the container and the volume associated with it.

1. Open a separate terminal and run `docker ps` to find the container ID.
2. To terminate the container, use the following command:

    `docker rm -fv CONTAINER_ID`

    The `-f` flag is short for `--force=false`, which forces the removal of a running container. The `-v` flag is short for `--volumes=false`, which removes the volumes associated with the container. You can use the long or short version of the flags.

Alternatively, you can sever the client connection to the server while keeping the
Docker container running.

1. Run `ps aux | grep docker` to find the `docker run` command.

    ```
    $ ps aux | grep docker
    rgbkrk        22442   0.0  0.0  2441988    700 s004  S+   10:49AM   0:00.01 grep docker
    rgbkrk        22434   0.0  0.0 145169880   5664 s002  S+   10:44AM   0:00.16 docker run whoa/tiny
    ```
2. Run the `kill` command for the process ID associated with `docker run`.

    ```
    $ kill 22434
    $ ps aux | grep docker
    rgbkrk        22448   0.0  0.0  2432772    680 s004  S+   10:49AM   0:00.00 grep docker
    rgbkrk        22434   0.0  0.0 145169880   5664 s002  S+   10:44AM   0:00.16 docker run whoa/tiny
    $ kill -9 22434
    ```
    If the first time you run the `kill` command doesn't work, you can use a signal to send a more specific `kill` command. Appending the `-9` signal sends a non-catchable, non-ignorable `kill`.

3. After ending the `docker run` command, find the running container and stop it
   by using the `rm` command shown earlier:

    ```
    $ docker ps
    CONTAINER ID        IMAGE                    COMMAND                CREATED             STATUS              PORTS                        NAMES
    2894da59f72e        whoa/tiny:latest         "/whoa"                6 minutes ago       Up 5 minutes        8080/tcp                     7b0948a3-d660-465a-b32d-5051c25184ba-n2/grave_colden
    $ docker rm -fv 2894da59f72e
    2894da59f72e
    ```
