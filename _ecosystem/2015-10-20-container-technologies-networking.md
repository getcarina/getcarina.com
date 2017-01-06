---
title: 'Introduction to container technologies: container networking'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-20
permalink: docs/best-practices/container-technologies-networking/
description: Compare tools for container networking
docker-versions:
topics:
  - best-practices
  - planning
---

*Use Weave to create a network in which Docker containers are part of the same virtual network switch, regardless of where they are running.*

In a robust application architecture, containers are connected to each other and to the rest
of your network. Adding a container-focused network tool, such as those introduced below, can help you establish and maintain a useful container configuration.

### Weave from Weaveworks

Weave "makes the network fit the application, not the other way round,"
as Weave co-founder Alexis Richardson puts it.
With Weave, Docker containers are all part
of a virtual network switch, regardless of where they are running. Services can
be selectively exposed across the network to the outside world through
firewalls and by using encryption for wide-area connections [(1)](#resources).

When using Weave, applications use the network just as if the containers
were all plugged into the same network switch, with no need to configure
port mappings, links, and so on. Services provided by application containers
on the Weave network can be made accessible to the outside world,
regardless of where those containers are running. Similarly, existing
internal systems can be exposed to application containers irrespective of
their location [(2)](#resources).

Richardson also stated that "Weave establishes per application
Layer 2 networks for containers across hosts, even across cloud providers
and other seemingly complex cases with minimum fuss" [(3)](#resources). Add this
functionality to the fact
that Weaveworks recently raised five million dollars in
Series A venture capital funding, and it makes a compelling argument for considering
Weave as a viable option.

### flannel from CoreOS

flannel is CoreOS’ primary way to manage container
networking. It establishes a private mesh network to enable the containers in a cluster to communicate with each other.
Because a mesh network connects devices to each other without any centralized organization,
configuration management issues such as port mapping, which can be complex in a large network of ephemeral containers, are not relevent with flannel.

In an overlay network, a virtual network runs in a layer above the physical network.
flannel creates an overlay mesh network that provisions a subnet to each server [(4)](#resources).
This is the main operating model that Kubernetes prescribes for all
minions and nodes that host containers. For more about networking and Kubernetes, read [Container ecosystem: Kubernetes]({{ site.baseurl }}/docs/best-practices/container-ecosystem-kubernetes/). Though flannel was originally intended for Kubernetes, it has
evolved into a generic overlay.

flannel is backed by and based on CoreOS’
etcd to serve as the key-value store for the networking configuration and
state management.

flannel is still in its early stages and development can be sporadic. It should be perceived as
experimental. However, do not disregard flannel’s presence in the market, as
their roadmap looks very optimistic given that CoreOS plans to be a big player in
the container space.

### Calico from Metaswitch

Project Calico integrates seamlessly with the cloud orchestration
system (such as OpenStack) to enable secure IP communication between
virtual machines. As VMs are created or destroyed, their IP addresses are
advertised to the rest of the network, and they are able to send and receive data
over IP just as they would with the native networking implementation – but with
higher security, scalability, and performance" [(5)](#resources).

In late 2014, the Calico team created a prototype of the Calico stack
that runs in Docker containers, in addition to a plugin that informs it
of all containers in the system. This prototype established as a proof
of concept that the networking model that Calico enables does work for containers.

Though the team seems to have some ideas as to how to proceed with
Calico and Docker, there are no short-term plans to evolve the prototype.
This has put the drive and initiative to do so into the hands of the
community. Calico is compatible with OpenStack Neutron [(6)](#resources).

### SocketPlane from SocketPlane

SocketPlane’s concept is to bring Open vSwitch
"production quality, multilayer virtual switch" [(7)](#resources) capabilities to the Docker host,
making it possible to
“have a container that’s going to be able to manage the data path and
also manage either overlays or underlays" [(8)](#resources).

However, few details have been published as SocketPlane is
in a semi-stealth mode. Its relevance and consideration as an option stems from the fact that its founders
are three very well known networking experts.
Madhu Venugopal, Brent Salisbury, and Dave Tucker left RedHat to start SocketPlane.
They also contribute to the OpenDaylight project,
developing an open source platform for building programmable, software-defined networks [(9)](#resources).

SocketPlane was purchased by Docker, Inc. in 2014, and they plan to
integrate SocketPlane into the Docker portfolio [(10)](#resources).
A "SocketPlane Technology Preview" is available at <https://github.com/socketplane/socketplane/blob/master/README.md>.
The concepts and the team behind SocketPlane predict that it could evolve
into a sound and promising technology.

### Native, multi-host Docker Overlay Networking

In late 2015, Docker [released the overlay networking feature](https://docs.docker.com/swarm/networking/) in Docker v1.9 and Swarm v1.0 to supply users with a native way to interconnect their Swarm containers with one another. The feature can create an overlay network using VXLAN tunneling, and is capable of standing up the tunnels automatically.

This feature was released as a plugin that can have its driver swapped with the overlay networking appliance of your choice, if you choose to do so, giving the user the ultimate flexibility in how they want to manage their containers networks.

If you want to hit the ground running, and want none of the setup hassle, this is a great staring point.

For more information, check out the [tutorial on overlay networks](https://getcarina.com/docs/tutorials/overlay-networks/)

### Comparison

It is very early in the Docker ecosystem to tell which
container networking solution will prevail, let alone which tools are
being used at production scale, as this space is quite new. Though
intriguing and backed by some powerful teams, flannel, Calico for
Docker, and SocketPlane all show signs that either not enough attention is
being given to the project or there have not yet been enough concrete features released to
seriously evaluate and test.

**Current Recommendation**: Native, multi-host Docker Overlay Networking for Docker-centric environments

### Resources

Numbered citations in this article:

1. <http://www.infoworld.com/article/2835222/application-virtualization/5-ways-docker-is-fixing-its-networking-woes.html>

2. <https://github.com/zettio/weave>

3. <http://www.eweek.com/cloud/weaveworks-raises-5-million-for-docker-container-networking.html>

4. [Introducing flannel: An etcd backed overlay network for containers](https://coreos.com/blog/introducing-rudder/)

5. <http://www.projectcalico.org/>

6. <http://www.sdxcentral.com/articles/news/madhu-venugopal-brent-salisbury-opendaylight-starts-open-shop-docker-startup/2014/10/>

7. <http://www.tomsitpro.com/articles/project-calico-networking-openstack-docker,1-2821.html>

8. <http://openvswitch.org/>

9. <https://www.opendaylight.org/lithium>

10. <http://thenewstack.io/docker-acquires-sdn-technology-startup-socketplane-io/>

Other recommended reading:

- [Container ecosystem: Kubernetes]({{ site.baseurl }}/docs/best-practices/container-ecosystem-kubernetes/)

- <http://www.projectcalico.org/getting-started/openstack/>

- <http://www.wired.com/2014/01/its-time-to-take-mesh-networks-seriously-and-not-just-for-the-reasons-you-think/>

- <http://searchsdn.techtarget.com/essentialguide/Overlay-networks-Understanding-the-basics-making-it-a-reality>

- <https://github.com/socketplane/socketplane/blob/master/README.md>

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
