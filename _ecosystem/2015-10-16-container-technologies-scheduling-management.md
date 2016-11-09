---
title: 'Introduction to container technologies: scheduling and management of services and resources'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-16
permalink: docs/best-practices/container-technologies-scheduling-management/
description: Compare options for scheduling and management
topics:
  - best-practices
  - planning
---

*For efficient isolation of resources facilitating different types of workloads and frameworks, use the Mesos distributed systems kernel.*

Within a container cluster, service and resource schedulers and managers are tools that track the availablity of underlying resources, place tasks across the cluster in a specified and expected manner, abide by rules and constraints, and offer the ability to execute tasks and services.

In the container ecosystem, the need for specialized tools for service and resource scheduling becomes evident in complex recurring situations such as:

- The lifecycle of installing and maintaining the Docker engine and its dependencies
- Setting up the requirements needed by your applications
- Servicing the system you implement for orchestration and management of your container cluster

To be clear, schedulers allocate the resources needed to execute a job, such as the execution of Docker containers, but it takes more than scheduling to create a Platform-as-a-Service offering. Schedulers assign work to resources; orchestrators ensure that the resources necessary to perform the work are available when needed. For example, if scheduled work requires load balancing, failure recovery, and scaling, an orchestrator creates an environment in which those services are available and then a scheduler can send work to make use of those services.

A scheduler can run any
service or task from a simple ``hello world`` application to instantiating a Docker container
on a cluster, but you are likely to need an orchestration tool to work with it; for some suggestions, read [Introduction to container technologies: orchestration and management of container clusters](../container-technologies-orchestration-clusters/).

The technologies described below are the current front-runners in the
industry with regard to service and resource scheduling.

### Apache’s Mesos

Mesos is a distributed systems kernel developed by Apache. It is built using the same
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
are active users and advocates of Mesos. Mesosphere's Datacenter Operating System (DCOS) is built on top of Mesos.

### CoreOS’ fleet

fleet is a distributed initialization system based on CoreOS etcd and Linux systemd:

- etcd for its manifest of tasks
- systemd to do the task execution

Jonathan Corbet explains fleet's use of etcd and systemd in this way:

> fleet is a cluster scheduler, meaning that its job is to distribute tasks across the machines in a cluster.
> It needs to respond to events like a machine going down and reschedule tasks as needed.
> The fleet scheduler gets its marching orders (the "manifest") via etcd, then gets systemd to do the real work.
> It is thus not surprising that fleet's commands look a lot like systemd commands [(2)](#resources).

Because systemd is part of Linux itself and interacting with fleet resembles interacting with systemd, learning fleet can seem natural and easy to those already skilled in Linux. You can think of fleet as an extension
of Linux systemd that operates at the cluster level and can be used to deploy
a systemd unit file anywhere on the cluster.

fleet can automatically reschedule units in response to machine failure, and can abide
by policies such as ensuring that units are deployed together on the
same machine, forbidding colocation of some resources, and deploying to specific
machines based on metadata and attributes.

### Comparison and recommendations

The following tables compare the design and functionality of fleet and Mesos [(3)](#resources):

**Table 1: Design Comparison**

<table>
  <thead>
    <tr>
      <th>Organization</th>
      <th>Tool</th>
      <th>Basic task orchestration</th>
      <th>Advanced task orchestration</th>
      <th>Up to 100s of hosts</th>
      <th>Up to 1000s of hosts</th>
      <th>Language</th>
    </tr>
  </thead>
  <tbody style="text-align: center;">
  <tr>
    <td>CoreOS</td>
    <td>fleet</td>
    <td class="table-cell-green">yes</td>
    <td></td>
    <td class="table-cell-green">yes</td>
    <td></td>
    <td>Go</td>
  </tr>
  <tr>
    <td>Apache</td>
    <td>Mesos</td>
    <td class="table-cell-green">yes</td>
    <td class="table-cell-green">yes</td>
    <td></td>
    <td class="table-cell-green">yes</td>
    <td>C++</td>
  </tr>
  </tbody>
</table>

**Table 2: Functionality Comparison**

<table>
  <thead>
    <tr>
      <th>Organization</th>
      <th>Tool</th>
      <th>Architecture</th>
      <th>Resource aware</th>
      <th>Host constraints</th>
      <th>Host balancing</th>
      <th>Group affinity</th>
      <th>Anti-affinity</th>
      <th>Global scheduling</th>
    </tr>
  </thead>
  <tbody style="text-align: center;">
    <tr>
      <td>CoreOS</td>
      <td>fleet</td>
      <td>Monolithic</td>
      <td></td>
      <td class="table-cell-green">yes</td>
      <td></td>
      <td class="table-cell-green">yes</td>
      <td class="table-cell-green">yes</td>
      <td class="table-cell-green">yes</td>
    </tr>
    <tr>
      <td>Apache</td>
      <td>Mesos</td>
      <td>Two-level</td>
      <td class="table-cell-green">yes</td>
      <td class="table-cell-green">yes</td>
      <td class="table-cell-green">yes</td>
      <td></td>
      <td class="table-cell-green">yes</td>
      <td></td>
    </tr>
  </tbody>
</table>

In terms of which technology to use:

- fleet has a strong community following, but
  it seems limited in its capabilities with regard to advance
  scheduling and health metrics. It’s also early in fleet's development.

- Mesos is the front-runner, utilized in the infrastructure of several large companies.
  Also, Mesosphere has started work on a Mesos framework to support Kubernetes [(4)](#resources)
  and seems to be making good progress.

**Current Recommendation:** Mesos

### Resources

Numbered citations in this article:

1. <http://mesos.apache.org/>

2. <https://lwn.net/Articles/617452/>

3. <http://gabrtv.github.io/deis-qconsf-2014/#/22>

4. <https://github.com/kubernetes/kubernetes/issues/6676>

Other recommended reading:

- [Introduction to container technologies: orchestration and management of container clusters](../container-technologies-orchestration-clusters/)

- <https://www.linux.com/learn/tutorials/788613-understanding-and-using-systemd>

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
