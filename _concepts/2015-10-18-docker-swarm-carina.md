---
title: Understanding how Carina uses Docker Swarm
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-18
permalink: docs/concepts/docker-swarm-carina/
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

### Carina nodes

Docker Swarm uses the term _node_ to represent a machine that runs a Docker daemon and containers. Carina also uses the term _node_ to represent a machine that runs a Docker daemon and containers. However, the key difference is their underlying technology.

A Docker Swarm node is typically installed by a tool like Docker Machine onto a physical or virtual machine (VM). Whereas, a Carina node is an LXC container provisioned by libvirt onto a physical machine. Carina nodes within a cluster may or may not reside on the same physical machine. Tests have shown a 60 percent performance boost when LXC containers are used instead of VMs.

Because your Docker containers run inside nodes, you cannot connect to the
parent host using SSH, like you can with a traditional VM. There are also
restrictions on mounting paths from the host file system, which is discussed in
the [Volumes](#volumes) section.

Also, because your Docker containers run inside nodes, if a node dies your container will likewise disappear. This underscores the idea of a container being extremely ephemeral and typically not a good choice for permanent data storage.

Each node is assigned a public IPv4 address, like a Docker host. You
can see all of these addresses with `docker info`.

Each node has 20 GB of disk space, 4 GB of memory, and roughly the equivalent of 2 vCPUs. The
maximum number of nodes that you can provision per cluster is 3. The maximum
number of clusters that you are allowed per account is 3. If you have a use case
requiring more, please contact us via the forum's [Capacity Thread](https://community.getcarina.com/t/capacity-requests/22). See [Running out of disk space on a node]({{ site.baseurl }}/docs/troubleshooting/common-problems/#running-out-of-disk-space-on-a-node) to find out how much disk space is used and how much is available per node.

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
Carina nodes) registered on the cluster. Many different kinds of discovery
back-ends are used in the the Docker ecosystem:

- Hosted Discovery with Docker Hub
- Static files
- etcd
- Zookeeper
- Consul

You can even use a static list of IP addresses or IP address ranges. With
Carina, we use Consul for service discovery. Each cluster gets a separate
Consul cluster with each of its agents identified by a unique private key. When
Carina creates a new node for a cluster, the Swarm agent is given the local
Consul agent in order for that segmet to become a part of the Swarm cluster.

For information about Swarm discovery backends, see the
[Docker Swarm discovery documentation](https://docs.docker.com/swarm/discovery/).


### Scheduling strategies

The Docker Swarm scheduler can distribute containers to hosts in different ways,
and it allows you to specify a scheduling strategy when a manager is provisioned.
You do this by passing the `--strategy` flag to the `swarm manage` command.

With Carina you do not get this option. Instead, the `spread` strategy, which is the
Swarm default, is used.

To find out more information about Swarm scheduling strategies, read the
[Strategies for distributing containers to nodes]({{ site.baseurl }}/docs/concepts/introduction-docker-swarm#strategies-for-distributing-containers-to-nodes)
section of the "Introduction to Docker Swarm" article.

### AppArmor profiles

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

As a result, you can only use the `--volume` flag when referring to node paths under `/var/lib/docker`. This means that any bind mount should take the following form: `--volume /var/lib/docker:/container-dir-of-your-choosing`.

Data volume containers are the preferred alternative to bind mounting from `/var/lib/docker`. For more information, see the [Use data volume containers]({{ site.baseurl }}/docs/tutorials/data-volume-containers/) article.

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
