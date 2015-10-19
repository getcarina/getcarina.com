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

Create a DVC for use by a MySQL instance running in another container.

```bash
$ docker create --name data \
  --volume /var/lib/mysql \
  mysql:5.6 \
  /bin/true \
```

### Troubleshooting

If the status of the container does not begin with Up, run a new MySQL container, and open a shell so you can use the `mysql` command to investigate your MySQL instance.

```bash
$ docker run --interactive --tty --rm mysql:5.6 /bin/bash
```

You can also enter a running container, and open a shell to investigate the container.

```bash
$ docker exec -it $(docker ps -q -l) /bin/bash
```

### Resources

* TODO

### Next

TODO
