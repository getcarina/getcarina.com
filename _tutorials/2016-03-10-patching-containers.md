---
title: Patching security vulnerabilities with Watchtower
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2016-03-01
permalink: docs/tutorials/patching-security-vulnerabilities/
description: Patching Docker containers against security vulnerabilities and outdated versions
docker-versions:
  - 1.10.2
topics:
  - docker
  - intermediate
---

One of the unique advantages of Docker containers is that it gives
developers the ability to tightly scope and lock down application dependencies.
The result being that whenever security vulnerabilities are detected and patches
released, rolling those changes out is easier, since there is a smaller footprint
of dependencies which need attention.

In this tutorial we will cover the basics of how to detect, patch, and redeploy
containers running out-of-date Docker images using a continuous deployment
tool called [Watchtower](https://github.com/getcarina/watchtower).

![Watchtower]({% asset_path patching-security-vulnerabilities/watchtower.jpg %})

### Prerequisite

One or more running containers on a cluster

### Rebuilding custom images

If you are using an official Docker image hosted on Docker Hub, you can go
straight to the [Redeploy Containers](#redeploy-containers).

The next step when using a custom image for your Docker containers is to rebuild
it. Due to the nature of Docker's UnionFS, this can be achieved
relatively quickly, since your application's filesystem will be re-layered on
top of the updated base layer, rather than rebuilt from scratch.

To rebuild your image, you will need to run:

    ```bash
    $ docker build --pull --tag <dockerhub-user>/<custom-image> .
    ```

If you are using a private registry, please remember to substitute the
`<dockerhub-user>` for your registry URL and port;
for example: `localhost:5000/wordpress`.

### Push rebuilt image to a registry

Before pushing, you will need to sign into Docker Hub:

    ```bash
    $ docker login
    Username: <dockerhub-user>git
    Password: <dockerhub-password>
    Email: <dockerhub-email>
    WARNING: login credentials saved in ~/.docker/config.json
    Login Succeeded
    ```

Once this is done, you push your custom image to your registry of choice:

    ```bash
    $ docker push <dockerhub-user>/<custom-image>
    ```

For more information about how to work with images on Docker Hub, please
read our [Using Docker Hub]({{ site.baseurl }}/docs/troubleshooting/run-container-using-custom-image/#use-docker-hub)
 guide.

### Redeploy containers

The final step is to redeploy all the out-of-date containers using the patched
images. Due to the onerous nature of this task, as well as the multitude of
ways it can be done, for the sake of this tutorial we will be using a container
running Watchtower.

Watchtower allows you to automate continuous deployment of containers. It runs
in a container and continually monitors all of the source images which are used
by containers across Docker hosts. If it detects that a
container is running an out-of-date image it will attempt to gracefully shut
it down by sending it a `SIGTERM` signal. This will allow it to handle remaining
traffic and be retired. A new container is then started, using the same
runtime configuration as its predecessor.

To run watchtower:

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

This will create a container named `watchtower` which will connect to the
Swarm endpoint using the TLS certificates made available via the
`swarm-data` container. It will poll Docker Hub every 30 seconds. If this is
too often or infrequent, feel free to adjust this value.

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

### Next

[Back up and restore container data](https://getcarina.com/docs/tutorials/backup-restore-data/)
