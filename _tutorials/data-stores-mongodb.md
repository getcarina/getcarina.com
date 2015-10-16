---
title: Use MongoDB on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/data-stores-mongodb/
description: Learn how to use MongoDB on Carina
docker-versions:
  - 1.8.3
topics:
  - docker
  - intermediate
  - data-stores
  - mongodb
---

This tutorial describes using MongoDB on Carina so that you can store data in a container.

### Prerequisites

1. [Carina cluster and credentials](cluster-and-credentials)

### Run a MongoDB instance

Run a MongoDB instance to store your application data.

1. Run a MongoDB instance in a container from an official image.

```bash
$ docker run --detach --publish-all mongo:3.0.6
47c6d35c63eca985b5529cff5379fb24455a3f07b787b990600373d911ffa327
```

The output of this `docker run` command is your running MongoDB container ID.

1. View the status of the container by using the `--latest` parameter.

```bash
$ docker ps --latest
```

The output of this `docker ps` command is your running containers.

The status of the container should begin with Up. If it doesn't, see the [Troubleshooting](#troubleshooting) section at the end of the tutorial.

1. View the ID of the container by using the `--quiet` parameter.

```bash
$ docker ps --quiet --latest
47c6d35c63ec
```

The output of this `docker ps` command is the shortened ID of the MongoDB container.

1. Discover what IP address and port MongoDB is running on by combining the `docker port` command, the ID of the container, and the default MongoDB port of 27017.

```bash
$ docker port $(docker ps --quiet --latest) 27017
104.130.0.124:32768
```

For the containerized MongoDB service, note that you don't need to care what it's named, what IP address it runs on, or what port it uses. Instead, you discover this information dynamically with the preceding command and use it later in the tutorial to connect to MongoDB.

### Create the database and user

Create the database and user to store your application data using the `mongo` command.

1. Export the necessary environment variables for your application.

```bash
$ export MONGO_HOST=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 1 -d ':')
$ export MONGO_PORT=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 2 -d ':')
$ export MONGO_DATABASE=guestbook
$ export MONGO_USER=guestbook-user
$ export MONGO_PASSWORD=guestbook-user-password
```

1. Review the environment variables and ensure that `MONGO_HOST` and `MONGO_PORT` were filled in correctly, from the values you discovered in step 4 of [Run a MongoDB instance](#run-a-mongodb-instance).

```bash
$ env | grep MONGO_
MONGO_HOST=104.130.0.124
MONGO_PORT=32768
MONGO_DATABASE=guestbook
MONGO_USER=guestbook-test
MONGO_PASSWORD=guestbook-test-password
```

1. Create the database and user.

```bash
docker run --rm mongo:3.0.6 \
  mongo --eval 'db.getSiblingDB("'"$MONGO_DATABASE"'").createUser({"user": "'"$MONGO_USER"'", "pwd": "'"$MONGO_PASSWORD"'", "roles": [ "readWrite" ]})' $MONGO_HOST:$MONGO_PORT
```

### Run the application

Run the Guestbook web application and view it in your web browser.

1. Run a container from the image. The application code uses the environment variables to connect to the MongoDB container. See [app.py](https://github.com/rackerlabs/carina-examples/blob/master/guestbook-mongo/app.py).

```bash
docker run --detach \
  --env MONGO_HOST=$MONGO_HOST \
  --env MONGO_PORT=$MONGO_PORT \
  --env MONGO_SSL=$MONGO_SSL \
  --env MONGO_DATABASE=$MONGO_DATABASE \
  --env MONGO_USER=$MONGO_USER \
  --env MONGO_PASSWORD=$MONGO_PASSWORD \
  --publish 5000:5000 \
  rackerlabs/guestbook-mongo:1.0
```

1. View the status of the container by using the `--latest` parameter.

```bash
$ docker ps --latest
```

The output of this `docker ps` command is your running containers.

The status of the container should begin with Up. If it doesn't, see the [Troubleshooting](#troubleshooting) section at the end of the tutorial.

1. View the logs of the container. The logs contain some information based on the environment variables.

```bash
$ docker logs $(docker ps --quiet --latest)
INFO: Welcome to Guestbook: Mongo Edition
DEBUG: The log statement below is for educational purposes only. Do not log credentials.
DEBUG: mongodb://guestbook-user:guestbook-user-password@104.130.0.124:32769/guestbook?ssl=False
INFO:  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

The output of this `docker logs` command is the log messages being logged to stdout and stderr from the application in the container.

1. Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

```bash
echo http://$(docker port $(docker ps --quiet --latest) 5000)
```

The output of this `docker port` command is the IP address and port that the application is using.

Have `\o/` and `¯\_(ツ)_/¯` sign your Mongo Guestbook.

1. Remove the containers

```bash
$ docker rm --force $(docker ps --quiet -n=-2)
```

The output of this `docker rm` command are the shortened IDs of the MongoDB and application containers that you removed.

When the container is gone, so is your data.

### Troubleshooting

If the status of the container does not begin with Up, run a new MongoDB container, and open a shell so you can use the `mongo` command to investigate your MongoDB instance.

```bash
$ docker run --interactive --tty --rm mongo:3.0.6 /bin/bash
```

You can also enter a running container, and open a shell to investigate the container.

```bash
$ docker exec -it $(docker ps -q -l) /bin/bash
```

### Resources

* [Getting Started with the mongo Shell](http://docs.mongodb.org/master/tutorial/getting-started-with-the-mongo-shell/)

### Next

If MongoDB isn't the data store for you, read [Use MySQL on Carina](data-stores-mongodb).
