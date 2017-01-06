---
title: Introduction to Docker Swarm
author: Matt Darby <matt.darby@rackspace.com>
date: 2015-10-19
permalink: docs/concepts/introduction-docker-swarm/
description: Learn how Docker Swarm enables easy cluster management
docker-versions:
  - 1.8
topics:
  - docker
  - intermediate
---

Docker Swarm is a management system for Docker. It enables an application to be containerized and run across multiple nodes in a cluster. Carina offers one node by default and is scalable up to three nodes in each cluster. A *node* (or node) is a slice of resources available in the cluster. Docker enables you to use commands that you're familiar with to manage the cluster as though it were a single host.

A Docker Swarm cluster has a few management containers that are necessary for cluster management. When you run `docker ps -a` on a cluster, the following result is displayed:

```bash
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
315d9db6f181        swarm:1.2.5         "/swarm manage -H=tcp"   2 hours ago         Up 2 hours                              34ee722d-48b3-47b5-8e17-92935280e6bd-production-master-00/swarm-manager
675e25337d5a        swarm:1.2.5         "/swarm join --addr=1"   2 hours ago         Up 2 hours                              34ee722d-48b3-47b5-8e17-92935280e6bd-production-master-00/swarm-agent
1b0392d0cfa8        cirros              "/sbin/init"             2 hours ago         Created                                 34ee722d-48b3-47b5-8e17-92935280e6bd-production-master-00/swarm-data
```

This result shows three containers. At the far right, the names of these containers are displayed: `swarm-manager`, `swarm-agent`, and `swarm-data`.

* `swarm-manager` maintains the cluster and manages resources.
* `swarm-agent` is the client to `swarm-manager`.
* `swarm-data` is a central data share for a particular node.

Usually you do not need to think about these containers. However, ensure that you don’t delete all the containers via a command like `docker rm --force 'docker ps -qa'`. If you remove these containers, the cluster will need to be rebuilt.

### Strategies for distributing containers to nodes
The *scheduler* is responsible for maintaining the life cycle of a container. It chooses the best node in your cluster and starts, stops, destroys the container when asked. Different scheduler strategies can be used to pick the best node to hold a container.

* `spread` (default): This strategy spreads containers as thinly as possible across all nodes in the cluster. If there are identical nodes, a random one is chosen and the container is placed on that node. This strategy is the only one currently used in Carina.
* `binpack`: This strategy leaves room on the cluster for a large containers by stacking smaller containers on one node in the cluster.
* `random`: This strategy places containers on a random node on the cluster.

### Scheduling filters

You can use different scheduling filters to fine tune how your cluster places containers on nodes.
When you create a container, you can select a subset of nodes that should be considered for scheduling by specifying one or more sets of key-value pairs.

To use scheduling filters, you must label the node as you add it to the cluster:

```
$ docker -d --label storage=ssd
swarm join --advertise=192.168.0.1:2375 token://<swarmMasterContainerId>
```

#### Scheduling constraints

Scheduling constraints are key-value pairs associated with particular nodes. They act much like node tags.
When creating a container, you can select a subset of nodes that should be considered for scheduling by specifying one or more sets of matching key-value pairs.

Docker Swarm allows you to filter nodes based on key-values available via `docker info`.

Example constraints:

* node ID or node name: `$ docker run -d -p 80:80 --name frontend nginx`
* storagedriver: `$ docker run -d -p 80:80 --storagedriver=devicemapper nginx`
* executiondriver: `$ docker run -d -p 80:80 --executiondriver=native-0.2 nginx`
* kernelversion: `$ docker run -d -p 80:80 --kernelversion=3.13.0-49-generic nginx`
* operatingsystem: `$ docker run -d -p 80:80 --operatingsystem=Debian GNU/Linux nginx`

#### Affinity

Docker Swarm provides a way to place containers in relation to other containers. This is called the `affinity` filter. You can schedule to place a container on the same node as another container by using the following commands:

`$ docker run -d -p 80:80 --name frontend nginx`

`$ docker run -d --name logger -e affinity:container==frontend logger`

#### Port

The `port` filter instructs Docker Swarm to treat ports as unique resources. If you want containers to serve a particular port (in this example, port 80), using the `port` filter will instruct Docker Swarm to schedule a new container on a node that has port 80 available.

If you have a three-node cluster, you can run the following command three times (equal to the number of nodes). If you run it a fourth time, the command fails because all nodes have port 80 already mapped.

`$ docker run -d -p 80:80 nginx`

#### Dependency

The `dependency` filter instructs Docker Swarm to co-schedule container creation on the same node.

If it cannot do this (because the dependent container doesn’t exist, or because the node doesn’t have enough resources), it prevents the container creation. The combination of multiple dependencies is honored if possible.

* Shared volumes: `$ docker run -d -p 80:80 --volumes-from=<containerName>`
* Shared network stack: `--net=container:<containerName>`


#### Health

The `health` filter simply instructs Docker Swarm to schedule container creation only on "healthy" nodes.

### Next steps
* To find out more about Carina, see [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
* To find out more about how Carina implements Docker Swarm, see [Understanding how Carina uses Docker Swarm]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/).
