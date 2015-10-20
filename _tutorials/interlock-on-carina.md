---
title: Running interlock, the event driven Docker Swarm plugin system, on Carina
author: Kyle Kelley <kyle.kelley@rackspace.com>
date: 2015-10-18
permalink: docs/tutorials/interlock-on-carina/
description: Using interlock to load balance containers or emit statistics across your swarm cluster.
topics:
  - docker
  - interlock
  - events
  - intermediate
---

To load balance your containers across a swarm cluster, send on statistics to carbon,
or other swarm event driven operations, you can use [interlock](https://github.com/ehazlett/interlock). 
Interlock listens for new Docker events, such as a new container being started and, according to your
configuration, notifies plugins.

Interlock has plugins for

* load balancing via HAProxy
* load balancing via Nginx
* stat forwarding to Carbon

Normally for interlock you need to mount a volume with certificates, set TLS options, and optionally set
environment variables. Using [libcarina, the go bindings for carina](https://github.com/rackerlabs/libcarina),
we've modified interlock to require only your username, API key, and the name of the cluster you want to run on.

Assuming you have a cluster named `boatie`, this is how you would run the `example` plugin (swapping in your own username and API key):

```bash
docker run carina/interlock --username $USERNAME  --api-key $APIKEY --clustername boatie --plugin example start
```

which results in output like so:

```
$ docker run carina/interlock --username $USERNAME  --api-key $APIKEY --clustername boatie --plugin example start
time="2015-10-19T01:22:59Z" level=info msg="interlock running version=0.3.2 (2df2d23)"
time="2015-10-19T01:22:59Z" level=info msg="loading plugin name=example version=0.1"
time="2015-10-19T01:22:59Z" level=info msg="[interlock] dispatching event to plugin: name=example version=0.1"
time="2015-10-19T01:22:59Z" level=info msg="[example] action=received event= time=1445217779076879776"
```

Try it out and let us know what you think!

