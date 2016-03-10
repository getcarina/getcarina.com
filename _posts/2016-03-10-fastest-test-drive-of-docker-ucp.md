---
title: "The fastest Docker UCP test drive"
date: 2016-03-10 11:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  Want to take Docker Universal Control plane for a test drive in under two
  minutes? We have you covered. Carina could be the fastest way for you to
  experiment with the new management GUI from Docker.
categories:
 - Deployment
 - Carina
 - Docker
 - Management
authorIsRacker: true
---

![Docker UCP]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp.png %})

{{ page.excerpt }}

The Carina team is always experimenting with new technology - from management UIs such as
[shipyard], [tutum], and others to service discovery tools like etcd and consul. So when
Docker acquired Tutum we were pretty excited to see what came of it. The result
was [Docker Universal Control Plane].

## What is UCP?

You can take a look at the [Docker Universal Control Plane] and the demo - it's
a great high level view and video. In a nutshell, UCP is a on-or-off premises
management UI for Dockerized applications & infrastructure. It nits together
multiple swarm hosts (nodes) into a single view with metrics tracking, deployment
options, and more.

An interesting aspect of UCP is that it's very close to the original [tutum] UI
and exposes a close to one-to-one mapping of the Docker command line options when
managing containers, volumes and networks. Take a look:

![Landing]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp-landing.png%})

![Containers]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp-container.png%})

**A Note about Terminology**: As an aside, there's a bit of terminology
split-brain. When you work with Docker and Docker Swarm, a 'node' is a Swarm Host
(cluster). A swarm host can host multiple applications and many containers. In
UCP this is both labeled as nodes and clusters / controllers:

![Swarms]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp-swarms.png%})

With Carina a cluster can host multiple Swarm nodes (segments) - the segments within
a cluster each get their own Swarm controller, network, disk space, etc. For
more see: [Understanding how Carina uses Docker Swarm].

The short version is that UCP is a great start and offering from Docker especially
as it maintains coherency with the command line Docker/Swarm/Machine tool set.

## Test drives in under two minutes.

So this is where we get to the neat intersection of Carina and UCP - if you
take a peek at the [Evaluation installation and quickstart] document there's
roughly 11 sections with a lot of sub-sections. Summarized these are:

1. Overview
2. Setting things up with Docker Machine
3. the UCP tool
4. Deploying UCP
5. Adding swarm nodes
6. UI walkthrough
8. Download the credentials bundle (close to [Download Carina credentials]!)
9. Deploying with the CLI

There's a lot in there - mostly around setting up machine. Carina allows you
to cut those instructions to:

1. Sign up for Carina (free) (assuming you have docker installed)
2. [Grab the CLI, API key] (assuming you have docker installed)
3. Run a 10 line Bash script.

This gets you to the UI in under two minutes:

<script src="https://gist.github.com/jnoller/2898492bd9f45d3d49ca.js"></script>

Additionally, since **you've already loaded the environment** (as part of the
shell script) via `eval "$(carina env ucp)"` your CLI tooling is already
configured!

Here's the dumb script:

<script src="https://gist.github.com/jnoller/b8a766c2460e39910360.js"></script>

Here's a better one:

<script src="https://gist.github.com/jnoller/85c8f503edc81d80002f.js"></script>


## At the end of the day

Ultimately, if you have a running Swarm - this is what you need:

```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
  -e UCP_ADMIN_USER=$username -e UCP_ADMIN_PASSWORD=$password \
  --name ucp docker/ucp install --swarm-port 2377 --fresh-install
```

![Boom]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/boom.gif%})


[Grab the CLI, API key]: https://getcarina.com/docs/getting-started/getting-started-carina-cli/
[Download Carina credentials]: https://getcarina.com/docs/references/carina-credentials/
[Evaluation installation and quickstart]: https://docs.docker.com/ucp/evaluation-install/
[Understanding how Carina uses Docker Swarm]: https://getcarina.com/docs/concepts/docker-swarm-carina/
[tutum]: https://www.tutum.co/
[Docker Universal Control Plane]: https://www.docker.com/products/docker-universal-control-plane
[shipyard]: https://shipyard-project.com/
[Docker Swarm and Carina]: https://getcarina.com/docs/concepts/docker-swarm-carina/
