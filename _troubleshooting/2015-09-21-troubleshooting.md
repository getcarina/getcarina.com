---
title: Troubleshooting common problems
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-21
featured: true
permalink: docs/troubleshooting/common-problems/
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

To resolve this error, ensure that you have gone through each step of [Connect to your cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster#connect-to-your-cluster).

### Error response from daemon: client and server don't have same version

If there is a version mismatch between your Docker client and your Carina cluster, you might get the following error message:

```
Error response from daemon: client and server don't have same version (client : x.xx, server: x.xx)`
```

To resolve this error:

1. Install the [Docker Version Manager (dvm)][dvm].
2. [Load your cluster credentials][carina-creds].
3. Run `dvm use`. This switches your Docker client to the same version used by your cluster.

[dvm]: {{site.baseurl}}/docs/tutorials/docker-version-manager/
[carina-creds]: {{site.baseurl}}/docs/references/carina-credentials/

### Cannot connect to the Docker daemon

The following error indicates one of two possible issues:

```
Cannot connect to the Docker daemon. Is "docker -d" running on this host?
```  
1. You're behind a firewall or VPN and it's blocking port 2376 (a port used by Docker). To resolve this error, request your network administrator to open that port or retry your actions from a location where port 2376 isn't blocked.

2. You've accidentally removed the Docker Swarm management containers. To resolve this error see [How do I rebuild a cluster?]({{site.baseurl}}/docs/reference/faq/#how-do-i-rebuild-a-cluster) and [What does the cluster rebuild action do?]({{site.baseurl}}/docs/reference/faq/#what-does-the-cluster-rebuild-action-do).

### Debug a running container

You can enter a running container to investigate and debug what's happening inside the container. The following command starts an interactive shell in the latest container run:

```bash
$ docker exec -it $(docker ps -q -l) /bin/bash
```

### nsenter: Failed to open ns file /proc/xxxxxx/ns for ns ipc: Permission denied

If you run `docker exec` on a container that runs a process that exits, you get an error message. For example:

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

### Running out of disk space on a segment

You get a certain amount of disk space per segment; see [Carina segments]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/#carina-segments) to find out how much. If you run out of disk space, the applications in your containers might fail to start and your containers will immediately go into the "Exited" status. For example, MongoDB will fail to start and `Insufficient free space for journal files` will be in the log messages.

Use the following commands to check the remaining disk space on your segments.

```bash
$ SEGMENTS=$(docker info | grep Nodes | awk '{print $2}')
$ for (( i=1; i<=$SEGMENTS; i++ )); do
   echo "*** Segment $i ***"
   docker run -it --rm --env constraint:node==*-n$i alpine:3.3 df -h /
  done
*** Segment 1 ***
Filesystem                Size      Used Available Use% Mounted on
none                     19.4G      1.6G     16.8G   9% /
*** Segment 2 ***
Filesystem                Size      Used Available Use% Mounted on
none                     19.4G      1.1G     17.3G   6% /
```

The output of these commands is the output of the `df` command being run on every segment in your cluster. You can clearly see how much disk space is used and how much is available per segment.

To help prevent this issue, reclaim disk space when you remove containers by using the `--volumes` flag (`-v` for short). However, take extreme care when you do because any data in the volumes associated with that container will be lost permanently.

```bash
$ docker rm -v my-container-name-or-id
```

### Cannot start container xxxxxx: [8] System error: permission denied

If you attempt to bind mount a volume from the host using a volume flag of the form `--volume host-dir:container-dir`, you get an error message. For example,

```bash
$ docker run --rm --volume $HOME/src/config:/src/config cirros echo "Hello"
Timestamp: 2015-11-09 19:46:32.746407404 +0000 UTC
Code: System error

Message: permission denied

Frames:
---
0: setupRootfs
Package: github.com/opencontainers/runc/libcontainer
File: rootfs_linux.go@37
---
1: Init
Package: github.com/opencontainers/runc/libcontainer.(*linuxStandardInit)
File: standard_init_linux.go@52
---
2: StartInitialization
Package: github.com/opencontainers/runc/libcontainer.(*LinuxFactory)
File: factory_linux.go@242
---
3: initializer
Package: github.com/docker/docker/daemon/execdriver/native
File: init.go@35
---
4: Init
Package: github.com/docker/docker/pkg/reexec
File: reexec.go@26
---
5: main
Package: main
File: docker.go@19
---
6: main
Package: runtimeError response from daemon: Cannot start container 1784f91f2f2cbd88c0eab24d24f7cfa7b7bf9cc882b28d02509e23238648c786: [8] System error: permission denied
```

This error occurs because of security restrictions on Carina. To resolve this error, see the section on [Volumes]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/#volumes) in [Understanding how Carina uses Docker Swarm]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/).

### Old PowerShell version on Windows

If you are running PowerShell version 2 or less, the $PSScriptRoot variable in docker.ps1 is not supported and you get the following error message:

```
PS C:\Users\username\Desktop\mycluster> docker info
Could not read CA certificate "C:\\Users\\username\\.docker\\ca.pem": open C:\Users\username\.docker\ca.pem: The system cannot find the file specified.
```

To resolve this error, upgrade PowerShell to version 3 or above.

### Troubleshooting other problems

* [How to stop a non-responsive running container]({{ site.baseurl }}/docs/troubleshooting/stop-nonresponsive-running-container/)
* [Error publishing a container to a specific port]({{ site.baseurl }}/docs/troubleshooting/troubleshooting-port-unavailable/)
* [Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10]({{ site.baseurl }}/docs/troubleshooting/troubleshooting-windows-docker-vm-startup/)
* [Error running interactive Docker shell on Windows]({{ site.baseurl }}/docs/troubleshooting/troubleshooting-cannot-enable-tty-mode-on-windows/)
