---
title: How Autoscaling works in Carina
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
in a production environment. Whether it's due to an unexpected spike in traffic
or a planned campaign, your infrastructure, which could be virtual machines
or Docker containers, needs to be able to cope with increased web traffic.

Carina handles auto scaling for you, meaning that you do not need to configure
anything. The system will periodically check that every Docker host has a
sufficient allocation of resources and, if not, grows the cluster. The scaling
action will trigger when either the average CPU or average memory consumption
exceeds 80% across the cluster. This consumption is based on reserved memory
and CPU, achieved through scheduler hints described in the
[Scheduler hints](#scheduler-hints) section.

The automated scaling action will never reduce the size of cluster. This is to
avoid potentially harmful consequences like data loss.

# Scheduler hints

You can reserve memory or CPU for a container by using runtime constraint flags
when executing `docker run`. This will explicitly reserve the resource
specified on the Docker host. If the automated auto scale action, which runs
every 5 minutes, notices that the total reserved CPUs or the memory exceeds 80%
of total capacity, a new segment will be provisioned.

To reserve 1 GB of memory for your container, run:

```
$ docker run -d -m 1GB busybox /bin/echo 'Hello world'
```

To reserve a specific amount of CPUs, run:

```
$ docker run -d -c 5 busybox /bin/echo 'Hello world'
```

Each segment has a total memory capacity of 4 GB, and 12 vCPUs. If runtime
constraints are used on a cluster that cannot provide the requested amount of
memory or CPUs, an error will appear, and the container will not be provisioned.
