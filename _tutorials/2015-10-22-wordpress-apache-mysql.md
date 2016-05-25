---
title: Run WordPress, Apache, and MySQL in Docker
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-22
permalink: docs/tutorials/wordpress-apache-mysql/
description: Learn how to spin up a single WordPress application running Apache and MySQL on Carina
topics:
  - docker
  - beginner
---

WordPress is one of the most prevalent web applications in the world. This
series of tutorials covers how to migrate your content management system (CMS)
application to more of a microservices model.

This tutorial uses the following scenario: set up WordPress in a single
Docker container, which runs in a Docker Swarm cluster on the Carina. Host the MySQL database
in a Docker container. Finally, use Apache to deliver traffic to your application.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Create an overlay network

The first step is to create a user-defined network. This network allows every
container that you create to communicate with all the other containers,
regardless of which Docker Swarm host they reside on.

To create an overlay network, run the following command:

    ```
    docker network create --driver overlay main-net
    ```

For more information on networking in Docker, read the [Understand Docker container networks](https://docs.docker.com/engine/userguide/networking/dockernetworks/)
documentation guide.

### Create MySQL container

The next step is to create the container that will run MySQL.

1. Generate two [strong passwords](https://strongpasswordgenerator.com/): a
root password and a password for the `wordpress` user.

2. Store these passwords temporarily in environment variables:

    ```
    $ export ROOT_PASSWORD=<rootPassword>
    $ export WORDPRESS_PASSWORD=<wordpressPassword>
    ```

    Be sure to replace `<rootPassword>` and `<wordpressPassword>` with your
    generated passwords.

3. Create the container by running the following terminal command. Name the
   container `mysql`, and use the password variables that you just created:

    ```
    $ docker run --detach \
      --name mysql \
      --env MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
      --env MYSQL_USER=wordpress \
      --env MYSQL_PASSWORD=$WORDPRESS_PASSWORD \
      --env MYSQL_DATABASE=wordpress \
      --net main-net \
      mysql
    ```

    The output should show the container ID.

4. To verify that the container is running, execute the following command:

    ```
    $ docker ps
    ```

    The output shows the full details of the `mysql` container, listening on port
    `3306/tcp`.

### Deploy the WordPress container

After you have a MySQL database instance and have a Docker Swarm cluster, you're
ready to deploy the WordPress container. Specify all of the database
configuration with environment variables, including the database host and
password by running the following command:

```
$ docker run --detach \
  --publish 80:80 \
  --name wordpress \
  --env WORDPRESS_DB_HOST=mysql:3306 \
  --env WORDPRESS_DB_USER=wordpress \
  --env WORDPRESS_DB_PASSWORD=$WORDPRESS_PASSWORD \
  --net main-net \
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
  * `WORDPRESS_DB_USER` is the name of the MySQL user that WordPress will use. If omitted,
     it will default to `wordpress`.
  * `WORDPRESS_DB_PASSWORD` is the password used by the MySQL user.
  * `WORDPRESS_DB_NAME` is the name of the MySQL database that WordPress will use.

* `--net` runs the container inside the overlay network named `main-net` that
you created earlier in this tutorial. This allows access to the MySQL container.

The default `wordpress` Docker image includes the Apache 2 web server by default,
meaning that traffic will be handled on port 80.

### Verify that the container is running

After running the preceding command, you should see the container's unique ID
on a new line in the output. You can verify that it’s running by executing the
following command:

```
$ docker ps
```

The output of this command should show your new `wordpress` container, with its
public IPv4 address and the port that the container is listening on (in the
`PORTS` column). If you copy the public IP address and paste it into your
browser, you can see your WordPress front-end and also log in to the admin back-end.

You could also run the following command, which opens your default browser and
points it to the IP address:

```
$ open http://$(docker port wordpress 80)
```

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next step

The [next tutorial](../linking-wordpress-containers) describes how to set up
more complex container relationships, such as an NGINX front end.
