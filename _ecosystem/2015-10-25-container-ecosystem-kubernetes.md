---
title: 'Container ecosystem: Kubernetes'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-25
permalink: docs/best-practices/container-ecosystem-kubernetes/
description: Explore the place of Google Kubernetes in the container ecosystem
topics:
  - best-practices
  - planning
---

*Use Kubernetes with Docker to manage and orchestrate containers in your stack.*

Kubernetes, from Google, is a tool for managing and orchestrating containers
within a stack. Kubernetes works with Docker but
they differ from each other in key ways.

### Operating model: the pod

Although Kubernetes’ documentation at <http://kubernetes.io/> fully describes its
purpose and its technical capabilities,
this article discusses Kubernetes' intended use more objectively and suggests how your
stack could benefit from adopting it.

Kubernetes defines a collection of primitives to aid in establishing and maintaining a cluster of
containers. Kubernetes is really just an opinionated model
of application containers, their dependencies with regard to other
resources, and their lifecycles.

In Kubernetes, the pod is the central concept.
A pod is a group of applications in the same physical location and with a shared context.
The context of the pod, created by sharing several Linux namespaces, enables applications
within the pod to share a hostname, coordinate through message queues, access the same IP
and port space, and see each other's processes. Applications within a pod can also share
volumes.

### Relating Kubernetes to Docker and Mesos

Kubernetes is not Docker. Kubernetes is an orchestration system for Docker containers. In
Docker terms,
a Kubernetes pod "consists of a colocated group of Docker containers with shared volumes
[(1)](#resources)."

Kubernetes does not function like Mesos, either. Mesos is a scheduling system for containers.
In relating Mesos, Docker, and Kubernetes, Timothy St. Clair explains that pods “are the
atom of scheduling, and are a group of containers that are scheduled onto the same
host…[that] facilitate data sharing and communication [by way of] shared mount points,
[and] network namespace [to create] microservices [(2)](#resources).”

### Kubernetes-specific functionality

Kubernetes does not directly intend to reinvent core Docker
functionality, but it does establish its own slightly divergent
semantics for concepts such as volumes and container communication.
In some cases, it has its own implementation of a concept that is also used in
Docker.

Key Kubernetes concepts such as *services*,
*labels* and *replication controllers* are ways to enhance pods.
Pods also enable users to declare the intended state
their containers should hold and have Kubernetes enforce. Therefore, it
is safe to say that Kubernetes does not even know what an application or
microservice actually is; it only knows how you wish to collect and manage your
containers, including adherence to requirements such as resource
allocation, affinity, replication, and load balancing.

#### Volumes

With *data volumes*, you can either
let Docker choose a random, unspecified location at which to create the
volume on the host or you can specify a host directory or file to mount on
the container. In Kubernetes, new abstractions such as volume and volume
mounts exist for usage with pods that have volume types `EmptyDir` and
`HostDir`. These Kubernetes volume types are essentially consistent with Docker data volumes, with additional overhead for
Kubernetes to maintain your configuration while it interfaces
with Docker to actually enable the sharing of volumes.

Where Kubernetes differs strongly from Docker with regard to volumes is in
*data volume containers*. Docker volumes can be data volumes or data volume containers.
Docker uses data volume containers as a means of sharing data volumes: one container,
the data volume container, manages the data volume while other containers can use it.
Docker prescribes the data volume containers mechanism as the preferred way to share data
among containers. However, the team behind Kubernetes believes that data volume containers
are a potential cause of failure in large-scale architectures and have chosen not to
support data volume containers as a type for Kubernetes volumes. The reasoning for this
is that data volume containers in Kubernetes are ultimately passive containers that can be
unintuitive from a user perspective and can create corner cases, potentially causing
problems for management systems.

For more discussion of Docker volumes as data volumes and data volume containers,
see
[Docker best practices: data and stateful applications]({{ site.baseurl }}/docs/best-practices/docker-best-practices-data-stateful-applications/).

#### Service discovery

For container service discovery, specifically within a pod, Kubernetes does
not directly use Docker links as they don’t do well outside of a single
host. Also, managing links' lifecycle can prove to be difficult given Kubernetes'
current capabilities. Instead, to support  the concept of *services*
that resemble linking, Kubernetes offers two modes of discovery:
environmental variables and DNS.

If a Kubernetes service exists, then Kubernetes has a backward-compatible method
to create Docker-style link environment variables
in the container. You can read more about this at
[Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/), but
remember that we believe they’re implicit and hard to work with.
Kubernetes can
also create simplified environmental variables with the pattern
`{SVCNAME}_SERVICE_HOST` and
`{SVCNAME}_SERVICE_PORT`.

Another way to perform service discovery with Kubernetes is by using a DNS
server. The DNS server watches the Kubernetes API for new services and
creates a set of DNS records for each. If DNS has been enabled
throughout the cluster, then
all pods should be able to do name resolution of all services
automatically [(3)](#resources). The takeaway from this is that you don’t need to
explicitly create links between communicating pods as you would do natively in
Docker because Kubernetes does the heavy lifting, so long as you
use the networking mechanisms.

Lastly, remember that tools outside of Kubernetes, such as etcd, Zookeeper, and
Consul, are also viable options. These and others are discussed in
[Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/).

#### Networking

Kubernetes' networking model allows each pod to have an IP in a
flat networking space. Within that space, the pod can communicate with hosts and
containers across the cluster. In doing so, pods are similar to
any other node in the network with regards to “port management,
networking, naming, service discovery, load balancing, application
configuration, and migration” and can create a NAT-free address space;
this concept is known as the “IP-per-pod” model [(4)](#resources).

Because Kubernetes applies IP addresses at the pod scope,
containers within
a pod share their network namespaces, including their IP address.
This means that
containers within a pod can all reach each other’s ports on `localhost`.
This implies that containers within a pod must coordinate port usage,
but this is no different than processes in a virtual machine [(5)](#resources).

We can achieve the IP-per-pod model via the network
requirements imposed by Kubernetes by allocating each host (referred to as a *minion*) with
its own subnet in an overlay network that can enable containers to
communicate with the host and any other networks available in the
environment. A common network split is to allocate a
cluster-wide /16 network to the overlay, and then divide that cluster-wide network
into a /24 network for each minion in the cluster. Once you
lay out your network space, you can implement the overlay and configure a
new bridge for the Docker host to use within it. Some tools that are
great for this particular purpose, especially in a cloud environment,
are container-intended networking technologies such as Flannel, Weave,
SocketPlane and even Open vSwitch. Several of these tools are discussed in
[Introduction to container technologies: container networking]({{ site.baseurl }}/docs/best-practices/container-technologies-networking/).

This approach to networking is different from the standard Docker model.
In the standard Docker model, each
container gets an IP address in a host-private networking space as defined in
[RFC1918 Address Allocation for Private Internets]
(https://tools.ietf.org/html/rfc1918). For example, a container may be assigned
an IP address in the 172-dot space. Container IP addresses are managed by the
Docker host bridge. The effect of this is that containers can only communicate with
other containers on the same host, as opposed to also being able to
communicate with other machines in the network. Furthermore, it
is possible for conflicts and confusion to arise because different
Docker hosts can use the same network space and configuration.

### Community status

Kubernetes is the front-runner among tools for managing and orchestrating
containers in your stack.
See [Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/)
for a comparison of Kubernetes and competing tools.

Although Kubernetes is still at a Beta release level and claims not to be
production-ready yet, it has been widely adopted across the industry. Some of Kubernetes'
popularity appears to be based on the fact that it is developed by Google; respect for
the impressive contributors working on Kubernetes appears to be another factor.

In addition to the positive publicity in blog posts, the community is showing its vested
interest by participating in Kubernetes' development: as of April 2015, Kubernetes averaged
around 400-500 commits per week and a very substantial following of almost 300 contributors.

### Resources

Numbered citations in this article:

1. <http://kubernetes.io/v1.0/docs/user-guide/pods.html>

2. [Musings on Mesos: Docker, Kubernetes, and beyond](http://www.slideshare.net/timothysc/apache-coneu)

3. <http://kubernetes.io/v1.0/docs/user-guide/services.html>

4. <https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/design/networking.md>

5. <http://kubernetes.io/v1.0/docs/admin/networking.html>

Other recommended reading:

- <http://kubernetes.io/>

- [Docker best practices: data and stateful applications]({{ site.baseurl }}/docs/best-practices/docker-best-practices-data-stateful-applications/)

- [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)

- [Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/)

- [RFC1918 Address Allocation for Private Internets](https://tools.ietf.org/html/rfc1918)

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product
organization and is tasked with performing bleeding edge R&D and providing market analysis,
design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a
Solutions Architect with the intent of helping OpenStack become the open standard for cloud
management. At Rackspace, Mike has led the integration effort with strategic partner
RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud;
and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace,
Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin,
performing research and development in cybersecurity with regard to distributed systems, cloud,
and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
