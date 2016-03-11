---
title: Back up and Restore Container Data
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
date: 2016-03-14
permalink: docs/tutorials/backup-restore-data/
description:
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
---

This tutorial explains how to back up and restore data from your containers, so you can quickly restore your application data in the event of a system failure.

### Prerequisites

Before you begin, you need to [create and connect to a Carina cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/).

Optionally, if you would like to store your backups in [Rackspace Cloud Files](https://www.rackspace.com/cloud/files), you will need a traditional Rackspace Cloud account (one _not_ created from the Carina website).

### Create a MySQL instance

In order to effectively test a backup process, you’ll need something worth backing up. In this section, you’ll create a MySQL instance with a separate [data volume container](/docs/tutorials/data-volume-containers/) for its data storage.

1. Create an [overlay network]({{ site.baseurl }}/docs/tutorials/overlay-networks/) named `mysql` to allow multiple containers to communicate with one another.

    ```bash
    $ docker network create mysql
    ```

1. Pull the latest official MySQL image.

    ```bash
    $ docker pull mysql:latest
    ```

1. Create a data volume container named `mysql-data`. The MySQL image stores its table data in `/var/lib/mysql`, so include `--volume /var/lib/mysql` to present that path as a volume that other containers can mount. Include `--volume /backups` to create a persistent folder for your database backups.

    ```bash
    $ docker create \
      --name mysql-data \
      --volume /var/lib/mysql \
      --volume /backups \
      mysql:latest
    ```

1. Start a MySQL container that uses the volumes from the `mysql-data` container to store its table data.

    ```bash
    $ docker run \
      --detach \
      -e MYSQL_ROOT_PASSWORD=secret \
      --name mysql-server \
      --net mysql \
      --volumes-from mysql-data \
      mysql:latest
    ```

### Add data to the MySQL instance

1. Start an interactive MySQL client in a Docker container.

    ```bash
    $ docker run \
      -it \
      --net mysql
      --rm \
      mysql:latest \
      mysql -psecret -h mysql-server
    ```

    The container displays the prompt for the interactive MySQL shell.

1. Create and use a database named `test`.

    ```sql
    mysql> CREATE DATABASE test; USE test;
    Query OK, 1 row affected (0.00 sec)

    Database changed
    ```

1. Create a table named `messages` with columns for an ID and a plain-text message.

    ```sql
    mysql> CREATE TABLE messages(id SERIAL PRIMARY KEY, message TEXT);
    Query OK, 0 rows affected (0.10 sec)
    ```
1. Add a message to the table and confirm the table's contents.

    ```sql
    mysql> INSERT INTO messages (message) VALUES('This is a very important message.');
    Query OK, 1 row affected (0.01 sec)

    mysql> SELECT * FROM messages;
    +----+-----------------------------------+
    | id | message                           |
    +----+-----------------------------------+
    |  1 | This is a very important message. |
    +----+-----------------------------------+
    1 row in set (0.00 sec)
    ```

### Back up the database

Now that you’ve created a MySQL instance with some data, you can use our [`carinamarina/backup`](https://hub.docker.com/r/carinamarina/backup/) Docker image to store the data in a safe place.

1. Pull the latest `carinamarina/backup` image.

    ```bash
    $ docker pull carinamarina/backup:latest
    ```

1. Dump the contents of your database...yada yada
<!--
Provide a descriptive heading for this section. Begin with the an imperative verb.

List steps in numbered order. Limit steps to a single action.

Include as many "steps" sections as needed to provide a complete topic to the user.
To make it easier to shuffle steps around, number each with 1. and Jekyll will handle numbering it appropriately.

1. Do this.

    Indent any descriptions or information needed between steps. If your task includes sublists, graphics, and code examples, use the spacing guidelines at https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#lists.

1. Do that.

1. Do this other thing.

1. Clean up.

    If a tutorial isn't part of a series of tutorials and the user might not need the containers that they created anymore, include an optional step at the end of the tutorial to remove only the containers created in the tutorial. Use the following text, adjusting the example as needed for your tutorial:

    *(Optional)* Remove the containers.

    ```bash
    $ docker rm --force $(docker ps --quiet -n=-2)
    47c6d35c63ec
    08d0383a775f
    ```

    The output of this `docker rm` command are the shortened IDs of the containers that you removed.

    When the container is gone, so is your data.

Conclude with a brief description of the end state.
-->

### Troubleshooting

<!--

Provide the following boilerplate. If you have a troubleshooting information that pertains only to this tutorial, you can include it in this section, before the boilerplate. However, if it might apply to more than one article, add a new section for it in the [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/) article or create a new article for it and link to that article from here as well.

-->

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

<!--
* Links to related content
-->

### Next step

<!--
* What should your audience read next?
-->
