---
title: Error running a container using a custom image
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-02-09
permalink: docs/troubleshooting/run-container-using-custom-image/
description: Troubleshoot the "image is not found" error when running a container
docker-versions:
  - 1.9.1
topics:
  - docker
  - swarm
  - troubleshooting
---

When you try to run a Docker container using a custom image that you have built,
as shown in the following example, it does not start and the following error
message is displayed:

```
$ docker build --tag <custom-image> .
Successfully built abf38d5a0750

$ docker run --detach --publish 50000:5000 <custom-image>
0588fe5b93707d54b023b7e31f15bd4baa793201427819794d1dea6cbc7f9f70

$ docker run --detach --publish 5000:5000 <custom-image>
Error response from daemon: Error: image library/<custom-image> not found
```

This error message indicates that the container was scheduled on a different segment
than the segment that built the image, and therefore the image could not be found.
To resolve this error, select one of the following options:

* [Use image affinity scheduling with Docker Swarm](#use-image-affinity-scheduling-with-docker-swarm)
* [Use Docker Hub](#use-docker-hub)
* [Use another public Docker registry](#use-a-public-docker-registry)
* [Use a private Docker registry](#use-a-private-docker-registry)

**Note**: This error occurs only after you scale your cluster to two or more segments.

### Use image affinity scheduling with Docker Swarm
When you create or run a container that uses `<custom-image>`,
specify `--env affinity:image==<custom-image>`. This command instructs Docker Swarm
to schedule the new container on a segment that has your custom image.

```
$ docker build -t <custom-image> .
$ docker run --env affinity:image==<custom-image> <custom-image>
```

**Note**: If you need to run the container on multiple segments,
then a Docker registry is required. See the following sections for options.

<!-- In future versions of Docker Swarm the image affinity hint won't be necessary, because of
https://github.com/docker/swarm/issues/743. However this article is still
useful because if you need to run on multiple segments
(not just the one the image was built upon) then you need to use a registry -->

### Use Docker Hub
Docker Hub is the default, official Docker registry. Carina can discover images on
[Docker Hub](https://hub.docker.com/) without requiring any configuration
changes or command-line flags.

1. Create a Docker Hub account.
1. Log in to Docker Hub from the command line. Your credentials are saved to `~/.docker/config.json`.

    ```
    $ docker login
    Username: <dockerhub-user>
    Password: <dockerhub-password>
    Email: <dockerhub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

1. Build your custom image.

    ```
    docker build --tag <dockerhub-user>/<custom-image> .
    ```

1. Push the custom image to Docker Hub.

    ```
    docker push <dockerhub-user>/<custom-image>
    ```

1. _(Optional)_ Pull the custom image down to every segment in your cluster.
    This step is optional because Carina automatically discovers Docker Hub images.

    ```
    $ docker pull <dockerhub-user>/<custom-image>
    c44a-47ff-8f95-3af379443ce4-n3: Pulling <dockerhub-user>/<custom-image>... : downloaded
    c44a-47ff-8f95-3af379443ce4-n2: Pulling <dockerhub-user>/<custom-image>... : downloaded
    c44a-47ff-8f95-3af379443ce4-n1: Pulling <dockerhub-user>/<custom-image>... : downloaded
    ```

    Each segment in the cluster downloads the image from Docker Hub, improving
    the performance of subsequent `run` commands.

1. Run a container using the custom image.

    ```
    docker run <dockerhub-user>/<custom-image>
    ```

### Use a public Docker registry
You can also use an alternative public Docker registry, such as [quay.io](http://quay.io),
to host your custom image.

1. Create an account on a public Docker registry.

1. Log in to the registry from the command line. Your credentials are saved to `~/.docker/config.json`.
    Replace `<registry>` with the registry's domain name, such as `quay.io`.

    ```
    $ docker login <registry>
    Username: <registry-user>
    Password: <registry-password>
    Email: <registry-hub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

1. Build your custom image.

    ```
    docker build --tag <registry>/<registry-user>/<custom-image> .
    ```

1. Push the custom image to the registry.

    ```
    docker push <registry>/<registry-user>/<custom-image>
    ```

    Docker uses the image name to determine to which registry the image should be pushed.
    For example, if the image name is `quay.io/myuser/myimage`, the image is pushed to the quay.io registry.

1. Pull the custom image down to every segment in your cluster.

    ```
    $ docker pull <registry>/<registry-user>/<custom-image>
    c44a-47ff-8f95-3af379443ce4-n3: Pulling <registry>/<registry-user>/<custom-image>... : downloaded
    c44a-47ff-8f95-3af379443ce4-n2: Pulling <registry>/<registry-user>/<custom-image>... : downloaded
    c44a-47ff-8f95-3af379443ce4-n1: Pulling <registry>/<registry-user>/<custom-image>... : downloaded
    ```

    Docker uses the image name to determine from which registry the image should be pulled.
    For example, if the image name is `quay.io/myuser/myrepo`, then each segment
    in the cluster pulls the image from the quay.io registry.

1. Run a container using the custom image.

    ```
    docker run <registry>/<registry-user>/<custom-image>
    ```

### Use a private Docker registry
In some cases, running your own private Docker registry directly on your cluster
might be advantageous, especially when dealing with large images or images that contain sensitive data.

1. Set up a private Docker registry by following the
    [Store private Docker registry images on Rackspace Cloud Files]({{site.baseurl}}/docs/tutorials/registry-on-cloud-files/)
    tutorial.

1. Build your custom image.

    ```
    docker build --tag 127.0.0.1:5000/<registry-user>/<custom-image> .
    ```

1. Push the custom image to your private registry.

    ```
    docker push 127.0.0.1:5000/<registry-user>/<custom-image>
    ```

1. Pull the custom image down to every segment in your cluster.

    ```
    $ docker pull 127.0.0.1:5000/<registry-user>/<custom-image>
    c44a-47ff-8f95-3af379443ce4-n3: Pulling 127.0.0.1:5000/<registry-user>/<custom-image>... : downloaded
    c44a-47ff-8f95-3af379443ce4-n2: Pulling 127.0.0.1:5000/<registry-user>/<custom-image>... : downloaded
    c44a-47ff-8f95-3af379443ce4-n1: Pulling 127.0.0.1:5000/<registry-user>/<custom-image>... : downloaded
    ```

    Docker uses the image name to determine from which registry the image should be pulled.
    For example, if the image name is `127.0.0.1:5000/myuser/myimage`,
    then each segment in the cluster pulls the image from your private registry.

1. Run a container using the custom image.

    ```
    docker run 127.0.0.1:5000/<registry-user>/<custom-image>
    ```

### Resources

* [Understanding how Carina uses Docker Swarm]({{site.baseurl}}/docs/concepts/docker-swarm-carina/)
* [Docker best practices: image repository]({{site.baseurl}}/docs/best-practices/docker-best-practices-image-repository/)
