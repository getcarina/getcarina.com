---
title: Introduction to container technologies: scheduling and management of services and resources
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/container-technologies-scheduling-management/
description: Introduction to container technologies, powered by the Rackspace Container Service
topics:
  - best-practices
  - planning
---

*For efficient isolation of resources facilitating different types of workloads and frameworks, use the Mesos distributed systems kernel.*

Within a container cluster, service and resource schedulers and managers
are tools that are
aware of the underlying resources available, are capable of placing
tasks across the cluster in
a specified and expected manner, abide by rules and constraints, and can
offer the ability to execute tasks and services.

In the container ecosystem, the need for specialized tools for service and resource scheduling  becomes evident in complex recurring situations such as:

- the lifecycle of installing and maintaining the Docker engine and its dependencies
- setting up the requirements needed by your applications
- servicing the system you implement for orchestration and management of your container cluster

To be clear, service/resource schedulers and managers do just that: they
allocate the resources needed to execute a job, such as the execution of
Docker containers.

However, by themselves, resource scheduling technologies should not be seen as options to
create a Platform-as-a-Service offering or to solely orchestrate a set of containers.
These tools serve a far
more basic purpose in respect to Docker services' requirements
such as load balancing, failure recovery,
deployment, and scaling;
these are handled by an actual orchestrator
sitting on top of your stack.

Therefore, just because they can run any
service or task from a simple ``hello world`` application to a much more
complex stack across a cluster to instantiating a Docker container
on said cluster, this does not mean that they should be fully in charge of
container orchestration.

The technologies described below are the current front-runners in the
industry with regards to service and resource scheduling.

### CoreOS’ “Fleet”

Fleet is a distributed initialization system based on CoreOS etcd and Linux systemd:

- etcd for its manifest of tasks
- systemd to do the task execution

Fleet can be seen as an extension
of systemd that operates at the cluster level and can be used to deploy
a systemd unit file anywhere on the cluster.

Fleet can automatically reschedule units in response to machine failure, and can abide
by policies such as ensuring that units are deployed together on the
same machine, forbidding colocation of some resources, and deploying to specific
machines based on metadata and attributes.

### Apache’s “Mesos”

Mesos is a distributed systems kernel. It is built using the same
principles as the Linux kernel but at a different level of abstraction.
The Mesos kernel runs on every machine and provides
APIs for resource management
and scheduling across entire datacenter and cloud environments
running applications such as Hadoop, Spark, Kafka, and Elastic Search
[(1)](#resources).

Mesos is a cluster manager that provides efficient isolation of
resources and is truly all about facilitating different types of
workloads and frameworks to run top of it.

Some of the biggest technology companies such as HubSpot and Twitter
are active users and advocates of Mesos.

### Comparison and recommendations

These tables compare Fleet and Mesos [(2)](#resources):

**Table 1: Design Comparison**

| Org    | Tool  | Req. Supplied Membership | Basic Task Orchestration | Advanced Task Orchestration | Up to  Hundreds of Hosts | Up to  Thousands of Hosts | Language |
|--------|-------|--------------------------|--------------------------|-----------------------------|--------------------------|---------------------------|----------|
| CoreOS | Fleet |             ✓            |             ✓            |                             |             ✓            |                           | Go       |
| Apache | Mesos |             ✓            |             ✓            |              ✓              |                          |             ✓             | C++      |

**Table 2: Functionality Comparison**

| Org    | Tool  | Architecture | Resource Aware | Host Constraints | Host Balancing | Group Affinity | Anti- Affinity | Global Scheduling |
|--------|-------|--------------|----------------|------------------|----------------|----------------|----------------|-------------------|
| CoreOS | Fleet | Monolithic   |                |         ✓        |                |        ✓       |        ✓       |         ✓         |
| Apache | Mesos | Two-level    |        ✓       |         ✓        |        ✓       |                |        ✓       |                   |

In terms of which technology to use:

- Fleet is new to the scene and has a decent community following, but
  it seems limited in its capabilities with regard to advance
  scheduling an health metrics. It’s also early in Fleet's development.

- Mesos is the front-runner with some heavy names utilizing it today
  in their infrastructure. Also, Mesosphere, the company that is
  commercializing Mesos and is a separate entity from Apache (the
  developer of Mesos) has currently started work on a Mesos
  framework to support Kubernetes [(3)](#resources) and has gotten a good amount of
  traction.

**Current Recommendation:** Mesos

<a name="resources"></a>
### Resources

Numbered citations in this article:

1. <http://mesos.apache.org/>

2. <http://gabrtv.github.io/deis-qconsf-2014/#/22>

3. <https://github.com/kubernetes/kubernetes/issues/6676>

Other recommended reading:

- <https://www.linux.com/learn/tutorials/788613-understanding-and-using-systemd>

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
