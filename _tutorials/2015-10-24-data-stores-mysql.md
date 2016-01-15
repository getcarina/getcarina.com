---
title: Use MySQL on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-24
permalink: docs/tutorials/data-stores-mysql/
description: Learn how to use MySQL on Carina
docker-versions:
  - 1.8.3
topics:
  - docker
  - intermediate
  - data-stores
  - mysql
---

This tutorial describes using MySQL on Carina so that you can store data in a container.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/)

### Run a MySQL instance

Run a MySQL instance to store your application data.

1. Export the necessary environment variables for your application.

    ```bash
    $ export MYSQL_ROOT_PASSWORD=root-password
    $ export MYSQL_DATABASE=guestbook
    $ export MYSQL_USER=guestbook-user
    $ export MYSQL_PASSWORD=guestbook-user-password
    ```

1. Run a MySQL instance in a container from an official image.

    ```bash
    $ docker run --detach --publish-all \
      --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      mysql:5.6
    0a45d95acc3ccc7ebcaa2851ce36cbe0bba864282d6dbadb4a4bf569f4c141e8
    ```

    The output of this `docker run` command is your running MySQL container ID.

1. View the status of the container by using the `--latest` parameter.

    ```bash
    $ docker ps --latest
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
    0a45d95acc3c        mysql:5.6           "/entrypoint.sh mysql"   15 seconds ago      Up 14 seconds       104.130.0.111:32771->3306/tcp   d850247d-ae6d-43bd-8b41-fd56f3530283-n1/loving_saha
    ```

    The output of this `docker ps` command is your running MySQL container.

    The status of the container should begin with Up. If it doesn't, see the [Troubleshooting](#troubleshooting) section at the end of the tutorial.

1. View the ID of the container by using the `--quiet` parameter.

    ```bash
    $ docker ps --quiet --latest
    0a45d95acc3c
    ```

    The output of this `docker ps` command is the shortened ID of the MySQL container.

1. Discover what IP address and port MySQL is running on by combining the `docker port` command, the ID of the container, and the default MySQL port of 3306.

    ```bash
    $ docker port $(docker ps --quiet --latest) 3306
    104.130.0.111:32771
    ```

    For the containerized MySQL service, you don't need to keep track of what it's named, what IP address it runs on, or what port it uses. Instead, you discover this information dynamically with the preceding command, and use it later in the tutorial to connect to MySQL.

### Create the database tables

Create the database tables to store your application data.

1. Export the necessary environment variables for your application.

    ```bash
    $ export MYSQL_HOST=$(docker port $(docker ps --quiet --latest) 3306 | cut -f 1 -d ':')
    $ export MYSQL_PORT=$(docker port $(docker ps --quiet --latest) 3306 | cut -f 2 -d ':')
    ```

1. Review the environment variables and ensure that `MYSQL_HOST` and `MYSQL_PORT` were filled in correctly, from the values you discovered in step 5 of [Run a MySQL instance](#run-a-mysql-instance).

    ```bash
    $ env | grep MYSQL_
    MYSQL_HOST=104.130.0.111
    MYSQL_PORT=32771
    MYSQL_ROOT_PASSWORD=root-password
    MYSQL_DATABASE=guestbook
    MYSQL_USER=guestbook-user
    MYSQL_PASSWORD=guestbook-user-password
    ```

1. Create the database tables.

    ```bash
    $ docker run --rm \
      --env MYSQL_HOST=$MYSQL_HOST \
      --env MYSQL_PORT=$MYSQL_PORT \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      carinamarina/guestbook-mysql \
      python app.py create_tables
    INFO: Welcome to Guestbook: MySQL Edition
    DEBUG: The log statement below is for educational purposes only. Do not log credentials.
    DEBUG: mysql+pymysql://guestbook-user:guestbook-user-password@104.130.0.111:32771/guestbook
    2015-10-16 20:01:52,337 INFO sqlalchemy.engine.base.Engine SHOW VARIABLES LIKE 'sql_mode'
    INFO: SHOW VARIABLES LIKE 'sql_mode'
    2015-10-16 20:01:52,337 INFO sqlalchemy.engine.base.Engine ()
    ...
    INFO:
    CREATE TABLE guests (
      id INTEGER NOT NULL AUTO_INCREMENT,
      name VARCHAR(256) NOT NULL,
      PRIMARY KEY (id)
    )
    ...
    INFO: COMMIT
    ```

    The output of this `docker run` command is the result of creating the tables.

### Run the application

Run the Guestbook web application and view it in your web browser.

1. Run a container from the image. The application code uses the environment variables to connect to the MySQL container. See [app.py](https://github.com/getcarina/examples/blob/master/guestbook-mysql/app.py).

    ```bash
    $ docker run --detach \
      --env MYSQL_HOST=$MYSQL_HOST \
      --env MYSQL_PORT=$MYSQL_PORT \
      --env MYSQL_DATABASE=$MYSQL_DATABASE \
      --env MYSQL_USER=$MYSQL_USER \
      --env MYSQL_PASSWORD=$MYSQL_PASSWORD \
      --publish 5000:5000 \
      carinamarina/guestbook-mysql
    3e731021acbeef0a1fdff85dc7b026e18cef51f6e3da49f8920cf5f8bbdef4d0
    ```

    The output of this `docker run` command is your running application container ID.

1. View the status of the container by using the `--latest` parameter.

    ```bash
    $ docker ps --latest
    CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                          NAMES
    3e731021acbe        carinamarina/guestbook-mysql   "/bin/sh -c 'python a"   51 seconds ago      Up 50 seconds       104.130.0.111:5000->5000/tcp   d850247d-ae6d-43bd-8b41-fd56f3530283-n1/backstabbing_stallman
    ```

    The output of this `docker ps` command is your running application container.

    The status of the container should begin with Up. If it doesn't, see the [Troubleshooting](#troubleshooting) section at the end of the tutorial.

1. View the application logs as they contain some information based on the environment variables.

    ```bash
    $ docker logs $(docker ps --quiet --latest)
    INFO: Welcome to Guestbook: MySQL Edition
    DEBUG: The log statement below is for educational purposes only. Do not log credentials.
    DEBUG: mysql+pymysql://guestbook-user:guestbook-user-password@104.130.0.111:32771/guestbook
    INFO:  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
    ```

    The output of this `docker logs` command are the log messages being logged to stdout and stderr from the application in the container.

1. Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

    ```bash
    $ echo http://$(docker port $(docker ps --quiet --latest) 5000)
    http://104.130.0.111:5000
    ```

    The output of this `docker port` command is the IP address and port that the application is using.

    Have `\o/` and `¯\_(ツ)_/¯` sign your MySQL Guestbook.

1. Remove the containers

    ```bash
    $ docker rm --force $(docker ps --quiet -n=-2)
    3e731021acbe
    0a45d95acc3c
    ```

    The output of this `docker rm` command are the shortened IDs of the MySQL and application containers that you removed.

    When the container is gone, so is your data.

### Troubleshooting

If the status of the container does not begin with Up, run a new MySQL container, and open a shell so you can use the `mysql` command to investigate your MySQL instance.

```bash
$ docker run --interactive --tty --rm mysql:5.6 /bin/bash
```

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [The MySQL Command-Line Tool](http://dev.mysql.com/doc/refman/5.6/en/mysql.html)

### Next steps

If you want to run your application with a production-grade database, read [Connect a Carina container to a Rackspace Cloud Database]({{ site.baseurl }}/docs/tutorials/data-stores-mysql-prod/)

If MySQL isn't the data store for you, read [Use MongoDB on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb/).
