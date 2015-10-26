---
title: Autoscaling resources in Carina
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-01
permalink: docs/tutorials/autoscaling-carina/
description: Learn how autoscaling works in Carina
docker-versions:
  - 1.8.2
topics:
  - docker
  - autoscaling
---

Being able to scale your web application is one of the most important features
in a production environment. Your infrastructure, which could be virtual machines
or Docker containers, must be able to cope with increased web traffic, whether
it's caused by an unexpected spike in traffic or a planned campaign.

Carina handles autoscaling for you. The system periodically checks that every
Docker host has a sufficient allocation of resources and, if not, grows the
cluster. The scaling action is triggered when either the average CPU or average
memory consumption exceeds 80 percent across the cluster. This consumption is
based on reserved memory and CPU, which you specify through _scheduler hints_
(described in the [next section](#scheduler-hints)).

To avoid potentially harmful consequences like data loss, the automated scaling
action will never reduce the size of a cluster.

### Scheduler hints

You can reserve memory or CPU for a container by using runtime constraint flags
when you execute the `docker run` command. These flags explicitly reserve the
specified resource on the Docker host. If the automated scaling action, which runs
every five minutes, detects that the total reserved CPUs or the memory exceeds
80 percent of total capacity, a new segment is provisioned.

For example, to reserve 1 GB of memory for your container, run the following command:

```
$ docker run -d -m 1GB <containerName>
```

To reserve a specific amount of CPUs, run:

```
$ docker run -d -c 5 <containerName>
```

Each segment has a total memory capacity of 4 GB and 12 vCPUs. If runtime
constraints are used on a cluster that cannot provide the requested amount of
memory or CPUs, an error message is issued and the container is not provisioned.
