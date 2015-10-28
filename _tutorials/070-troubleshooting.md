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

This article provides some solutions for common problems that you might encounter while using Carina. It also provides links to help for other issues. 

### Is your Docker daemon up and running?

If your environment isn't configured properly, you might get the following error message when attempting to run any `docker` command:

```
Get http:///var/run/docker.sock/v1.20/info: dial unix /var/run/docker.sock: no such file or directory.
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

To resolve this error, ensure that you have gone through each step of [Connect to your cluster](/docs/tutorials/create-connect-cluster#connect-to-your-cluster).

### Error response from daemon: client and server don't have same version

If there is a version mismatch between your Docker client and your Carina cluster, you might get the following error message:

```
Error response from daemon: client and server don't have same version (client : x.xx, server: x.xx)`
```

To resolve this error, ensure that you have gone through each step of [Connect to your cluster](/docs/tutorials/create-connect-cluster#connect-to-your-cluster) and have downloaded the correct version of the Docker client.

### Cannot connect to the Docker daemon

If you're behind a firewall or VPN and it's blocking port 2376 (a port used by Docker), you get the following error message:

```
Cannot connect to the Docker daemon. Is "docker -d" running on this host?
```

To resolve this error, request your network administrator to open that port or retry your actions from a location where port 2376 isn't blocked.

### Debug a running container

You can enter a running container to investigate and debug what's happening inside the container. The following command starts an interactive shell in the latest container run: 

```bash
$ docker exec -it $(docker ps -q -l) /bin/bash
```

### nsenter: Failed to open ns file /proc/xxxxxx/ns for ns ipc: Permission denied

If you run `docker exec` on a container that runs a process that exits, you an error message. For example:

```bash
$ docker run --name test -e MYSQL_ROOT_PASSWORD=password -d mysql
bbfce65817c7fe76a1137aa984ec50bf79378343ef70f3f5593f16b038a9f1fe

$ docker exec test echo "Yay! :)" || echo "Aw Man :("
nsenter: Failed to open ns file /proc/27625/ns for ns ipc: Permission denied
Aw Man :(
```

The key to the fix is that the original image runs a process that exits (in this case, `./entrypoint.sh mysqld`). Instead, run `tail –f /dev/null` at the end, which will never exit and thus preserve `pid 1` and allow `docker exec` to continue working. For example:

```bash
$ docker rm -f test
test

$ docker run --name test -e MYSQL_ROOT_PASSWORD=password -d --entrypoint /bin/bash mysql -c "./entrypoint.sh mysqld && tail -f /dev/null"
0d01fc4fe1ca53ca98f5f6a3d6ae634467b590523d7b9b3c7053e1d2244339bc

$ docker exec test echo "Yay! :)" || echo "Aw Man :("
Yay! :)
```

### Old PowerShell version on Windows

If you experience this issue, you will see:

```
PS C:\Users\username\Desktop\mycluster> docker info
Could not read CA certificate "C:\\Users\\username\\.docker\\ca.pem": open C:\Users\username\.docker\ca.pem: The system cannot find the file specified.
```

If you do not have PowerShell version 3 or above, the $PSScriptRoot variable in docker.ps1 is not supported, and the environment is not set up properly.
Upgrade PowerShell to version 3 or above to fix this issue.

### Troubleshooting other problems

* [How to stop a non-responsive running container](/docs/tutorials/stop-nonresponsive-running-container/)
* [Error publishing a container to a specific port](/docs/references/troubleshooting-port-unavailable/)
* [Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10](/docs/tutorials/troubleshooting-windos-docker-vm-startup/)
* [Error running interactive Docker shell on Windows](/docs/references/troubleshooting-cannot-enable-tty-mode-on-windows/)
