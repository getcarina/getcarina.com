---
title: 'Container ecosystem: OpenShift'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-23
permalink: docs/best-practices/container-ecosystem-openshift/
description: Explore the place of RedHat OpenShift in the container ecosystem
topics:
  - best-practices
  - planning
---

*OpenShift can integrate with both OpenStack and Project Atomic, but OpenShift Enterprise might
require top-to-bottom adoption of RedHat’s container and virtualization products.*

RedHat’s OpenShift has always been associated with managing your
applications at the Platform-as-a-Service (PaaS) layer.
With three OpenShift offerings--OpenShift
Online, OpenShift Enterprise, and OpenShift Origin--RedHat aims to claim a
stake in various markets.

### Three kinds of OpenShift

The differences between the three offerings are
best explained by identifying their primary purpose, which is either to compete
with more-established alternatives or to grow by attracting contributors:

- OpenShift Online [(1)](#resources) competes with
  Heroku [(2)](#resources) and Google App Engine [(3)](#resources).
- OpenShift Enterprise [(4)](#resources) competes with
  CloudFoundry [(5)](#resources).
- OpenShift Origin [(6)](#resources) is RedHat's open-source attempt at contributing to
  the community while
  benefiting from the enhancements that open source brings to the table.

### OpenShift and Kubernetes

With Kubernetes paving the way as the standard for container
orchestration in the Docker world, RedHat's newest release of OpenShift, version 3, focuses on adopting
and building on Kubernetes. In doing so, RedHat is not only betting on
Kubernetes as the future of container orchestration, but they are also able to leverage
Project Atomic, their preferred hosting platform for
Docker containers that competes with CoreOS.

To learn more about Kubernetes and other tools for container orchestration, read
[Container ecosystem: Kubernetes]({{ site.baseurl }}/docs/best-practices/container-ecosystem-kubernetes/) and
[Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/).

### OpenShift, OpenStack, and Project Atomic

RedHat has stated that OpenShift is capable of integrating with both
OpenStack [(7)](#resources) and Project Atomic [(8)](#resources),
but given the nature of RedHat’s
previous business models, the OpenStack integration is most likely
inline with the intent of OpenShift Origin: to appease the open-source
community. As Diane Mueller explains [(7)](#resources), OpenShift Origin serves as the upstream source for OpenShift Enterprise, enabling integration that begins in OpenShift Origin to make its way to OpenShift Enterprise as the OpenShift team deems appropriate.

It is possible that considering OpenShift
Enterprise for managing containers in a
mission-critical IT shop will require a full top-to-bottom
adoption of RedHat’s container and virtualization products, if both
types of workloads will be co-located.

### Resources

Numbered citations in this article:

1. <https://www.openshift.com/products/online>

2. <https://www.heroku.com/>

3. <https://cloud.google.com/appengine/docs>

4. <https://enterprise.openshift.com/>

5. <https://www.cloudfoundry.org/>

6. <https://www.openshift.org/>

7. <https://www.openstack.org/summit/openstack-summit-atlanta-2014/session-videos/presentation/openshift-the-state-of-the-art-paas-on-openstack>

8. <https://blog.openshift.com/openshift-v3-platform-combines-docker-kubernetes-atomic-and-more/>

Other recommended reading:

- [Container ecosystem: Kubernetes]({{ site.baseurl }}/docs/best-practices/container-ecosystem-kubernetes/)

- [Introduction to container technologies: orchestration and management of container clusters]({{ site.baseurl }}/docs/best-practices/container-technologies-orchestration-clusters/)

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product
organization and is tasked with performing bleeding edge R&D and providing market
analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace
in 2012 as a Solutions Architect with the intent of helping OpenStack become the open
standard for cloud management. At Rackspace, Mike has led the integration effort with
strategic partner RightScale; aided in the assessment, development, and evolution of
Rackspace Private Cloud; and served as the Chief Architect of the Service Provider
Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National
Laboratories, a subsidiary of Lockheed Martin, performing research and development in
cybersecurity with regard to distributed systems, cloud, and mobile computing.
Follow Mike on [Twitter](https://twitter.com/@mikemetral).
