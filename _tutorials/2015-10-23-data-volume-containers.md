---
title: Use data volume containers
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-23
permalink: docs/tutorials/data-volume-containers/
description: Use data volume containers to share data
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
  - volumes
---

This tutorial describes using data volume containers so that you can share data between containers.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Data volumes

A data volume is a directory within a container that is meant to persist beyond the life cycle of the container. For this reason, volumes are not automatically deleted when a container is removed. All volumes are stored on the Docker host in a system path, meaning that volumes can be shared and reused among containers. Changes to a volume are made directly and are not reflected in the Docker image, because they bypass the Union File System.

### Data volume containers

A data volume container (DVC) is a container that houses a volume and whose sole aim is to store data in a persistent way. Because volumes can be shared with other containers, DVCs are often used as a centralized data store across multiple containers on the same Docker host. Other containers can mount the volume inside a DVC and save their data to it, providing non-persistent containers with a way to handle persistent storage.

Following are some advantages of using a DVC:

* Data can be shared between containers on the same Docker host.
* Non-persistent containers can access and save data in a persistent way.
* Services can be upgraded without impacting the data.
* Data can be backed up, restored, and migrated more easily.
* You don't need to manually specify host mount points and handle the additional concerns of file permissions, AppArmor profiles, and security restrictions.

For example, upgrading the MySQL version in a container would not risk data loss, if its data files are stored in a separate DVC

### Create a DVC

To understand the benefits of using data-only containers, create a DVC that will later be used by a container running a MySQL instance. The `--volume` flag mounts a volume in the container's filesystem from a location on the host's filesystem determined by the Docker Engine.

```bash
$ docker create --name data \
  --volume /var/lib/mysql \
  cirros
42350d0131d52cb0248df286b0fab04f8d16f6948edadc73d3f06c92c3be4c15
```

The output of this `docker create` command is the container ID.

**Note**: The image used for a DVC is irrelevant as you don't run the container. The `cirros` image is used in the previous command because the `cirros` image already exists on all Carina clusters and thus doesn't have to be downloaded.

### Use a DVC

Run a MySQL instance container that mounts the volume inside the DVC. The `--volumes-from <dataVolumeContainerName>` flag mounts all of the volumes from the DVC. You can specify this flag multiple times to mount volumes from multiple DVCs. In the following example, you mount the volume located at `/var/lib/mysql` inside the `data` container. All of the data files used by MySQL in this container will be stored there.

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

**Note**: You can also mount a volume from a non-DVC if that container itself mounts volumes from a DVC; this is called _extending the chain_.

### Inspect the volume

Discover the volume mount information of your DVC.

```bash
$ docker inspect --format '{% raw %}{{ .Mounts }}{% endraw %}' data
[{
  9e22f6557f43c57ddb14e28f0fd54cdda1f6ab7e60a2380523f7bfd6390d0556
  /var/lib/docker/volumes/9e22f6557f43c57ddb14e28f0fd54cdda1f6ab7e60a2380523f7bfd6390d0556/_data
  /var/lib/mysql
  local  
  true
}]
```

The output of this `docker inspect` command is a list of all the volumes mounted in the `data` container. The output will appear as one line but has been separated out here for clarity. The information returned is defined in the following way:

1. The volume ID.
1. The volume location on the host.
1. The volume mount point on the container.
1. The volume driver.
1. The read/write status.

### View the data

View the files that MySQL has created in the DVC.

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

The output of this `docker run` command is the list of files in the `/var/lib/mysql` directory of the volume in the DVC.

### Copy the data

You can copy all of the data from a DVC to a directory on your local machine. This is useful when you are backing up databases or performing similar activities.

Copy all of the files inside the `/var/lib/mysql` directory in the DVC to the current directory on your local machine.

```bash
$ docker cp \
  data:/var/lib/mysql .
$ ls mysql/
auto.cnf		ib_logfile1		mysql
ib_logfile0		ibdata1			performance_schema
```

There is no output from the `docker cp` (copy) command. The output of the `ls` command is the list of files copied from the `/var/lib/mysql` directory of the volume in the DVC.

### Delete the data

Delete the DVC and the MySQL containers. The `--volumes` flag removes the volumes associated with the DVC from the host.

```bash
$ docker rm --force --volumes mysql56
mysql56
$ docker rm --force --volumes data
data
```

The output of these `docker rm` commands is the names of the containers that you removed.

**Note**: The Docker client will not warn you when removing a container without providing the `--volumes` flag to delete its volumes. If you remove a container without providing the `--volumes` flag to delete its volumes, you might end up with "dangling" volumes, which are volumes that are no longer referenced by a container. Dangling volumes are difficult to delete and can take up a large amount of disk space.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

Learn more about volumes in [Understanding how Carina uses Docker Swarm]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/#volumes).

### Next steps

Learn how to [back up and restore container data]({{ site.baseurl }}/docs/tutorials/backup-restore-data/), and [schedule tasks with a cron container]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/)

Use a data volume container in the [Use MySQL on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mysql/) or [Use MongoDB on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb/) tutorials.
