---
title: Back up and restore container data
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
date: 2016-03-15
permalink: docs/tutorials/backup-restore-data/
description: Back up and restore the contents of data volume containers
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
---

This tutorial explains how to back up and restore data from a MySQL database, so you can quickly restore your application data in the event of a system failure. Although several of the steps described here are specific to backing up a MySQL server, the general concepts (especially the use of the `carinamarina/backup` Docker image) are applicable to any backup scenario.

![Backups stored in Rackspace Cloud Files]({% asset_path cloud-files-backups.jpg %})

### Prerequisites

* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)
* _(Optional)_ A Rackspace cloud account that you can use to access the [Cloud Control Panel](https://mycloud.rackspace.com/).
  * If you don't have a Rackspace cloud account, you can [sign up](https://www.rackspace.com/cloud) for one.

### Create a MySQL instance

To effectively test a backup process, you need something worth backing up. In this section, you create a MySQL instance with a separate data volume container for its data storage.

1. Create an overlay network named `mysql` to allow multiple containers to communicate with one another.

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
      --env MYSQL_ROOT_PASSWORD=<your-mysql-password> \
      --env MYSQL_DATABASE=test \
      --name mysql-server \
      --net mysql \
      --volumes-from mysql-data \
      mysql:latest
    ```

1. Populate the database with some empty tables for testing purposes.

    ```bash
    $ docker run --rm \
      --env MYSQL_HOST=mysql-server \
      --env MYSQL_PORT=3306 \
      --env MYSQL_USER=root \
      --env MYSQL_PASSWORD=<your-mysql-password> \
      --env MYSQL_DATABASE=test \
      --net mysql \
      carinamarina/guestbook-mysql \
      python app.py create_tables
    ```

### Back up the database

Now that you’ve created a MySQL instance with some data, you can use the `carinamarina/backup` Docker image to store the data in a safe place.

Dump the contents of your database to a single file in the `/backups` directory provided by your data volume container.

```bash
$ docker run \
  --rm \
  --net mysql \
  --volumes-from mysql-data \
  mysql \
  bash -c "mysqldump -p<your-mysql-password> -h mysql-server --databases test > /backups/test.sql"
```

#### Back up the database dump to your local filesystem

Run the `carinamarina/backup` image with the `--stdout` option. Redirect the container's output (the contents of the backup archive) to a file on your local filesystem.

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

This command adds all the contents of `/backups/` from your data volume container to a compressed tar archive and pipes it to a file on your local filesystem. Whatever you do with the backup file after this is up to you.

#### Back up the database dump to Rackspace Cloud Files _(optional)_

If you have a paid Rackspace account in addition to your Carina account, you can store your backups in a Cloud Files container. A Cloud Files container is a place where you can store files in the Rackspace cloud and is unrelated to a container created by Docker, unfortunately the terminology is overlapping.

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
Finished! Uploaded object [2016/03/11/21-30-backups.tar.gz] to container [<name-of-cloud-files-container>] in now
Done.
```

The uploaded object is named according to the following format:

{% raw %}

```
{{ year }}/{{ month }}/{{ day }}/{{ hour }}-{{ minute }}-{{ pathToSource }}.tar.gz
```

{% endraw %}

#### Restore the database dump from your local filesystem

Unpack the backup archive to the `/backups/` volume by piping it from your local filesystem to a Docker command.

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

#### Restore the database dump from Rackspace Cloud Files _(optional)_ 

Download the backup archive from Cloud Files, and unpack it to the `/backups/` volume.

```bash
$ docker run \
  --rm \
  --env RS_USERNAME=<your-rackspace-username> \
  --env RS_API_KEY=<your-rackspace-api-key> \
  --env RS_REGION_NAME=IAD \
  --volumes-from mysql-data \
  carinamarina/backup \
  restore \
  --container <name-of-cloud-files-container> \
  --object 2016/03/11/21-30-backups.tar.gz \
  --destination /backups/ \
  --zip
Reading and unzipping archive...
Done.
```

#### Import the unpacked database dump into your MySQL server

```bash
$ docker run \
  --rm \
  --net mysql \
  --volumes-from mysql-data \
  mysql:latest \
  bash -c "mysql -p<your-mysql-password> -h mysql-server < /backups/test.sql"
```

That's all! You’ve successfully created a MySQL server, backed up the contents of a database to a compressed archive, and then restored data using your backup.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help, or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [`carinamarina/backup` README](https://hub.docker.com/r/carinamarina/backup/)
* [data volume containers](/docs/tutorials/data-volume-containers/)
* [overlay networks]({{ site.baseurl }}/docs/tutorials/overlay-networks/)
* <a href="https://en.wikipedia.org/wiki/Tar_(computing)"><code>Tar</code></a>

### Next step

[Schedule regular backups using cron]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/)
