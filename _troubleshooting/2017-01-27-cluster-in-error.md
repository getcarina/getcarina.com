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

When you initiate a task on a cluster, like create or resize, Carina performs that task asynchronously. That task may cause a cluster to go into the `error` status. The Carina team is automatically notified about every cluster that goes into the `error` status and someone is assigned to investigate. Our aim is to understand the root cause of these errors and prevent them so you have a robust and stable platform to build on.

However, at this time, we cannot move a cluster out of the `error` status and that cluster continues to count against your quota. Your best recourse is to delete the cluster and try again.

### Data

Carina is a beta service and we do not recommend storing data on your clusters. We cannot guarantee that your data will be recoverable from a cluster in `error`.

If you do have data on your cluster that you'd like to recover, it is still worthwhile to at least try connect to it using the instructions for your cluster type in [Create and connect to a cluster]({{site.baseurl}}/docs/getting-started/create-connect-cluster/). If you can connect, you may still be able to download your data.

To avoid this situation in the future, we recommend the following tutorials for Docker Swarm clusters.

* [Back up and restore container data]({{site.baseurl}}/docs/tutorials/backup-restore-data/)
* [Schedule regular backups using cron]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/)
* [Connect a Carina container to a Rackspace cloud database]({{ site.baseurl }}/docs/tutorials/data-stores-mysql-prod/)
* [Connect a Carina container to an ObjectRocket MongoDB instance]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb-prod/)

Tutorials for Kubernetes are forthcoming.
