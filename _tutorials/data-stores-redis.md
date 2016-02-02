---
title: Use Redis on Carina
author: Bill Anderson <bill.anderson@rackspace.com>
date: 2016-01-04
permalink: docs/tutorials/data-stores-redis/
description: Learn how to use Redis on Carina
docker-versions:
  - 1.9.0
topics:
  - docker
  - intermediate
  - data-stores
  - redis
---

This tutorial describes using Redis on Carina so you can store data in a container.

### Prerequisites

[Create and connect to a cluster](/docs/tutorials/create-connect-cluster/)


### A primer on Redis security

Redis is intended and designed to run on a secure intranet. As a result it does
not have certain features you might expect, such as SSL or a User system. Redis
uses a single password or token to provide minimal authenticated access. As
there are no users there are no permissions other than you have access
or you do not. Best practice is to always use a password, which you can
set either in the config file or via the command line.

Running Redis over SSL requires running a proxy service such as Nginx or Stunnel. It
also requires you to use a client library that has added SSL support.
Running a Redis container with an SSL proxy means writing your own
Dockerfile to add an additional service as well as your generated SSL
certificates. How to do that is out of scope for this tutorial.

A final, if somewhat more drastic, step you can take is to rename certain
commands such as `CONFIG`. This is, at its core, "security through obscurity" but
in a plain-text protocol with minimal authentication support it is an option to
consider. Note that tools such as Sentinel and the Jedis client library for
Java do not work well with renaming commands. For more information about
security and Redis read the [Redis Security
](http://redis.io/topics/security) article.

### Run a Redis instance

Run a Redis instance to store your application data.


1. Run a Redis instance in a container from an official image using a
   password via the command line.

    ```bash
    $ docker run --detach --publish-all -m 1G redis \
	  redis-server --requirepass mysecretpassword \
	  --maxmemory 800M
    ```

    The output of the `docker run` command is the Redis container's ID.
    The `-m 1G` option specifies a reserved memory of one gigabyte. With Redis all data
    is in memory, so reserve some memory for the container and
    folow it up with a `maxmemory` setting to limit Redis' data memory
    allocation. In this case 800 MB was specified as the `maxmemory` value for Redis
    to provide 800 MB of data and client buffer space, and 200 MB for Redis persistence
    requirements.

    Note: Although you can change the password via the API, restarting the
    container resets it to the password specified on the command line. If
    you want to manage the password via the API, you can choose to not set a password
    at the command line and then *immediately* set one via the API.

1. View the status of the container by using the `--latest` parameter.

    ```bash
    $ docker ps --latest
    CONTAINER ID        IMAGE               COMMAND CREATED             STATUS              PORTS NAMES
    559d211c4cb1        redis               "/entrypoint.sh redis"   16 seconds ago      Up 6 seconds        172.99.78.231:32768->6379/tcp 7ffed4c5-fdcb-473d-8740-f133804b39a4-n1/amazing_mayer
    ```

    The output of this `docker ps` command is your running Redis container.

    The status of the container should begin with Up. If it doesn't, see
    the [Troubleshooting](#troubleshooting) section at the end of the
    tutorial.

1. View the ID of the container by using the `--quiet` parameter, store
   it in an environment variable for later use.

    ```bash
    $ REDCON=$(docker ps --quiet --latest)
    $ echo $REDCON
    54182185355c
    ```

    The output of the `docker ps` command is the shortened ID of the
	Redis container. This output was stored in the `REDCON` environment
	variable and displayed using the `echo` command.

1. Discover the IP address and port on which Redis is running by combining the `docker port` command, the ID of the container, and the default Redis port of 6379.

    ```bash
    $ docker port $REDCON 6379
    172.99.78.231:32769
    ```

    For the containerized Redis service you don't need to keep track of
	its name, IP address, or port.  Instead, you discover this information
	dynamically with the preceding command and use it later in the tutorial to
	connect to Redis.


1. To make using `redis-cli` easier, create a few more environment variables. Use `REDIS_HOST` for the IP address and `REDIS_PORT` for the TCP port.

    ```bash
    $ REDIS_HOST=$(docker inspect --format {% raw %}'{{ (index (index .NetworkSettings.Ports "6379/tcp") 0).HostIp }}'{% endraw %} $REDCON)
    $ REDIS_PORT=$(docker inspect --format {% raw %}'{{ (index (index .NetworkSettings.Ports "6379/tcp") 0).HostPort }}'{% endraw %} $REDCON)
    $ echo $REDIS_HOST:$REDIS_PORT
    ```

1. Testing the connection


    ```bash
    $ docker run --rm redis redis-cli -h $REDIS_HOST -p $REDIS_PORT -a mysecretpassword
    172.99.78.231:32769>
    ```

    Type in `PING`. You should see `PONG` come back. You should
    now have a functional Redis server requiring authentication.

1.  Set and get a key.

    ```bash
    $ docker run --rm redis redis-cli -h 172.99.78.231 -p 32769 -a mysecretpassword set redis:on:carina true
    OK
    $ docker run --rm redis-cli -h 172.99.78.231 -p 32769 -a mysecretpassword get redis:on:carina
    "true"
    ```

### Troubleshooting

If the status of the container does not begin with `Up`, check Redis' log
output. The Redis official container logs to `stdout` by default. We can see
those logs using the `docker logs` command.

```bash
$ docker logs $REDCON
```

This command will tell you why Redis failed to start as well as other
information such as whether THP support is enabled and any warnings about the
kernel's overcommit_memory settings.

See [Troubleshooting common problems](/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Redis Quick Start](http://redis.io/topics/quickstart)
* [Redis Security](http://redis.io/topics/security)

### Next steps

If you want Redis to listen only on the internal, multi-tenant network within
Carina, read [Communicate between containers over the ServiceNet internal
network](/docs/tutorials/servicenet/).

If Redis isn't the data store for you, read [Use MongoDB on
Carina](/docs/tutorials/data-stores-mongodb/).
