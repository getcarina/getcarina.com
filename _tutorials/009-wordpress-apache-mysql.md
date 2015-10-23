---
title: Run WordPress, Apache, and MySQL in Docker
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-05
permalink: docs/tutorials/wordpress-apache-mysql/
description: Learn how to spin up a single WordPress application running Apache and MySQL on Carina
topics:
  - docker
  - beginner
---

WordPress is one of the most prevalent web applications in the world. This
series of tutorials covers how to migrate your content management system (CMS)
application to more of a microservices model.

This tutorial uses the following scenario: setting up WordPress in a single
Docker container, which runs in a Docker Swarm cluster on the Rackspace
Container Service. The MySQL database is also hosted in a Docker container.
Finally, you use Apache to deliver traffic to your application.

### Prerequisites

If you're not sure what a Docker container is, read the
[Docker 101](../docker-101-introduction-docker) tutorial to learn some basics.

### Create a Swarm cluster

Now you need to set up the Docker Swarm cluster. If you need instructions, read
the getting started guide. After you've followed the steps and have a fully
operational cluster, you can resume this tutorial.

### Create MySQL container

The first step is to create the container that will be running MySQL.

1. Generate two [strong passwords](https://strongpasswordgenerator.com/): a
root password and a password for the `wordpress` user.

2. Store these passwords temporarily in environment variables:

  ```
  export ROOT_PASSWORD=<rootPassword>
  export WORDPRESS_PASSWORD=<wordpressPassword>
  ```

  Be sure to replace `<rootPassword>` and `<wordpressPassword>` with your
  generated passwords.

3. Create the container by running the following terminal command. Name the
   container `mysql` and use the password variables that you just created:

  ```
  docker run --detach \
    --name mysql \
    --env MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
    --env MYSQL_USER=wordpress \
    --env MYSQL_PASSWORD=$WORDPRESS_PASSWORD \
    --env MYSQL_DATABASE=wordpress \
    mysql
  ```

  The output should show the container ID.

4. To verify that the container is running, execute the following command:

  ```
  docker ps
  ```

  The output shows the full details of the `mysql` container, listening on port
  `3306/tcp`.

### Deploy the WordPress container

After you have a MySQL database instance and have a Docker Swarm cluster, you're
ready to deploy the WordPress container. You specify all of the database
configuration with environment variables, including the database host and
password:

```
docker run --detach \
  --publish 80:80 \
  --name wordpress \
  --link mysql:mysql \
  --env WORDPRESS_DB_USER=wordpress \
  --env WORDPRESS_DB_PASSWORD=$WORDPRESS_PASSWORD \
  wordpress
```

The following list explains each component of this command:

* `--detach` runs the container as a background process.
* `--publish` pairs port 80 on the Swarm host to the container's own internal port 80.
This is the port that Apache listens on for incoming HTTP traffic.
* `--name` enables you to set a human-readable name for the container.
* `--env` enables you to set the environment variables that will be injected into
your Docker container (and therefore made available to our PHP app). You can
set the following the variables:

  * `WORDPRESS_DB_HOST` is the hostname of your MySQL instance.
  * `WORDPRESS_DB_USER` is the name of the MySQL user that WordPress will use.
  * `WORDPRESS_DB_PASSWORD` is the password used by the MySQL user.
  * `WORDPRESS_DB_NAME` is the name of the MySQL database that WordPress will use.

You do not need to specify the WORDPRESS_DB_HOST variable because it defaults to
the IP address and port of the linked `mysql` container. Nor do you need to
specify the WORDPRESS_DB_NAME variable, because it defaults to `wordpress`.

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
