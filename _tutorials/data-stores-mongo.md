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

### MongoDB with RCS

This tutorial describes using MongoDB with RCS so that you can store temporary data for development/testing in containers and store your production data persistently and securely in ObjectRocket's MongoDB.

#### Prerequisites

1. [Concepts](data-stores)
1. [RCS Credentials](rcs-credentials)

#### Steps

1. Create a MongoDB container for dev/test

    ```bash

docker run --detach --publish-all mongo:3.0.6
docker ps --latest
docker port $(docker ps --quiet --latest) 27017

For our containerized MongoDB service, note how we don't care what it's called, where it runs, or what port it uses.

export GB_MONGO_HOST=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 1 -d ':')
export GB_MONGO_PORT=$(docker port $(docker ps --quiet --latest) 27017 | cut -f 2 -d ':')
export GB_MONGO_DB=guestbook
export GB_MONGO_DB_USERNAME=guestbook-test
export GB_MONGO_DB_PASSWORD=guestbook-test-password

env | grep GB_

docker run -it --rm mongo:3.0.6 \
  mongo --eval 'db.getSiblingDB("'"$GB_MONGO_DB"'").createUser({"user": "'"$GB_MONGO_DB_USERNAME"'", "pwd": "'"$GB_MONGO_DB_PASSWORD"'", "roles": [ "readWrite" ]})' $GB_MONGO_HOST:$GB_MONGO_PORT

Note: Tap Enter

git clone https://github.com/rackerlabs/guestbook-mongo.git
cd guestbook-mongo
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

docker ps --latest

docker logs $(docker ps --quiet --latest)

open http://$(docker port $(docker ps --quiet --latest) 5000)

docker ps --quiet -n=-2

docker rm --force $(docker ps --quiet -n=-2)

export GB_MONGO_HOST=iad-mongosX.objectrocket.com
export GB_MONGO_PORT=54321
export GB_MONGO_SSL=True
export GB_MONGO_DB=guestbook
export GB_MONGO_DB_USERNAME=guestbook-admin
export GB_MONGO_DB_PASSWORD=guestbook-admin-password

docker run --detach \
  --env GB_MONGO_HOST=$GB_MONGO_HOST \
  --env GB_MONGO_PORT=$GB_MONGO_PORT \
  --env GB_MONGO_SSL=$GB_MONGO_SSL \
  --env GB_MONGO_DB=$GB_MONGO_DB \
  --env GB_MONGO_DB_USERNAME=$GB_MONGO_DB_USERNAME \
  --env GB_MONGO_DB_PASSWORD=$GB_MONGO_DB_PASSWORD \
  --publish 5000:5000 \
  guestbook-mongo:1.0

docker ps --latest

docker logs $(docker ps --quiet --latest)

open http://$(docker port $(docker ps --quiet --latest) 5000)

docker rm --force $(docker ps --quiet --latest)

Don't forget to remove your MongoDB if you're not using it.

## Troubleshooting

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









## Troubleshooting

docker run -it --rm mongo:3.0.6 /bin/bash
