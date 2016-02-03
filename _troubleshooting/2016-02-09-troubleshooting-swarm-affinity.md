---
title: Error running a container using a custom image
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-02-09
permalink: docs/troubleshooting/troubleshooting-swarm-affinity/
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

$ docker run --publish 50000:5000 <custom-image>
0588fe5b93707d54b023b7e31f15bd4baa793201427819794d1dea6cbc7f9f70

$ docker run --publish 5000:5000 <custom-image>
Error response from daemon: Error: image library/<custom-image> not found
```

This error message indicates that the container was scheduled on a different segment
than the segment that built the image, and therefore the image could not be found.
To resolve this error, you must either
[use Docker Swarm image affinity scheduling](#use-docker-swarm-image-affinity-scheduling),
[use Docker Hub](#use-docker-hub), [use another public Docker registry](#use-a-public-docker-registry),
or [use a private Docker registry](#use-a-private-docker-registry).

**Note**: By default clusters contain only one segment, so you will only encounter
this error when your cluster has two or more segments.

### Use Docker Swarm image affinity scheduling
Specify `--affinity:image==<custom-image>` when creating or running a container
that uses `<custom-image>`. This instructs Docker Swarm to schedule the new
container on a segment which has your custom image.

```
$ docker build -t <custom-image> .
$ docker run --env affinity:image==<custom-image>
```

**Note**: If you need to run the container on multiple segments,
then a Docker registry is required.

<!-- In future versions of Docker Swarm the image affinity hint won't be necessary, because of
https://github.com/docker/swarm/issues/743. However this article is still
useful because if you need to run on multiple segments
(not just the one the image was built upon) then you will need to use a registry -->

### Use Docker Hub
Docker Hub is the default, official Docker registry. Carina can discover images on
[Docker Hub](https://hub.docker.com/), without requiring any configuration
changes or command-line flags.

1. Create a Docker Hub account.
1. Log in to Docker Hub from the command line. Your credentials will be saved to `~/.docker/config.json`.

    ```
    $ docker login
    Username: <dockerhub-user>
    Password: <dockerhub-password>
    Email: <dockerhub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

1. Build your custom image. Ensure that `<custom-image>` follows the required
    Docker Hub format of `<user>/<repo-name>:<tag>`, such as `myuser/myimage`.

    ```
    docker build --tag <custom-image> .
    ```

1. Push the custom image to Docker Hub.

    ```
    docker push <custom-image>
    ```

1. Run a docker container using the custom image.

    ```
    docker run <custom-image>
    ```

### Use a public Docker registry
You can also use an alternative public Docker registry, such as [quay.io](http://quay.io),
to host your custom image.

1. Create an account on a public Docker registry.

1. Log in to the registry from the command line. Your credentials will be saved to `~/.docker/config.json`.
    Replace `<registry>` with the the registry's domain name, such as `quay.io`.


    ```
    $ docker login <registry>
    Username: <registry-user>
    Password: <registry-password>
    Email: <registry-hub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

1. Build your custom image. Ensure that `<custom-image>` follows the required
    external registry format of `/<registry>/<user>/<repo-name>:<tag>`, such as `quay.io/myuser/myimage`.

    ```
    docker build --tag <custom-image> .
    ```

1. Push the custom image to the registry.

    ```
    docker push <custom-image>
    ```

    Docker uses the image name to determine
    to which registry the image should be pushes. For example, if the image name
    starts with `quay.io`, the image will be pushed to quay.io.

1. Pull the custom image down to every segment in your cluster.

    ```
    docker pull <custom-image>
    ```

1. Run a docker container using the custom image.

    ```
    docker run <custom-image>
    ```

### Use a private Docker registry

1. Follow the [Store private Docker registry images on Rackspace Cloud Files](https://getcarina.com/docs/tutorials/registry-on-cloud-files/)
tutorial to set up a private Docker registry.

1. Log in to the registry from the command line. Your credentials will be saved to `~/.docker/config.json`.
    Replace `<registry-ip>:<registry-port>` with your private registry's IP address and port.


    ```
    $ docker login <registry-ip>:<registry-port>
    Username: <registry-user>
    Password: <registry-password>
    Email: <registry-hub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

    **Note**: You can configure a custom domain with your registry's IP address, and
    run the registry service on port 80. Then you can simplify the login argument
    `<regiery-ip>:<registry-port>` to `<custom-domain>`, such as `example.com`.

1. Build your custom image. Ensure that `<custom-image>` follows the required
    external registry format of `/<registry-ip>:<registry:port>/<repo-name>:<tag>`,
    such as `172.99.73.114:5000/myimage`.

    ```
    docker build --tag <custom-image> .
    ```

    **Note**: If you configured a custom domain for your registry,
    then you can simplify `<custom-image>` to
    `<custom-domain>/<repo-name>:<tag>`, such as `example.com/myimage`.

1. Push the custom image to the registry.

    ```
    docker push <custom-image>
    ```

    Docker uses the image name to determine
    to which registry the image should be pushes. For example, if the image name
    starts with `172.99.73.114:5000`, the image will be pushed to the private registry
    located at that IP address and port.


1. Pull the custom image down to every segment in your cluster.

    ```
    docker pull <custom-image>
    ```

1. Run a docker container using the custom image.

    ```
    docker run <custom-image>
    ```

### Resources

* [Understanding how Carina uses Docker Swarm](https://getcarina.com/docs/concepts/docker-swarm-carina/)
* [Docker best practices: image repository](https://getcarina.com/docs/best-practices/docker-best-practices-image-repository/)
