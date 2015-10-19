---
title: Run WordPress across linked front end and back end containers
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-05
description: Learn how to spin up a multi-container WordPress application split across linked containers, using NGINX as the front end and PHP-FPM as the back end.
topics:
  - docker
  - beginner
---

In the [previous tutorial](../wordpress-apache-mysql), you set up a single
Docker container running Apache 2 and WordPress. For your database, you used an
externally hosted MySQL instance, thereby avoiding some of the more complicated
issues around container relationships and data persistence in Docker.

This tutorial describes how to set up container links, according to the best
practices set out by the Docker community. By the end, you will have a single
NGINX container accepting traffic, a back-end container running PHP-FPM and
WordPress, and a MySQL container handling persistent state.

**Note:** Storing persistent data in containers is a hotly contested issue. Many
prefer to instead use an external service such as Rackspace Cloud Databases.
This tutorial sets up a MySQL container just to demonstrate container
relationships. If you'd rather use a database instance, use the instance that
you created in [the previous tutorial](../wordpress-apache-mysql), and skip the
[Create a MySQL container](#create-mysql-container) and
[Deploy a WordPress container running a PHP-FPM pool](#deploy-wordpress-container-running-php-fpm-pool)
sections of this tutorial.

### Prerequisite

A Carina cluster, with at least two nodes, running Docker Swarm.

**Note:** If you completed the [previous tutorial](../wordpress-apache-mysql), you
can reuse the same cluster, so long as all previous Docker containers have been
removed. You can delete all of them with this command:

```
docker rm -fv $(docker ps -q)
```

### One process per container

One of the common expectations of Docker containers is that each one should
encapsulate a single running process. This is the topic of a best practices
article, but the following list summarizes why "one process per container" is
ideal:

- If multiple processes ran in a single container, an intermediary piece of
software like [supervisord](http://supervisord.org/) would be needed to manage
the multiple processes. This added layer would go against one of the core aims
of the Docker project: to use a solution that is granular, lightweight, and
focuses on doing one thing well.

- Single processes bind the life cycle of a container with the life cycle of the
process itself. This connection means that if a process like NGINX fails, this
fatal error directly impacts the state of the container itself, making
debugging fairly straightforward.

- Decoupling applications into smaller components aligns with the microservices
model which provides far greater scalability than one monolithic application.

- Splitting applications into multiple containers allows you to better allocate
compute resources to individual parts of your application stack.

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

### Deploy WordPress container running PHP-FPM pool

Next, set up the back-end container that is running the WordPress installation:

```
docker run -d \
  --link mysql:mysql \
  --name wordpress-fpm \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=$WORDPRESS_PASSWORD \
  wordpress:fpm
```

You are linking this container with the `mysql` container that you just started,
because the WordPress container will need access for persistent data storage.
To see a full list of the environment variables that are required, see the
[official WordPress image](https://hub.docker.com/_/wordpress/) on Docker Hub.
You do not need to specify the WORDPRESS_DB_HOST variable because it defaults to
the IP address and port of the linked `mysql` container. Nor do you need to
specify the WORDPRESS_DB_NAME variable, because it defaults to `wordpress`.

### Prepare the NGINX Docker image

The final step is to start an NGINX front-end container. To do so, you deploy a
variant of the base `nginx` Docker image. You have the following options:

- Build the image locally from a Dockerfile and push it to your own Docker Hub account.
- Run a prebuilt image that is hosted on the `rackspace` Docker Hub account.

If you want to use the prebuilt image, you can skip to
[Run the NGINX container](#run-the-NGINX-container).

To build the Docker image, build it locally and push it to a central repository
such as Docker Hub.

1. Clone the Rackspace [Examples repo](https://github.com/rackerlabs/carina-examples),
which contains the `nginx` Dockerfile and the `nginx` configuration file:

  ```
  git clone https://github.com/rackerlabs/carina-examples.git
  ```

2. Build your image as follows, where `<userNamespace>` is your Docker Hub username:

  ```
  docker build -t <userNamespace>/NGINX-fpm NGINX-fpm
  ```

3. Push your local image to Docker Hub, just like you would with Git:

  ```
  docker push <userNamespace>/NGINX-fpm
  ```

### Run the NGINX container

After you've prepared the image, you can start the NGINX container.

Run the following command, substituting `<namespace>` with either your own
Docker Hub account name, or `rackspace` if you did not build and push your own
Docker image:

```
docker run -d \
  -p 80:80 \
  --name NGINX \
  --link wordpress-fpm:fpm \
  --volumes-from wordpress-fpm \
  -e "affinity:container==wordpress-fpm" \
  <namespace>/NGINX-fpm
```

This command creates a container running NGINX, which handles traffic for the
`/var/www/html` directory. This directory is a volume mount, made available
(and therefore shared) by the `wordpress` container by using the `--volumes-from`
option.

NGINX will proxy all requests to the PHP-FPM container (`wordpress`)
via the FCGI protocol by using that container's TCP hostname and port (`fpm:9000`).

### Verify the stack is running

Verify that your stack is running by executing the following command:

```
docker ps
```

You can also visit your NGINX front end by finding its IPv4 address and opening
it in your default browser:

```
open http://$(docker port NGINX 80)
```

You should now see the standard WordPress installation guide.

### Next step

The [next tutorial]() explores how to set up a fully load balanced and more
distributed WordPress cluster on Docker Swarm.
