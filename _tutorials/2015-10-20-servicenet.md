---
title: Communicate between containers over the ServiceNet internal network
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-20
permalink: docs/tutorials/servicenet/
description: Learn how containers can communicate over the ServiceNet internal network
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
  - networking
---

This tutorial describes using the internal network ServiceNet with Carina so that containers will only communicate only by using the internal network.

**Note**: We strongly recommend using an overlay network instead of exposing containers on ServiceNet anytime you need two or more containers to communicate. For instructions, see [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/).

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/) with two or more nodes.

### PublicNet and ServiceNet

Carina network traffic runs over two networks, PublicNet and ServiceNet.

PublicNet connects nodes to the public Internet. When you create a node, it gets an IPv4 and IPv6 address from PublicNet by default. This is the address that the node uses to communicate with the public Internet.

ServiceNet connects nodes to the internal, multi-tenant network within Carina. When you create a node, it gets only an IPv4 address from ServiceNet by default. This is the address that the node can use to communicate with other nodes in Carina.

When containers are run with default flags, they are exposed on both PublicNet and ServiceNet. That means your containers are accessible from the public Internet and the internal, multi-tenant network within Carina by default.

The following sections demonstrate this default behavior and how to expose containers only through ServiceNet.

### Run a Redis container exposed on both PublicNet and ServiceNet

Run a Redis container to see how containers are accessible by default.

**Note**: Redis is used only as an example service here. Redis is designed to be accessed by trusted clients inside trusted environments. This means that normally you don’t want to expose the Redis instance directly to the Internet or, in general, to an environment where untrusted clients can directly access the Redis TCP port or UNIX socket. Do not run Redis anywhere (Carina or elsewhere) without adhering to all proper [Redis Security](http://redis.io/topics/security) procedures.

1. Run a Redis instance in a container from an official image.

    ```bash
    $ docker run --detach --name redis --publish 6379:6379 redis
    e2760c095744d36e3917ad2a78bb58a55f5bfd21d1bee7e64613af1d3d0a3229

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
    e2760c095744        redis               "/entrypoint.sh redis"   4 minutes ago       Up 4 minutes        104.130.22.225:6379->6379/tcp   3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2/redis
    ```

    In the output of the `docker ps` command, the PORTS column shows that the container is listening on the public IP address 104.130.22.225 on port 6379 of PublicNet. This means that your containerized Redis instance is exposed to the public Internet which might not be what you want.

    The output of the `docker ps` command doesn't report the internal IP address of ServiceNet, but you'll see how to find that in a later section.

1. Remove the Redis instance

    ```bash
    $ docker rm -f redis
    redis
    ```

### Run a Redis container exposed only on ServiceNet

If you don't want your container to be exposed to the public Internet, you need to specify the internal IP address of a node by using the `--publish ip:hostPort:containerPort` flag when you execute a `docker run` command. Because that flag requires a specific IP address, you first have to choose which node you want the container to run on, and then discover the internal IP address of that node.

1. View your cluster information.

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

1. Choose a node (one of the nodes) from the output of `docker info`. Although any node (node) will work, you could choose the one with the fewest running containers. In the preceding output, that would be `3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2`.

1. Get the internal IP address of the node using the `racknet/ip` Docker utility image.

    ```bash
    $ docker run --rm \
      --net=host \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2 \
      racknet/ip \
      service ipv4
    10.176.225.205
    ```

    The output of this command is the internal IP address of the node on which you want to run a Redis container exposed only on ServiceNet. For example, `10.176.225.205`. For more information about the `racknet/ip` Docker utility image, see the [Discover PublicNet and ServiceNet IP addresses](#discover-publicnet-and-servicenet-ip-addresses) section.

1. Run a Redis container that is exposed only on ServiceNet

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

    In the output of the `docker ps` command, the PORTS column shows that the container is listening on the internal IP address 10.176.225.205 on port 6379 of ServiceNet. You know it's an internal IP address because it's in the 10.0.0.0/8 address range. This means that your containerized Redis instance is exposed only to the internal, multi-tenant network within Carina. Your other containers can communicate with this Redis instance at this internal IP address and port.

### Communicate with a Redis container exposed only on ServiceNet

1. Export the necessary environment variables for your application.

    ```bash
    $ export REDIS_HOST=$(docker port $(docker ps --quiet --filter name=redis) 6379 | cut -f 1 -d ':')
    $ export REDIS_PORT=6379
    ```

1. Run a Guestbook web application and connect it to your Redis instance.

    ```bash
    $ docker run --detach \
      --env REDIS_HOST=$REDIS_HOST \
      --env REDIS_PORT=$REDIS_PORT \
      --publish 5000:5000 \
      carinamarina/guestbook-redis
    ebae15446fe4e1e24b7978d77c19015109c125ccbe9cc47db7497e61f01834f7
    ```

    The output of this `docker run` command is your running application container ID.

1. Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

    ```bash
    $ echo http://$(docker port $(docker ps --quiet --latest) 5000)
    http://104.130.0.88:5000
    ```

    The output of this `docker port` command is the IP address and port that the application is using.

1. Have `\o/` and `¯\_(ツ)_/¯` sign your Redis Guestbook.


1. _(Optional)_ Remove the containers

    ```bash
    $ docker rm --force $(docker ps --quiet -n=-2)
    a84ed5c6a123
    ebae15446fe4
    ```

    The output of this `docker rm` command shows the shortened IDs of the Redis and application containers that you removed.

    When the Redis container is gone, so is your data.

### Discover PublicNet and ServiceNet IP addresses

The `racknet/ip` Docker utility image is an image you can use to discover the PublicNet and ServiceNet IP addresses of your nodes.

For more information about specifying a constraint, see [Scheduling constraints]({{ site.baseurl }}/docs/concepts/introduction-docker-swarm/#scheduling-constraints).

1. View the public IP address of a node (node). You use the `--env` flag to specify a constraint that this container should be scheduled to a specific node (node).

    ```bash
    $ docker run --rm \
      --net=host \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n2 \
      racknet/ip \
      public ipv4
    104.130.22.225
    ```

    The output of this command is the public IP address of the node on which you want to communicate with a container exposed on PublicNet.

1. View the internal IP address of a node (node). You use the `--env` flag to specify a constraint that this container should be scheduled to a specific node (node).

    ```bash
    $ docker run --rm \
      --net=host \
      --env constraint:node==3947b48f-7b6b-409b-8a49-a9d71672a0d4-n1 \
      racknet/ip \
      service ipv4
    10.176.224.86
    ```

    The output of this command is the internal IP address of a node on which you want to communicate with a container exposed on ServiceNet.

1. View the help information for the `racknet/ip` Docker utility image.

    ```bash
    $ docker run --rm --net=host racknet/ip --help
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

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Redis Security](http://redis.io/topics/security)
* [A few things about Redis security](http://antirez.com/news/96)
* [racknet/ip Docker image](https://hub.docker.com/r/racknet/ip/)
* [Scheduling constraints]({{ site.baseurl }}/docs/concepts/introduction-docker-swarm/#scheduling-constraints)

### Next step

To isolate your services from PublicNet and ServiceNet and increase your security by reducing your attack surface, read [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks).
