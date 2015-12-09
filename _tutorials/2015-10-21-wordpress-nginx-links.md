---
title: Run WordPress across linked front end and back end containers
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-21
permalink: docs/tutorials/linking-wordpress-containers/
description: Learn how to spin up a multi-container WordPress application split across linked containers, using NGINX as the front end and PHP-FPM as the back end.
topics:
  - docker
  - beginner
---

In the [previous tutorial]({{ site.baseurl }}/docs/tutorials/wordpress-apache-mysql/), you set up a Docker
container running Apache 2 and WordPress. For your database, you ran MySQL in a
Docker container.

This tutorial describes how to set up container links, according to the best
practices set out by the Docker community. By the end, you will have a single
NGINX container accepting traffic, a back-end container running PHP-FPM and
WordPress, and a MySQL container handling persistent state.

**Note:** Storing persistent data in containers is a hotly contested issue. Many
prefer to instead use an external service such as Rackspace Cloud Databases.
This tutorial sets up a MySQL container to demonstrate container relationships.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/) that has at least two segments.

**Note:** If you completed the [previous tutorial]({{ site.baseurl }}/docs/tutorials/wordpress-apache-mysql/), you can reuse the same cluster, so long as all previous Docker containers have been removed. You can delete all of them with this command:

```
$ docker rm -fv $(docker ps -q)
```

### One process per container

One of the common expectations of Docker containers is that each one should
encapsulate a single running process. This is the topic of a best practices
article, but the following list summarizes why "one process per container" is
ideal:

- If multiple processes ran in a single container, an intermediary piece of
software, like [supervisord](http://supervisord.org/), would be needed to manage
the multiple processes. This added layer would go against one of the core aims
of the Docker project: to use a solution that is granular, lightweight, and
focuses on doing one thing well.

- Single processes bind the life cycle of a container with the life cycle of the
process itself. This connection means that if a process, like NGINX, fails, this
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
    $ export ROOT_PASSWORD=<rootPassword>
    $ export WORDPRESS_PASSWORD=<wordpressPassword>
    ```

    Be sure to replace `<rootPassword>` and `<wordpressPassword>` with your
    generated passwords.

3. Create the container by running the following terminal command. Name the
   container `mysql` and use the password variables that you just created:

    ```
    $ docker run --detach \
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
    $ docker ps
    ```

    The output shows the full details of the `mysql` container, listening on port
    `3306/tcp`.

### Deploy WordPress container running PHP-FPM pool

Next, set up the back-end container that is running the WordPress installation:

```
$ docker run -d \
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

The final step is to start an NGINX front-end container, by deploying a
variant of the base `nginx` Docker image. You have the following options:

- Build the image locally from a Dockerfile and push it to your own Docker Hub account.
- Run a prebuilt image that is hosted on the `carinamarina` Docker Hub account.

If you want to use the prebuilt image, you can skip to
[Run the NGINX container](#run-the-nginx-container).

To build the Docker image, build it locally and push it to a central repository
such as Docker Hub.

1. Clone the Rackspace [Examples repo](https://github.com/getcarina/examples),
which contains the `nginx` Dockerfile and the `nginx` configuration file:

    ```
    $ git clone https://github.com/getcarina/examples.git
    ```

2. Build your image as follows, where `<userNamespace>` is your Docker Hub username:

    ```
    $ docker build -t <userNamespace>/nginx-fpm nginx-fpm
    ```

3. Push your local image to Docker Hub, just like you would with Git:

    ```
    $ docker push <userNamespace>/nginx-fpm
    ```

### Run the NGINX container

After you've prepared the image, you can start the NGINX container.

Run the following command, substituting `<namespace>` with either your own
Docker Hub account name, or `carinamarina` if you did not build and push your own
Docker image:

```
$ docker run -d \
  -p 80:80 \
  --name nginx \
  --link wordpress-fpm:fpm \
  --volumes-from wordpress-fpm \
  -e "affinity:container==wordpress-fpm" \
  <namespace>/nginx-fpm
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
$ docker ps
```

You can also visit your NGINX front end by finding its IPv4 address and opening
it in your default browser:

```
$ open http://$(docker port nginx 80)
```

You should now see the standard WordPress installation guide.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next step

Learn more about storing persistent data in containers at [Use data volume containers]({{ site.baseurl }}/docs/tutorials/data-volume-containers/).

<!--
TODO: Use the text below when that tutorial is back in for M2.

The [next tutorial](../load-balance-wordpress-docker-containers/) explores how
to set up a fully load balanced and more distributed WordPress cluster on
Docker Swarm.
-->
