---
title: Introduction to container technologies: registration and discovery of container services
permalink: docs/best-practices/container-technologies-registration-discover/
description: Introduction to container technologies, powered by the Rackspace Container Service
author: Mike Metral
date: 2015-10-01
topics:
  - best-practices
  - planning
---

*For service discovery and shared configuration, use the etcd distributed key/value store.*

Service registration discovery is the centerpiece in systems that are
both distributed and service-oriented. Pinpointing how nodes in a cluster
can register, discover and determine the necessary services available,
and the means by which they can communicate with said service is the
heart of the problem that service discovery technologies aim to solve.

In an active environment, containers are constantly being commissioned
and decommissioned based on needs, standards, maintenance and failures.
As you scale out your container architecture, keeping track of all the
services in a static manner
simply won’t cut it, and a dynamic means of avoiding disturbance or
disruption to your services is required.

The technologies described below are the current front-runners in the
industry with regards to service registration and service
discovery.

## Apache’s “Zookeeper”

Zookeeper is a distributed configuration service synchronization service
and naming registry for large distributed systems. ZooKeeper was a
sub-project of Hadoop but is now a top-level project in its own right.

Zookeeper configurations are designed to provide consistency (all nodes see the same data at the same time) and partition tolerance (operation continues despite partitioning caused by network failures).
Zookeeper uses the Zookeeper Atomic Broadcast (ZAB) protocol to coordinate changes across the
cluster [(1)](#resources).

Many projects use Zookeeper, including Hadoop’s HBase, Yahoo, and
Rackspace’s Email & Apps.

## CoreOS’ “etcd”

Etcd is a distributed key/value store used for service discovery and shared
configuration. It is aimed to be a simple implementation of the Raft
consensus algorithm, particularly, with regards to agreements on
election cycle and leader nomination, as well as manipulation of data.

Etcd configurations are designed to provide consistency (all nodes see the same data at the same time) and partition tolerance (operation continues despite partitioning caused by network failures).
Etcd chooses consistency over availability, specifically
sequential consistency based on a quorum of nodes.

Many projects use etcd, including Google's Kubernetes, Pivotal's Cloud
Foundry, Rackspace's Mailgun, Apache's Mesos, and Mesosphere's DCOS [(2)](#resources).

## Hashicorp’s “Consul”

Consul is a tool for service discovery and configuration. It is distributed,
highly available, and extremely scalable. Key features include:

- **service discovery:** Consul makes it simple for services to
  register themselves and to discover other services via DNS or HTTP
  interface. External services such as SaaS providers can be
  registered as well.

- **health checking:** health checking enables Consul to quickly
  alert operators about any issues in a cluster. The integration with
  service discovery prevents routing traffic to unhealthy hosts and
  enables service level circuit breakers.

- **key/value storage:** Flexible key/value store enables
  dynamic configuration, feature flagging, coordination, leader
  election and more. The simple HTTP API makes it easy to use
  anywhere.

- **multi-datacenter:** Consul is built to be datacenter-aware
  and can support any number of regions without complex
  configuration [(3)](#resources).

Consul implements the Raft consensus algorithm [(4)](#resources).
Consul configurations are designed to provide consistency (all nodes see the same data at the same time) and partition tolerance (operation continues despite partitioning caused by network failures).

In a limited search, public projects or companies using Consul were not found.

## Comparison and recommendations

| Org       | Tool      | Client/Server  Architecture | Primitive Key/Value Store | Basic  Service Discovery | Advanced Service Discovery | Consistency | Language |
|-----------|-----------|-----------------------------|---------------------------|--------------------------|----------------------------|-------------|----------|
| Apache    | Zookeeper |              ✓              |             ✓             |             ✓            |                            |      ✓      | Java     |
| Hashicorp | Consul    |              ✓              |             ✓             |                          |              ✓             |      ✓      | Go       |
| CoreOS    | Etcd      |              ✓              |             ✓             |             ✓            |                            |      ✓      | Go       |

**Table 1 -­‐ Service Registration & Discovery Comparison**

Note: Basic vs. Advanced Service Discovery revolves around the notion
that in an advanced setting, the technology has more service
monitoring and health-checking capabilities.

In terms of which technology to use:

- Zookeeper has been around longer and thus is considered to be mature,
  but its dependency and usage of Java tends to deter many users. It
  is also worth noting many think that it may be starting to show some
  age and its adaptability into cloud infrastructures isn’t the
  easiest process as its proven to be complicated, hard to work with
  and troubleshoot.

- Etcd and Consul are both new to the scene, but etcd is slightly older
  than Consul and the community seems to be favoring as well as
  using etcd far more.

**Current Recommendation** etcd

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <https://cwiki.apache.org/confluence/display/ZOOKEEPER/Zab1.0>

2. <https://coreos.com/blog/etcd-2.0-release-first-major-stable-release/>

3. <https://github.com/hashicorp/consul>

4. https://raft.github.io/

*Other recommended reading*

- <http://www.infoq.com/articles/cap-twelve-years-later-how-the-rules-have-changed>

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
