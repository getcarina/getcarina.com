---
title: Connect a Carina container to an ObjectRocket MongoDB instance
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-04-12
permalink: docs/tutorials/data-stores-mongodb-prod/
description: Learn how to connect a Carina container to an ObjectRocket MongoDB instance and span your infrastructure across both Carina and ObjectRocket
docker-versions:
  - 1.10.1
topics:
  - docker
  - data
---

Would you like to move your application to containers but are overwhelmed with the complexity
of managing stateful services, like a mission-critical production database, in a container?
With Carina, you can take advantage of containers without sacrificing the simplicity of
ObjectRocket managed data services. Carina containers are connected to the Rackspace ServiceNet network
and can communicate directly with ObjectRocket managed data services.

This tutorial describes how to connect a Carina container to an ObjectRocket MongoDB instance.

### Prerequisites

* [Create and connect to a cluster](/docs/tutorials/create-connect-cluster/)
* A Rackspace cloud account that you can use to access the [Cloud Control Panel][control-panel].
 * If you don't have a Rackspace cloud account, you need to [sign up for one](https://www.rackspace.com/cloud).

### Run a MongoDB instance on ObjectRocket

Run a MongoDB instance to store your application data.

#### Create an instance

1. Login to the [Rackspace Cloud Control][control-panel] panel
1. Go to Databases > MongoDB
1. Create an instance by following the [Getting Started with MongoDB](https://objectrocket.com/docs/mongodb_getting_started.html) guide

#### Configure the instance

When you get to [Create an instance](https://objectrocket.com/docs/mongodb_getting_started.html#create-an-instance), use the following.

* Name: mongo
* Service: MongoDB
* Type: MongoDB Sharded
* Version: 3.0+
* Zone: US-East-IAD3, AWS Direct Connect
* Plan: 5GB MEDIUM

#### Create a database

When you get to [Add a database](https://objectrocket.com/docs/mongodb_getting_started.html#add-a-database), use the following.

* Database Name: guestbook
* Username: guestbook-prod
* Password: guestbook-prod-password

#### Add an Access Control List

When you get to [Add an ACL](https://objectrocket.com/docs/mongodb_getting_started.html#add-an-access-control-list-acl), add an Access Control List for the Carina ServiceNet (SNet) IP address range.

 * IP Address: 10.176.224.0/19
 * Description: Carina SNet Range

After the instance has been created, make note of the `SNet SSL Connect String` of the Connect section as you'll need it in the next step.

### Run an application that connects to a MongoDB instance on ObjectRocket

Communication from the application to the MongoDB instance is as secure as possible. You use SSL to encrypt the traffic, ServiceNet to keep the traffic on Rackspace's internal network only, and an ACL to ensure the MongoDB instance only accepts traffic from Carina IP addresses.

#### Export the necessary environment variables for your application.

Get the values for `MONGO_HOST` and `MONGO_PORT` from the `SNet SSL Connect String` of the Connect section on the Mongo Details screen.

```bash
$ export MONGO_HOST=iadX-sn-mongosX.objectrocket.com
$ export MONGO_PORT=54321
$ export MONGO_SSL=True
$ export MONGO_DATABASE=guestbook
$ export MONGO_USER=guestbook-prod
$ export MONGO_PASSWORD=guestbook-prod-password
```

#### Run a the application

The application code uses the environment variables to connect to ObjectRocket's MongoDB instance, see [app.py](https://github.com/getcarina/examples/blob/master/guestbook-mongo/app.py).

```bash
$ docker run --detach \
  --name guestbook \
  --env MONGO_HOST=$MONGO_HOST \
  --env MONGO_PORT=$MONGO_PORT \
  --env MONGO_SSL=$MONGO_SSL \
  --env MONGO_DATABASE=$MONGO_DATABASE \
  --env MONGO_USER=$MONGO_USER \
  --env MONGO_PASSWORD=$MONGO_PASSWORD \
  --publish 5000:5000 \
  carinamarina/guestbook-mongo
b2178dd6acf9e769e6d47ef73f06865c74f2a5c70b4f6b285392b9d3626b8b25
```

#### View the logs

View the logs of the container you just ran using the `docker logs` command. The logs will contain some information based on the environment variables.

```bash
$ docker logs guestbook
INFO: Welcome to Guestbook: Mongo Edition
DEBUG: The log statement below is for educational purposes only. Do not log credentials.
DEBUG: mongodb://guestbook-prod:guestbook-prod-password@iad1-sn-mongos1.objectrocket.com:26236/guestbook?ssl=True
INFO:  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
INFO:  * Restarting with stat
INFO: Welcome to Guestbook: Mongo Edition
DEBUG: The log statement below is for educational purposes only. Do not log credentials.
DEBUG: mongodb://guestbook-prod:guestbook-prod-password@iad1-sn-mongos1.objectrocket.com:26236/guestbook?ssl=True
WARNING:  * Debugger is active!
INFO:  * Debugger pin code: 183-701-214
```

The output of this `docker logs` command are the log messages being logged to stdout and stderr from the application in the container.

#### View the application

Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

```bash
$ echo http://$(docker port guestbook 5000)
http://172.99.79.254:5000
```

Have `\o/` and `¯\_(ツ)_/¯` sign your Mongo Guestbook.

Remove the container.

```bash
$ docker rm --force --volumes guestbook
guestbook
```

The data stored in the MongoDB instance is persistent. It has been stored securely, highly available, and redundant.

Don't forget to remove your MongoDB instance in ObjectRocket, if you're not using it.

### Troubleshooting

Run a new Mongo container, and open a shell so you can use the `mongo` command to explore your MongoDB instance.

```bash
$ docker run -it --rm mongo:3.0.8 /bin/bash
```

Enter a running container, and open a shell so you can explore.

```bash
$ docker exec -it guestbook /bin/bash
```

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [ObjectRocket's MongoDB features](http://objectrocket.com/mongodb/)
* [ObjectRocket's MongoDB documentation](http://objectrocket.com/docs/mongodb.html)
* [Getting Started with the mongo Shell](http://docs.mongodb.org/master/tutorial/getting-started-with-the-mongo-shell/)

### Next step

If you want develop and test with MongoDB in a container, read [Use MongoDB on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb/).

[control-panel]: http://mycloud.rackspace.com
