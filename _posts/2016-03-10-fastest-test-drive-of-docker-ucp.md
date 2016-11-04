---
title: "The fastest Docker UCP test drive"
date: 2016-03-10 11:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  Want to take Docker Universal Control Plane (UCP) for a test drive in under two
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
[shipyard] and [tutum] to service discovery tools like etcd and consul. So when
Docker acquired tutum we were pretty excited to see what came of it. The result
was [Docker Universal Control Plane].

## What is UCP?

[Docker Universal Control Plane] (UCP) is an on-or-off premises management UI for
Dockerized applications and infrastructure. It knits together multiple swarm hosts
(nodes) into a single view with metrics tracking, deployment options, and more.

An interesting aspect of UCP is that it's very close to the original [tutum] UI and exposes
an almost one-to-one mapping of the Docker command-line options when you are
managing containers, volumes, and networks. Take a look:

![Landing]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp-landing.png%})

![Containers]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp-container.png%})

**A Note about Terminology**: As an aside, there's a bit of terminology disconnect. When
you work with Docker and Docker Swarm, a node is a Swarm host (cluster). A Swarm
host can host multiple applications and many containers. In most cases nodes/hosts
are on different physical or virtual machines. In UCP, this is labeled both as
nodes and clusters or controllers.

![Swarms]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/ucp-clusters.png%})

With Carina, a cluster can host multiple Swarm nodes (nodes). Each node within
a cluster gets its own Swarm controller, network, disk space, and so on. For more
information, see U[Understanding how Carina uses Docker Swarm].

The short version is that UCP is a great start and offering from Docker especially
because it maintains coherency with the command line Docker/Swarm/Machine tool set.

## Test drives in under two minutes.

So this is where we get to the neat intersection of Carina and UCP - if you
take a peek at the [Evaluation installation and quickstart] document there's
roughly 11 sections with a lot of sub-sections. Summarized these are:

1. Overview
2. Get a license for UCP (Docker website)
3. Setting things up with Docker Machine
4. The UCP tool
5. Deploying UCP
6. Adding Swarm nodes
7. UI walkthrough
8. Download the credentials bundle at [Connect to your cluster]
9. Deploying with the CLI

There's a lot in there - mostly around setting up machine. Carina allows you
to cut those instructions to:

1. Get a license for UCP (Docker website)
1. Sign up for Carina (free)
2. [Grab the CLI] & API key (assuming you have Docker installed)
3. Run a 10 line Bash script.

This gets you to the UI in under two minutes:

<script src="https://gist.github.com/jnoller/2898492bd9f45d3d49ca.js"></script>

Additionally, because **you've already loaded the environment** (as part of the
shell script) via `eval "$(carina env ucp)"`, your CLI tooling is already
configured!

Once you go to the url provided:

```
Login as "admin"/(your admin password) to UCP at https://172.99.79.193:443
```

Upload the UCP license as prompted you got for UCP from the Docker website.

* *Do I need to setup the UCP stuff attached to my docker account?*: Yes!
* *Do I care about the trusted registry suggest?*: Not for the demo/trial.


Here's the dumb script:

<script src="https://gist.github.com/jnoller/b8a766c2460e39910360.js"></script>

Here's a better one:

<script src="https://gist.github.com/jnoller/85c8f503edc81d80002f.js"></script>


## At the end of the day

Ultimately, if you have a running Swarm - this is what you need to start UCP on
the swarm host (note: UCP also contains its own self-managed swarm host but that
  happily coexists and links within the Carina Swarm hosts):

```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
  -e UCP_ADMIN_USER=$username -e UCP_ADMIN_PASSWORD=$password \
  --name ucp docker/ucp install --swarm-port 2377 --fresh-install
```

![Boom]({% asset_path 2016-03-10-fastest-test-drive-of-docker-ucp/boom.gif%})

This time to launch is not just the work of the tooling, or control plane, or
the higher level portions of Carina. The data plane (see [Overview of Carina])
work done under the covers provides a lightning fast environment both in
terms of provisioning times and overall performance.

So thanks goes to the data plane team for many months of hard work.


[Overview of Carina]: https://getcarina.com/docs/overview-of-carina/
[Grab the CLI]: https://getcarina.com/docs/getting-started/getting-started-carina-cli/
[Connect to your cluster]: https://getcarina.com/docs/getting-started/create-connect-cluster/#connect-to-a-docker-swarm-cluster
[Evaluation installation and quickstart]: https://docs.docker.com/ucp/evaluation-install/
[Understanding how Carina uses Docker Swarm]: https://getcarina.com/docs/concepts/docker-swarm-carina/
[tutum]: https://www.tutum.co/
[Docker Universal Control Plane]: https://www.docker.com/products/docker-universal-control-plane
[shipyard]: https://shipyard-project.com/
[Docker Swarm and Carina]: https://getcarina.com/docs/concepts/docker-swarm-carina/
