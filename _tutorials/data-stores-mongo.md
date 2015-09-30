---
title: MongoDB with RCS
slug: mongodb-with-rcs
description: How to store production data in MongoDB with RCS
docker-version: 1.8.2
topics:
  - docker
  - intermediate
  - data-stores
  - mongodb
---

This tutorial describes using MongoDB with RCS so that you can store temporary data for development/testing in containers and store your production data persistently and securely in ObjectRocket's MongoDB.

### Prerequisites

1. [Concepts](data-stores)
1. [RCS Credentials](rcs-credentials)
1. [Git](https://git-scm.com/downloads)

### Steps

1. Create a MongoDB container for dev/test

    Create a MongoDB instance running in a container from an official image.

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

1. Run a MongoDB container in a container for ephemeral data storage

    Export the necessary environment variables for your application.

    ```bash
    export GB_MONGO_HOST=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 1 -d ':')
    export GB_MONGO_PORT=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 2 -d ':')
    export GB_MONGO_DB=guestbook
    export GB_MONGO_DB_USERNAME=guestbook-test
    export GB_MONGO_DB_PASSWORD=guestbook-test-password
    ```

    Review the environment variables and ensure `GB_MONGO_HOST` and `GB_MONGO_PORT` were filled in correctly.

    ```bash
    env | grep GB_
    ```

    Create the database.

    ```bash
    docker run --interactive --tty --rm mongo:3.0.6 \
      mongo --eval 'db.getSiblingDB("'"$GB_MONGO_DB"'").createUser({"user": "'"$GB_MONGO_DB_USERNAME"'", "pwd": "'"$GB_MONGO_DB_PASSWORD"'", "roles": [ "readWrite" ]})' $GB_MONGO_HOST:$GB_MONGO_PORT
    ```

    Note: You'll have to hit Enter a couple of times after running the command above to get your prompt back.

1. Get the application source code

    Clone the code from GitHub.

    ```bash
    git clone https://github.com/rackerlabs/guestbook-mongo.git
    cd guestbook-mongo
    ```

1. Build and run the application

    Build an image from source code and run a container from the image. The application code uses the environment variables to connect to the MongoDB container, [app.py](https://github.com/rackerlabs/guestbook-mongo/blob/master/app.py).

    ```bash
    docker build --tag="guestbook-mongo:1.0" .
    docker run --detach \
      --env GB_MONGO_HOST=$GB_MONGO_HOST \
      --env GB_MONGO_PORT=$GB_MONGO_PORT \
      --env GB_MONGO_SSL=$GB_MONGO_SSL \
      --env GB_MONGO_DB=$GB_MONGO_DB \
      --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
      --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
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

    When you get to section 1. [Create an instance](https://objectrocket.com/docs/mongodb_getting_started.html#create-an-instance), use the following.

     * Name: mongo
     * Service: MongoDB
     * Type: MongoDB Sharded
     * Version: 3.0+
     * Plan: 5GB MEDIUM
     * Zone: US-East-IAD3, AWS Direct Connect

    When you get to section 2. [Create a database](https://objectrocket.com/docs/mongodb_getting_started.html#create-a-database), use the following.

     * Database Name: guestbook
     * Username: guestbook-prod
     * Password: guestbook-prod-password

    When you get to section 3. [Add an ACL](https://objectrocket.com/docs/mongodb_getting_started.html#add-an-acl), add two ACLs.
     * IP Address: 104.130.22.0/24
     * Description: RCS 1
     * IP Address: 104.130.0.0/24
     * Description: RCS 2

    Make note of the `SSL SNet Connect String` under the Instance Details as you'll need it in the next step.

1. Run the application

    Export the necessary environment variables for your application.

    ```bash
    export GB_MONGO_HOST=iad-sn-mongosX.objectrocket.com # copied from the Instance Details
    export GB_MONGO_PORT=54321 # copied from the Instance Details
    export GB_MONGO_SSL=True
    export GB_MONGO_DB=guestbook
    export GB_MONGO_DB_USERNAME=guestbook-prod
    export GB_MONGO_DB_PASSWORD=guestbook-prod-password
    ```

    Run a container from the image. The application code uses the environment variables to connect to ObjectRocket's MongoDB instance, [app.py](https://github.com/rackerlabs/guestbook-mongo/blob/master/app.py).

    ```bash
    docker run --detach \
      --env GB_MONGO_HOST=$GB_MONGO_HOST \
      --env GB_MONGO_PORT=$GB_MONGO_PORT \
      --env GB_MONGO_SSL=$GB_MONGO_SSL \
      --env GB_MONGO_DB=$GB_MONGO_DB \
      --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
      --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
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

    Remove the container

    ```bash
    docker rm --force $(docker ps --quiet --latest)
    ```

    The data stored in the MongoDB instance is persistent. It has been stored securely, highly available, and redundant.

    Don't forget to remove your MongoDB instance in ObjectRocket, if you're not using it.

## Troubleshooting

    ```bash
    docker run --interactive --tty --rm mongo:3.0.6 /bin/bash
    ```

<!--
* List troubleshooting steps here.

    Cover the most common mistakes and error states first.

    Link or create a separate article for troubleshooting steps that aren't specific to the tutorial.

* Link to support articles and generic troubleshooting information.

    Create a separate article for generic troubleshooting information.
-->

## Resources

<!--
* Links to related content
-->

## Next Steps

<!--
* What should your audience read next?
-->
