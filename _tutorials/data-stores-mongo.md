---
title: MongoDB with RCS
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/mongodb-with-rcs/
description: How to store production data in MongoDB with RCS
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - data-stores
  - mongodb
---

This tutorial describes using MongoDB with RCS so that you can store temporary data for development/testing in containers and store your production data persistently and securely in ObjectRocket's MongoDB.

### Prerequisites

1. [RCS Credentials](rcs-credentials)
1. [Git](https://git-scm.com/downloads)

### Steps

1. Run a MongoDB container for dev/test in a container for ephemeral data storage

    Run a MongoDB instance in a container from an official image.

    ```bash
    docker run --detach --publish-all mongo:3.0.6
    ```

    Review the status of the container and the id of that container.

    ```bash
    docker ps
    docker ps --quiet --latest
    ```

    Combine the above with the `docker port` command and you can discover what IP address and port Mongo is running on.

    ```bash
    docker port $(docker ps --quiet --latest) 27017
    ```

    For the containerized MongoDB service, note how you don't care what it's named, what IP address it runs on, or what port it uses.

1. Get the application source code

    Clone the code from GitHub.

    ```bash
    git clone https://github.com/rackerlabs/guestbook-mongo.git
    cd guestbook-mongo
    ```

1. Build the image

    Build an image from the source code.

    ```bash
    docker build --tag="guestbook-mongo:1.0" .
    ```

1. Create the database and user

    Export the necessary environment variables for your application.

    ```bash
    export MONGO_HOST=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 1 -d ':')
    export MONGO_PORT=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 2 -d ':')
    export MONGO_DATABASE=guestbook
    export MONGO_USER=guestbook-test
    export MONGO_PASSWORD=guestbook-test-password
    ```

    Review the environment variables and ensure `MONGO_HOST` and `MONGO_PORT` were filled in correctly.

    ```bash
    env | grep MONGO_
    ```

    Create the database and user.

    ```bash
    docker run --rm mongo:3.0.6 \
      mongo --eval 'db.getSiblingDB("'"$MONGO_DATABASE"'").createUser({"user": "'"$MONGO_USER"'", "pwd": "'"$MONGO_PASSWORD"'", "roles": [ "readWrite" ]})' $MONGO_HOST:$MONGO_PORT
    ```

    Note: You'll have to hit Enter a couple of times after running the command above to get your prompt back.

1. Run the application

    Run a container from the image. The application code uses the environment variables to connect to the MongoDB container, [app.py](https://github.com/rackerlabs/guestbook-mongo/blob/master/app.py).

    ```bash
    docker run --detach \
      --env MONGO_HOST=$MONGO_HOST \
      --env MONGO_PORT=$MONGO_PORT \
      --env MONGO_SSL=$MONGO_SSL \
      --env MONGO_DATABASE=$MONGO_DATABASE \
      --env MONGO_USER=$MONGO_USER \
      --env MONGO_PASSWORD=$MONGO_PASSWORD \
      --publish 5000:5000 \
      guestbook-mongo:1.0
    ```

    Review the status of the application container and the logs of that container.

    ```bash
    docker ps --latest
    docker logs $(docker ps --quiet --latest)
    ```

    Open a browser and visit your application.

    ```bash
    echo http://$(docker port $(docker ps --quiet --latest) 5000)
    ```

    Remove the containers

    ```bash
    docker ps --quiet -n=-2
    docker rm --force $(docker ps --quiet -n=-2)
    ```

    The data stored in the MongoDB container is ephemeral. Once the container is gone, so is your data.

1. Run a MongoDB instance on ObjectRocket for persistent data storage

    1. Login to the [Rackspace Cloud Control](https://mycloud.rackspace.com/) panel
    1. Go to Databases > MongoDB
    1. Create an instance by following the [Getting Started with MongoDB](https://objectrocket.com/docs/mongodb_getting_started.html) guide

    When you get to [Create an instance](https://objectrocket.com/docs/mongodb_getting_started.html#create-an-instance), use the following.

     * Name: mongo
     * Service: MongoDB
     * Type: MongoDB Sharded
     * Version: 3.0+
     * Plan: 5GB MEDIUM
     * Zone: US-East-IAD3, AWS Direct Connect

    When you get to [Create a database](https://objectrocket.com/docs/mongodb_getting_started.html#create-a-database), use the following.

     * Database Name: guestbook
     * Username: guestbook-prod
     * Password: guestbook-prod-password

    When you get to [Add an ACL](https://objectrocket.com/docs/mongodb_getting_started.html#add-an-acl), add an Access Control List for the RCS ServiceNet (SNet) IP address range.
     * IP Address: 10.176.224.0/19
     * Description: RCS SNet Range

    After the instance has been created, make note of the `SSL SNet Connect String` under the Instance Details as you'll need it in the next step.

1. Run the application

    Communication from the application to the MongoDB instance is as secure as possible. You use SSL to encrypt the traffic, ServiceNet to keep the traffic on Rackspace's internal network only, and an ACL to ensure the MongoDB instance only accepts traffic from RCS.

    Export the necessary environment variables for your application.

    ```bash
    export MONGO_HOST=iad-sn-mongosX.objectrocket.com # copy this from the Instance Details
    export MONGO_PORT=54321 # copy this from the Instance Details
    export MONGO_SSL=True
    export MONGO_DATABASE=guestbook
    export MONGO_USER=guestbook-prod
    export MONGO_PASSWORD=guestbook-prod-password
    ```

    Run a container from the image. The application code uses the environment variables to connect to ObjectRocket's MongoDB instance, [app.py](https://github.com/rackerlabs/guestbook-mongo/blob/master/app.py).

    ```bash
    docker run --detach \
      --env MONGO_HOST=$MONGO_HOST \
      --env MONGO_PORT=$MONGO_PORT \
      --env MONGO_SSL=$MONGO_SSL \
      --env MONGO_DATABASE=$MONGO_DATABASE \
      --env MONGO_USER=$MONGO_USER \
      --env MONGO_PASSWORD=$MONGO_PASSWORD \
      --publish 5000:5000 \
      guestbook-mongo:1.0
    ```

    Review the status of the application container and the logs of that container.

    ```bash
    docker ps --latest
    docker logs $(docker ps --quiet --latest)
    ```

    Open a browser and visit your application.

    ```bash
    echo http://$(docker port $(docker ps --quiet --latest) 5000)
    ```

    Have `\o/` and `¯\_(ツ)_/¯` sign your Mongo Guestbook.

    Remove the container.

    ```bash
    docker rm --force $(docker ps --quiet --latest)
    ```

    The data stored in the MongoDB instance is persistent. It has been stored securely, highly available, and redundant.

    Don't forget to remove your MongoDB instance in ObjectRocket, if you're not using it.

### Troubleshooting

Run a new Mongo container and open a shell so you can use the `mongo` command to poke around in your MongoDB.

```bash
docker run --interactive --tty --rm mongo:3.0.6 /bin/bash
```

Enter a running container and open a shell so you can poke around.

```bash
docker exec -it $(docker ps -q -l) /bin/bash
```

### Resources

* [ObjectRocket's MongoDB features](http://objectrocket.com/mongodb/)
* [ObjectRocket's MongoDB documentation](http://objectrocket.com/docs/mongodb.html)
* [Getting Started with the mongo Shell](http://docs.mongodb.org/master/tutorial/getting-started-with-the-mongo-shell/)

### Next

If MongoDB isn't the data store for you, read [Data Stores](data-stores) for links to other data stores.
