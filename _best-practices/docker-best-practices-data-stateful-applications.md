---
title: 'Docker best practices: data and stateful applications'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/docker-best-practices-data-stateful-applications/
description: Explore best practices for handling data or logs
docker-versions:
topics:
  - best-practices
  - planning
---

*Never store data or logs in a container. Instead, use Docker volume mounts to create either a data volume or a data volume container.*

A natural way to begin learning what containers can provide is to build an
actual stack for a containerized application that could benefit from Docker.

Containers are ideal for stateless applications, meaning that data generated in one session is not recorded for use in another session.
However, many applications require some ability to record user session activity, making some aspects of the application stateful.
Because containers facilitate separation of concerns in a complex application, stateless and stateful aspects of an application can each be configured optimally.

A common use case is a three-tier web application with a
user interface at the front end,
a logic layer in the middle,
and a database at the backend.
In such an application, the
frontend and middle logic layers, if they are stateless, are perfect fits to be containerized.
However, for
stateful information such as a backend database layer, or for any data that must be preserved or reused, containers are not the best match.

### Datastore and logs

Because containers are likely to be short-lived and are conceptually ephemeral,
more so than virtual machines, you should never store data or
logs in a container. Instead, store data and logs by leveraging
Docker’s volume mounts to create either a data volume or a data volume
container that can be used and shared by other containers.

Union file systems, or UnionFS, are lightweight, fast file systems that operate by creating layers. Docker uses union file systems to provide the building blocks for containers. Docker can use several union file system variants including AUFS, btrfs, vfs, and DeviceMapper [(1)](#resources).
Using a Docker volume mount creates a specially designed directory within one
or more containers that bypasses the union file system and provides a
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
collect" volumes that are no longer referenced by a container [(2)](#resources).
Data volumes are created by either using the `--volume` or `-­v` flag in `docker run`,
or by using the `VOLUME` instruction in your Dockerfile.
Both options perform the same task: create a volume in the
container that is mapped to a directory on the host itself.
In both cases, the location of the volume is irrelevant.
The only variation is that, if you do care about the volume's location
from the host's perspective,
you can use `docker run` with the `-v` flag to request
mounting a particular file or directory from the host
and, if necessary, mapping the host directory to a container directory.

<a name="mapping"></a>
For example,
`docker run –v /host/src/demo:/opt/demo`
maps a volume so it is known in the host directory as `/host/src/demo`
and in the container directory as `/opt/demo`.

**Data volume containers** operate like data volumes
but are designed to persist data that you want to share between
containers or that you want to use from non-persistent containers. To use a
data volume container with other containers, you begin by creating
it with something like `docker create -v /data –name datastore mysql`.
This command will
start a container and exit immediately, because it is used as a
container shell that references a newly created volume that other
containers will use, rather than an active process like other application
containers. After the data volume container exits, you can reference it
from other containers by using the `--volumes-from` flag on
subsequent containers such as: `docker run –d --volumes-from datastore
–name mywebapp demo/webapp`.

If you remove the datastore container or
the containers that reference it, this does not delete the volume where
your data is stored. To delete the volume from disk, you must explicitly
call `docker rm –v` against the last container with a reference to the
volume [(3)](#resources). This allows you to upgrade or effectively migrate data volumes
between containers or even the containers using the data volume
container with no worries of losing the data itself.

If you use volumes with containers, when you need to back up
a database or log that lives on the volume which in turn lives on
the host, you can use your familiar tools on the host itself as you had
been doing in your organization before containers were implemented. After doing
so, you can carry out tasks such as upgrading the image itself by
shutting down the previous container and starting the updated one with
the same volume or volumes, or you can perform any other routine updates and
maintenance. In summary, the general rule is that if it gets
written to, it should be done in a volume.

Using a data volume container sounds like a great solution to the data
management issue, in theory. However, when you want to
scale out where your data resides or when your host machine restarts
due to maintenance or failure, data volume containers may not be a complete solution.
The current recommendation is what common sense might lead you to guess: move
data management tasks to self-managed systems. For example, you can use
dedicated rsyslog servers for logs.
You can also use redundant cloud
services such as cloud block storage and cloud database as a service
to persist your database, although these could introduce concerns such as
cloud vendor lock-in and performance implications. Another strategy
is to integrate data management back into the stateless
applications, but doing so only creates
the monolithic mess we’re trying to avoid in the first place with
containers.

In theory, we should be able to co-locate the stateless applications with the
data management services they rely on, with all of these services
running in containers, but Docker is not ready to handle this.
With their Flocker tool, ClusterHQ is attempting to tackle this problem by using ZFS as the foundation for
data management and replication for containers. However, Flocker is still in very
early developmental stages, and it assumes you can accept
a clustered filesystem model and the nuances it can introduce such as
relying on a storage pool; Flocker can also cause I/O to take a performance
hit. However, Flocker is open-source and free to use, so you can experiment and make up your own mind.
ClusterHQ seems to be becoming an important provider of container tools, so monitoring the growth of both the Flocker tool and the ClusterHQ company is well-advised.

You can read more about Flocker and other orchestration tools at
[Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/).

For Docker to truly flourish as the new infrastructure stack that
powers the next web, containers need serious work mitigating the data
management problem. For now, you should stick to the
traditional data management solutions that live outside of containers,
or strictly use data volumes as a means to map to a host directory or
a file that you can curate and manage external to
Docker.

### Block storage

Given the potential of Docker volumes to manage
your data, and the assumption that you are operating on a cloud
provider, it is only logical to think that you could use the
provider’s block storage as a service (for example, Rackspace Cloud Block Storage)
in conjunction with volume
mounts.

If you have several hundred containers running on a host, all
requiring an allocated and attached block device to mount their
individual volumes, it is only a matter of time
before you hit a limit of some sort at the account level, or more
restrictively, at the service provider’s infrastructure level.
Exceeding an infrastructure's limit is a problem you might have run into whether or not
you were running containers; because people who run containers probably run large numbers of containers, they are likely to hit such limits sooner than otherwise.

Adding cloud block storage can help you expand your storage infrastructure as needed.
Cloud block storage that is attached to a host is indistinguishable from direct attached storage [(4)](#resources).
This means you can
map a data volume container to a block storage device and share that container with other containers without having
to introduce an additional management layer,
just as you can [map a data volume](#mapping) so that it is known to the host by one name and to the container by another name.

<a name="resources"></a>
### Resources

Numbered citations in this article:

1. <https://github.com/jorgemoralespou/docker-slides/blob/master/docker-explained/docker-explained.adoc#union-file-systems>

2. <https://docs.docker.com/userguide/dockervolumes/>

3. <http://docs.docker.com/userguide/dockervolumes/>

4. <http://cloud-mechanic.blogspot.com/2014/10/storage-concepts-in-docker-network-and.html>

Other recommended reading:

- <http://www.rackspace.com/cloud/block-storage>

- <http://unionfs.filesystems.org/>

- <https://developer.rackspace.com/blog/rsyslog-and-elasticsearch/>

- <http://www.rackspace.com/cloud/databases>

- [Introduction to container technologies: orchestration and management of container clusters](/container-technologies-orchestration-clusters/)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. You can follow him in GitHub at https://github.com/metral and at Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
