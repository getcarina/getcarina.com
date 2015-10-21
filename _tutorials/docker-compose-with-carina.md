---
title: Docker Compose with Carina
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-19
permalink: docs/tutorials/docker-compose-with-carina/
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

Managing these components &em; their installation, configuration, and relationships
with one another &em; can be a tedious and onerous task. Normally, you'd have to
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

The first section of this example indicates that the `web` service uses the
`rackerlabs/magento` Docker image hosted on Docker Hub, it binds to port 80, it
links to the `redis` service, and its container's name is `web`.

The `redis` service uses the base `redis` image hosted on Docker Hub, and its
container name is `redis`.

### Limitations

**Note:** For more information about how Docker Swarm works in Carina, see the
[Understanding Docker Swarm in Carina](../differences-swarm-carina) article.

Docker has said that Compose is **not yet production-ready** because
it does not fully integrate with Docker Swarm. Eventually, Docker aims to have
full integration, meaning that you will be able to deploy multicontainer
applications spread over multiple Docker hosts. However, this integration is not
currently in place because of limitations in Docker networking.

If services in your application rely on one another through the `--link` flag,
you must ensure they are provisioned on the same Docker host, since container
linking does not currently work for containers on different hosts. This will
change in the future as Docker networking is revamped. To find out more
information about container linking and steps you can take to mitigate
networking issues, read our
[Connect containers by using the ambassador pattern](../connect-docker-containers-ambassador-pattern/)
and [Connect containers with Docker links](../connect-docker-containers-with-links/)

To ensure that reliant containers can contact eachother, you must use the
`links` keyword in your **docker-compose.yml** file. This will ensure they are
deployed to the same Docker host.

### Resources

- [Overview of Docker Compose](https://docs.docker.com/compose/)
- [docker-compose.yml reference](https://docs.docker.com/compose/yml/)
- [Docker compose environment variable reference](https://docs.docker.com/compose/env/)
