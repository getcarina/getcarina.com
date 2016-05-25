---
title: Use Redis on Carina
author: Bill Anderson <bill.anderson@rackspace.com>
date: 2015-10-25
permalink: docs/tutorials/data-stores-redis/
description: Learn how to use Redis on Carina
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
  - data-stores
  - redis
---

This tutorial describes using Redis on Carina so you can store data in a container.

### Prerequisites

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### A primer on Redis security

Redis is intended and designed to run on a isolated network. As a result it does not have certain features you might expect, such as SSL or a user system. Redis uses a single password or token to provide minimal authenticated access. As there are no users there are no permissions other than what you have access or what you do not. Best practice is to always run Redis on an overlay network and use a password, which you can set either in the config file or via the command line.

Running Redis over SSL requires running a proxy service such as Nginx or Stunnel. It also requires you to use a client library that has added SSL support. Running a Redis container with an SSL proxy means writing your own Dockerfile to add an additional service as well as your generated SSL certificates. How to do that is out of scope for this tutorial.

A final, if somewhat more drastic, step you can take is to rename certain commands such as `CONFIG`. This is, at its core, "security through obscurity" but in a plain-text protocol with minimal authentication support it is an option to consider. Note that tools such as Sentinel and the Jedis client library for Java do not work well with renaming commands. For more information about security and Redis read the [Redis Security](http://redis.io/topics/security) article.

### Create a network

Use the `docker network create` command to create an overlay network.

```bash
$ docker network create mynetwork
501e123b2904757fe9fe23cb60e64191f3764c6d42e188cb3ba7ad30d845f84b
```

The output of this command is the network ID.

### Run a Redis instance

Run a Redis instance to store your application data.

1. Run a Redis instance in a container from an official image using a
   password via the command line.

    ```bash
    $ docker run --detach --name redis --net mynetwork -m 1G redis \
	    redis-server --requirepass mysecretpassword --maxmemory 800M
    859cdc810b3a193842b16466d5a0620fa4002c1205ac4d2aecd5d0a116162331
    ```

    The output of the `docker run` command is the Redis container's ID. The `-m 1G` option specifies a reserved memory of one gigabyte. With Redis all data is in memory, so reserve some memory for the container and follow it up with a `maxmemory` setting to limit Redis' data memory allocation. In this case 800 MB was specified as the `maxmemory` value for Redis to provide 800 MB of data and client buffer space, and 200 MB for Redis persistence requirements.

    Note: Although you can change the password via the API, restarting the container resets it to the password specified on the command line. If you want to manage the password via the API, you can choose to not set a password at the command line and then *immediately* set one via the API.

1. View the status of the container by using the `--latest` parameter.

    ```bash
    $ docker ps --latest
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    859cdc810b3a        redis               "/entrypoint.sh redis"   6 minutes ago       Up 6 minutes        6379/tcp            fc6b9aa0-87fc-41b8-a421-21d1bb8469f0-n2/redis
    ```

    The output of this `docker ps` command is your running Redis container.

    The status of the container should begin with Up. If it doesn't, see the [Troubleshooting](#troubleshooting) section at the end of the tutorial.

1. Testing the connection

    ```bash
    $ docker run --rm -it --net mynetwork redis redis-cli -h redis -a mysecretpassword
    redis:6379>
    ```

    Type in `PING`. You should see `PONG` come back. You should now have a functional Redis server requiring authentication.

1.  Set and get a key.

    ```bash
    $ docker run --rm --net mynetwork redis redis-cli -h redis -a mysecretpassword set redis:on:carina true
    OK
    $ docker run --rm --net mynetwork redis redis-cli -h redis -a mysecretpassword get redis:on:carina
    true
    ```

### Troubleshooting

If the status of the container does not begin with `Up`, check Redis' log output. The Redis official container logs to `stdout` by default. We can see those logs using the `docker logs` command.

```bash
$ docker logs $REDCON
```

This command will tell you why Redis failed to start as well as other information such as whether THP support is enabled and any warnings about the kernel's overcommit_memory settings.

See [Troubleshooting common problems]({{ site.baseurl }}/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Redis Quick Start](http://redis.io/topics/quickstart)
* [Redis Security](http://redis.io/topics/security)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)

### Next steps

Learn how to [back up and restore container data]({{ site.baseurl }}/docs/tutorials/backup-restore-data/), and [schedule tasks with a cron container]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/)

If you want to store your data in a data volume container, read [Use data volume containers]({{ site.baseurl }}/docs/tutorials/data-volume-containers/).

If Redis isn't the data store for you, read [Use MongoDB on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb/).
