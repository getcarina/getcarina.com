---
title: Troubleshooting common problems
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/troubleshooting/
description: Troubleshooting common problems on Carina
docker-versions:
  - 1.8.3
topics:
  - troubleshooting
---

### Is your docker daemon up and running?

If your environment isn't configured properly, you may get the following error when attempting to run any `docker` command.

```
Get http:///var/run/docker.sock/v1.20/info: dial unix /var/run/docker.sock: no such file or directory.
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

To resolve this error, make sure you have gone through each step of [Connect to your cluster](/docs/tutorials/create-connect-cluster#connect-to-your-cluster).

### nsenter: Failed to open ns file /proc/xxxxxx/ns for ns ipc: Permission denied

If you try to `docker exec` to a container that runs a process that exits, you will get the following error. For example,

```bash
$ docker run --name test -e MYSQL_ROOT_PASSWORD=password -d mysql
bbfce65817c7fe76a1137aa984ec50bf79378343ef70f3f5593f16b038a9f1fe

$ docker exec test echo "Yay! :)" || echo "Aw Man :("
nsenter: Failed to open ns file /proc/27625/ns for ns ipc: Permission denied
Aw Man :(
```

The key to the fix is that the original image runs a process that exits (`./entrypoint.sh mysqld` in this case). Instead, make it run `tail –f /dev/null` at the end which will never exit and thus preserve pid 1 and allow docker exec to continue working. For example,

```bash
$ docker rm -f test
test

$ docker run --name test -e MYSQL_ROOT_PASSWORD=password -d --entrypoint /bin/bash mysql -c "./entrypoint.sh mysqld && tail -f /dev/null"
0d01fc4fe1ca53ca98f5f6a3d6ae634467b590523d7b9b3c7053e1d2244339bc

$ docker exec test echo "Yay! :)" || echo "Aw Man :("
Yay! :)
```
