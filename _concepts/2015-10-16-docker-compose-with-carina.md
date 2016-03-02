---
title: Docker Compose with Carina
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-16
permalink: docs/concepts/docker-compose-with-carina/
description: Learn how to use Docker Compose with Carina
docker-versions:
  - 1.8.3
topics:
  - docker
  - beginner
  - docker-compose
---

Docker Compose is a tool that you can use to define and run multicontainer
applications. To use it, you define the different components, or services, that
compose the application in a single YAML file. You then specify this file as a
command-line argument when running the command to launch your application.

### What advantages does it give?

Complicated applications often rely on multiple components to work.
A Magento application, for example, can store persistent state in a MySQL
database, cache page requests in Redis, aggregate logs with Logstash, and
handle catalog searching with Elasticsearch.

Managing these components&mdash;their installation, configuration, and relationships
with one another&mdash;can be a tedious and onerous task. Normally, you'd have to
deploy each service manually and set up the container links by yourself. Doing
so could introduce the risk of errors and downtime. But with Docker Compose, you
have a single point of authority that centralizes this logic in a succinct way.

### The docker-compose.yml file

Central to Docker Compose is the **docker-compose.yml** file. Each
container, or _service_, is represented in its own YAML section, like so:

```yaml
web:
  # define here...
redis:
  # define here...
```

In each YAML section, you define the characteristics of your service and how it
will operate:

```yaml
version: '2'
services:
  web:
    image: rackerlabs/magento
    ports:
      - "80:80"
    container_name: web
  redis:
    image: redis
    container_name: redis
```

The first section of this example indicates that the `web` service uses the
`rackerlabs/magento` Docker image hosted on Docker Hub, it binds to port 80,
and its container's name is `web`.

The `redis` service uses the base `redis` image hosted on Docker Hub, and its
container name is `redis`.

### Limitations

Integration between Docker Swarm and Compose is still in the experimental phase,
but if you want to understand more about how they work together, see the
[Integration Guide](https://docs.docker.com/compose/swarm/). This guide also
describes limitations in networking, scheduling, and dependencies.

### Resources

- [Overview of Docker Compose](https://docs.docker.com/compose/)
- [docker-compose.yml reference](https://docs.docker.com/compose/yml/)
- [Docker Compose and Swarm integration](https://docs.docker.com/compose/swarm/)
