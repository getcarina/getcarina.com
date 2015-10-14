---
title: Getting Started
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/getting-started/
description: Getting Started on Carina
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
---

This tutorial shows you how to get your first containerized application up and running on Carina in a minimal amount of time.

### Sign up for Carina

To run applications on Carina, get an account by following the [sign up process](https://mycluster.rackspacecloud.com/managed).

### Create your cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

To create your cluster:

1. Sign in to [http://mycluster.rackspacecloud.com](http://mycluster.rackspacecloud.com)
1. Enter a cluster name in the Create New text field
1. Click Create Cluster
1. Click the Refresh button until your cluster reaches a status of active

### Connect to your cluster

Connect to your cluster by sourcing the cluster credentials and configuration. The cluster credentials and configuration are a set of files that allow you to securely access your cluster.

If you run into problems, consult the [Troubleshooting](#troubleshooting) section.

1. Click the [insert-download-icon-here]

1. Unzip the file to a location on your computer

    ```bash
    /Users/octopus/Downloads/57d513b9-ed36-487d-8415-4ac65b6d41a8
    ```

1. Open a terminal application

1. Change to the unzipped directory

    ```bash
    cd /Users/octopus/Downloads/57d513b9-ed36-487d-8415-4ac65b6d41a8
    ```

1. Download the Docker 1.8.2 client into the unzipped directory
 * [Linux](https://get.docker.com/builds/Linux/x86_64/docker-1.8.2)
 * [Mac](https://get.docker.com/builds/Darwin/x86_64/docker-1.8.2)
 * [Windows](https://get.docker.com/builds/Windows/x86_64/docker-1.8.2.exe)

1. Rename the client

    ```bash
    mv docker-1.8.2 docker
    ```

1. Ensure the client is executable on Linux and Mac

    ```bash
    chmod u+x docker
    ```

1. Source the cluster credentials and configuration

    ```bash
    source docker.env
    ```

1. Connect to your cluster and display information about it

    ```bash
    $ ./docker info

    Containers: 3
    Images: 2
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 1
     57d513b9-ed36-487d-8415-4ac65b6d41a8-n1: 104.130.0.124:42376
      └ Containers: 3
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 4.2 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    CPUs: 12
    Total Memory: 4.2 GiB
    Name: 3e867f7a955f
    ```

### Run your first application

Run a WordPress blog with a MySQL database.

1. Run a MySQL instance in a container

    Give it a name and use "my-root-pw" as a password.

  	```bash
  	./docker run --detach \
      --name mysql \
      --env MYSQL_ROOT_PASSWORD=my-root-pw \
      mysql:5.6
  	```

2. Run a Wordpress instance in a container

    Give it a name, link it to the MySQL instance, and publish the internal port 80 to the external port 8080.

  	```bash
  	./docker run --detach \
      --name wordpress \
      --link mysql \
      --publish 8080:80 \
      wordpress
  	```

3. Verify your run is successful

    View your running containers.

    ```bash
    $ ./docker ps

    CONTAINER ID    IMAGE        COMMAND                   CREATED           STATUS           PORTS                         NAMES
    35d29a25755a    wordpress    "/entrypoint.sh apach"    15 seconds ago    Up 14 seconds    104.130.0.124:8080->80/tcp    57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress
    2c9c2799f879    mysql:5.6    "/entrypoint.sh mysql"    9 minutes ago     Up 9 minutes     3306/tcp                      57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/mysql
    ```

5. View your WordPress site

    Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

    ```bash
    echo http://$(./docker port $(./docker ps --quiet --latest) 80)
    ```

6. Remove your WordPress site (optional)

    If you aren't going to use your WordPress site, it's best to remove it. This will also remove and posts you've made in the WordPress site.

    ```bash
    ./docker rm --force $(./docker ps --quiet -n=-2)
    ```

### Congratulations

You've successfully run your first containerized application!

Carina has many more features and there is more to learn. Please review the [Resources](#resources) and [Next step](#next-step) sections below for more information.

### Troubleshooting

#### Version Conflict

If you get the error

`Error response from daemon: client and server don't have same version (client : x.xx, server: x.xx)`

then read the [Version Conflict](/docs/references/version-conflict) guide.

#### Credentials

If you had trouble downloading your credentials then read the [Download Rackspace Container Service credentials](/docs/references/carina-credentials/) guide.

#### Cannot Connect

If you're behind a firewall or VPN and it's blocking port 2376 (a port used by Docker) and you get the error

`Cannot connect to the Docker daemon. Is "docker - d" running on this host?`

then request your network administrator to open that port or try this tutorial from a location where port 2376 isn't blocked.

### Resources

* If you're new to Docker, learn more at [Docker 101](/docs/tutorials/002-docker-102).
* 1-2 more links

### Next step

Learn about all of the features available to you in the [Overview of Carina](/docs/tutorials/overview-of-carina)
