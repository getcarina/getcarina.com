---
title: Linking containers using WordPress and nginx
description: How to spin up a multi-container WordPress application running nginx, php-fpm and MySQL on the Rackspace Container Service
topics:
  - docker
  - beginner
---

In the previous tutorial we covered how to set up a single Docker container
running Apache 2 and WordPress. For our database we used an externally hosted
MySQL instance, thereby avoiding some of the more complicated issues around
container relationships and data persistence in Docker.

In this guide we'll explore how to set up container links, in line with the best
practices set out by the Docker community. By the end, we'll have a single nginx
container accepting traffic, a backend container running php-fpm and WordPress,
and a MySQL container handling persistent state.

Before we begin, it's important to note that storing persistent data in
containers is quite a hotly contested issue. Many prefer extracting this type
of functionality out into external services, like Rackspace Cloud Databases. We
are setting up a MySQL container in this tutorial purely to demonstrate
container relationships. If you'd rather use a Database instance instead, follow
steps 1-3 in our [first tutorial](../wordpress-apache-mysql). Once you're done,
go straight to Step 3 of this tutorial.

### One process per container

One of the common expectations we have of Docker containers is that each one
should encapsulate a single running process. We discuss this in our [best practices]()
article, but to summarise the reasons of why this should be done:

- If we ran multiple processes per container we'd need an intermediary
piece of software like [supervisord](http://supervisord.org/) to manage multiple
processes, which goes against one the core aims of the Docker project: to use a
solution which is granular, lightweight and focuses on doing one thing well.

- Single processes bind the lifecycle of a container with the lifecycle of the
process itself. This means that if a process like nginx dies, this fatal error
directly impacts the state of the container itself, making debugging fairly
straightforward.

- Decoupling applications into smaller components aligns with the micro-services
model which provides far greater scalability than one monolithic application.

- Splitting out into multiple containers allows you to better allocate compute
resources to individual parts of your application stack.

### Step 1: Create MySQL container

The first step is to create the container that will be running MySQL. You first
need to generate two [strong passwords](https://strongpasswordgenerator.com/):
a root password and a password for the `wordpress` user. It's advisable to
store these temporarily in environment variables:

```
export ROOT_PASSWORD=<rootPassword>
export WORDPRESS_PASSWORD=<wordpressPassword>
```

Be sure to replace `<rootPassword>` and `<wordpressPassword>`. Once you have these,
plug them into the following terminal command:

```
docker run --detach \
  --name mysql \
  --env MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
  --env MYSQL_USER=wordpress \
  --env MYSQL_PASSWORD=$WORDPRESS_PASSWORD \
  --env MYSQL_DATABASE=wordpress \
  mysql
```

You should see the container ID outputted and, when you run `docker ps`, the
full details of the `mysql` container listening on port `3306/tcp`.

### Step 2: Deploy WordPress container running php-fpm pool

The next step is to set up the backend container running the WordPress
installation:

```
docker run -d \
  --link mysql:mysql \
  --name wordpress-fpm \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=$WORDPRESS_PASSWORD \
  wordpress:fpm
```

We are linking this container with the `mysql` container we just started, since
it will need access for persistent data storage. If you consult the [official
WordPress image](https://hub.docker.com/_/wordpress/) on Docker Hub, you can
see a full list of the environment variables that are required. As you will
notice, we did not specify the `WORDPRESS_DB_HOST` since it defaults to the IP
and port of the linked `mysql` container. Nor did we need to specify the
`WORDPRESS_DB_NAME`, since it defaults to `wordpress`.

### Step 3: Prepare nginx Docker image

The final set-up step is to start our nginx frontend container. We will be
deploying a variant of the base `nginx` Docker image which means you can either:

1. Build the image locally from a Dockerfile and push to your own Docker Hub account; or
2. Run a prebuilt image hosted on the `rackspace` Docker Hub account.

If you want to use the prebuilt image, you can skip the next step and head
straight to `Step 4: Running your container`.

#### Optional: Building your own image

For the time being, you will need to build the Docker image locally and push
it to a central repository, like Docker Hub.

To start, we'll clone Rackspace's [Library repo](https://github.com/rackerlabs/rcs-library)
which contains the nginx Dockerfile, and the nginx config file:

```
git clone https://github.com/rackerlabs/rcs-library
cd rcs-library/nginx-fpm
```

Once we're inside the directory, we can build our image:

```
docker build -t <userNamespace>/nginx-fpm .
```

Where `<userNamespace>` is your Docker Hub username.

The final step is to then push your local image to Docker Hub, just like you
would with git:

```
docker push <userNamespace>/nginx-fpm
```

### Step 4: Running the nginx container

Once you've prepared the image, you're ready to start the nginx container. You
will need to substitute `<namespace>` with either your own Docker Hub account
name, or `rackspace` if you did not build and push your own Docker image.

```
docker run -d \
  -p 80:80 \
  --name nginx \
  --link wordpress-fpm:fpm \
  --volumes-from wordpress-fpm \
  -e "affinity:container==wordpress-fpm" \
  <namespace>/nginx-fpm
```

This will create a container running nginx which handles traffic for the
`/var/www/html` directory. This directory is a volume mount, made available
(and therefore shared) by the `wordpress` container using the `--volumes-from`
option.

nginx will proxy all requests to the PHP FPM container (`wordpress`)
via the FCGI protocol using that container's TCP hostname and port (`fpm:9000`).

### Step 4: Complete!

We can see whether our stack is running:

```
docker ps
```

And we can visit our nginx frontend by finding its IPv4 address and opening it
in our default browser:

```
open http://$(docker port nginx 80)
```

That's it! You should now see the standard WordPress installation guide.

In the next tutorial, we'll be exploring how to set up a fully load balanced
and more distributed WordPress cluster on Docker Swarm.
