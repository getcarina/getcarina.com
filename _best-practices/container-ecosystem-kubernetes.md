---
title: Container ecosystem: Kubernetes
permalink: docs/_best-practices/container-ecosystem-kubernetes/
description: Best practices for container ecosystems, powered by the Rackspace Container Service
author: Mike Metral
date: 2015-10-01
topics:
  - best-practices
  - planning
---

*Use Kubernetes with Docker to manage and orchestrate containers in your stack.*

Kubernetes, from Google, is a a tool for managing and orchestrating containers
within a stack. Kubernetes works with Docker but
they differ from each other in key ways.

## Operating model

Kubernetes’ own documentation at <http://kubernetes.io/> fully describes its
purpose and its technical capabilities. However, we want to take the
opportunity to take a step back and give a synopsis of how Kubernetes
is intended to be used and where the real need for including it in
your stack lies.

Kubernetes’ added benefit is that it defines a collection of
primitives to aid in establishing and maintaining a cluster of
containers. In short, Kubernetes is really just an opinionated model
of application containers, their dependencies with regards to other
resources, and their lifecycles. Without going into too much fine-grained detail,
*pods* “are the atom of scheduling, and are a group of
containers that
are scheduled onto the same host…[that] facilitate data sharing and
communication [by way of] shared mount point’s, [and] network namespace
[to create] microservices [(1)](#resources).”

The rest of the concepts/units Kubernetes outlines such as *services*,
*labels* and *replication controllers* are ways to enhance *pods*.
They also enable users to declare the intended state
their containers should hold and have Kubernetes enforce. Therefore, it
is safe to say that Kubernetes does not even know what an application or
microservice actually is; it only know how you wish to collect and manage your
containers, including adherence to requirements such as resource
allocation for containers, affinity, replication, and load balancing.
Anything more than that is beyond the scope of Kubernetes.

## Kubernetes-specific functionality

Kubernetes does not directly intend to reinvent core Docker
functionality, but it does establish its own slightly divergent
semantics for concepts such as volumes and container communication.
In some cases, it has its own implementation of a concept that is also used in
Docker.

### Volumes

Docker volumes can be *data volumes* or *data volume containers*.  

With *data volumes*, you can either
let Docker choose a random, unspecified location at which to create the
volume on the host or you can specify a host directory or file to mount on
the container. In Kubernetes, new abstractions such as volume and volume
mounts exist for usage with pods that have volume types `EmptyDir` and
`HostDir`. However, behind the scenes, these types essentially map to the
way one can use a Docker Data volume, with additional overhead for
Kubernetes to maintain the user’s configuration while it interfaces
directly with Docker to actually enable the sharing of volumes.

Where Kubernetes differs strongly from Docker with regard to volumes is in
*data volume containers*. Docker's documentation,
as well as various blog posts and articles,
prescribes the data volume containers mechanism as the preferred way to share data among
containers. As with data volumes,
various intrinsic issues exist with data volume containers
when you begin to scale out your
architecture. The team behind Kubernetes has recognized this methodology
as a potential for failure and has chosen not to support data volume
containers as a type in their volumes. The reasoning for this is that data
volume containers are ultimately passive containers that can be
very unintuitive to understand from a user perspective, and can create
corner cases and potentially be problematic for management systems.

For more discussion of Docker volumes
as *data volumes* and *data volume containers*,
see
[Docker best practices: data and stateful applications] (/docker-best-practices-data-stateful-applications/).

### Discovery

For container service discovery, specifically within a pod, Kubernetes does
not directly use Docker links as they don’t do well outside of a single
host. Also, managing links' lifecycle can prove to be difficult given Kubernetes'
current capabilities. Instead, to support  the concept of *services*
that resemble linking, Kubernetes offers two modes of discovery:
environmental variables and DNS.

If a Kubernetes service exists, then Kubernetes has a backward
compatible mannerism to create Docker-style link environment variables
in the container; you can read more about this at
[Docker best practices: container linking]
(/docker-best-practices-container-linking/), but
remember that we believe they’re implicit and hard to work with.
Kubernetes can
also create simplified environmental variables with the pattern
{SVCNAME}\_SERVICE\_HOST and
{SVCNAME}\_SERVICE\_PORT.

Another recommended way to perform service discovery is by using a DNS
server. The DNS server watches the Kubernetes API for new services and
creates a set of DNS records for each. If DNS has been enabled
throughout the cluster, then
all pods should be able to do name resolution of all services
automatically [(2)](#resources). The takeaway from this is that you don’t need to
explicitly create links between communicating pods as done natively in
Docker because Kubernetes does the heavy lifting, so long as you oblige
by using the networking mechanisms.

Lastly, do not forget that non-Kubernetes tools such as etcd, Zookeeper, and
Consul are also viable options. These and others are discussed in
[Introduction to container technologies: orchestration and management of container clusters] (/container-technologies-orchestration-clusters/).

### Networking

Kubernetes deviates from the default Docker networking model. The goal
of Kubernetes' networking model is to allow each pod to have an IP in a
flat networking space. Within that space, the pod can communicate with hosts and
containers across the cluster. In doing so, pods can be thought of as
any other node in the network with regards to “port management,
networking, naming, service discovery, load balancing, application
configuration, and migration” and can create a NAT-free address space;
this concept is known as the “IP-per-pod” model [(3)](#resources).

Because Kubernetes applies IP addresses at the pod scope,
containers within
a pod share their network namespaces, including their IP address.
This means that
containers within a pod can all reach each other’s ports on `localhost`.
This implies that containers within a pod must coordinate port usage,
but this is no different than processes in a virtual machine [(4)](#resources).

We can achieve the IP-per-pod model via the prescribed network
requirements imposed by Kubernetes by allocating each host (minion) with
its own subnet in an overlay network that can enable containers to
communicate with the host and any other networks available in the
environment. A common network split is to allocate to the overlay a
cluster-wide /16 network and then divide that cluster-wide network up
into a /24 network for each minion in the cluster. Once you
lay out your network space, you can implement the overlay and configure a
new bridge for the Docker host to use within it. Some tools that are
great for this particular purpose, especially in a cloud environment,
are container-intended networking technologies such as Flannel, Weave,
SocketPlane and even Open vSwitch. Several of these are discussed in
[Introduction to container technologies: container networking]
(container-technologies-networking).

This approach to networking is different from the standard Docker model.
In the standard Docker model, each
container gets an IP address in a host-private networking space as defined in
[RFC1918 Address Allocation for Private Internets]
(https://tools.ietf.org/html/rfc1918). For example, a container may be assigned
an IP address in the 172-dot space. Container IP addresses are managed by the
Docker host bridge. The effect of this is that containers can only communicate with
other containers on the same host, as opposed to also being able to
communicate with other machines in the network. Furthermore, it
may even be the case that conflicts and confusion arise due to different
Docker hosts using the same network space and configuration.

# Community status

Kubernetes is the front-runner among tools for managing and orchestrating
containers in your stack;
see [Introduction to container technologies: orchestration and management of container clusters] (/container-technologies-orchestration-clusters/) for a comparison of Kubernetes
and competing tools.

Although Kubernetes is still at a Beta release level and claims not to be
production-ready yet, the industry has not strayed away from betting
on Kubernetes’ future and success. Widespread adoption of Kubernetes appears to
be based on the fact that
Google is backing it, as well as in respect for the impressive contributors
working on it.

Aside from the positive publicities in blog posts and community chatter influencing
its adoption, the community is showing its vested interest:
as of April 2015, Kubernetes averaged around 400-500 commits per
week and a very substantial following of almost 300 contributors.

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <http://www.slideshare.net/timothysc/apache-coneu>

2. <http://kubernetes.io/v1.0/docs/user-guide/services.html>

3. <https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/design/networking.md>

4. <http://kubernetes.io/v1.0/docs/admin/networking.html>

*Other recommended reading*

- <http://kubernetes.io/>

- [Docker best practices: data and stateful applications](/docker-best-practices-data-stateful-applications/)

- [Docker best practices: container linking](/docker-best-practices-container-linking/)

- [Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/)

- [RFC1918 Address Allocation for Private Internets](https://tools.ietf.org/html/rfc1918)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations, explore the *tutorials* collection.
* For detailed descriptions of reference architectures designed
  for specific use cases,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

## About the author

Mike Metral is a Product Architect at Rackspace. You can follow him in GitHub at https://github.com/metral and at http://www.metralpolis.com/.
