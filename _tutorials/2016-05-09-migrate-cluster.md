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
  <img src="{% asset_path migrate-cluster/migrate.jpg %}" alt="Migrate"/>
  <figcaption>
  Image credit: <a href="https://www.flickr.com/photos/tabor-roeder/" target="_blank_">Phil Roeder</a>
  <a href="https://creativecommons.org/licenses/by/2.0/" target="_blank_">CC BY 2.0</a>
  </figcaption>
</figure>

### Install the Docker Version Manager

Migrating to a new cluster likely means using a newer version of Docker. That means you will have two or more clusters with different versions of Docker. To make it easy to work with different versions of the Docker client, follow the tutorial to [manage Docker client versions with Docker Version Manager (dvm)]({{ site.baseurl }}/docs/tutorials/docker-version-manager/).

### Install the Carina CLI

Migrating to a new cluster is much easier using the Carina CLI. If you haven't already begun using the Carina CLI, follow the tutorial for [getting started with the Carina CLI]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).

### Connect to your old cluster

1. [Create and connect to a new cluster](/docs/tutorials/create-connect-cluster/).

### Old cluster

eval $(carina env old)

docker create \
  --name old \
  --volume /var/lib/mysql \
  cirros

docker run --rm \
  --volumes-from old \
  cirros \
  /bin/sh -c "echo 'data' > /var/lib/mysql/datafile"

docker run --rm --volumes-from old cirros cat /var/lib/mysql/datafile

### New cluster

eval $(carina env old)

export DOCKER_CERT_PATH_OLD=$DOCKER_CERT_PATH
export DOCKER_HOST_OLD=$DOCKER_HOST
export DOCKER_VERSION_OLD=$DOCKER_VERSION

eval $(carina env new)

docker create \
  --name old-swarm-data \
  --volume /etc/docker \
  cirros

docker cp $DOCKER_CERT_PATH_OLD/ca-key.pem old-swarm-data:/etc/docker/
docker cp $DOCKER_CERT_PATH_OLD/ca.pem old-swarm-data:/etc/docker/
docker cp $DOCKER_CERT_PATH_OLD/cert.pem old-swarm-data:/etc/docker/
docker cp $DOCKER_CERT_PATH_OLD/key.pem old-swarm-data:/etc/docker/

docker create \
  --name new \
  --volume /var/lib/mysql \
  cirros

docker run --rm \
  --env DOCKER_HOST=$DOCKER_HOST_OLD \
  --env DOCKER_VERSION=$DOCKER_VERSION_OLD \
  --env DOCKER_TLS_VERIFY=1 \
  --env DOCKER_CERT_PATH=/etc/docker \
  --volumes-from new \
  --volumes-from old-swarm-data \
  docker:$DOCKER_VERSION_OLD \
  docker cp old:/var/lib/mysql/datafile /var/lib/mysql/

docker run --rm --volumes-from new cirros cat /var/lib/mysql/datafile

stop any databases first!

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* something something

### Next step

Run through another one of the [tutorials]({{ site.baseurl }}/docs/#tutorials).
