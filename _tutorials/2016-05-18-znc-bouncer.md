---
title: Set up a free IRC bouncer on Carina with ZNC and Docker Swarm
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2016-05-18
permalink: docs/tutorials/znc-bouncer/
description: Set up a free IRC bouncer on Carina with ZNC and Docker Swarm
docker-versions:
  - 1.10.2
topics:
  - docker
  - irc
  - intermediate
---

Internet Relay Chat (IRC) is a popular application protocol that allows
users in distributed teams to communicate and keep up to date on shared
projects. It is widely used in open-source communities, including Docker and
OpenStack, as a way to open up and facilitate discussion.

The process works on a client/server networking model, meaning that, by
default, it is ephemeral: there is no way for clients to preserve
message logs whilst temporarily or permanently disconnected from the server.
For that, you need a piece of middlware called a bouncer. A bouncer, or BNC,
relays traffic like a proxy and stays permanently connected to the remote
server, allowing clients to disconnect from the internet and have their
history of connected channels maintained. One of the more popular bouncers is
ZNC.

In this tutorial we will be setting up ZNC in a container using Docker Swarm
on Carina. The container will simplify installation and configuration steps
and provide a fully functioning IRC bouncer with a public IPv4 that listens
on a SSL connection.  

## Prerequisites

- working Carina cluster
- an account on Freenode
- an IRC client

## Step 1: Create configuration

If you already have a configuration file from a previous or current ZNC
installation, skip to step 2.

If you need to create your configuration file from scratch, it is best to do
so using ZNC's interactive guide. It will help you to set an initial
password hashed with `SHA256`, generate an SSL pem file, and structure your
configuration file. To do so, run the following:

```
$ docker run -it --name znc-conf carinamarina/znc-conf
root@5062ef654755:/# su - znc
$ znc -c
[ ?? ] Listen on port (1025 to 65534): 6697
[ ?? ] Listen using SSL (yes/no) [no]: yes
[ ?? ] Listen using both IPv4 and IPv6 (yes/no) [yes]:
[ ?? ] Username (alphanumeric): <username>
[ ?? ] Enter password: <password>
[ ?? ] Confirm password: <password>
[ ?? ] Nick [foo]:
[ ?? ] Alternate nick [foo_]:
[ ?? ] Ident [foo]:
[ ?? ] Real name [Got ZNC?]: <fullName>
[ ?? ] Bind host (optional):
[ ?? ] Name [freenode]:
[ ?? ] Server host [chat.freenode.net]:
[ ?? ] Server uses SSL? (yes/no) [yes]:
[ ?? ] Server port (1 to 65535) [6697]:
[ ?? ] Server password (probably empty):
[ ?? ] Initial channels: #carina #docker
[ ?? ] Launch ZNC now? (yes/no) [yes]: no
$ exit
root@5062ef654755:/# exit
```

Replace `<password>`, `<password>` and `<password>` with your own values.

After you have filled out all the fields, the guide will generate a file to
`/home/znc/.znc/configs/znc.conf`. To retrieve this file from the container,
you will need to copy it to your local host, like so:

```
$ docker cp znc-conf:/home/znc/.znc/configs/znc.conf .
```

If you are happy with things, you can then delete the container:

```
$ docker rm znc-conf
```

## Step 2: Provision data container

Once you have a configuration file, you will need to store it in a data
volume container. If you are unsure of what this is, read [our guide to
storing data in Docker](/docs/tutorials/data-volume-containers/).

To run the data container:

```
$ docker run --detach \
  --name znc-data \
  --volume /data \
  alpine true
```

## Step 3: Copy conf file to data container

After your data volume container is created, you need to insert your
configuration file into it, like so:

```
$ docker cp znc.conf znc-data:/data
```

## Step 4: Spin up ZNC container

Once your data is stored in the correct place, you are ready to deploy the
actual ZNC container. To run it:

```
$ docker run --detach \
  --publish 6697:6697 \
  --name znc \
  --volumes-from znc-data \
  carinamarina/znc /data
```

## Step 5: Set up client

If things were followed correctly, your ZNC container will be listening on a
publicly addressable IPv4, which your client needs in order to talk to the
IRC servers. To retrieve it:

```
$ docker port znc 6697
```

You just need to plug this value into your client of choice, along with the
port number (6697) and ensure SSL connection is enabled, and you should have
a working IRC bouncer running on Carina, for free.
