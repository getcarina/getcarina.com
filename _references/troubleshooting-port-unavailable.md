---
title: Error publishing container to a specific port
permalink: docs/references/troubleshooting-port-unavailable/
topics:
  - docker
  - troubleshooting
---

When you try to run a Docker container that is published to a specific port,
as shown in the following example, it does not start and the following error
message is displayed:

```
$ docker run --detach --publish 80:80 nginx
Error response from daemon: Cannot start container 1b48146:  Bind for 0.0.0.0:80 failed: port is already allocated
```

This error message indicates that the Docker host already has a container published
to the specified port. To resolve this error, you must either
[remove the container that is using the port](#remove-container) or [use another port](#alternate-port).

Alternatively, if you are using Rackspace Container Service or Docker Swarm, the following error
message is displayed:

```
$ docker run --detach --publish 80:80 nginx
Error response from daemon: unable to find a node with port 80 available
```

This error message indicates that every node in the cluster already has a container published
to the specified port. To resolve this error, you must either
[remove the container(s) that are using the port](#remove-container),
[use another port](#alternate-port), or [add capacity to the cluster](#grow-cluster).

### <a name="remove-container"></a> Remove the containers already using the port
1. To identify the containers that are using the port, run the following command,
    changing `<port>` to the port number that you want to use.

    ```bash
    docker ps -a | grep <port>/tcp
    ```

2. To remove the containers, run the following command for each container identified in step 1,
    changing `<containerId>` to the ID of the container.
    The `--force` argument ensures that the container is removed even if it
    is currently running.

    ```bash
    docker rm --force --volumes <containerId>
    ```

You can now run your container using the port number.

### <a name="alternate-port"></a> Publish to an alternative port
Use the `--publish` flag to publish the container to an alternative port on the Docker host. For example,
if the container exposes port 80 and you have selected port 8081 as the alternative port,
you would use `--publish 8081:80` when running your Docker container. For example:

```bash
docker run --detach --publish 8081:80 nginx
```

### <a name="grow-cluster"></a> Add capacity to the cluster
If you are using Rackspace Container Service, execute the **Grow Cluster** action
on the cluster to add capacity.

1. Log in to the control panel at [https://mycluster.rackspacecloud.com](https://mycluster.rackspacecloud.com).
2. Click the gear icon next to the cluster and select **Grow Cluster**.

    ![Cluster Action Menu &rarr; Grow Cluster]({% asset_path troubleshooting-port-unavailable/grow-cluster.png %})

Otherwise, you can use Docker Machine to add a node to the Docker Swarm cluster.
See the Docker Machine documentation for additional information about [how to manage
a Docker Swarm with Docker Machine][docker-machine-swarm].

```bash
docker-machine create
    --driver <driver> \
    --swarm --swarm-discovery token://<swarmToken> \
    <nodeName>
```

You can now run your container using the port number.

[docker-machine-swarm]: https://docs.docker.com/machine/get-started-cloud/#using-docker-machine-with-docker-swarm
