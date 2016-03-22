---
title: Error publishing a container to a specific port
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-07
permalink: docs/troubleshooting/troubleshooting-port-unavailable/
description: Troubleshoot "port is already allocated" or "unable to find a node with port available" errors when running a container
docker-versions:
  - 1.10.1
topics:
  - docker
  - troubleshooting
---

When you try to run a Docker container that is published to a specific port,
as shown in the following example, it does not start and the following error
message is displayed:

```
$ docker run --detach --publish 80:80 nginx
Error response from daemon: unable to find a node with port 80 available
```

This error message indicates that the Docker host already has a container published
to the specified port. To resolve this error, you must either
[remove the container that is using the port](#remove-the-containers-already-using-the-port) or [use another port](#publish-to-an-alternative-port).

Alternatively, if you are using Carina or Docker Swarm, the following error message is displayed:

```
$ docker run --detach --publish 80:80 nginx
Error response from daemon: unable to find a node with port 80 available
```

This error message indicates that every node in the cluster already has a container published
to the specified port. To resolve this error, you must either
[remove the containers that are using the port](#remove-the-containers-already-using-the-port),
[use another port](#publish-to-an-alternative-port), or [add capacity to the cluster](#add-capacity-to-the-cluster).

### Remove the containers already using the port
1. To identify the containers that are using the port, run the following command,
    changing `<port>` to the port number that you want to use.

    ```bash
    $ docker ps -a | grep <port>/tcp
    ```

2. To remove the containers, run the following command for each container identified in step 1,
    changing `<containerId>` to the ID of the container.
    The `--force` argument ensures that the container is removed even if it
    is currently running.

    ```bash
    $ docker rm --force --volumes <containerId>
    ```

You can now run your container using the port number.

### Publish to an alternative port
Use the `--publish` flag to publish the container to an alternative port on the Docker host. For example,
if the container exposes port 80 and you have selected port 8081 as the alternative port,
you would use `--publish 8081:80` when running your Docker container. For example:

```bash
$ docker run --detach --publish 8081:80 nginx
```

### Add capacity to the cluster
If you are using Carina, add nodes to add capacity.

1. Log in to the [Carina control panel](https://app.getcarina.com).
2. Click the gear icon associated with the cluster and select **Edit Cluster**.
3. On the Cluster Details page, click **Add nodes**.
4. Specify the new cluster size and click **Add Nodes**.

Otherwise, you can use Docker Machine to add a node to the Docker Swarm cluster.
See the Docker Machine documentation for additional information about [how to manage
a Docker Swarm with Docker Machine][docker-machine-swarm].

```bash
$ docker-machine create
  --driver <driver> \
  --swarm --swarm-discovery token://<swarmToken> \
  <nodeName>
```

You can now run your container using the port number.

[docker-machine-swarm]: https://docs.docker.com/machine/get-started-cloud/#using-docker-machine-with-docker-swarm
