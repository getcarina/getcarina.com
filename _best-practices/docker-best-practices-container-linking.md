---
title: 'Docker best practices: container linking'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/docker-best-practices-container-linking/
description: Docker best practices, powered by the Rackspace Container Service
docker-versions:
topics:
  - best-practices
  - planning
---

*Avoid container linking; use a service registration and discovery tool instead.*

Docker has a concept known as “linking” that allows you to connect
containers via a socket or through a hostname using a sender and
recipient model. Links can also be used to leverage service discovery
between containers. Links work by having the client
container use Docker's private networking interface to
access an exposed port in another server container.

### Links create a tunnel

For example, to link a MySQL database backend server named `mysql_server` to a client container named `webapp`:

1. Start the database server, `mysql_server`, from a stored image named `mysql`:

       `docker run -d --name mysql_server mysql`.

2. Create the client container, `webapp`, with a link to the serving container, `mysql_server`,
   assigned an alias of `db` and enabled to run the bash shell:

       `docker run -t -i --name webapp --link mysql_server:db /bin/bash`

With links forming a secure tunnel between the containers,
the client is allowed to access data on the serving container.

Connectivity information is exposed to the client
in environmental variables and via a host entry for
the source container in the `/etc/hosts` file [(1)](#resources).

In the environmental variables, the client will see information
such as the following:

    DB_NAME=/webapp/db
    DB_PORT=tcp://172.17.0.5:3306
    DB_PORT_3306_TCP=tcp://172.17.0.5:3306
    DB_PORT_3306_TCP_PROTO=tcp
    DB_PORT_3306_TCP_PORT=3306
    DB_PORT_3306_TCP_ADDR=172.17.0.5

### Ambassador pattern

In Docker linking, a pattern emerged that allows the proxying of
connections between a server and client container. This separate proxy
container, the ambassador, transparently redirects connections based on parameters.

However, because ambassador containers themselves depend on links, they
too are exposed to the issues linking has, primarily that it is beneficial
to use linking only as long as it
does not fail or crash.

In essence, the usage of the ambassador pattern has dwindled down as far
as the community is concerned as it does not necessarily add any benefit
that links don’t already provide, and it further complicates the
architecture without solving the underlying issues at hand.

### Issues with linking

As provocative as linking seems, it seems to be met with a couple of
different nuances and issues when you begin to think of linking
containers across different hosts as well as how much of an ephemeral
lifecycle a particular container can hold.

Some problems and needs which are not addressed by links include:

-   Service discovery suffers from the static nature of linking.

-   Links are volatile. IP addresses, port mappings, and link names can
    change as the result of manipulating a link, and other containers
    are not notified of these changes nor can they trivially deal with
    these issues [(2)](#resources).

With such complications, it becomes difficult to use containers with links in
certain situations. Links functionality can only work for
containers on the same node or by using the ambassador model,
which itself isn’t being adopted much.

Additionally, the exposure of the environmental variables in linking is
done in a very odd manner:
you must know know the intended interface and the port of the service
set in the environment beforehand, so then you can supply them
to the service that is supposed to be
supplying you with what the interface and port
*are*. This is quite a useless feature. For example, if one cares
to know the name of the protocol being used in the connection to environmental variables, one must know that the environmental variable is named
`DB_PORT_3306_TCP_PROTO`; the `TCP` in the variable name is sufficient to determine that the protocol in use is TCP.

Also, once you discover the environmental variables, you’ll have to
parse the various strings for each connection to compose the full
connection information, so you may as well just have a single
environment variable containing all information about hosts, ports, and interfaces,
such as the following:

    DB_NAME=/web2/db
    DB_PORTS=tcp://172.17.0.5:3306,udp://172.17.0.5: 3306

In summary, links are not at the state to easily aid the developer in
terms of connecting server and client containers without much
foreknowledge of the connection itself. The stability and benefits of linking
just aren’t ready to be integrated into
mission-critical, production-grade stacks.

### Alternative to linking

An alternative that is becoming an industry standard is to use a
service registration and discovery tool. You can read more about this at
[Introduction to container technologies: registration and discovery of container services](/container-technologies-registration-discover/).

<a name="resources"></a>
### Resources

Numbered citations in this article:

1. <https://docs.docker.com/userguide/dockerlinks/>

2. <https://github.com/docker/docker/issues/7467>

Other recommended reading:

- [Introduction to container technologies: registration and discovery of container services](/container-technologies-registration-discover/)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
