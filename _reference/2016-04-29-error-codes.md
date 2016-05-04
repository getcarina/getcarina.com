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

You attempted to run a container with a change to its [security configuration](https://docs.docker.com/engine/reference/run/#security-configuration). This is not allowed in Carina due to security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, do not use the `--security-opt` flag.

### CARINA-1001

`Privileged containers not allowed by policy`

You attempted to run a container in privileged mode. This is not allowed in Carina due to security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, do not use the `--privileged` flag.

### CARINA-1002

`Host mount path(s) not allowed by policy`

You attempted to run a container that mounts a volume from a restricted directory of the node using a volume flag of the form `--volume /node/dir:/container/dir` or `-v /node/dir:/container/dir`. This is not allowed in Carina due to security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, see the section on [Volumes]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/#volumes).

[docker-swarm-carina]: {{ site.baseurl }}/docs/concepts/docker-swarm-carina/

### CARINA-1003

`Adding capabilities not allowed by policy`

You attempted to run a container that adds Linux capabilities. This is not allowed in Carina due to security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, do not use the `--cap-add` flag.

### CARINA-1004

`Dropping capabilities not allowed by policy`

You attempted to run a container that drops Linux capabilities. This is not allowed in Carina due to security restrictions, see [Understanding how Carina uses Docker Swarm][docker-swarm-carina]. To resolve this error, do not use the `--cap-drop` flag.
