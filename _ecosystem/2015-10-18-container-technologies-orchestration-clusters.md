---
title: 'Introduction to container technologies: orchestration and management of container clusters'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-18
permalink: docs/best-practices/container-technologies-orchestration-clusters/
description: Compare options for orchestration and management of container clusters
docker-versions:
topics:
  - best-practices
  - planning
---

*The best tool for orchestration and management of container clusters varies with the size of the cluster. Kubernetes and Marathon excel with thousands of hosts while Compose is ideal for a single host.*

Orchestrating and managing a cluster of Docker containers is an emerging
trend that is very competitive and evolving rapidly. Many options currently exist with
various feature sets. Some of those feature sets overlap, making it challenging to choose between seemingly similar tools.

One way to make a useful choice is to focus your investigation on tools that are designed primarily for the container ecosystem layers of most interest to you.

![Strata of the container ecosystem]({% asset_path best-practices/orchestration-clusters/container-ecosystem.svg %})

As shown in the figure above, the following are the ecosystem layers:

- Layer 7 = Workflow

- Layer 6 = Orchestration

- Layer 5 = Scheduling

- Layer 4 = Container engine

- Layer 3 = Operating system

- Layer 2 = Virtual infrastructure

- Layer 1 = Physical infrastructure

Kubernetes and Marathon are leaders in the container orchestration layer.
For other container management activities such as workflow and scheduling, leaders include Deis and Mesos [(1)](#resources).
OpenStack also offers features that are especially relevant at scheduling and virtual infrastructure layers.

Another basis for comparison is a tool's ability to offer features beyond simple orchestration as shown in the following figure:

- Docker Compose is in the intersection between traditional platform as a service (PaaS) and container orchestration.

- Flynn is in the intersection between traditional PaaS and specialized offerings such as stateful  applications.

- Flocker is in the intersection between specialized offerings and container orchestration.

![Intersections between PaaS, container orchestration, and specialized offerings]({% asset_path best-practices/orchestration-clusters/containers-orchestration.svg %})

Following is a discussion of notable open-source container orchestration engines and managers, along with a summary of what they each aim to achieve. This is a general introduction to those tools. Before you adopt any of them, you should perform your own careful analysis of which option to choose given the use case that you intend to fulfill and the scale at which you want to operate.

### Marathon from Mesosphere

Marathon is a cluster-wide initiation and control system for services in
cgroups (Linux kernel control groups) or Docker containers. It requires and is based on Apache Mesos
and the Mesosphere Chronos job scheduler framework. Whereas Mesos operates as the
kernel for your data center, Marathon serves as a cluster’s init
or upstart daemon. Marathon has a UI and a REST API for managing and
scheduling Mesos frameworks, including Docker containers.

Marathon is a *meta framework*. You can start other Mesos frameworks
with it. It can launch anything that can be launched in a standard shell.
You can even start other Marathon instances via Marathon [(2)](#resources).
Because Marathon is a framework built on Mesos, it is comparable
to Clocker, which is itself a blueprint (analogous to a framework)
for Apache’s Brooklyn.

Because of its flexibility, Marathon can operate as a cluster-wide
process supervisor. Marathon operates as a private PaaS through
functionality that includes service discovery, failure handling, deployment, and scalability.

Deimos, also from Mesosphere, is a plug-in for Mesos that enables it to work with Docker.
Deimos provides external containerization.
Marathon, based on Mesos, uses the Deimos plug-in.
This combination of frameworks allows Marathon to
become an orchestration and management layer for Docker containers and
provides the key services and dependencies one would expect in
those toolsets.

You can read more about how Mesos relates to Docker in
[Container ecosystem: Mesos versus OpenStack]({{ site.baseurl }}/docs/best-practices/container-ecosystem-mesos-openstack/).

Major companies using Marathon include Airbnb, eBay,
Groupon, OpenTable, PayPal, and Yelp.

### Kubernetes from Google

Kubernetes is a system for managing containerized applications in clusters
across multiple hosts. It provides basic mechanisms for deployment,
maintenance, and scaling of applications.

Specifically, Kubernetes provides the following features:

- Uses Docker to package, instantiate, and run containerized
  applications.

- Establishes robust declarative primitives for maintaining the
  desired state requested by the user. Because it has active controllers, not
  just imperative orchestration, it enables self-healing mechanisms
  such as automatically restarting, re-scheduling,
  and replicating containers.

- Targets applications that comprise multiple
  containers, such as elastic, distributed microservices.

- Enables users to ask a cluster to run a set of containers.
  The system automatically chooses hosts on which to run those containers,
  using a scheduler that is policy rich, topology aware, and workload specific.

You can read more about how Kubernetes relates to Docker and Mesos at
[Container ecosystem: Kubernetes]({{ site.baseurl }}/docs/best-practices/container-ecosystem-kubernetes/).

Kubernetes builds upon a decade and a half of experience at Google running
production workloads at scale, combined with best-of-breed ideas and
practices from the community. It is written in Golang and is lightweight,
modular, portable, and extensible [(3)](#resources).

#### Kubernetes concepts

Following are some of the key ideas behind Kubernetes:

- **Pods:** A way to co-locate group containers with shared
  volumes. A pod is a collocation of one or more
  containers sharing a single IP address, multiple volumes, and a
  single set of ports.

- **Replication controllers:** A way to handle the life cycle of pods.
  By creating or removing pods as required, replication controllers
  ensure that a specified number of pods are running at any given time.

- **Labels:** A way to organize and select groups of objects based on a
  key-value pair.

- **Services:** A set of containers performing a common function with a
  single, stable name and address for a set of pods. Services act like a
  basic load balancer [(4)](#resources).

#### Comparing Kubernetes and Mesos

The increasing popularity of Kubernetes has forced many comparisons of Kubernetes to
Mesos, which has been the leader in cluster-oriented development and
management for the past couple of years.

Kubernetes is an opinionated declarative model of how to address
microservices, and Mesos is the layer that provides an imperative
framework by which developers can define a scheduling policy in a
programmatic fashion. When leveraged together, they provide a
data center with the ability to do both.

Although their basic visions have some overlap,
Kubernetes and Mesos differ in important ways.
The products are at different points in their
lifecycles and focus on meeting different needs. Mesos is a distributed
systems kernel that stitches together many different machines into
a logical computer. It was created for a world in which you own many
physical resources and can combine them to create a big static computing cluster.

Many modern scalable data processing
applications (such as Hadoop, Kafka, and Spark) run well on Mesos,
and you can run them all on the same basic resource pool, along
with modern container-packaged applications. Mesos is somewhat more heavyweight than
Kubernetes, but is getting easier to manage because of the work of companies like Mesosphere.

Mesos is currently being
adapted to incorporate many Kubernetes concepts and to support the
Kubernetes API. So Mesos will provide a way to get more capabilities
for your Kubernetes application, such as a high-availability master, more advanced
scheduling semantics, and the ability to scale to a very large number of
nodes. This will make Mesos well suited to run production
workloads.

Some say Kubernetes and Mesos can be a good match:

- Kubernetes enables the pod, along with labels for service discovery,
  load-balancing, and replication control.
- Mesos provides the fine-grained resource allocations for pods across nodes in a cluster
  and facilitates resource sharing among Kubernetes and other frameworks
  running on the same cluster [(5)](#resources).

However, Mesos can be replaced by
OpenStack. If you have adopted Openstack, the dependency on and
usage of Mesos can be eliminated.

#### Best fits for Kubernetes

Kubernetes is currently a best fit for
typical web applications and stateless applications.
It is in
pre-production beta status. However, Kubernetes is one of the most active and
tracked projects on GitHub. You can expect many changes in not only its
functionality, stability, and supported use cases, but also in the number
of technologies working to become highly interoperable with Kubernetes.

### Compose from Docker

Compose, known as “Fig” before its acquisition by Docker, Inc., is a simple
orchestration framework intended to allow the definition of fast,
isolated development environments for Docker containers.

You can run Compose on Mac OS X and 64-bit Linux.
It is not supported on Windows [(6)](#resources).

Its real advantage is for applications that revolve around a single-purpose
server that could easily scale out if
architectural complexity is not a requirement. Development environments,
which tend to use an all-in-one method of operation,
fit well into this requirement. This makes Compose an obviously viable
option for software developers.

Based on use cases, something as simple as Compose might be sufficient.
However, because a solution such as Compose has both limited capabilities and overhead, teams can decide to independently develop micro-solutions of this kind for the sake of not taking on extra overhead in their stack.

The community's reception of Compose has been notably positive, but the practicality of its usage and the lack of ability to create a long-term vision around it tend to minimize the actual legitimacy of adopting it as a container orchestration technology.

### Flynn from Price Directive

Prime Directive labels Flynn as "the product that ops provides to
developers" [(7)](#resources). They believe that “ops should be a product team, not
consultants” and that “Flynn is the single platform that ops can provide
to developers to power production, testing, and development, freeing
developers to focus.”

Flynn is an open-source Platform-as-a-Service built from pluggable components that you
can mix and match however you want. Out of the box, Flynn resembles a cloud application platform such as [Heroku](https://www.heroku.com/), but a Heroku that you can self-host and that
allows you to
replace the pieces you choose with whatever you need.

Flynn differs from other PaaS like Heroku, Cloud
Foundry, Deis, or Dokku in that “the other PaaS technologies mainly focus on
scaling a stateless app tier. They may run one or two persistent services for you, but for the most
part you are on your own to figure that part out. Flynn is really trying
to solve the state problems, which is pretty unique" [(8)](#resources).

With regard to stateful management,
particularly in databases, Flynn supports Postgres. Offering automated backup, automated failover, zero downtime, and no configuration effort, Flynn's goal
is to manage your database service for you.
To learn more about working with data and stateful applications in containers, read [Docker best practices: data and stateful applications]({{ site.baseurl }}/docs/best-practices/docker-best-practices-data-stateful-applications/).

Sponsors and users of Flynn include but are not limited to Coinbase,
Shopify, and CenturyLink.

### Deis from OpDemand

Deis is an open-source PaaS that facilitates the deployment and
management of applications. It is built on Docker and CoreOS, including etcd,
fleet, and the operating system itself, to "provide lightweight PaaS with
Heroku-inspired workflow" [(9)](#resources).
To learn more about the need for container-focused operating systems such as CoreOS, read [Introduction to container technologies: container operating systems]({{ site.baseurl }}/docs/best-practices/container-technologies-operating-systems/).

Deis can deploy an application or service that works in a Docker container, and its
structure mimics Heroku’s 12-factor stateless methodology for how applications
should be created and managed. Deis also leverages Heroku’s Buildpacks
and comes with out-of-the-box support for Ruby, Python, Node.js,
Java, Clojure, Scala, Play, PHP, Perl, Dart, and Go.

Much like Flynn, Deis resembles a Heroku clone that you can
self-host. However, Deis lacks persistent storage and state-aware
support for use cases such as databases. Instead, Deis depends on a third-party
cloud database solution. In this regard, Flynn seems to be ahead of
Deis as the front-runner in Heroku-like projects.

Users of Deis include small and medium size businesses and technology companies, but
no major companies have announced their use of it.

### Flocker from ClusterHQ

Flocker is an open-source data volume and multihost container manager that supports and works with the file format syntax used by Docker’s Compose.
Docker works well with applications such as
front-end or API servers, which use shared storage and are replicated
or made highly available.
Flocker offers the same portability for applications with systems
such as databases and messaging or queuing systems. State management in
containers is still an incomplete feature that is missing in the
community, giving Flocker an opportunity to meet this need.

The advantage of Flocker seems to be centered on its data management
features; Flocker has proclaimed itself the leader in this area.
However, although it appears to be the front-runner in datastore-centric models,
full support of data in many use cases is still a work in progress
and some operations can only be performed by undergoing downtime of some capacity.

Flocker alleviates the issue of managing data for containers by
using Zettabyte File System (ZFS) replication technology as the underlying technology for containers' attached datastore, with ZFS handling volume behaviors [(10)](#resources).
However, Flocker is still in very
In addition to the ZFS properties, Flocker imposes a network proxy across
all of the Flocker nodes to handle container linking, storage mapping,
and user interaction throughout the cluster.

### Clocker from Cloudsoft

Clocker is an open-source project that enables users to establish a Docker Cloud over any cloud or fixed infrastructure
without generating excess containers [(11)](#resources). The project is built on top of Apache Brooklyn, which is undergoing incubation at the Apache Software Foundation as a tool for modeling, deploying, and managing multi-cloud application software.

Following are some features of Clocker:

- Automatic creation and management of multiple Docker hosts in cloud
  infrastructure.

- Intelligent container placement, providing fault tolerance, easy
  scaling, and efficient use of resources.

- Use of any public or private cloud as the underlying infrastructure for
  Docker Hosts.

- Deployment of Brooklyn/CAMP (Cloud Application Management for Platforms)
  blueprints to Docker locations, without modifications.

Clocker uses Apache Brooklyn to create a Docker cloud [(12)](#resources).
Brooklyn uses Apache jclouds, a multicloud toolkit, to
provision and configure secure communications (SSH) with cloud virtual
machines. The Docker architecture provides containers on host
machines. Brooklyn provisions cloud machines using jclouds and uses
them as Docker hosts.

Brooklyn uses Dockerfile to make an SSH server available in each
Docker container, after which the container can be treated like any virtual
machine. Brooklyn receives sensor data from the application, every Docker
host, every Docker container, and every software component making up the
application, and it can make changes in each of these. This enables Brooklyn to
manage distribution of the application across the Docker cloud [(13)](#resources).

In short, Brooklyn is a platform that monitors and manages Docker
containers using YAML blueprints for its configuration
instructions. Clocker then is essentially a blueprint for Brooklyn with
extra intelligence for configuring and managing Docker hosts and
containers.

### Swarm from Docker

Swarm aims to provide a common interface for the many
orchestration and scheduling frameworks available. It serves as a
clustering and scheduling tool that optimizes the infrastructure based
on requirements of the application and performance. Solomon Hykes, CTO of
Docker, stated, “Docker will give devs a standard interface to all
[orchestration tools] and [Swarm] is an ingredient of that standard
interface. [It] can be thought of as the glue between Docker and orchestration
backends” [(14)](#resources).

Swarm is designed to provide a smooth Docker deployment workflow,
working with some existing container workflow frameworks such as Deis,
but flexible enough to yield to heavyweight deployment and resource
management such as Mesos. It is said to be a very simple add-on to
Docker. It currently not as comprehensive as Kubernetes, and its
place in the ecosystem is still to be determined.

### Comparison and recommendations

Following are tables identifying which orchestration tools are
best suited for configurations of different sizes [(Table 1)](#compare-sizes)
and comparing key elements of their functionality [(Table 2)](#compare-features):

<a name="compare-sizes"></a>
**Table 1 -‐ Size comparison of container orchestrators and managers**

<table>
 <thead>
   <tr>
    <th>Organization</th>
    <th>Tool</th>
    <th>One host (nano)</th>
    <th>Up to 10s of hosts (micro)</th>
    <th>Up to 100s of hosts (medium)</th>
    <th>Up to 1000s of hosts (large)</th>
  </tr>
 </thead>
 <tbody style="text-align: center;">
  <tr>
   <td>Docker</td>
   <td>Compose</td>
   <td class="table-cell-green">yes</td>
   <td></td>
   <td></td>
   <td></td>
  </tr>
  <tr>
   <td>Prime Directive</td>
   <td>Flynn</td>
   <td></td>
   <td class="table-cell-green">yes</td>
   <td></td>
   <td></td>
  </tr>
  <tr>
   <td>OpDemand</td>
   <td>Deis</td>
   <td></td>
   <td class="table-cell-green">yes</td>
   <td></td>
   <td></td>
  </tr>
  <tr>
   <td>ClusterHQ</td>
   <td>Flocker</td>
   <td></td>
   <td class="table-cell-green">yes</td>
   <td></td>
   <td></td>
  </tr>
  <tr>
   <td>CloudSoft</td>
   <td>Clocker</td>
   <td></td>
   <td></td>
   <td class="table-cell-green">yes</td>
   <td></td>
  </tr>
  <tr>
   <td>Mesosphere</td>
   <td>Marathon</td>
   <td></td>
   <td></td>
   <td></td>
   <td class="table-cell-green">yes</td>
  </tr>
  <tr>
   <td>Google</td>
   <td>Kubernetes</td>
   <td></td>
   <td></td>
   <td></td>
   <td class="table-cell-green">yes</td>
  </tr>
 </tbody>
</table>

<p> </p>

<a name="compare-features"></a>
**Table 2 -‐ Functionality comparison of container orchestrators and managers**

<table class="condensed">
 <thead>
  <tr>
   <th>Organization</th>
   <th>Tool</th>
   <th>Cluster state management</th>
   <th>Monitoring &amp; healing</th>
   <th>Deploy spec</th>
   <th>Allows Docker dependency &amp; architectural mapping</th>
   <th>Deployment method</th>
   <th>Language</th>
  </tr>
 </thead>
 <tbody style="text-align: center;">
  <tr>
   <td>Docker</td>
   <td>Compose</td>
   <td></td>
   <td></td>
   <td>Dockerfile + YAML manifest</td>
   <td class="table-cell-green">yes</td>
   <td>CLI</td>
   <td>Python</td>
  </tr>
  <tr>
   <td>Prime Directive</td>
   <td>Flynn</td>
   <td></td>
   <td></td>
   <td>Procfile, Heroku Buildpack</td>
   <td></td>
   <td>Git push</td>
   <td>Go</td>
  </tr>
  <tr>
   <td>OpDemand</td>
   <td>Deis</td>
   <td></td>
   <td></td>
   <td>Dockerfile, Heroku Buildpack</td>
   <td></td>
   <td>Git push</td>
   <td>Go</td>
  </tr>
  <tr>
   <td>ClusterHQ</td>
   <td>Flocker</td>
   <td class="table-cell-green">yes</td>
   <td></td>
   <td>Dockerfile + YAML manifest</td>
   <td class="table-cell-green">yes</td>
   <td>CLI</td>
   <td>Python</td>
  </tr>
  <tr>
   <td>CloudSoft</td>
   <td>Clocker</td>
   <td class="table-cell-green">yes</td>
   <td class="table-cell-green">yes</td>
   <td>Apache Brooklyn YAML blueprint + Dockerfile</td>
   <td class="table-cell-green">yes</td>
   <td>API / Web</td>
   <td>Java</td>
  </tr>
  <tr>
   <td>Mesosphere</td>
   <td>Marathon</td>
   <td class="table-cell-green">yes</td>
   <td class="table-cell-green">yes</td>
   <td>JSON</td>
   <td class="table-cell-green">yes</td>
   <td>API / CLI</td>
   <td>C++</td>
  </tr>
  <tr>
   <td>Google</td>
   <td>Kubernetes</td>
   <td class="table-cell-green">yes</td>
   <td class="table-cell-green">yes</td>
   <td>YAML / JSON</td>
   <td class="table-cell-green">yes</td>
   <td>API / CLI</td>
   <td></td>
  </tr>
 </tbody>
</table>

<p> </p>

**Current Recommendation:** Kubernetes

### Resources

Numbered citations in this article:

1. <https://pbs.twimg.com/media/B33GFtNCUAE-vEX.png:large>

2. <https://github.com/mesosphere/marathon>

3. <https://github.com/GoogleCloudPlatform/kubernetes>

4. <http://stackoverflow.com/questions/26705201/whats-the-difference-between-apaches-mesos-and-googles-kubernetes>

5. <https://github.com/mesosphere/kubernetes-mesos/blob/master/README.md>

6. <https://docs.docker.com/compose/install/>

7. <https://flynn.io/>

8. <http://www.centurylinklabs.com/interviews/what-is-flynn-an-open-source-docker-paas/>

9. <http://deis.io/overview/>

10. <http://www.eweek.com/virtualization/clusterhq-brings-docker-virtualization-to-data-storage.html>

11. <http://www.cloudsoftcorp.com/community/>

12. <http://www.cloudsoftcorp.com/blog/2014/06/clocker-creating-a-docker-cloud-with-apache-brooklyn/>

13. <http://www.infoq.com/news/2014/06/clocker>

14. <https://twitter.com/solomonstre/status/492111054839615488>

Other recommended reading:

- [Docker best practices: data and stateful applications](../docker-best-practices-data-stateful-applications/)

- [Introduction to container technologies: container operating systems](../container-technologies-operating-systems/)

- [Container ecosystem: Kubernetes](../container-ecosystem-kubernetes/)

- [Container ecosystem: Mesos versus OpenStack](../container-ecosystem-mesos-openstack/)

- <https://www.heroku.com/>

- <http://12factor.net/>

- <https://elements.heroku.com/buildpacks>

- <https://brooklyn.incubator.apache.org/>

- <https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=camp#technical>

- <https://jclouds.apache.org/>

- <http://yaml.org/>

- <https://github.com/mesosphere/deimos>

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. You can follow him in GitHub at https://github.com/metral and at Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
