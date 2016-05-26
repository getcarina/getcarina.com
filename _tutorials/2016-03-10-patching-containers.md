---
title: Patch security vulnerabilities with watchtower
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2016-03-17
permalink: docs/tutorials/patching-security-vulnerabilities/
description: Patching Docker containers against security vulnerabilities and outdated versions
docker-versions:
  - 1.10.2
topics:
  - docker
  - intermediate
---

One of the unique advantages of Docker containers is that they give
developers the ability to tightly scope and lock down application dependencies.
As a result, whenever security vulnerabilities are detected and patches are
released, rolling those changes out is easier because fewer dependencies need
attention.

This tutorial explains how to rebuild Docker images and then redeploy containers
that are running out-of-date images by using a continuous deployment
tool called [watchtower](https://github.com/getcarina/watchtower).

![Watchtower]({% asset_path patching-security-vulnerabilities/watchtower.jpg %})

### Prerequisite

* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)

### Rebuild custom images

If you are using an official Docker image hosted on Docker Hub, you can skip
to the [Redeploy containers section](#redeploy-containers).

When a security vulnerability is detected in a custom image that you are using
for your Docker containers, you need to rebuild the image. Because of the
nature of Docker's UnionFS, you can rebuild images relatively quickly, because
your application's file system is re-layered on top of the updated base layer,
rather than rebuilt from scratch.

To rebuild your image, run the following command:

```bash
$ docker build --pull --tag <dockerhub-user>/<custom-image> .
```

If you are using a private registry, substitute `<dockerhub-user>` for your
registry URL and port; for example, `localhost:5000/wordpress`.

### Push the rebuilt image to a registry

1. Log in to Docker Hub:

    ```bash
    $ docker login
    Username: <dockerhub-user>git
    Password: <dockerhub-password>
    Email: <dockerhub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

1. Push your custom image to your registry of choice:

    ```bash
    $ docker push <dockerhub-user>/<custom-image>
    ```

For more information about how to work with images on Docker Hub, read our
[Use Docker Hub]({{ site.baseurl }}/docs/troubleshooting/run-container-using-custom-image/#use-docker-hub)
 guide.

### Redeploy containers

Whether you are using an official Docker image that has been updated or you
have rebuilt a custom image, you need to redeploy all of the containers that
are using the updated image. Because redeploying images can be an onerous task
and can be performed in many ways, this tutorial describes how to accomplish
this task by using watchtower.

Watchtower automates the continuous deployment of containers. It runs in a
container and continually monitors all of the source images that are used by
containers across Docker hosts. If watchtower detects that a container is
running an out-of-date image, it attempts to gracefully shut it down by
sending it a `SIGTERM` signal. This allows the container to handle remaining
traffic and be retired. A new container is then started, using the same runtime
configuration as its predecessor.

To run watchtower, use the following command:

```bash
$ docker run --detach \
  --name watchtower \
  --volumes-from swarm-data \
  --env DOCKER_HOST=$DOCKER_HOST \
  carina/watchtower \
  --tlsverify \
  --tlscacert=/etc/docker/ca.pem \
  --tlskey=/etc/docker/server-key.pem \
  --tlscert=/etc/docker/server-cert.pem \
  --interval 30
```

This command creates a container named `watchtower` that connects to the Swarm
endpoint by using the TLS certificates made available via the `swarm-data`
container. It polls Docker Hub every 30 seconds. If this is too often or
infrequent, you can adjust this value.

You can monitor updates by viewing the logs:

```bash
$ docker logs watchtower
time="2016-03-16T00:30:31Z" level=info msg="Checking containers for updated images"
time="2016-03-16T00:30:31Z" level=debug msg="Retrieving running containers"
time="2016-03-16T00:30:36Z" level=debug msg="Pulling wordpress:latest for /adoring_roentgen"
time="2016-03-16T00:30:31Z" level=info msg="Stopping /XVlBzgbaiCMRAjWwhTHctcuAxhxKQFDa (532d7b7deb95f64f282b8ec42217f92ffe50ca28319a7e2b540922efc9562864) with SIGTERM"
time="2016-03-16T00:30:31Z" level=debug msg="Removing container 532d7b7deb95f64f282b8ec42217f92ffe50ca28319a7e2b540922efc9562864"
```

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Error running a container using a custom image](https://getcarina.com/docs/troubleshooting/run-container-using-custom-image/)
* [Store private Docker registry images on Rackspace Cloud Files]({{ site.baseurl }}/docs/tutorials/registry-on-cloud-files/)

### Next step

[Back up and restore container data](https://getcarina.com/docs/tutorials/backup-restore-data/)
