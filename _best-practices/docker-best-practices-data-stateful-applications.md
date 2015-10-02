---
title: Docker best practices: data and stateful applications
permalink: docs/_best-practices/docker-best-practices-data-stateful-applications/
description: Docker best practices, powered by the Rackspace Container Service
author: Mike Metral
date: 2015-10-01
topics:
  - best-practices
  - planning
---

*Never store data or logs in a container. Instead, use Docker volume mounts to create either a data volume or a data volume container.*

A natural way to begin learning what containers can provide is to build an
actual stack that could benefit from Docker.

A common use-case is a three-tier webapp with a
frontend, middle logic layer, and backend database. In such an application, the
frontend and middle logic layers are perfect fits to be containerized,
if they are stateless. However, for
stateful information such as a backend database layer or data in
general that needs to be preserved, used, and possibly written to logs,
containers are not the best match, yet.

## Datastore and logs

There are strong recommendations that you should never store data or
logs in a container as a container is likely to be short-­lived
and containers themselves are conceptually ephemeral, more so than
virtual machines. Instead, one should store the data and logs by leveraging
Docker’s volume mounts to create either a data volume or a data volume
container that is used and shared by other containers.

Using volume mounts creates a specially designed directory within one
or more containers that bypasses the Union File System and provides a
set of features for persistent and shared data:

- Volumes are initialized when a container is created. If the
  container's base image contains data at the specified mount point,
  that data is copied into the new volume.

- Data volumes can be shared and reused among containers.

- Changes to a data volume are made directly.

- Changes to a data volume are not included when an image is updated.

- Data volumes persist even if the container itself is deleted.

**Data volumes** are designed to persist data, independent of the
container's life cycle. Docker, therefore, *never* automatically
deletes volumes when you remove a container, nor will it "garbage
collect" volumes that are no longer referenced by a container [(1)](#resources).
Data volumes are created by either using the `-­v` flag in `docker run`,
or by using the `VOLUME` instruction in your Dockerfile.
Both options perform the same task: create a volume in the
container that is mapped to a directory on the host itself.
In both cases, the location of the volume is irrelevant to us.
The only variation is that, if you do care about the volume's location
from the host's perspective,
you can use the `-v` flag to request
mounting a particular file or directory from the host by
issuing a command such as `docker run –v /host/src/foobar:/opt/foobar`.

**Data volume containers** operate in a similar fashion to data volumes
but are designed to persist data that you want to share between
containers or that you want to use from non-persistent containers. To use a
data volume container with other containers, you begin by creating
it with something like `docker create -v /data –name datastore mysql`.
This command will
start a container and exit immediately, because it is used as a
container shell that references a newly created volume that other
containers will use, rather than an active process like other application
containers. After the data volume container exits, you can reference it
from other containers by using the `-- volumes-from` flag on the
subsequent containers such as: `docker run –d -volumes- from datastore
–name mywebapp foobar/webapp`. If you remove the datastore container or
the containers that reference it, this does not delete the volume where
your data is stored. To delete the volume from disk, you must explicitly
call `docker rm –v` against the last container with a reference to the
volume [(2)](#resources). This allows you to upgrade or effectively migrate data volumes
between containers or even the containers using the data volume
container with no worries of losing the data itself.

If you use volumes with containers, when you need to back up
a database or log that lives on the volume, which in turn lives on
the host, you can use your familiar tools on the host itself as you had
been doing in your organization before containers were implemented. After doing
so, you can carry out tasks such as upgrading the image itself by
shutting down the previous container and starting the updated one with
the same volume or volumes, or you can perform any other routine updates and
maintenance. In summary, the general rule of thumb is that if it gets
written to, it should be done in a volume.

Using a data volume container sounds like a great solution to the data
management issue, in theory. However, what happens when you want to
scale out where your data resides or when your host machine goes down
in events such as a restart due to maintenance or failure?
The current recommendation is what common sense might lead you to guess: move the
data management tasks to self-managed systems. For example, you can use
dedicated rsyslog servers for logs, or you can use redundant cloud
services such as cloud block storage and cloud database as a service
to persist your database. However, these could introduce concerns such as
cloud vendor lock-in and performance implications. Another strategy
is to integrate the data management back into the stateless
applications, but doing so only creates
the monolithic mess we’re trying to avoid in the first place with
containers.

In theory, we should be able to co-locate the stateless applications with the
data management services they rely on, with all of these services
running in containers, but Docker isn’t there quite yet and this
quickly becomes a whole different ballgame which Docker itself does
not touch. ClusterHQ is attempting to tackle this problem for
containers with their tool Flocker, by using ZFS as the foundation for
data management and replication. However, Flocker is still in very
early developmental stages, and it assumes you are accepting of
a clustered filesystem model and the nuances it can introduce such as
relying on a storage pool; Flocker can also cause I/O to take a performance
hit. However, Flocker is open-source and free to use if you care to
kick the tires and ClusterHQ seems to be making serious waves as a
leader on this front, so keeping tabs on them both is well-advised.

You can read more about Flocker and other orchestration tools at
[Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/).

For Docker to truly flourish as the new infrastructure stack that
powers the next web, containers need serious work mitigating the data
management problem. For now, it is suggested that you stick to the
traditional data management solutions that live outside of containers,
or strictly use data volumes as a means to map to a host directory or
a file that you can curate and manage external to
Docker.

## Block storage

Given the potential of Docker volumes to manage
your data, and the assumption that you are operating on a cloud
provider, it is only logical to think that one could use the
provider’s block storage as a service (for example, Rackspace Cloud Block Storage)
in conjunction with volume
mounts, if you decided to go down that route.

In theory, this sounds great; however, you could imagine the scenario
where you have several hundred containers running on a host, all
requiring an allocated and attached block device to mount their
individual volumes. In such a setting it is only a matter of time
before you hit a limit of some sort at the account level, or more
restrictively, at the service provider’s infrastructure level.
Exceeding an infrastructure's limit is a problem you might have run into whether or not
you were running containers; because people who run containers probably run large numbers of containers, they are likely to hit such limits sooner than otherwise.

However, you do have the option to map a data volume container to a
block storage device and share said container with other containers without having
to introduce an additional management layer.

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <https://docs.docker.com/userguide/dockervolumes/>

2. <http://docs.docker.com/userguide/dockervolumes/>

*Other recommended reading*

- <http://www.rackspace.com/cloud/block-storage>

- <http://unionfs.filesystems.org/>

- <https://developer.rackspace.com/blog/rsyslog-and-elasticsearch/>

- <http://www.rackspace.com/cloud/databases>

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
