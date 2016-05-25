---
title: Use MongoDB on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-25
permalink: docs/tutorials/data-stores-mongodb/
description: Learn how to use MongoDB on Carina
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
  - data-stores
  - mongodb
---

This tutorial describes using MongoDB on Carina so that you can store data in a container.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Create a network

Use the `docker network create` command to create an overlay network.

```bash
$ docker network create mynetwork
501e123b2904757fe9fe23cb60e64191f3764c6d42e188cb3ba7ad30d845f84b
```

The output of this command is the network ID.

### Run a MongoDB instance

Run a MongoDB instance to store your application data.

1. Run a MongoDB instance in a container from an official image.

    ```bash
    $ docker run --detach --name mongo --net mynetwork mongo:3.0.8
    47c6d35c63eca985b5529cff5379fb24455a3f07b787b990600373d911ffa327
    ```

    The output of this `docker run` command is your running MongoDB container ID.

1. View the status of the container by using the `--latest` parameter.

    ```bash
    $ docker ps --latest
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    5d950cd88532        mongo:3.0.8         "/entrypoint.sh mongo"   12 seconds ago      Up 11 seconds       27017/tcp           fc6b9aa0-87fc-41b8-a421-21d1bb8469f0-n3/mongo
    ```

    The output of this `docker ps` command is your running MongoDB container.

    The status of the container should begin with Up. If it doesn't, see the [Troubleshooting](#troubleshooting) section at the end of the tutorial.

### Create the database and user

Create the database and user to store your application data using the `mongo` command.

1. Export the necessary environment variables for your application.

    ```bash
    $ export MONGO_HOST=mongo
    $ export MONGO_PORT=27017
    $ export MONGO_DATABASE=guestbook
    $ export MONGO_USER=guestbook-user
    $ export MONGO_PASSWORD=guestbook-user-password
    ```

1. Create the database and user.

    ```bash
    $ docker run --rm \
      --net mynetwork \
      mongo:3.0.8 \
      mongo --eval 'db.getSiblingDB("'"$MONGO_DATABASE"'").createUser({"user": "'"$MONGO_USER"'", "pwd": "'"$MONGO_PASSWORD"'", "roles": [ "readWrite" ]})' $MONGO_HOST:$MONGO_PORT
    MongoDB shell version: 3.0.8
    connecting to: mongo:27017/test
    Successfully added user: { "user" : "guestbook-user", "roles" : [ "readWrite" ] }
    ```

    The output of this `docker run` command is the result of running the `mongo` command.

### Run the application

Run the Guestbook web application and view it in your web browser.

1. Run a container from the image. The application code uses the environment variables to connect to the MongoDB container. See [app.py](https://github.com/getcarina/examples/blob/master/guestbook-mongo/app.py).

    ```bash
    $ docker run --detach \
      --name guestbook \
      --net mynetwork \
      --publish 5000:5000 \
      --env MONGO_HOST=$MONGO_HOST \
      --env MONGO_PORT=$MONGO_PORT \
      --env MONGO_SSL=$MONGO_SSL \
      --env MONGO_DATABASE=$MONGO_DATABASE \
      --env MONGO_USER=$MONGO_USER \
      --env MONGO_PASSWORD=$MONGO_PASSWORD \
      carinamarina/guestbook-mongo
    08d0383a775f05bbf6e0d3e21ceb96cfcf1a0ca1b96e023e390cd52592c9f360  
    ```

    The output of this `docker run` command is your running application container ID.

1. View the application logs as they contain some information based on the environment variables.

    ```bash
    $ docker logs guestbook
    INFO: Welcome to Guestbook: Mongo Edition
    DEBUG: The log statement below is for educational purposes only. Do not log credentials.
    DEBUG: mongodb://guestbook-user:guestbook-user-password@mongo:27017/guestbook?ssl=False
    INFO:  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
    INFO:  * Restarting with stat
    INFO: Welcome to Guestbook: Mongo Edition
    DEBUG: The log statement below is for educational purposes only. Do not log credentials.
    DEBUG: mongodb://guestbook-user:guestbook-user-password@mongo:27017/guestbook?ssl=False
    WARNING:  * Debugger is active!
    INFO:  * Debugger pin code: 304-955-976
    ```

    The output of this `docker logs` command are the log messages being logged to stdout and stderr from the application in the container.

1. Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

    ```bash
    $ echo http://$(docker port guestbook 5000)
    http://104.130.0.124:5000
    ```

    The output of this `docker port` command is the IP address and port that the application is using.

    Have `\o/` and `¯\_(ツ)_/¯` sign your Mongo Guestbook.

1. Remove the containers

    ```bash
    $ docker rm --force --volumes mongo guestbook
    mongo
    guestbook
    ```

    The output of this `docker rm` command are the shortened IDs of the MongoDB and application containers that you removed.

    When the container is gone, so is your data.

### Troubleshooting

If the status of the container does not begin with Up, run a new MongoDB container, and open a shell so you can use the `mongo` command to investigate your MongoDB instance.

```bash
$ docker run --interactive --tty --rm mongo:3.0.8 /bin/bash
```

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Getting Started with the mongo Shell](http://docs.mongodb.org/master/tutorial/getting-started-with-the-mongo-shell/)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)

### Next steps

Learn how to [back up and restore container data]({{ site.baseurl }}/docs/tutorials/backup-restore-data/), and [schedule tasks with a cron container]({{ site.baseurl }}/docs/tutorials/schedule-tasks-cron/)

If you want to run your application with a production-grade database, read [Connect a Carina container to an ObjectRocket MongoDB instance]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb-prod/).

If you want to store your data in a data volume container, read [Use data volume containers]({{ site.baseurl }}/docs/tutorials/data-volume-containers/).

If MongoDB isn't the data store for you, read [Use MySQL on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mysql/).
