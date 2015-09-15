---
title: How to stop a runaway container
slug: containers-101-introduction-containers
description: How to stop a container if you've accidentally attached a non-interactive conatiner
topics:
  - containers
  - Docker
  - tutorial
  - troubleshooting
---
If you accidentally launch a container without the `--detach` (`-d`) flag, and the process
doesn't respond to `ctrl-c` or `ctrl-d`, you can stop the container by
opening a separate terminal and force quitting the container.

```
$ docker run whoa/tiny
^C^C
^C

^C
HALP, STAHP
^D
^D
SRSLY^C
```
Open a separate terminal and run `docker ps` to find the container ID. To force
quit the container, use the following command:

`docker rm -fv CONTAINER_ID`.

The `-f` flag is short for `--force=false`, which forces the removal of
a running container. The `-v` flag is short for `--volumes=false`, which
removes the volumes associated with the container. You can use the long or
short version of the flags.

Alternatively, you can kill the client connection to the server, which appears
as follows:

```
$ ps aux | grep docker
rgbkrk        22442   0.0  0.0  2441988    700 s004  S+   10:49AM   0:00.01 grep docker
rgbkrk        22434   0.0  0.0 145169880   5664 s002  S+   10:44AM   0:00.16 docker run whoa/tiny
$ kill 22434
$ ps aux | grep docker
rgbkrk        22448   0.0  0.0  2432772    680 s004  S+   10:49AM   0:00.00 grep docker
rgbkrk        22434   0.0  0.0 145169880   5664 s002  S+   10:44AM   0:00.16 docker run whoa/tiny
$ kill -9 22434
```
After this, you can find the running container and stop it:

```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND                CREATED             STATUS              PORTS                        NAMES
2894da59f72e        whoa/tiny:latest         "/whoa"                6 minutes ago       Up 5 minutes        8080/tcp                     7b0948a3-d660-465a-b32d-5051c25184ba-n2/grave_colden
$ docker rm -fv 2894da59f72e
2894da59f72e
```
