---
title: Understanding how Carina uses Docker Swarm
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/docker-swarm-carina/
description: Learn how Carina uses Docker Swarm
docker-versions:
  - 1.8.3
topics:
  - docker
  - docker-swarm
  - beginner
---

Carina provisions Docker Swarm clusters for you to deploy your containers to.
Although these clusters offer much of the native functionality of Docker Swarm,
you should be aware of the specific ways in which Carina implements Docker Swarm.

### Carina segments

Docker Swarm uses the concept of a _host_ to represent a machine that runs a
Docker daemon and stores containers. In Carina, the concept is almost
identical, but the term is _segment_.

A Carina segment is similar to a Docker host because both of them house a set of
Docker containers given to them by the Swarm scheduler. One of the key differences,
however, is their underlying virtualization technology. A segment is an LXC
container provisioned by libvirt, whereas a Docker host is typically installed
by you, or by a tool like Docker Machine, onto an operating system, often in a
Virtual Machine (VM). Tests have shown a 60 percent performance boost when LXC
containers are used instead of VM hosts.

Because your Docker containers live on segments, you cannot connect to the
parent host using SSH, like you can with a traditional VM. There are also
restrictions on mounting paths from the host file system, which is discussed in
the [Volumes](#volumes) section.

Each segment is assigned a public IPv4 address, like a Docker host. You
can see all of these addresses with `docker info` or by using the command
provided in the
[Retrieve your Swarm discovery token](#retrieve-your-swarm-discovery-token)
section.

Each segment has 4 GB of memory and roughly the equivalent of 2 vCPUs. The
maximum number of segments that you can provision per cluster is 3. The maximum
number of clusters that you are allowed per account is 3. If you have a use case
requiring more, please contact us via the forum's [Capacity Thread](https://community.getcarina.com/t/capacity-requests/22).

### Cluster creation

The usual way to provision a Swarm cluster is via the command line, where you
perform the following steps:

- Generate a discovery token
- Provision the Swarm manager
- Add a set of Swarm nodes with the Swarm agent installed

But with Carina, these steps are done for you, meaning that you skip this
initial set up. Instead, you use the Carina control panel or
[CLI](https://github.com/getcarina/carina) to
deploy, manage, and visualize your clusters.

### Discovery back ends

Swarm uses the concept of a discovery back-end to track all the hosts (or
Carina segments) registered on the cluster. Many different kinds of discovery
back-ends are used in the the Docker ecosystem:

- Hosted Discovery with Docker Hub
- Static files
- etcd
- Zookeeper
- Consul

You can even use a static list of IP addresses or IP address ranges. With
Carina, however, the only supported option is Hosted Discovery with Docker Hub.
Each cluster is assigned its own Discovery token ID, and hosts use Docker Hub
for service discovery.

#### Retrieve your Swarm discovery token

To retrieve the discovery token for a cluster, run the following command:

```
$ docker inspect -f "{% raw %}{{index .Config.Cmd 6}}{% endraw %}" $(docker ps -aq -f name=swarm-manager -n 1)
token://<cluster_id>
```

This command inspects the `Cmd` configuration of the first container that it
finds named `swarm-manager`. All you are doing here is retrieving the original
command used to provision the manager container, since it contains the cluster ID.

To list the host IP addresses in your cluster, run the following command:

```
$ swarm list token://<cluster_id>
```

For information about how to install and use the `swarm` binary, see the
[installation instructions on the Docker Swarm GitHub site](https://github.com/docker/swarm#installation-for-swarm-developers).

### Scheduling strategies

The Docker Swarm scheduler can distribute containers to hosts in different ways,
and it allows you to specify a scheduling strategy when a manager is provisioned.
You do this by passing the `--strategy` flag to the `swarm manage` command.

With Carina you do not get this option. Instead, the `spread` strategy, which is the
Swarm default, is used.

To find out more information about Swarm scheduling strategies, read the
[Strategies for distributing containers to segments](/docs/tutorials/introduction-docker-swarm#strategies-for-distributing-containers-to-segments)
section of the "Introduction to Docker Swarm" article.

### AppArmor profiles

Carina builds on the standard restrictions set out by
[libcontainer](https://github.com/opencontainers/runc/blob/master/libcontainer/SPEC.md#security)
by using an AppArmor profile as an additional security layer. Specifically,
the AppArmor profile performs the following actions:

- Denies access to sensitive file paths on the hosts (such as system files and
  mount locations)
- Whitelists expected mount calls for the container file system
- Restricts the device capabilities of the Docker process

### Privileged and capability run flags

By default, Docker containers cannot access any devices on the host. If, however,
you use the `--privileged` flag with the `docker run` command, the container
can access all of the devices on the host as if it were a normal process.
Carina disallows this action and forces all containers to run in unprivileged mode.

In line with Linux conventions, Docker uses capabilities to restrict the behavior
of containers. Operations can override these security rules by using the
`--cap-add` and `--cap-drop` flags to add fine-grained control. Carina disallows
these overrides.

### Volumes

One of the features of Docker containers is the ability to mount directories from the host machine (bind mounting), but, with Carina, this feature is heavily restricted for security.

As a result, you can only use the `--volume` flag when referring to segment paths under `/var/lib/docker`. This means that any bind mount should take the following form: `--volume /var/lib/docker:/container-dir-of-your-choosing`.

<!-- TODO: remove this caveat when Carina releases Docker 1.11 -->
**Note**: [Auto-creating missing host paths for bind mounts](http://docs.docker.com/engine/misc/deprecated/#auto-creating-missing-host-paths-for-bind-mounts) has been deprecated by Docker. In the future, if your bind mounts take the following form `--volume /var/lib/docker/dir-that-does-not-exist-yet:/container-dir-of-your-choosing`, Docker will error out.

Data volume containers are the preferred alternative to bind mounting from `/var/lib/docker`. For more information, see the [Use data volume containers](/docs/tutorials/data-volume-containers/) article.

### TLS certificates

All TLS certificates for a cluster are made available on each host through the
`swarm-data` container. To access them, use `--volumes-from swarm-data`
with the `docker run` command. The certificates are then available inside the
container in the following paths:

```
$ docker run --rm --volumes-from swarm-data cirros ls /etc/docker
ca.pem
server-cert.pem
server-key.pem
```
