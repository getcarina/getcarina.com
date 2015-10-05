---
title: Run WordPress, Apache, and MySQL in Docker
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-05
permalink: docs/tutorials/wordpress-apache-mysql/
description: Learn how to spin up a single WordPress application running Apache and MySQL on the Rackspace Container Service
topics:
  - docker
  - beginner
---

WordPress is one of the most prevalent web applications in the world. This
series of tutorials covers how to migrate your content management system (CMS)
application to more of a microservices model.

This tutorial uses the following scenario: setting up WordPress in a single
Docker container, which runs in a Docker Swarm cluster on the Rackspace
Container Service.

The MySQL database is hosted externally on the Rackspace Cloud Databases platform,
which makes it easier to deploy, manage, and scale our web application over time.
Finally, you use Apache to deliver traffic to your application.

### Prerequisites

If you're not sure what a Docker container is, read the
[Docker 101](../docker-101-introduction-docker) tutorial to learn some basics.

### Set up the MySQL instance

First you create a database instance that is running MySQL. You can do this in
the Rackspace Cloud Control Panel by following these instructions:

1. Log in to the [Cloud Control Panel](https://mycloud.rackspace.com/).
2. At the top of the panel, click **Databases > MySQL**.
3. On the Cloud Databases page, click **Create Instance**.
4. Name the instance **WordPress** and select **IAD** as the region.
5. For the engine, select **MySQL 5.6**.
6. For the RAM, **2 GB** is recommended, but use the value that you prefer (a single
   WordPress container does not require much RAM).
7. Specify **5 GB** for the disk space.
8. In the Add Database section, create a database named **wordpress**.
9. Specify **wordpress** as the username, and assign a
   [strong password](https://strongpasswordgenerator.com/) to it. Be sure to
   remember this password because you will need it in step 11 and later.
10. Click **Create instance**.

    A compute instance with 2 GB of RAM and 5 GB of disk space running MySQL
    5.6 is provisioned. It might take a few minutes to build. The **wordpress**
    user is automatically granted full privileges to the new **wordpress**
    database.
11. Save your password as an environment variable:

  ```
  export DB_PASSWORD="<strongPassword>"
  ```

12. Save your instance hostname as an environment variable, which should look
    something like this:

  ```
  export DB_HOST=cdedf98d3852989dc00f4b6bd0e31f98af746a1c.rackspaceclouddb.com
  ```

### Create a Swarm cluster

Now you need to set up the Docker Swarm cluster. If you need instructions, read
the getting started guide. After you've followed the steps and have a fully
operational cluster, you can resume this tutorial.

### Deploy the WordPress container

After you have a MySQL database instance and have a Docker Swarm cluster, you're
ready to deploy the WordPress container. You specify all of the database
configuration with environment variables, including the database host and
password:

```
docker run --detach \
  --publish 80:80 \
  --name wordpress \
  --env WORDPRESS_DB_HOST=$DB_HOST \
  --env WORDPRESS_DB_USER=wordpress \
  --env WORDPRESS_DB_PASSWORD=$DB_PASSWORD \
  --env WORDPRESS_DB_NAME=wordpress \
  wordpress
```

The following list explains each component of this command:

* `--detach` runs the container as a background process.
* `--publish` pairs port 80 on the Swarm host to the container's own internal port 80.
This is the port that Apache listens on for incoming HTTP traffic.
* `--name` enables you to set a human-readable name for the container.
* `--env` enables you to set the environment variables that will be injected into
your Docker container (and therefore made available to our PHP app). You are
setting the following the variables:

  * `WORDPRESS_DB_HOST` is the hostname of your MySQL instance. This variable
     resolves to an IPv4 address in the IAD ServiceNet subnet, which is a
     private network that only resources inside the IAD region can access.
  * `WORDPRESS_DB_USER` is the name of the MySQL user that WordPress will use.
  * `WORDPRESS_DB_PASSWORD` is the password used by the MySQL user.
  * `WORDPRESS_DB_NAME` is the name of the MySQL database that WordPress will use.

The default `wordpress` Docker image includes the Apache 2 web server by default,
meaning that traffic will be handled on port 80.

### Verify that the container is running

After running the preceding command, you should see the container's unique ID
on a new line in the output. You can verify that it’s running by executing the
following command:

```
docker ps
```

The output of this command should show your new `wordpress` container, with its
public IPv4 address and the port that the container is listening on (in the
`PORTS` column). If you copy the public IP address and paste it into your
browser, you can see your WordPress front end and also log in to the admin back
end.

You could also run the following command, which opens your default browser and
points it to the IP address:

```
open http://$(docker port wordpress 80)
```

### Next step

The [next tutorial](../linking-wordpress-containers) describes how to set up
more complex container relationships, such as an NGINX front end.
