---
title: MySQL with RCS
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/mysql-with-rcs/
description: How to store production data in MySQL with RCS
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - data-stores
  - mysql
---

This tutorial describes using MySQL with Rackspace Container Service (RCS) so that you can store temporary data for development/testing in containers and store your production data persistently and securely in Rackspace's MySQL Cloud Database.

### Prerequisites

1. [RCS Credentials](rcs-credentials)
1. [Git](https://git-scm.com/downloads)

### Steps

1. Run a MySQL container for dev/test in a container for ephemeral data storage

    Export the necessary environment variables that will configure the MySQL instance.

    ```bash
    export MYSQL_ROOT_PASSWORD=root-password
    export MYSQL_DATABASE=guestbook
    export MYSQL_USER=guestbook-test
    export MYSQL_PASSWORD=guestbook-test-password
    ```

    Run a MySQL instance in a container from an official image.

    ```bash
    docker run --detach --publish-all \
      --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      mysql:5.6
    ```

    Review the container you just ran using the `--latest` parameter. The Status of the container should begin with "Up". If it doesn't, see the Troubleshooting section below

    ```bash
    docker ps --latest
    ```

    View the id of the container you just ran using the `--quiet` parameter.

    ```bash
    docker ps --quiet --latest
    ```

    Discover what IP address and port MySQL is running on by combining the `docker port` command, the id of the container you just ran, and the default MySQL port of 3306.

    ```bash
    docker port $(docker ps --quiet --latest) 3306
    ```

    For the containerized MySQL service, note how you don't care what it's named, what IP address it runs on, or what port it uses. Instead you discover this information dynamically with the command above and use it later in the tutorial to connect to MySQL.

1. Get the application source code

    Clone the code from GitHub.

    ```bash
    git clone https://github.com/rackerlabs/guestbook-mysql.git
    cd guestbook-mysql
    ```

1. Build the image

    Build an image from the source code.

    ```bash
    docker build --tag="guestbook-mysql:1.0" .
    ```

1. Create the database tables

    Export the necessary environment variables for your application.

    ```bash
    export MYSQL_HOST=$(docker port $(docker ps --quiet --latest) 3306 | cut -f 1 -d ':')
    export MYSQL_PORT=$(docker port $(docker ps --quiet --latest) 3306 | cut -f 2 -d ':')
    ```

    Review the environment variables and ensure `MYSQL_HOST` and `MYSQL_PORT` were filled in correctly.

    ```bash
    env | grep MYSQL_
    ```

    Create the database tables.

    ```bash
    docker run --rm \
      --env MYSQL_HOST=$MYSQL_HOST \
      --env MYSQL_PORT=$MYSQL_PORT \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      guestbook-mysql:1.0 \
      python app.py create_tables
    ```

1. Run the application

    Run a container from the image. The application code uses the environment variables to connect to the MySQL container, see [app.py](https://github.com/rackerlabs/guestbook-mysql/blob/master/app.py).

    ```bash
    docker run --detach \
      --env MYSQL_HOST=$MYSQL_HOST \
      --env MYSQL_PORT=$MYSQL_PORT \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      --publish 5000:5000 \
      guestbook-mysql:1.0
    ```

    Review the container you just ran using the `--latest` parameter. The Status of the container should begin with "Up". If it doesn't, see the Troubleshooting section below

    ```bash
    docker ps --latest
    ```

    View the logs of the container you just ran using the `docker logs` command. The logs will contain some information based on the environment variables.

    ```bash
    docker logs $(docker ps --quiet --latest)
    ```

    Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

    ```bash
    echo http://$(docker port $(docker ps --quiet --latest) 5000)
    ```

    Remove the containers

    ```bash
    docker ps --quiet -n=-2
    docker rm --force $(docker ps --quiet -n=-2)
    ```

    The data stored in the MySQL container is ephemeral. Once the container is gone, so is your data.

1. Run a MySQL instance for persistent data storage

    1. Login to the [Rackspace Cloud Control](https://mycloud.rackspace.com/) panel
    1. Go to Databases > MySQL
    1. Click Create Instance
     * Instance Name: guestbook
     * Region: Northern Virginia (IAD)
     * Engine: MySQL 5.6
     * RAM: 1 GB
     * Disk: 5 GB
     * Database Name: guestbook
     * Username: guestbook-prod
     * Password: guestbook-prod-password
    1. Click Create Instance

    After the instance has been created, make note of the `Hostname` under the Instance Details as you'll need it in the next step.

1. Run the application

    Traffic from the application to the MySQL instance runs over ServiceNet to keep the traffic on Rackspace's internal network only.

    Export the necessary environment variables for your application.

    ```bash
    export MYSQL_HOST=xxx.rackspaceclouddb.com # copy this from the Instance Details
    export MYSQL_PORT=3306
    export MYSQL_DATABASE=guestbook
    export MYSQL_USER=guestbook-prod
    export MYSQL_PASSWORD=guestbook-prod-password
    ```

    Create the database tables.

    ```bash
    docker run --rm \
      --env MYSQL_HOST=$MYSQL_HOST \
      --env MYSQL_PORT=$MYSQL_PORT \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      guestbook-mysql:1.0 \
      python app.py create_tables
    ```

    Run a container from the image. The application code uses the environment variables to connect to the MySQL instance, see [app.py](https://github.com/rackerlabs/guestbook-mysql/blob/master/app.py).

    ```bash
    docker run --detach \
      --env MYSQL_HOST=$MYSQL_HOST \
      --env MYSQL_PORT=$MYSQL_PORT \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      --publish 5000:5000 \
      guestbook-mysql:1.0
    ```

    Review the container you just ran using the `--latest` parameter. The Status of the container should begin with "Up". If it doesn't, see the Troubleshooting section below

    ```bash
    docker ps --latest
    ```

    View the logs of the container you just ran using the `docker logs` command. The logs will contain some information based on the environment variables.

    ```bash
    docker logs $(docker ps --quiet --latest)
    ```

    Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

    ```bash
    echo http://$(docker port $(docker ps --quiet --latest) 5000)
    ```

    Have `\o/` and `¯\_(ツ)_/¯` sign your MySQL Guestbook.

    Remove the container.

    ```bash
    docker rm --force $(docker ps --quiet --latest)
    ```

    The data stored in the MySQL instance is persistent. It has been stored securely, highly available, and redundant.

    Don't forget to remove your MySQL instance, if you're not using it.

### Troubleshooting

Read the logs of the latest container you

```bash
docker logs $(docker ps --quiet --latest)
```

Run a new MySQL container, and open a shell so you can use the `mysql` command to poke around in your MySQL.

```bash
docker run -it --rm mysql:5.6 /bin/bash
```

Enter a running container, and open a shell so you can poke around.

```bash
docker exec -it $(docker ps -q -l) /bin/bash
```

### Resources

* [Cloud Databases features](http://www.rackspace.com/cloud/databases)
* [Cloud Databases documentation](http://www.rackspace.com/knowledge_center/getting-started/cloud-databases)
* [The MySQL Command-Line Tool](http://dev.mysql.com/doc/refman/5.6/en/mysql.html)

### Next

If MySQL isn't the data store for you, read [Data Stores](data-stores) for links to other data stores.
