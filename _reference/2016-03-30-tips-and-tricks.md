---
title: Tips and tricks
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-30
permalink: docs/reference/tips-and-tricks/
description: Tips and tricks for working with Carina
docker-versions:
  - 1.10.2
topics:
  - tips
---

A collection of tips and tricks for working with Docker Swarm on Carina.

### Alias to check your Docker environment.

```
$ alias de='env | grep DOCKER | sort'
$ de
DOCKER_CERT_PATH=/Users/octopus/.carina/clusters/octopus/dev
DOCKER_HOST=tcp://xxx.xxx.xxx.xxx:2376
DOCKER_TLS_VERIFY=1
DOCKER_VERSION=1.10.2
```

### Unset all Docker environment variables.

```
$ unset ${!DOCKER_*}
```
