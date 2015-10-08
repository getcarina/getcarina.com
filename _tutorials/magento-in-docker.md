---
title: Run Magento in a Docker container
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-05
permalink: docs/tutorials/magento-in-docker/
description: Learn how to set up Magento to run in a Docker container, linked with Redis and MySQL.
topics:
  - docker
  - beginner
---

Magento is one of the most well-established eCommerce platforms in the PHP
community, but the task of installing it on a virtual machine and configuring
everything can be daunting for beginners and onerous for experienced developers.
With Docker, a lot of the complications are taken away, since you have a
portable and reproducible environment already set up: all you need to do is run
it.

In this tutorial you will be setting up a Docker container running Magento,
alongside a Redis container for caching, and an external MySQL database for
persistent storage.

### Prerequisites

A Rackspace Container Service cluster running Docker Swarm.

If you're not sure what a Docker container is, read the
[Docker 101](../docker-101-introduction-docker) tutorial to learn some basics.

### Download environment file

Later on when running your Magento container, you will link to a local
environment file that contains most of your configuration. So it makes
sense to download it early so you can populate it as you progress through this
guide.

```
git clone https://github.com/rackerlabs/rcs-library
```

If you navigate to the `magento` directory, you will see the `env` file (along
  with a few other files) that you will need for this tutorial.

**Note**: _Never_ check this file into version control or expose it publicly.

### Modify configuration

Open up the `env` file in the directory you cloned in the previous step. You
should see all of the configuration values for your Magento installation. Be
sure to edit these values according to your preference.

### Set up MySQL

The next step is to create a database instance that is running MySQL. You can
do this in the Rackspace Cloud Control Panel by following these instructions:

1. Navigate to the directory where you cloned the environment file in Step 1.
2. Log in to the [Cloud Control Panel](https://mycloud.rackspace.com/).
3. At the top of the panel, click **Databases > MySQL**.
4. On the Cloud Databases page, click **Create Instance**.
5. Name the instance **Magento** and select **IAD** as the region.
6. For the engine, select **MySQL 5.6**.
7. For the RAM, **2 GB** is recommended, but use the value that you prefer.
8. Specify **5 GB** for the disk space.
9. In the Add Database section, create a database named **magento**. Set the
   `MYSQL_DATABASE` in the `env` file to the database name you specified.
10. Specify **magento** as the username, and assign a
   [strong password](https://strongpasswordgenerator.com/) to it. Using these
   two values, set `MYSQL_USER` and `MYSQL_PASSWORD` in the `env` file.
11. Click **Create instance**.

    A compute instance with 2 GB of RAM and 5 GB of disk space running MySQL
    5.6 is provisioned. It might take a few minutes to build. The **magento**
    user is automatically granted full privileges to the new **magento**
    database.
12. Once it's displayed, set the `MYSQL_HOST` variable in the `env` file
    to the instance hostname shown in the Control Panel. It will look like this:

  ```
  cdedf98d3852989dc00f4b6bd0e31f98af746a1c.rackspaceclouddb.com
  ```

### Run web and redis containers

Next, you will start the following containers:

- A `web` container running Apache 2. This will accept connections on port 80
  just like a normal web server.

- A `redis` container that will handle back-end and session caching. Because
  Magento does not support this by default, we have preinstalled the
  [Cm_RedisSession](https://github.com/colinmollenhour/Cm_RedisSession) and
  [Cm_Cache_Backend_Redis](https://github.com/colinmollenhour/Cm_Cache_Backend_Redis)
  plugins into the Docker image for the `web` container.

In the `magento` directory there exists a `docker-compose.yml` file which
allows you to setup both containers using a single `docker-compose` command:

```
docker-compose up -d
```

This command will provision two containers and link them; bind port 80 to the
web container; and inject the environment variables from the `env` file into the
`web` container.

### Verify and setup hosts

Verify that the `web` container is operating correctly, by running:

```
docker ps
```

You should see two containers running, one of which has a public IPv4 assigned
to it. Using that IPv4 address and the `MAGENTO_URL` value you specified in
[Modify configuration](#modify-configuration), add an entry to your
`/etc/hosts` file. It should look like this:

```
<publicIPv4> <hostname>
```

This will allow you to visit your Magento website using a simulated hostname,
rather than IP address. If you open up this IP address in your default browser,
you will be redirected:

```
open http://$(docker port web 80)/
```

This will display the default Magento installation page. You can either
manually go through the steps yourself, adding in the configuration, or you
can run the following script which finishes up the installation for you:

```
docker exec -it web bash /opt/setup-config.bash
```

### Sample data

Sometimes it is useful to install sample data so that you can better simulate
what a production website will look like. You can do this by running:

```
docker exec -it web bash /opt/install-data.bash
```

### Verify Redis is working

You can verify that Redis is being used by Magento for caching by running
the following command:

```
docker exec -it redis redis-cli
```

And, once the CLI prompt is ready, write `MONITOR` and hit enter. All I/O
will now be outputted. Next, go to any frontend webpage on your Magento website,
and you should see all of the relevant activity outputted to your terminal.

To test that sessions are being stored, go to the Admin login portal and sign in.

### Next step

In our next tutorial, we will be covering more advanced topics, such as
statelessness and how to scale Magento in Docker.
