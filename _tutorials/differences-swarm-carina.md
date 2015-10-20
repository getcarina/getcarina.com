---
title: Differences between Carina and Docker Swarm
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-30
permalink: docs/tutorials/differences-swarm-carina/
description: Learn the differences between the Carina service and Docker Swarm
docker-versions:
  - 1.8.3
topics:
  - docker
  - docker-swarm
  - beginner
---

Carina provisions Docker Swarm clusters for users to deploy their containers to.
Although these clusters offer much of the native functionality you usually get
with Docker Swarm, there are certain differences between native Docker and Carina
that you should be aware of.

### CLI creation

The usual way you provision a Swarm cluster is via the command-line. You will
usually expect to:

- Generate a discovery token
- Provision the Swarm manager
- Add a set of Swarm nodes with the Swarm agent installed

But with Carina, this is all handled for you, meaning that you skip this
initial set up. Instead, you use the Carina control panel to deploy, manage,
and visualise your clusters.

### Discovery backends

Swarm uses the concept of a discovery backend to keep track of all the hosts
registered on the cluster. There are many different kinds of discovery backends
in use through the Docker ecosystem:

- Hosted Discovery with Docker Hub
- Using static files
- etcd
- zookeeper
- consul

You can even use a static list of IP addresses, or IP ranges, instead. With
Carina, however, the only supported option is Hosted Discovery with Docker Hub.
Each cluster is assigned its own Discovery token ID, and hosts use Docker Hub
for service discovery.

#### Retrieve your Swarm discovery token

To retrieve your discovery token, you can run:

```
docker inspect -f "{{index .Config.Cmd 6}}" $(docker ps -aq -f name=swarm-manager -n 1)
```

This command will inspect the `Cmd` configuration of any container it can find
first named `swarm-manager`. This is because that these manager containers,
when first run, are provided with the unique token ID - so all we are doing here
is retrieving the original command use to provision the manager container.

To list of the Swarm nodes in your cluster, run:

```
swarm list $(docker inspect -f "{{index .Config.Cmd 6}}" $(docker ps -aq -f name=swarm-manager -n 1))
```

See the [installation instruction](https://github.com/docker/swarm#installation-for-swarm-developers)
for information about how to install and use the `swarm` binary.

### Scheduling strategies

The Docker Swarm scheduler can distribute containers to hosts in different ways,
and it allows you to specify them when a manager is provisioned. You do this
by passing the `--strategy` flag to the `swarm manage` command.

With Carina you do not get this option: the `spread` strategy is used (the
  Swarm default).

### AppArmor profiles

Carina builds on the standard restrictions set out by
[libcontainer](https://github.com/opencontainers/runc/blob/master/libcontainer/SPEC.md#security)
by using AppArmor profiles as an additional security layer. Specifically, it:

- denies access to sensitive file paths on the hosts (such as system files and
  mount locations)
- sets up various mount rules for the container filesystem
- restricts the device capabilities of the Docker process

### Privileged and capability run flags

By default, Docker containers cannot access any devices on the host. If, however,
the `--privileged` flag is used with the `docker run` command, it allows the
container to access all of the devices on the host as if it were a normal process.
Due to security concerns, Carina disallows this and forces all containers to run
in unprivileged mode.

In line with Linux conventions, Docker uses capabilities to restrict the behavior
of containers. Operations can override these security rules using the `--cap-add`
and `--cap-drop` flags to add fine grain control. Carina disallows this.

### Volumes

One of the features of Docker containers is the ability to mount directories
from the host machine, but with Carina this is disabled for security.

This means that you cannot use the `--volume` flag when referring to host paths.

### TLS certificates

All TLS certificates for a cluster are made available on each host through the
`swarm-data` container. To access them, you should use `--volumes-from swarm-data`
with the `docker run` command. The certificates will then be available inside the
container in the following paths:

```
/etc/docker/ca.pem
/etc/docker/server-cert.pem
/etc/docker/server-key.pem
```
