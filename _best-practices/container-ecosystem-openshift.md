---
title: Container ecosystem: OpenShift
permalink: docs/best-practices/container-ecosystem-openshift/
description: Best practices for container ecosystems, powered by the Rackspace Container Service
author: Mike Metral
date: 2015-10-01
topics:
  - best-practices
  - planning
---

*OpenShift can integrate with both OpenStack and Project Atomic, but OpenShift Enterprise may require top-to-bottom adoption of RedHat’s container and virtualization products.*

RedHat’s OpenShift has always been associated with managing your
applications at the Platform-as-a-Service (PaaS) layer.
With three OpenShift offerings--OpenShift
Online, OpenShift Enterprise, and OpenShift Origin--RedHat aims to claim a
stake in various markets. The differences between the three offerings are
best explained by identifying their primary purpose, which is either to compete
with more-established alternatives or to grow by attracting contributors:

- OpenShift Online [(1)](#resources) competes with
  Heroku [(2)](#resources) and Google App Engine [(3)](#resources).
- OpenShift Enterprise [(4)](#resources) competes with
  CloudFoundry [(5)](#resources).
- OpenShift Origin [(6)](#resources) is RedHat's open-source attempt at contributing to
  the community while
  benefiting from the enhancements that open source brings to the table.

With Kubernetes really paving the way as the standard for container
orchestration in the Docker world, RedHat has taken the stance with
the next release of their products, version 3, to really focus, adopt
and build on Kubernetes. In doing so, RedHat is not only betting on
Kubernetes as the future of container orchestration, along with the
rest of the community, but they are allowing themselves to leverage
their Project Atomic, which is their preferred hosting platform for
Docker containers that competes with CoreOS.

To learn more about Kubernetes and other tools for container orchestration, read
[Container ecosystem: Kubernetes](/container-ecosystem-kubernetes/) and
[Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/).

RedHat has stated that OpenShift is capable of integrating with both
OpenStack [(7)](#resources) and Project Atomic [(8)](#resources),
but given the nature of RedHat’s
previous business models, the OpenStack integration is most likely
inline with the intent of OpenShift Origin: to appease the open-source
community. It is possibile that considering OpenShift
Enterprise as a viable option for managing containers in a
mission-critical IT shop will require a full top-to-bottom
adoption of RedHat’s container and virtualization products, if both
types of workloads are aimed to be co-located. How OpenShift’s
adoption of Kubernetes plays out, especially in terms of
OpenShift's intent to be a wrapper for Kubernetes,
is sure to be an interesting story over the
in the long run of the “PaaS war”.

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <https://www.openshift.com/products/online>

2. <https://www.heroku.com/>

3. <https://cloud.google.com/appengine/docs>

4. <https://enterprise.openshift.com/>

5. <https://www.cloudfoundry.org/>

6. <https://www.openshift.org/>

7. <https://www.openstack.org/summit/openstack-summit-atlanta-2014/session-videos/presentation/openshift-the-state-of-the-art-paas-on-openstack>

8. <https://blog.openshift.com/openshift-v3-platform-combines-docker-kubernetes-atomic-and-more/>

*Other recommended reading*

- [Container ecosystem: Kubernetes](/container-ecosystem-kubernetes/)

- [Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/)

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
