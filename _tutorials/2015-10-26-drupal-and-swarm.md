---
title: Set up Drupal on Carina
author: Matt Darby <matt.darby@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/drupal-and-swarm/
description: Learn how to run a Drupal instance and a MySQL database in containers with Carina
docker-versions:
  - 1.10.2
topics:
  - docker
  - drupal
  - mysql
---

This tutorial provides steps for running a Drupal instance and a MySQL database in containers with Carina.

[Drupal](https://drupal.org) is an open source content management application. It’s built, used, and supported by an active and diverse community of people around the world and is easily customizable.

[MySQL](https://mysql.com) is a popular open source database system that powers millions of web applications.

**Note:** Storing persistent data in containers is a hotly contested issue. Many prefer to instead use an external database service. This tutorial sets up a MySQL container just to demonstrate container relationships.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Set up Drupal in Carina

1. Download and source the environment file that Carina provides:

    `source docker.env`

1. Create an overlay network. This virtual network will privately encapsulate your containers for security.

    `docker network create mynetwork`

1. Create a MySQL container in which to store data for the Drupal container. MySQL installation will takes about 10 seconds after the Docker script returns. You need to set the following container environment variables:
  * `MYSQL_USER` is the username to use for the Drupal installation.
  * `MYSQL_PASSWORD` is the password to use with the username for the Drupal installation.
  * `MYSQL_DATABASE` is the database name to use for the Drupal installation.
  * `MYSQL_ROOT_PASSWORD` is the MySQL root username used to install the MySQL database.

      ```
      $ docker run --name mysql \
      --net=mynetwork \
      -e MYSQL_USER=drupal \
      -e MYSQL_PASSWORD=<password> \
      -e MYSQL_DATABASE=drupal \
      -e MYSQL_ROOT_PASSWORD=<rootPassword> \
      -d mysql
      ```

1. To check the installation status, run `docker logs mysql`. The following output shows the finished installed state:

    ```
    2015-10-05 17:47:47 1 [Note] mysqld: ready for connections.
    Version: '5.6.27'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
    ```

1. After MySQL is confirmed as installed, create the Drupal container. The second line of the command tells the Drupal container to create a network connection to (link to) the resulting `mysql` container.

    ```
    $ docker run --name drupal \
    --net=mynetwork \
    -p 80:80 \
    -d drupal
    ```

1. Find the Carina IP address:

    `echo $DOCKER_HOST`

    In this example the following string is returned: `tcp://104.130.0.164:2376`

1. Go to the Drupal installation wizard via the IP address: `http://104.130.0.164`
1. Choose an installation method (Standard or Minimal) depending on your use case.
1. Enter the MySQL values that you used for the MySQL container, as shown in the following image:

    ![Configure MySQL Settings]({% asset_path drupal-and-swarm/config.png %})
  * For **Database name**, enter **drupal**.
  * For **Database username**, enter **drupal**.
  * For **Database password**, enter the password for the database user
  * Under Advanced Options, enter the name of the MySQL container, **mysql**, in the **Database host** field.

1. Follow the remaining steps in the installation wizard.

Drupal is installed and you are given a link to the new Drupal site.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Carina](https://app.getcarina.com)
* [Drupal](https://drupal.org)
* [MySQL](https://mysql.com)

### Next step

For further information on how to get up and running with Carina, read [Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).
