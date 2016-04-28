---
title: Carina Error Codes
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-30
permalink: docs/reference/error-codes/
description: Carina Error Codes
docker-versions:
  - 1.10.3
topics:
  - errors
---

### CARINA-1000

`Changing SecurityOpt not allowed by policy`

You attempted to run a container with a change to the SecurityOpt. This is not allowed in Carina because of security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, do not use the `--security-opt` flag.

### CARINA-1001

`Privileged containers not allowed by policy`

You attempted to run a container in privileged mode. This is not allowed in Carina because of security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, do not use the `--privileged` flag.

### CARINA-1002

`Host mount path(s) not allowed by policy`

You attempted to run a container that mounts a volume from the node using a volume flag of the form `--volume /node/dir:/container/dir`. This is not allowed in Carina because of security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, see the section on [Volumes]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/#volumes).

[docker-swarm-carina]: {{ site.baseurl }}/docs/concepts/docker-swarm-carina/
