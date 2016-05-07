---
title: Migrate to a new cluster
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-05-09
permalink: docs/tutorials/migrate-cluster/
description: Migrate to a new cluster to take advantage of new features, security, services, and Docker versions
docker-versions:
  - 1.10.3
topics:
  - docker
---

This tutorial describes how to migrate to a new cluster to take advantage of new features, security, services, and Docker versions. It demonstrates how to manage different Docker versions, how to move data from one cluster to another, and offers some tips to make the process go more smoothly in the future.

**Note**: Carina cannot automatically do a cluster upgrade for you. The system does not understand your applications, data, and requirements. There would be too much risk of data loss or downtime for an automated upgrade by the system. Hence the need for you to create a new cluster and migrate to it.

<figure>
  <img src="{% asset_path migrate-cluster/migrate.jpg %}" alt="Canada goose migrating south" title="Canada goose migrating south"/>
  <figcaption>
  Image credit: <a href="https://www.flickr.com/photos/tabor-roeder/" target="_blank_">Phil Roeder</a>
  <a href="https://creativecommons.org/licenses/by/2.0/" target="_blank_">CC BY 2.0</a>
  </figcaption>
</figure>

### Install the Docker Version Manager

Migrating to a new cluster likely means using a newer version of Docker. That means you will have two or more clusters with different versions of Docker. To make it easy to work with different versions of the Docker client, follow the tutorial to [manage Docker client versions with Docker Version Manager (dvm)]({{ site.baseurl }}/docs/tutorials/docker-version-manager/).

### Install the Carina CLI

Migrating to a new cluster is much easier using the Carina CLI. Creating new clusters is easier and switching between clusters is easier. If you haven't already begun using the Carina CLI, follow the tutorial for [getting started with the Carina CLI]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).

### Create and connect to a new cluster

For the purposes of this tutorial we will refer your new cluster as *new* and the cluster you are migrating from as *old*.

```bash
$ carina create --wait new
ClusterName         Flavor              Nodes               AutoScale           Status
new                 container1-4G       1                   false               active

$ eval $(carina env new)
```

### Run your application in the new cluster

Run all of the containers your application uses in the new cluster. Ideally you scripts or Docker Compose to that can run your application with a using a command or two.

### Copy data from the old cluster to the new cluster

If you have data in the old cluster that you want to copy to the new cluster, use the `docker cp` command to copy it over. This requires being able to communicate to your old cluster from your new cluster.

**Note**: If you are copying over database files, remember to stop your database running on the old cluster first.

1. Export all of the Docker environment variables for your old cluster.

```bash
$ eval $(carina env old)

$ export DOCKER_CERT_PATH_OLD=$DOCKER_CERT_PATH
$ export DOCKER_HOST_OLD=$DOCKER_HOST
$ export DOCKER_VERSION_OLD=$DOCKER_VERSION
```

1. Create a data volume container on the new cluster to hold the certificates from the old cluster.

```bash
eval $(carina env new)

$ docker create \
  --name old-swarm-data \
  --volume /etc/docker \
  cirros
c2f613ba8569b90aed1fd84a4f57c71f2468fd442a3966184aeda101ce41c871

$ docker cp $DOCKER_CERT_PATH_OLD/ca-key.pem old-swarm-data:/etc/docker/
$ docker cp $DOCKER_CERT_PATH_OLD/ca.pem old-swarm-data:/etc/docker/
$ docker cp $DOCKER_CERT_PATH_OLD/cert.pem old-swarm-data:/etc/docker/
$ docker cp $DOCKER_CERT_PATH_OLD/key.pem old-swarm-data:/etc/docker/
```

1. Create a data volume container on the new cluster to hold the data from the old cluster.

```bash
$ docker create \
  --name new-dvc \
  --volume /data \
  cirros
23a2a7e8ecc2866b00fda5882e7b7e1411adf1462c183162f724c6668eaf191b
```

1. Copy the data to the new cluster from the old cluster.

This command runs a container from the official Docker image in the new cluster. The Docker CLI within that container is configured using `--env` flags to connect to the old cluster. This is how `docker cp` can copy data to the new cluster from the old cluster.

```bash
$ docker run --rm \
  --env DOCKER_HOST=$DOCKER_HOST_OLD \
  --env DOCKER_VERSION=$DOCKER_VERSION_OLD \
  --env DOCKER_TLS_VERIFY=1 \
  --env DOCKER_CERT_PATH=/etc/docker \
  --volumes-from new-dvc \
  --volumes-from old-swarm-data \
  docker:$DOCKER_VERSION_OLD \
  docker cp old-dvc:/data/datafile /data/datafile
```

### Copy data from the old cluster to your local machine

If you have data in the old cluster that you want to copy to your local machine, use the `docker cp` command to copy it over. This requires being able to communicate to your old cluster from your local machine.

```bash
$ eval $(carina env old)

$ docker cp old-dvc:/data/datafile /data/datafile
```

### Update DNS

Your new cluster will have nodes with new IP addresses. If you have a domain names pointing to IP addresses on the old cluster, remember to point them to the new IP addresses on the new cluster.

### Store data off cluster

Containers excel at ephemeral computing workloads. Because of their ephemeral nature they are not always best suited to storing persistent data. You may want to consider storing your data off cluster by [connecting a Carina container to a Rackspace Cloud Database]({{ site.baseurl }}/docs/tutorials/data-stores-mysql-prod/) or [connecting a Carina container to an ObjectRocket MongoDB instance]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb-prod/). If your persistent data is stored off cluster then migrating to a new cluster can be as simple as running your application on a new cluster and connecting it to your persistent data store.

### Back up your data on a schedule

If you prefer to store your data on cluster, learn how to [back up and restore container data]({{ site.baseurl }}/docs/tutorials/backup-restore-data/), and combine that with [scheduling tasks with a cron container]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/) to back up your data on a schedule.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Use data volume containers]({{ site.baseurl }}/docs/tutorials/data-volume-containers/)
* [Docker Compose](https://docs.docker.com/compose/)

### Next steps

If you are migrating to a new cluster and haven't taken advantage of overlay networks yet, learn how to [use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/).

Run through another one of the [tutorials]({{ site.baseurl }}/docs/#tutorials).
