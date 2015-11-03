---
title: Communication between containers over the internal network ServiceNet
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-11-03
permalink: docs/tutorials/servicenet/
description: Learn how containers can communicate over the internal network ServiceNet.
docker-versions:
  - 1.8.3
topics:
  - docker
  - intermediate
  - networking
---

This tutorial describes using the internal network ServiceNet on Carina so that containers will only communicate using the internal network.

### Prerequisite

[Create and connect to a cluster](/docs/tutorials/create-connect-cluster/) with two or more segments.

### PublicNet and ServiceNet

Carina network traffic runs over PublicNet and ServiceNet.

PublicNet connects segments to the public Internet. When you create a segment, it gets an IPv4 and IPv6 address from PublicNet by default. This is the address that the segment uses to communicate with the public Internet.

ServiceNet connects segments to the internal, multi-tenant network within Carina. When you create a segment, it only gets an IPv4 address from ServiceNet by default. This is the address that the segment can use to communicate with other segments in Carina.

When containers are run with default flags, they will be exposed on both PublicNet and ServiceNet. That means your containers are accessible from the public Internet and the internal, multi-tenant network within Carina by default.

### Run a Redis container exposed on both PublicNet and ServiceNet

Run a Redis container to see how it's accessible by default.

1. Run a Redis instance in a container from an official image.

    ```bash
    $ docker run --detach --name redis --publish 6379:6379 redis
    e2760c095744d36e3917ad2a78bb58a55f5bfd21d1bee7e64613af1d3d0a3229

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
    e2760c095744        redis               "/entrypoint.sh redis"   4 minutes ago       Up 4 minutes        104.130.22.225:6379->6379/tcp   3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2/redis
    ```

    In the output of the `docker ps` command under the PORTS column, we can see that the container is listening on the public IP address 104.130.22.225 on port 6379 of PublicNet. This means that your containerized Redis instance is exposed to the public Internet which may not be what you want.

    The output of the `docker ps` command doesn't report the internal IP address of ServiceNet but you'll see how to do that in a later step.

1. Remove the Redis instance

    ```bash
    $ docker rm -f redis
    redis
    ```

### Run a Redis container exposed only on ServiceNet

If you don't want your container to be exposed to the public Internet, you need to specify the internal IP address of a segment when doing a `docker run` using the `--publish ip:hostPort:containerPort` flag. But because that flag requires a specific IP address, you first have to choose which segment you want the container to run on, and then discover the internal IP address of that segment.

1. View your cluster info

    ```bash
    $ docker info
    Containers: 3
    Images: 12
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 2
     3947b48f-7b6b-409b-8a49-a9d71672a0d4-n1: 104.130.0.88:42376
      └ Containers: 2
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 4.2 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
     3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2: 104.130.22.225:42376
      └ Containers: 1
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 4.2 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    CPUs: 24
    Total Memory: 8.4 GiB
    Name: f11f822500bb
    ```

    Choose a segment (one of the nodes) from the output of `docker info`. Any segment (node) will do. Perhaps choose the one with the least running containers. For example, `3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2`.

1. Get the internal IP address of the segment using the `racknet/ip` Docker utility image.

    ```bash
    $ docker run --net=host \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2 \
      racknet/ip \
      service ipv4
    10.176.225.205
    ```

    The output of this command is the internal IP address of the segment where you want to run a Redis container exposed only on ServiceNet. There's more information on the `racknet/ip` Docker utility image in the [Discover PublicNet and ServiceNet IP addresses](#discover-publicnet-and-servicenet-ip-addresses) section.

1. Run a Redis container exposed only on ServiceNet

    ```bash
    $ docker run --detach \
      --name redis \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2 \
      --publish 10.176.225.205:6379:6379 \
      redis
    a84ed5c6a1234e1bdd5e42a85eed82c0fb73619ba40bc23b3d7abce90b2eac95

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
    a84ed5c6a123        redis               "/entrypoint.sh redis"   5 seconds ago       Up 5 seconds        10.176.225.205:6379->6379/tcp   3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2/redis
    ```

    In the output of the `docker ps` command under the PORTS column, we can see that the container is listening on the internal IP address 10.176.225.205 on port 6379 of ServiceNet. This means that your containerized Redis instance is only exposed to the the internal, multi-tenant network within Carina. Your other containers will be able to communicate with this Redis instance at this internal IP address and port.

### Communicate with a Redis container exposed only on ServiceNet

TODO

### Discover PublicNet and ServiceNet IP addresses

The `racknet/ip` Docker utility image is an image you can use to discover the PublicNet and ServiceNet IP addresses of your segments.

1. View the public IP address of a segment (node). You use the `--env` flag to specify a constraint (see [Scheduling constraints](/docs/tutorials/introduction-docker-swarm/#scheduling-constraints)) that this container should scheduled to a specific segment (node).

    ```bash
    $ docker run --net=host \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2 \
      racknet/ip \
      public ipv4
    104.130.22.225
    ```

    The output of this command is the public IP address of a segment where you want to communicate with a container exposed on PublicNet.

1. View the internal IP address of a segment (node). You use the `--env` flag to specify a constraint (see [Scheduling constraints](/docs/tutorials/introduction-docker-swarm/#scheduling-constraints)) that this container should scheduled to a specific segment (node).

    ```bash
    $ docker run --net=host \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n1 \
      racknet/ip \
      service ipv4
    10.176.224.86
    ```

    The output of this command is the internal IP address of a segment where you want to communicate with a container exposed on ServiceNet.

1. View the help information for the `racknet/ip` Docker utility image.

```bash
$ docker run --net=host racknet/ip --help
racknet public [ipv4|ipv6]
racknet service [ipv4|ipv6]

Examples:
          $ racknet public
          104.130.0.127

          $ racknet service ipv6
          fe80::be76:4eff:fe20:b452

Examples when run with Docker:
          $ docker run --net=host racknet/ip public
          104.130.0.127
```

### Troubleshooting

See [Troubleshooting common problems](/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [racknet/ip Docker image](https://hub.docker.com/r/racknet/ip/)
* [Scheduling constraints](/docs/tutorials/introduction-docker-swarm/#scheduling-constraints)

### Next

[Docker networking basics](/docs/tutorials/docker-networking-basics/)
