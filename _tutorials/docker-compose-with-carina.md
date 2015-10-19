---
title: Docker Compose with Carina
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/docker-compose-with-carina/
description: Learn how to use Docker Swarm on Carina
docker-versions:
  - 1.8.3
topics:
  - docker
  - beginner
  - docker-compose
---

Docker Compose is a tool for defining and running multi-container applications.
To do this, you define the different components - or microservices - that
compose the application in a single YAML file. You then specify this file
when running the command to launch your application.

### What advantages does it give?

Complicated applications often rely on multiple components in order to work.
A Magento application, for example, can store persistent state in a MySQL
database, cache page requests in Redis, aggregate logs with logstash, and
handle catalog searching with ElasticSearch.

Managing these components - their installation, configuration and relationship
with one another - can be a fiddly and onerous task. Normally, you'd have to
deploy each service manually and set up the container links by yourself. Doing
so may introduce the risk of errors and downtime. But with Docker Compose, you
have a single point of authority which centralizes this logic in a succinct way.

### The docker-compose.yml file

At the heart of Docker Compose is the **docker-compose.yml** file. Each
container, or _service_, is represented in its own YAML section, like so:
```
web:
  # define here...
redis:
  # define here...
```

In each YAML section, you define the characteristics of your service and how it
will operate:

```
web:
  image: rackerlabs/magento
  ports:
    - "80:80"
  links:
    - redis
  container_name: web
redis:
  image: redis
  container_name: redis
```

In the first section, we indicate that the `web` service uses the `rackerlabs/magento`
Docker image hosted on Docker Hub, it binds to port 80, it links to the `redis`
service, and its container's name is `web`.

The `redis` service uses the base `redis` image hosted on Docker Hub, and its
container name is `redis`.

### Limitations

Docker have officially said that Compose is **not yet production-ready** because
it does not fully integrate with Docker Swarm yet. Eventually they aim to have
full integration - meaning that you will be able to deploy multi-container
applications spread over multiple hosts - but this is not currently the case
due to limitations in Docker networking.

If services in your application rely on one another through container linking,
you must ensure they are provisioned on the same Swarm host, since linking
does not currently work for containers on different hosts. This will change
in the future as Docker networking is revamped.

To ensure that reliant containers can contact eachother, you must use the
`links` keyword in your **docker-compose.yml** file. This will ensure they are
deployed to the same host.
