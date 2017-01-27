---
title: Troubleshooting a cluster in error
author: Everett Toews <everett.toews@rackspace.com>
date: 2017-01-27
featured: true
permalink: docs/troubleshooting/cluster-in-error/
description: Troubleshooting a cluster in error on Carina
docker-versions:
  - 1.11.2
kubernetes-versions:
  - 1.4.5
topics:
  - troubleshooting
---

When you initiate a task on a cluster, like create or resize, Carina performs that task asynchronously. That task may cause a cluster to go into the `error` status. The Carina team is automatically notified about every cluster that goes into the `error` status and someone is assigned to investigate. Our aim is to understand the root cause of these errors and mitigate them so you have a robust and stable platform to build on.

However, at this time, we cannot move a cluster out of the `error` status and that cluster continues to count against your quota. Your only recourse is to delete the cluster and try again.
