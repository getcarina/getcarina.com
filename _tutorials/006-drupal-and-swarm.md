---
title: Drupal on Docker Swarm
author: Matt Darby <matt.darby@rackspace.com>
date: 2015-10-05
permalink: docs/tutorials/drupal-and-swarm/
description: How to use Drupal on Docker Swarm
docker-versions:
  - 1.8.2
topics:
  - docker
  - drupal
  - mysql
---

This tutorial describes how to setup Drupal on Rackspace Cloud Service.

[Drupal](drupal.org) is an open source content management platform powering millions of websites and applications. It’s built, used, and supported by an active and diverse community of people around the world.

[MySQL](mysql.com) is the most popular open source database system. Many of the world's largest and fastest-growing organizations including Facebook, Google, Adobe, Alcatel Lucent and Zappos rely on MySQL to save time and money powering their high-volume Web sites, business-critical systems and packaged software.

### Prerequisites

* An [RCS cluster](mycluster.rackspace.com)

### Steps

1. Download and source the environment file that RCS provides:

    `source docker.env`

1. Create a MySQL container for the Drupal container to store data.
  * `MYSQL_USER` is the username to use for the Drupal installation.
  * `MYSQL_PASSWORD` is the password to use with the username for the Drupal installation.
  * `MYSQL_DATABASE` is the database name to use for the Drupal installation.
  * `MYSQL_ROOT_PASSWORD` is the MySQL's root username to install the MySQL database.

  ```
  docker run --name mysql \
    -e MYSQL_USER=drupal \
    -e MYSQL_PASSWORD=drupal \
    -e MYSQL_DATABASE=drupal \
    -e MYSQL_ROOT_PASSWORD=secretpassword \
    -d mysql
  ```

1. MySQL installation will take ~10 seconds after the docker script returns.

  To check on it's installation progress, simply run `docker logs mysql`.

  ```
  2015-10-05 17:47:47 1 [Note] mysqld: ready for connections.
  Version: '5.6.27'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
  ```

1. Once MySQL is confirmed as installed, we can create the Drupal container:

  ```
  docker run --name drupal \
    --link mysql:mysql \
    -p 80:80 \
    -d drupal
  ```

1. Find the RCS IP address:

  `echo $DOCKER_HOST`

  In this example this string is returned: `tcp://104.130.0.164:2376`

1. Go to the Drupal installation wizard via the RCS IP address: `http://104.130.0.164`
1. Choose an installation method ("Standard" or "Minimal") depending on your use case.
1. Enter the MySQL values used in for the MySQL container:
  * **Note:** Ensure you use the MySQL container name under *Advanced Options*.
  ![Configure MySQL Settings]({% asset_path drupal-and-swarm/config.png %})

1. The Drupal installation wizard will take you through the remaining steps.
1. Drupal will install and will then provide a link to the new Drupal site.

### Resources

* [RCS](mycluster.rackspace.com)
* [Drupal](drupal.org)
* [MySQL](mysql.com)
