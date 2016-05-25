---
title: Connect a Carina container to an ObjectRocket MongoDB instance
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-04-12
permalink: docs/tutorials/data-stores-mongodb-prod/
description: Learn how to connect a Carina container to an ObjectRocket MongoDB instance and span your infrastructure across both Carina and ObjectRocket
docker-versions:
  - 1.10.1
topics:
  - docker
  - data
---

Would you like to move your application to containers but are overwhelmed with the complexity of managing stateful services, like a mission-critical production database, in a container? With Carina, you can take advantage of containers without sacrificing the simplicity of ObjectRocket managed data services. Carina containers are connected to the Rackspace ServiceNet network and can communicate directly with ObjectRocket managed data services.

This tutorial describes how to connect a Carina container to an ObjectRocket MongoDB instance.

![ObjectRocket]({% asset_path data-stores-mongodb-prod/ObjectRocket.png %})

### Prerequisites

* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)
* A Rackspace cloud account that you can use to access the [Cloud Control Panel][control-panel].
 * If you don't have a Rackspace cloud account, you need to [sign up for one](https://www.rackspace.com/cloud).

### Run a MongoDB instance on ObjectRocket

Run a MongoDB instance to store your application data.

#### Create an instance

1. Log in to the [Rackspace Cloud Control][control-panel] panel
1. Go to **Databases > MongoDB**
1. If you haven't used an ObjectRocket data store before, you will be asked for a credit card.
1. Create an instance by following the instructions in the [Getting Started with MongoDB](https://objectrocket.com/docs/mongodb_getting_started.html) guide and using the values in the following sections.

#### Configure the instance

When you [create the instance](https://objectrocket.com/docs/mongodb_getting_started.html#create-an-instance), use the following values:

* Name: mongo
* Service: MongoDB
* Type: MongoDB Sharded
* Version: 3.0+
* Zone: US-East-IAD3, AWS Direct Connect
* Plan: 5GB MEDIUM
* Storage Engine: MMAPv1
* Encrypted: Checked

#### Create a database

When you [add a database](https://objectrocket.com/docs/mongodb_getting_started.html#add-a-database), use the following values:

* Database Name: guestbook
* Username: guestbook-prod
* Password: guestbook-prod-password

#### Add an access control list

When you [add an access control list (ACL)](https://objectrocket.com/docs/mongodb_getting_started.html#add-an-access-control-list-acl), add an entry for the Carina ServiceNet (SNet) IP address range.

 * IP Address or CIDR Block: 10.176.224.0/19
 * Description: Carina SNet Range

After the instance has been created, note the `SNet SSL Connect String` in the Connect section. You'll need it in the next step.

### Run an application that connects to a MongoDB instance on ObjectRocket

Communication from the application to the MongoDB instance is as secure as possible. You use SSL to encrypt the traffic, ServiceNet to keep the traffic on Rackspace's internal network only, encryption to protect the data at rest, and an ACL to ensure that the MongoDB instance accepts traffic only from Carina IP address(es).

#### Export the necessary environment variables for your application.

Get the values for `MONGO_HOST` and `MONGO_PORT` from the `SNet SSL Connect String` in the Connect section on the Instance Details screen.

```bash
$ cat << EOF > guestbook.env
MONGO_HOST=iadX-sn-mongosX.objectrocket.com
MONGO_PORT=54321
MONGO_SSL=True
MONGO_DATABASE=guestbook
MONGO_USER=guestbook-prod
MONGO_PASSWORD=guestbook-prod-password
EOF
```

#### Run the application

The application code uses the environment variables to connect to ObjectRocket's MongoDB instance. For more information, see [app.py](https://github.com/getcarina/examples/blob/master/guestbook-mongo/app.py).

```bash
$ docker run --detach \
  --name guestbook \
  --env-file guestbook.env \
  --publish 5000:5000 \
  carinamarina/guestbook-mongo
b2178dd6acf9e769e6d47ef73f06865c74f2a5c70b4f6b285392b9d3626b8b25
```

#### View the logs

View the logs of the container that you just ran by using the `docker logs` command. The logs contain some information based on the environment variables.

```bash
$ docker logs guestbook
DEBUG: The log statement below is for educational purposes only. Do not log credentials.
DEBUG: mongodb://guestbook-prod:guestbook-prod-password@iad1-sn-mongos0.objectrocket.com:26127/guestbook?ssl=True
INFO:  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
INFO:  * Restarting with stat
INFO: Welcome to Guestbook: Mongo Edition
DEBUG: The log statement below is for educational purposes only. Do not log credentials.
DEBUG: mongodb://guestbook-prod:guestbook-prod-password@iad1-sn-mongos0.objectrocket.com:26127/guestbook?ssl=True
WARNING:  * Debugger is active!
INFO:  * Debugger pin code: 183-701-214
```

The output of this `docker logs` command are the log messages being logged to stdout and stderr from the application in the container.

#### Specify your exact ServiceNet IP address in the MongoDB instance ACL _(optional)_

1. To further secure your MongoDB instance so that it accepts only connections from the ServiceNet IP address where your application container is running, run the following command.

    ```bash
    $ docker run --rm --net=host --env affinity:container==guestbook racknet/ip service ipv4
    10.176.229.26
    ```

    The output is the ServiceNet IP address of the node where your application container is running.

1. Revisit the [Add an access control list](#add-an-access-control-list) section, and edit the IP address of the `Carina SNet Range` entry to be the ServiceNet IP address of the node where your application container is running.

#### View the application

Open a browser and visit your application by running the following command and pasting the result into your browser address bar.

```bash
$ echo http://$(docker port guestbook 5000)
http://172.99.79.254:5000
```

Have `\o/` and `¯\_(ツ)_/¯` sign your Mongo Guestbook.

#### Remove the container

```bash
$ docker rm --force --volumes guestbook
guestbook
```

The data stored in the MongoDB instance is persistent. It has been stored securely, and is highly available and redundant.

Don't forget to remove your MongoDB instance in ObjectRocket, if you're not using it to avoid unnecessary charges.

### Troubleshooting

Run a new Mongo container, and open a shell so you can use the `mongo` command to explore your MongoDB instance.

```
$ docker run -it --rm --env-file guestbook.env --env affinity:container==guestbook mongo:3.0.8 /bin/bash
# mongo --ssl --sslAllowInvalidCertificates \
  -u $MONGO_USER -p $MONGO_PASSWORD \
  --authenticationDatabase $MONGO_DATABASE \
  $MONGO_HOST:$MONGO_PORT/$MONGO_DATABASE
MongoDB shell version: 3.0.8
connecting to: iad1-sn-mongos0.objectrocket.com:26127/guestbook
mongos> show collections
guests
objectrocket.init
system.indexes
mongos> db.guests.find()
{ "_id" : ObjectId("570d2bf2c03ed200140abcd6"), "name" : "\\o/" }
{ "_id" : ObjectId("570d2c00c03ed200140abcd7"), "name" : "¯\\_(ツ)_/¯" }
```

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [ObjectRocket's MongoDB features](http://objectrocket.com/mongodb/)
* [ObjectRocket's MongoDB documentation](http://objectrocket.com/docs/mongodb.html)
* [Getting Started with the mongo Shell](http://docs.mongodb.org/master/tutorial/getting-started-with-the-mongo-shell/)
* [Communicate between containers over the ServiceNet internal network]({{ site.baseurl }}/docs/tutorials/servicenet/)

### Next step

If you want develop and test with MongoDB in a container, read [Use MongoDB on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mongodb/).

[control-panel]: http://mycloud.rackspace.com
