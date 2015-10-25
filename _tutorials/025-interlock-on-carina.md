---
title: Run interlock on Carina
author: Kyle Kelley <kyle.kelley@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/interlock-on-carina/
description: Use interlock to load balance containers or emit statistics across your swarm cluster
topics:
  - docker
  - interlock
  - events
  - intermediate
---

This tutorial shows you how to use [interlock](https://github.com/ehazlett/interlock), the event-driven Docker Swarm plug-in system, to load balance your containers across a Swarm cluster, send statistics to Carbon, and perform other Swarm event-driven operations. Interlock listens for new Docker events, such as a new container being started, and, according to your configuration, notifies plug-ins.

Interlock has plug-ins for:

* Load balancing via HAProxy
* Load balancing via NGINX
* Statistics forwarding to Carbon

Normally for interlock you need to mount a volume with certificates, set TLS options, and optionally set
environment variables. Using [libcarina, the go bindings for carina](https://github.com/rackerlabs/libcarina),
interlock in Carina has been modified to require only your username, API key, and the name of the cluster you want to run on.

Assuming that you have a cluster named `boatie`, following is how you would run the `example` plug-in (substituting your own username and API key):

```bash
docker run carina/interlock --username $USERNAME  --api-key $APIKEY --clustername boatie --plugin example start
```

The resulting output looks as follows:

```
$ docker run carina/interlock --username $USERNAME  --api-key $APIKEY --clustername boatie --plugin example start
time="2015-10-19T01:22:59Z" level=info msg="interlock running version=0.3.2 (2df2d23)"
time="2015-10-19T01:22:59Z" level=info msg="loading plugin name=example version=0.1"
time="2015-10-19T01:22:59Z" level=info msg="[interlock] dispatching event to plugin: name=example version=0.1"
time="2015-10-19T01:22:59Z" level=info msg="[example] action=received event= time=1445217779076879776"
```
