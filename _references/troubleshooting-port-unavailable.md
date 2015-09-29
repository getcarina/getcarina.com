---
title: Error publishing container to a specific port
permalink: /docs/references/troubleshooting-port-unavailable/
topics:
  - docker
  - troubleshooting
---

When you try to run a Docker container published to a specific port,
as shown in the following example, it does not start and the following error
message is displayed:

```
$ docker run --detach --publish 80:80 nginx
Error response from daemon: Cannot start container 1b48146:  Bind for 0.0.0.0:80 failed: port is already allocated
```

This error indicates that the Docker host already has a container with the
specified port published. To resolve this error, you must either [use another port](#alternate-port)
or [remove the container which is using the port](#remove-container).

Alternatively, if you are using Rackspace Container Service or Docker Swarm, the following error
message is displayed:

```
$ docker run --detach --publish 80:80 nginx
Error response from daemon: unable to find a node with port 80 available
```

This indicates that every node in the cluster already has a container with the
specified port published. To resolve this error, you must either [use another port](#alternate-port),
[remove the container(s) which are using the port](#remove-container), or
[add capacity to the cluster](#grow-cluster).

### <a name="remove-container"></a> Remove container using the port
1. Run the following command, changing **{port}** to the desired port number,
    to identify the container(s) which are using the port.

    ```bash
    docker ps -a | grep {port}/tcp
    ```

2. Repeat the following command for each container identified in step 1,
    changing **{container-id}** to the id of the container, to remove the container.
    The `--force` argument ensures that the container is removed even when it
    is currently running.

    ```bash
    docker rm --force --volumes {container-id}
    ```

You can now run your container using the desired port.

### <a name="alternate-port"></a> Publish to an alternate port
Use the `--publish` flag to publish the container to an alternate port on the Docker host. For example,
if the container exposes port 80 and you have selected port 8081 as the alternate port,
you would use `--publish 8081:80` when running your Docker container.

```bash
docker run --detach --publish 8081:80 nginx
```

### <a name="grow-cluster"></a> Add capacity to the cluster
If you are using Rackspace Container Service, execute the **Grow Cluster** action
on the cluster to add capacity.

![Cluster Action Menu &rarr; Grow Cluster]({% asset_path troubleshooting-port-unavailable/grow-cluster.png %})

Otherwise, you can use Docker Machine to add a node to the Docker Swarm cluster.
See the Docker Machine documentation for additional information on [how to manage
a Docker Swarm with Docker Machine][docker-machine-swarm].

```bash
docker-machine create
    --driver {driver} \
    --swarm --swarm-discovery token://{swarm-token} \
    {node-name}
```

You can now run your container using the desired port.

[docker-machine-swarm]: https://docs.docker.com/machine/get-started-cloud/#using-docker-machine-with-docker-swarm
