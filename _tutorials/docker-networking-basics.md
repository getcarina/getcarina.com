---
title: Docker Networking Basics
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-08
permalink: docs/tutorials/docker-networking-basics/
description: Connecting Docker containers over the network
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
---

Docker encourages an application architecture with multiple interdependent containers,
rather than a single container providing many services. For example, a web application
container that relies upon a caching container. There are multiple solutions which
facilitate networking containers, in this tutorial we will cover two basic
options: [Docker links](#links) and [Weave](#weave).

This tutorial describes how to network Docker containers so that they can communicate
among themselves.

### <a name="links"></a> Docker links
Docker links enable containers *on the same host* to communicate. This is useful
for development environments but is not recommended in production, as the single-host
restriction limits your topology and hinders scalability and availability.

When you run a container, the `--link` flag connects the new container, the _target_,
to an existing container, the _source_. Docker then provides information to both the
source and target containers so that they are aware of each other. It does so by
defining environment variables on the target container and adding entries to both
the source and target containers' **/etc/hosts** file.

The link alias should be a well known value and is not arbitrary. The target container
must know the link alias ahead of time, as it must know the link alias in order to lookup the target container.

This is useful for container isolation, not just service discovery. When containers are run with `--icc` and `--iptables`, then they cannot communicate unless explicitly allowed by a Docker link.

Below is a summary of the link information provided by Docker. The source container name is **db**,
the target container name is **web**, and the link alias is **webdb**.

**Target container environment variables**
The _sourcePort_ value is the port exposed on the source container from its Dockerfile.
If the source container exposes multiple ports, the hosts file will contain additional entries.

If the port and protocol are not well known, then **<linkAlias>_PORT** can be parsed
to discover that information.

In cases where the protocol and port for the source container are known ahead of time,
the ip address of the target container is the most interesting information. However, as the
environment variable cannot be relied upon, the hosts file should be used instead.

```bash
# <linkAlias>_NAME=/<targetName>/<linkAlias>
WEBDB_NAME=/web/webdb

# <linkAlias>_PORT=<sourceProtocol>://<sourceIpAddress>:<sourcePort>
WEBDB_PORT=tcp://172.17.0.10:5432

# <linkAlias>_PORT_<sourcePort>_<sourceProtocol>=<sourceProtocol>://<sourceIpAddress>:<sourcePort>
WEBDB_PORT_5432_TCP=tcp://172.17.0.10:5432

# <linkAlias>_PORT_<sourcePort>_<sourceProtocol>_PROTO=<sourceProtocol>
WEBDB_PORT_5432_TCP_PROTO=tcp

# <linkAlias>_PORT_<sourcePort>_<sourceProtocol>_ADDR=<sourceIpAddress>
WEBDB_PORT_5432_TCP_ADDR=172.17.0.10

# <linkAlias>_PORT_<sourcePort>_<sourceProtocol>_PORT=<sourcePort>
WEBDB_PORT_5432_TCP_PORT=5432
```

**Target container host entry**

```bash
# <sourceContainerIPAddress> <linkAlias> <sourceContainerId> <sourceContainerName>
172.17.0.10	webdb 6ecbec9ede41 db
```

The following command, run on the target container, will print the IP address
of the source container:

```bash
# grep -i <linkAlias> /etc/hosts | awk '{print $1}'
$ grep -i webdb /etc/hosts | awk '{print $1}'
172.17.0.10
```

**Source container host entries**

```bash
# <targetContainerIPAddress> <targetContainerName>
172.17.0.13	web
```

**Note**: The source container environment variables are not updated when the target container
is restarted, only **/etc/hosts** is updated. When looking up the target container's IP address,
use **/etc/hosts**, as it will always contain the correct value.

what is the topology? ip addresses and ports, tunnels, security, environment variables

using it from the dependent container

### <a name="weave"></a> Docker Weave
[Weave][weave] is a suite of products for managing a multi-container
applications. This tutorial will focus on Weave Net, which creates a network
capable of spanning Docker hosts.

what does a command look like?
* install on host vs remote

what is the topology? ip addresses and ports, tunnels, security, environment variables

using it from the dependent container

[weave]: http://weave.works/
<!--
List the steps required for users to get to your concept's equivalent of "Hello, world!"

Use a single numbered list for detailed steps when possible.

A single numbered list might be impractical for topics with a good amount of supporting information at each step. If a single numbered list of steps is not useful:

* Identify the main steps with H2-level headings.

    Omit numbering from headings. For example: "Install the latest version of Docker" is OK. "Step One: Install ..." is not OK.

    Include as many sections as needed to logically explain the idea.

* Limit subheadings to H3.

    Headings requiring further depth deserve their own tutorial. Create a separate tutorial, then link to it.

* In each section, provide a numbered list of substeps.

    Also provide paragraphs for explanations, bullet lists, code samples, and examples.
-->

### Troubleshooting

<!--
* List troubleshooting steps here.

    Cover the most common mistakes and error states first.

    Link or create a separate article for troubleshooting steps that aren't specific to the tutorial.

* Link to support articles and generic troubleshooting information.

    Create a separate article for generic troubleshooting information.
-->

### Resources

* [Docker links](https://docs.docker.com/userguide/dockerlinks/)
* [Weave documentation](http://docs.weave.works/weave/latest_release/index.html)

### Next

* [Connect containers with Docker links]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-with-links/)
* [Connect RCS containers with Weave]({{ site.baseurl }}/docs/tutorials/connect-rcs-containers-with-weave/)
