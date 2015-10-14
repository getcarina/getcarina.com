---
title: How to set up Drupal on Rackspace Container Service
author: Matt Darby <matt.darby@rackspace.com>
date: 2015-10-05
permalink: docs/tutorials/drupal-and-swarm/
description: How to setup Drupal on Rackspace Container Service
docker-versions:
  - 1.8.2
topics:
  - docker
  - drupal
  - mysql
---

Learn how to run a Drupal instance and a MySQL database in containers with Rackspace Container Service.

[Drupal](drupal.org) is an open source content management application. It’s built, used, and supported by an active and diverse community of people around the world and is easily customizable.

[MySQL](mysql.com) is a very popular open source database system that powers millions of web applications.

*Note:* Storing persistent data in containers is a hotly contested issue. Many prefer to instead use an external service such as Rackspace Cloud Databases. This tutorial sets up a MySQL container just to demonstrate container relationships.

### Prerequisites

* An [Rackspace Container Service cluster](mycluster.rackspace.com)

### Set up Drupal in Rackspace Container Service

1. Download and source the environment file that Rackspace Container Service provides:

    `source docker.env`

1. Create a MySQL container for the Drupal container to store data.

  In this step we will need to set container environment variables:
  * `MYSQL_USER` is the username to use for the Drupal installation.
  * `MYSQL_PASSWORD` is the password to use with the username for the Drupal installation.
  * `MYSQL_DATABASE` is the database name to use for the Drupal installation.
  * `MYSQL_ROOT_PASSWORD` is the MySQL root username used to install the MySQL database.

  ```
  docker run --name mysql \
    -e MYSQL_USER=drupal \
    -e MYSQL_PASSWORD=<password> \
    -e MYSQL_DATABASE=drupal \
    -e MYSQL_ROOT_PASSWORD=<rootPassword> \
    -d mysql
  ```

1. MySQL installation will takes about 10 seconds after the Docker script returns.

  To check the status, run `docker logs mysql`. The output below shows the finished installed state:

  ```
  2015-10-05 17:47:47 1 [Note] mysqld: ready for connections.
  Version: '5.6.27'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
  ```

1. After MySQL is confirmed as installed, create the Drupal container. The second line of the command tells our new Drupal container to link a network connection to the resulting `drupal` container.

  ```
  docker run --name drupal \
    --link mysql:mysql \
    -p 80:80 \
    -d drupal
  ```

1. Find the Rackspace Container Service IP address:

  `echo $DOCKER_HOST`

  In this example the following string is returned: `tcp://104.130.0.164:2376`

1. Go to the Drupal installation wizard via the Rackspace Container Service IP address: `http://104.130.0.164`
1. Choose an installation method (Standard or Minimal) depending on your use case.
1. Enter the MySQL values that you used for the MySQL container, as shown in the following image:

  ![Configure MySQL Settings]({% asset_path drupal-and-swarm/config.png %})

  * For Database name, enter the "drupal".
  * For Database username, enter the "drupal".
  * For Database password, enter the password for the database user
  * Under *Advanced Options*, enter the name of the MySQL container, *mysql*, in the Database host field.


1. Follow the remaining steps in the installation wizard.
1. Drupal is installed and you are given a link to the new Drupal site.

### Resources

* [Rackspace Container Service](mycluster.rackspace.com)
* [Drupal](drupal.org)
* [MySQL](mysql.com)
