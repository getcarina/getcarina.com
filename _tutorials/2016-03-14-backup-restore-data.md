---
title: Back up and Restore Container Data
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
date: 2016-03-14
permalink: docs/tutorials/backup-restore-data/
description: Back up and restore the contents of data volume containers
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
---

This tutorial explains how to back up and restore data from your containers, so you can quickly restore your application data in the event of a system failure.

### Prerequisites

Before you begin, you need to [create and connect to a Carina cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/).

Optionally, if you would like to store your backups in [Rackspace Cloud Files](https://www.rackspace.com/cloud/files), you need a traditional Rackspace Cloud account (one _not_ created from the Carina website).

### Create a MySQL instance

In order to effectively test a backup process, you’ll need something worth backing up. In this section, you’ll create a MySQL instance with a separate [data volume container](/docs/tutorials/data-volume-containers/) for its data storage.

1. Create an [overlay network]({{ site.baseurl }}/docs/tutorials/overlay-networks/) named `mysql` to allow multiple containers to communicate with one another.

    ```bash
    $ docker network create mysql
    ```

1. Create a data volume container named `mysql-data`. The MySQL image stores its table data in `/var/lib/mysql`, so include `--volume /var/lib/mysql` to present that path as a volume that other containers can mount. Include `--volume /backups` to create a persistent folder for your database backups.

    ```bash
    $ docker create \
      --name mysql-data \
      --volume /var/lib/mysql \
      --volume /backups \
      mysql:latest
    ```

1. Start a MySQL container with a database named `test`. Include `--volumes-from mysql-data` to mount the volumes provided by that container.

    ```bash
    $ docker run \
      --detach \
      --env MYSQL_ROOT_PASSWORD=secret \
      --env MYSQL_DATABASE=test \
      --name mysql-server \
      --net mysql \
      --volumes-from mysql-data \
      mysql:latest
    ```

1. Populate the database with some empty tables for testing purposes (we’re borrowing the `carinamarina/guestbook-mysql` Docker image used in the tutorial [Use MySQL on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mysql/)).

    ```bash
    $ docker run --rm \
      --env MYSQL_HOST=mysql-server \
      --env MYSQL_PORT=3306 \
      --env MYSQL_USER=root \
      --env MYSQL_PASSWORD=secret \
      --env MYSQL_DATABASE=test \
      --net mysql \
      carinamarina/guestbook-mysql \
      python app.py create_tables
    ```

### Back up the database

Now that you’ve created a MySQL instance with some data, you can use our [`carinamarina/backup`](https://hub.docker.com/r/carinamarina/backup/) Docker image to store the data in a safe place.

1. Dump the contents of your database to a single file in the `/backups` directory provided by your data volume container.

    ```bash
    $ docker run \
      --rm \
      --net mysql \
      --volumes-from mysql-data \
      mysql \
      bash -c "mysqldump -psecret -h mysql-server --databases test > /backups/test.sql"
    ```

1. Back up the database dump to your local filesystem.

    ```bash
    docker run \
      --rm \
      --volumes-from mysql-data \
      carinamarina/backup \
      backup \
      --source /backups/ \
      --stdout \
      --zip > my-local-backup.tar.gz
    ```

    This adds all the contents of `/backups/` from your data volume container to a compressed <a href="https://en.wikipedia.org/wiki/Tar_(computing)"><code>tar</code></a> archive and pipe it to a file on your local filesystem. Whatever you do with the backup file after this is up to you.

1. _(Optional)_ Back up the database dump to Rackspace Cloud Files. If you have a paid Rackspace account in addition to your Carina account, you can store your backups in a Cloud Files container.

    ```bash
    $ docker run \
      --rm \
      --env RS_USERNAME=<your-rackspace-username> \
      --env RS_API_KEY=<your-rackspace-api-key> \
      --env RS_REGION_NAME=IAD \
      --volumes-from mysql-data \
      carinamarina/backup \
      backup \
      --source /backups/ \
      --container <name-of-cloud-files-container> \
      --zip
    Bundling archive...
    Uploading archive to Cloud Files...
    Finished! Uploaded object [2016/03/11/21-30-backups.tar.gz] to container [carina-backup] in now
    Done.
    ```

### Restore the database from your backup

1. Unpack the backup archive to the `/backups/` volume by piping it from your local filesystem to a Docker command.

    ```bash
    $ docker run \
      --rm \
      --interactive \
      --volumes-from mysql-data \
      carinamarina/backup \
      restore \
      --destination /backups/ \
      --stdin \
      --zip \
      < my-local-backup.tar.gz
    Reading and unzipping archive...
    Done.
    ```

1. _(Optional)_ Download the backup archive from Cloud Files and unpack it to the `/backups/` volume.

    ```bash
    $ docker run \
      --rm \
      --env RS_USERNAME=<your-rackspace-username> \
      --env RS_API_KEY=<your-rackspace-api-key> \
      --env RS_REGION_NAME=IAD \
      --volumes-from mysql-data \
      carinamarina/backup \
      restore \
      --container carina-backup \
      --object 2016/03/11/21-30-backups.tar.gz \
      --destination /backups/
      --zip
    Reading and unzipping archive...
    Done.
    ```

1. Import the unpacked database dump into your MySQL server.

    ```bash
    $ docker run \
      --rm \
      --net mysql \
      --volumes-from mysql-data \
      mysql \
      bash -c "mysql -psecret -h mysql-server < /backups/test.sql"
    ```

That's all! You’ve successfully created a MySQL server, backed up the contents of a database to a compressed archive, then restored data using your backup.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [`carinamarina/backup` README](https://hub.docker.com/r/carinamarina/backup/)

### Next step

* [Schedule regular backups using cron]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/)
