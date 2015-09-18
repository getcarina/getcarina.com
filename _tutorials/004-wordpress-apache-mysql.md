---
title: Running WordPress, Apache and MySQL in Docker
description: How to spin up a single WordPress application running Apache and MySQL on the Rackspace Container Service
topics:
  - docker
  - beginner
---

WordPress is one of the most prevalent web applications in the world today, and
in this series of tutorials we'll be covering how to migrate your CMS to more
of a micro-services model.

In this guide we'll deal with a simple use-case: setting up WordPress in
a single Docker container, which runs in a Docker Swarm cluster on the
Rackspace Container Service.

The MySQL database will be hosted externally on Rackspace's Cloud Databases platform,
making it easier to deploy, manage and scale our web application over time.
Finally, we'll be using Apache to deliver traffic to our app.

If you're unsure about what a Docker container is, I recommend you reading
our [Docker 101]() tutorial to learn some of the basics first.

## Step 1: Set up the Database

The first thing we'll need to do is create a database instance running MySQL.
We can do this in the Control Panel by following this instructions:

1. Sign in to https://mycloud.rackspace.com/ using your username and password.
2. Navigate to Databases > MySQL and click on the "Create Instance button".
3. Call the instance "WordPress" and select "IAD" as the region. For the Engine,
be sure to choose MySQL 5.6. For the RAM, 2GB is recommended but you can toggle
the value according to your preference (a single WordPress container will not
require much RAM). Finally specify 5GB for the disk space.
4. Create a database named `wordpress`
5. Create a user called `wordpress`, and assign a [strong password](https://strongpasswordgenerator.com/)
to it. Be sure to remember this since we'll need it later on.
6. Click on "Create instance".

This will provision a compute instance with 2GB of RAM and 5GB of disk space
running MySQL 5.6. Give it a few minutes to build. The `wordpress` user created
will also  be automatically granted full privileges to the new `wordpress`
database.

## Step 2: Create a Swarm cluster

The next step will be to set up the Docker Swarm cluster.  If you're unsure of
how to do this, you can consult our [Getting Started guide](). Once you've
followed these steps and have a fully operational cluster, you can resume this
tutorial.

## Step 3: Deploy the WordPress container

Once you have a MySQL database instance and Docker Swarm cluster, you're
ready to deploy WordPress:

```
docker run -d -p 80:80 --name wordpress \
  -e WORDPRESS_DB_HOST= \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD= \
  -e WORDPRESS_DB_NAME=wordpress \
  wordpress
```

Let's breakdown this command and explain each component:

* `-d` as we know from [Docker 101](), daemonizes the container as a background
process.
* `-p` pairs port 80 on the Swarm host to the container's own internal port 80.
This is the port Apache listens on for incoming HTTP traffic.
* `--name` allows us to set a human-readable name for the container.
* `-e` allows us to set the environment variables which will be injected into
our Docker container (and therefore made available to our PHP app). Here are
the variables we're setting:

  * `WORDPRESS_DB_HOST` is the hostname of our MySQL instance. This resolves to
     an IPv4 address in the IAD servicenet subnet, which is a private network
     that only resources inside the IAD region can access.
  * `WORDPRESS_DB_USER` is the name of the MySQL user that WordPress will use.
  * `WORDPRESS_DB_PASSWORD` is the password used by the MySQL user.
  * `WORDPRESS_DB_NAME` is the name of the MySQL database that WordPress will use.

## Step 4: Complete!

After running that command, we should see the container's unique identifier
outputted on a new line. We can check it's running by executing:

```
docker ps
```

which should output our new `wordpress` container, along with its public
IPv4 address and port that our container is listening on (in the `PORTS` column).
If you copy and paste the public IP into your browser, you can see your
WordPress frontend and also log in to the admin backend.

Another way to do this is by running:

```
open http://$(docker port wordpress 80)
```

which opens up your default browser and points it to the IP.

So there we go! In the next tutorial, we'll be covering how to set up more
complex container relationships, such as an nginx frontend and a database
container.
