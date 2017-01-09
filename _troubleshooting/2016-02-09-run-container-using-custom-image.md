---
title: Error running a container using a custom image
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-01-09
permalink: docs/troubleshooting/run-container-using-custom-image/
description: Troubleshoot the "image is not found" or ErrImagePull error when running a container
docker-versions:
  - 1.11.2
topics:
  - docker
  - kubernetes
  - swarm
  - troubleshooting
---

When you try to run a container using a custom image that you have built,
as shown in the following examples, it does not start and one of the following error
messages is displayed:

**Docker Swarm**

This error message indicates that the container was scheduled on a different node
than the node that built the image, and therefore the image could not be found.
This error occurs only after you scale your cluster to two or more nodes.

```
$ docker build --tag <custom-image> .
Successfully built abf38d5a0750

$ docker run --detach --publish 50000:5000 <custom-image>
0588fe5b93707d54b023b7e31f15bd4baa793201427819794d1dea6cbc7f9f70

$ docker run --detach --publish 5000:5000 <custom-image>
Error response from daemon: Error: unable to find a node that satisfies image==<custom-image>
```

**Kubernetes**

This error message indicates that Kubernetes failed to pull the image.
It can be caused by running an unpublished image on multi-node cluster, or
the image pull policy is not specified when the image tag is `latest`.

```
$ docker build --tag <custom-image> .
Successfully built abf38d5a0750

$ kubectl run mydeploy --labels name=mydeploy --image <custom-image>
deployment mydeploy created

$ kubectl describe pod -l name=mydeploy
Name:        mydeploy-3232079581-ojxkk
Namespace:   default
Node:        10.223.64.94/10.223.64.94
Start Time:  Mon, 09 Jan 2017 10:34:11 -0600
Labels:      name=mydeploy
             pod-template-hash=3232079581
Status:      Pending
IP:          172.20.25.4
Controllers: ReplicaSet/mydeploy-3232079581
Containers:
  mydeploy:
    Container ID:
    Image:        <custom-image>
    Image ID:
    Port:
    State:        Waiting
      Reason:     ErrImagePull
    Ready:        False
```

To resolve this error, select one of the following options:

* [Specify the Kubernetes image pull policy](#specify-the-kubernetes-image-pull-policy)
* [Use Docker Hub](#use-docker-hub)
* [Use another public Docker registry](#use-a-public-docker-registry)
* [Use a private Docker registry](#use-a-private-docker-registry)

### Specify the Kubernetes image pull policy

If this error occurs on a single-node Kubernetes cluster, and the image tag is `latest` or
is omitted, then [specify the image pull policy]({{site.baseurl}}/docs/tutorials/run-a-custom-image-on-kubernetes/#image-pull-policy).

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

1. Run a container using the custom image.

    **Docker Swarm**

    ```
    docker run <dockerhub-user>/<custom-image>
    ```

    **Kubernetes**

    ```
    kubectl run <deploy-name> --image <dockerhub-user>/<custom-image>
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

1. Run a container using the custom image.

    **Docker Swarm**

    ```
    docker run <registry>/<registry-user>/<custom-image>
    ```

    **Kubernetes**

    ```
    kubectl run <deploy-name> --image <registry>/<registry-user>/<custom-image>
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

1. Run a container using the custom image.

    ```
    docker run 127.0.0.1:5000/<registry-user>/<custom-image>
    ```

### Resources

* [Run a custom Docker image on Kubernetes]({{site.baseurl}}/docs/tutorials/run-a-custom-image-on-kubernetes/)
* [Understanding how Carina uses Docker Swarm]({{site.baseurl}}/docs/concepts/docker-swarm-carina/)
* [Docker best practices: image repository]({{site.baseurl}}/docs/best-practices/docker-best-practices-image-repository/)
