---
title: Use Data Volume Containers
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/data-volume-containers/
description: Use data volume containers to share data
docker-versions:
  - 1.8.3
topics:
  - docker
  - intermediate
  - volumes
---

This tutorial describes using data volume containers so that you can share data between containers.

### Prerequisites

1. [Carina cluster and credentials](cluster-and-credentials)

### Data volume containers

A data volume container (DVC) is a container with a volume mounted inside of it that is used to share data with other containers. The volume is mounted from the Docker host to the container. Other containers can also mount this volume. All containers mounting this volume will all run on the same Docker host.

Some advantages of using a DVC are:

* data can be shared between containers
* short-lived containers can access the data
* services can be upgraded without impacting the data
* data can be backed up, restored, and migrated more easily
* you don't have to concern yourself with permissions and other security mechanisms on the Docker host when mounting volumes

### Create a data volume container

Create a DVC for use by a MySQL instance running in another container. The `--volume` parameter mounts a volume in the container's filesystem from a location on the host's filesystem determined by the Docker Engine.

```bash
$ docker create --name data \
  --volume /var/lib/mysql \
  mysql:5.6 \
  /bin/true
42350d0131d52cb0248df286b0fab04f8d16f6948edadc73d3f06c92c3be4c15
```

The output of this `docker run` command is the container ID.

### Use a data volume container

Run a MySQL instance that uses the DVC. The `--volumes-from` parameter mounts all the defined volumes from the listed containers. In the example below, it mounts the `/var/lib/mysql` volume from the container named data. The data saved by this MySQL instance will be stored there.

```bash
$ docker run --detach \
  --name mysql56 \
  --env MYSQL_ROOT_PASSWORD=my-root-pw \
  --env MYSQL_DATABASE=test \
  --env MYSQL_USER=test-user \
  --env MYSQL_PASSWORD=test-password \
  --volumes-from data \
  mysql:5.6
466699d49f670cc7fdb71ebdb053fd97f9130a886f1c804664333596ca7a24b0
```

The output of this `docker run` command is the container ID.

### Inspect the volume

Discover the volume mount information of your DVC.

```bash
$ docker inspect --format '{{ .Mounts }}' data
[{
  9e22f6557f43c57ddb14e28f0fd54cdda1f6ab7e60a2380523f7bfd6390d0556
  /var/lib/docker/volumes/9e22f6557f43c57ddb14e28f0fd54cdda1f6ab7e60a2380523f7bfd6390d0556/_data
  /var/lib/mysql
  local  
  true
}]
```

The output of this `docker run` command is all of the volumes mounted for the container named data. The output will appear as one line but has been separated out here for clarity. The information return is as follows.

1. The volume ID.
1. The volume location on the host.
1. The volume mount point on the container.
1. The volume driver.
1. The read/write status.

### View the data

View the files created by MySQL in the DVC.

```bash
$ docker run --rm \
  --volumes-from data \
  mysql:5.6 \
  ls /var/lib/mysql
auto.cnf
ib_logfile0
ib_logfile1
ibdata1
mysql
performance_schema
```

The output of this `docker run` command is the list of files in the `/var/lib/mysql` directory of the volume from the DVC.

### Copy the data

Copy the data from your DVC to the directory your in on your local machine.

```bash
$ docker cp \
  data:/var/lib/mysql .
$ ls mysql/
auto.cnf		ib_logfile1		mysql
ib_logfile0		ibdata1			performance_schema
```

There is no output from the `docker cp` (copy) command. The output of the `ls` command is the list of files copied down from the `/var/lib/mysql` directory of the volume from the DVC.

### Delete the data

Delete the containers. The `--volumes` parameter will remove the volumes associated with the container from the host.

```bash
$ docker rm --force mysql56
mysql56
$ docker rm --force --volumes data
data
```

The output of these `docker rm` commands are the names of the containers that you removed.

Note: Docker will not warn you when removing a container without providing the --volumes option to delete its volumes. If you remove containers without using the --volumes option, you may end up with "dangling" volumes; volumes that are no longer referenced by a container. Dangling volumes are difficult to get rid of and can take up a large amount of disk space.

### Resources

* Learn more about volumes in [Understanding how Carina uses Docker Swarm](/docs/tutorials/docker-swarm-carina/#volumes).

### Next

Use a data volume container in the [Use MySQL on Carina](/docs/tutorials/data-stores-mysql/) or [Use MongoDB on Carina](/docs/tutorials/data-stores-mongo/) tutorials.
