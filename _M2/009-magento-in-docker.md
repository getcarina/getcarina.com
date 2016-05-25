---
title: Run Magento in a Docker container
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/magento-in-docker/
description: Learn how to set up Magento to run in a Docker container, linked with Redis and MySQL
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
---

Magento is one of the most well-established ecommerce platforms in the PHP
community, but the task of installing it on a virtual machine and configuring
everything can be daunting, for beginners, and onerous, for experienced developers.
With Docker, most of the complications are taken away, because you have a
portable and reproducible environment already set up. All you need to do is run
it.

In this tutorial, you will set up a Docker container running Magento, a Redis
container (for caching), and an external MySQL database (for persistent storage).

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Download an environment file

When you run your Magento container later in this tutorial, you will link to a
local environment file that contains most of your configuration. It makes
sense to download it early so you can populate it as you progress through this
tutorial.

1. Clone the Carina library by running the following command:

  ```
  git clone https://github.com/getcarina/examples.git
  ```

2. Navigate to the **magento** directory to find the **env** file (and a few
  other files) that you need for this tutorial.

**Note**: _Never_ check this file into version control or expose it publicly.

### Modify the configuration

Open the **env** file in the **magento** directory that you just cloned. You
should see all of the configuration values for your Magento installation. Edit
these values according to your preference.

### Set up MySQL

Next, create a database instance that is running MySQL. You can
do this, in the Rackspace Cloud Control Panel, by following these instructions:

1. Open the **env** file that you downloaded in
   [Download an environment file](#download-an-environment-file).
2. Log in to the [Cloud Control Panel](https://mycloud.rackspace.com/).
3. At the top of the panel, click **Databases > MySQL**.
4. On the Cloud Databases page, click **Create Instance**.
5. Name the instance **Magento** and select **IAD** as the region.
6. For the engine, select **MySQL 5.6**.
7. For the RAM, **2 GB** is recommended, but use the value that you prefer.
8. Specify **5 GB** for the disk space.
9. In the Add Database section, create a database named **magento**.
10. In the **env** file, set the value for MYSQL_DATABASE to the database name
    that you just specified.
11. Specify **magento** as the username, and assign a
   [strong password](https://strongpasswordgenerator.com/) to it.
12. In the **env** file, set the value for MYSQL_USER and MYSQL_PASSWORD to the
    two values that you just specified.
13. Click **Create Instance**.

    A compute instance with 2 GB of RAM and 5 GB of disk space running MySQL
    5.6 is provisioned. It might take a few minutes to build. The **magento**
    user is automatically granted full privileges to the new **magento**
    database.
14. When the instance hostname is displayed in the control panel, set the value
    of the MYSQL_HOST variable in the **env** file to it. The hostname looks
    like the following example:

  ```
  cdedf98d3852989dc00f4b6bd0e31f98af746a1c.rackspaceclouddb.com
  ```

### Run web and Redis containers

Next, start the following containers:

- A `web` container running Apache 2. This container accepts connections on
  port 80, just like a normal web server.

- A `redis` container that will handle back-end and session caching. Because
  Magento does not support this by default, the
  [Cm_RedisSession](https://github.com/colinmollenhour/Cm_RedisSession) and
  [Cm_Cache_Backend_Redis](https://github.com/colinmollenhour/Cm_Cache_Backend_Redis)
  plug-ins were preinstalled in the Docker image for the `web` container.

The **magento** directory contains a **docker-compose.yml** file that enables
you to set up both containers by using a single `docker-compose` command. Simply
run:

```
$ docker-compose up -d
```

This command provisions two containers, links them, binds port 80 to the
`web` container, and injects the environment variables from the **env** file
into the `web` container.

### Verify and set up hosts

1. Verify that the `web` container is operating correctly by running the
   following command:

  ```
  $ docker ps
  ```

  You should see two containers running, one of which has a public IPv4 address
  assigned to it.

2. Using that IPv4 address and the MAGENTO_URL value that you specified in
  [Modify the configuration](#modify-the-configuration), add the following
  entry to your `/etc/hosts` file:

  ```
  <publicIPv4> <hostname>
  ```

  This entry enables you to visit your Magento website by using a simulated
  hostname rather than the IP address.

3. Open this IP address in your default browser:

  ```
  open http://$(docker port web 80)/
  ```

  You are redirected to the default Magento installation page.

4. Either manually go through the steps yourself, adding in the configuration,
   or run the following script, which finishes up the installation for you:

  ```
  docker exec -it web bash /opt/setup-config.bash
  ```

### Install sample data

Sometimes it is useful to install sample data so that you can better simulate
what a production website will look like. You can do this by running the
following command:

```
docker exec -it web bash /opt/install-data.bash
```

### Verify that Redis is working

You can verify that Redis is being used by Magento for caching.

1. Run the following command:

  ```
  $ docker exec -it redis redis-cli
  ```

2. When the CLI prompt is ready, write `MONITOR` and press Enter.
  All I/O will now be outputted.

3. Go to any front-end web page on your Magento website.
  You should see all of the relevant activity outputted to your terminal.

4. To test that sessions are being stored, go to the Admin login portal and
   sign in.

### Next step

The next tutorial covers more advanced topics, such as statelessness and how to
scale Magento in Docker.
