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

## One process per container

One of the common expectations we have of Docker containers is that each one
should encapsulate a single running process. We discuss this in our [best practices]()
article, but to summarise the reasons of why this should be done:

- if we ran multiple processes per container we'd need an intermediary
piece of software like [supervisord](http://supervisord.org/) to manage multiple
processes, which goes against one the core aims of the Docker project: to use a
solution which is granular, lightweight and focuses on doing one thing well.

- single processes bind the lifecycle of a container with the lifecycle of the
process itself. This means that if a process like nginx dies, this fatal error
directly impacts the state of the container itself, making debugging fairly
straightforward.

- decoupling applications into smaller components aligns with the micro-services
model which provides far greater scalability than one monolithic application.

- going back to the idea of efficiency, splitting out into multiple containers
allows you to better allocate compute resources to individual parts of your
application stack. So, for example, if you only need one instance of nginx, but
multiple instances of fpm, you don't need to waste memory.

## Step 1: Create MySQL container

The first step is to create the container that will be running MySQL. You first
need to generate two [strong passwords](https://strongpasswordgenerator.com/):
a root password and a password for the `wordpress` user. Once you have these,
plug them into the following terminal command:

```
docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=<ROOT_PASSWORD> \
  -e MYSQL_USER=wordpress \
  -e MYSQL_PASSWORD=<WORDPRESS_PASSWORD> \
  -e MYSQL_DATABASE=wordpress \
  mysql
```

Be sure to replace `<ROOT_PASSWORD>` and `<WORDPRESS_PASSWORD>`.

## Step 2: Deploy WordPress container running php-fpm pool

The next step is to set up the backend container running the WordPress
installation:

```
docker run -d --link mysql:mysql --name wordpress-fpm \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=<WORDPRESS_PASSWORD> \
  wordpress:fpm
```

Be sure to replace `<WORDPRESS_PASSWORD>` with the MySQL password used in
previous steps. As you will notice, we are linking this container with the
MySQL container we just started. If you're not sure what this is, please
read our article on [Container Linking]().

## Step 3: Prepare nginx Docker image

The final set-up step is to start our nginx frontend container.

We will be deploying a variant of the base `nginx` Docker image which means you
can either:

* build the image locally from a Dockerfile and push to your own Docker Hub account; or
* run a prebuilt image hosted on the `rackspace` Docker Hub account.

If you want to use the prebuilt image, you can skip the next step and head
straight to `Step 4: Running your container`.

### Optional: Building your own image

For the time being, you will need to build the Docker image locally and push
it to a central repository, like Docker Hub. If you're unfamiliar with any of these
concepts, please read our [Introduction to Docker Hub]() article.

To start, we'll clone [this gist](https://gist.github.com/md5/d9206eacb5a0ff5d6be0)
which contains the nginx Dockerfile, and the nginx config file:

```
git clone git://github.com/d9206eacb5a0ff5d6be0.git docker-nginx-fpm
cd docker-nginx-fpm
```

Once we're inside the directory, we can build our image:

```
docker build -t <USER_NAMESPACE>/nginx-fpm .
```

Where `<USER_NAMESPACE>` is the name of your Docker Hub account. The final step
is to then push your local image to Docker Hub, just like you would with
GitHub:

```
docker push <USER_NAMESPACE>/nginx-fpm
```

## Step 4: Running the nginx container

Once you've prepared the image, you're ready to start the nginx container. You
will need to substitute `<NAMESPACE>` with either your own Docker Hub account
name, or `rackspace` if you did not build and push your own Docker image.

```
docker run -d -p 80:80 --name nginx \
  --link wordpress-fpm:fpm \
  --volumes-from wordpress-fpm \
  -e "affinity:container==wordpress-fpm" \
  <NAMESPACE>/nginx-fpm:latest
```

## Step 4: Complete!

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
