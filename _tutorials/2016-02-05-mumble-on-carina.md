---
title: Use Mumble on Carina
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2016-02-05
permalink: docs/tutorials/2016-02-05-mumble-on-carina/
description: Learn how to use Mumble on Carina
docker-versions:
  - 1.9.0
topics:
  - docker
  - carina
  - intermediate
  - mumble
  - irc  
---

[Mumble](http://wiki.mumble.info/wiki/Main_Page) is a low-latency, multiplatform voice chat software. It has two parts, server (called Murmur) and client. While primarily used for gaming, it has features that make it appealing for various commercial and business uses, such as open source, encryption, and support for multiple simultaneous users.

In the past, you had to run Murmur on an always-on machine you own, or rent one in the cloud. But now, Docker makes it possible to run Murmur in a container. And Carina enables you to run that container in the cloud, at no cost.

This tutorial describes how to run Murmur on Carina.

### Prerequisites

- [Create and connect to a cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/)

## Select a Murmur image

For this tutorial, we have selected the easily configurable [extra/mumble](https://hub.docker.com/r/extra/mumble/) image. Multiple Murmur images are available on Docker Hub, and you should select one that best matches your needs and operational security requirements, or build your own.

### Start a Murmur container

Start a new container named `mumble` using the `extra/mumble` image, using custom ports `53453` for TCP and UDP, and a SuperUser password `6b53r54Iwmi0` (make sure to generate your own secure password!):

```
$ docker run \
--name mumble \ 
--env "MAX_USERS=50" \ 
--env "SERVER_TEXT=Welcome to My Mumble Server" \ 
--env "SUPW=6b53r54Iwmi0" \
--publish 53453:64738 \
--publish 53453:64738/udp \
extra/mumble
```

The command will display:

```
Starting Initialization
<W>2016-02-04 14:38:28.897 Initializing settings from /data/murmur.ini (basepath /data)
<W>2016-02-04 14:38:28.897 Binding to address 0.0.0.0
<W>2016-02-04 14:38:28.898 Meta: TLS cipher preference is "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:AES256-SHA:AES128-SHA"
<W>2016-02-04 14:38:28.898 OpenSSL: OpenSSL 1.0.1q 3 Dec 2015
<W>2016-02-04 14:38:28.901 ServerDB: Opened SQLite database /data/db.sqlite
<W>2016-02-04 14:38:28.901 Generating new tables...
<F>2016-02-04 14:38:28.953 Superuser password set on server 1
Initilization Completed
<W>2016-02-04 14:38:28.978 Initializing settings from /data/murmur.ini (basepath /data)
<W>2016-02-04 14:38:28.978 Binding to address 0.0.0.0
<W>2016-02-04 14:38:28.979 Meta: TLS cipher preference is "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:AES256-SHA:AES128-SHA"
<W>2016-02-04 14:38:28.979 OpenSSL: OpenSSL 1.0.1q 3 Dec 2015
<W>2016-02-04 14:38:28.980 ServerDB: Opened SQLite database /data/db.sqlite
<W>2016-02-04 14:38:28.981 Failed to connect to D-Bus session
<W>2016-02-04 14:38:28.982 OSInfo: Failed to execute lsb_release
<W>2016-02-04 14:38:28.982 Murmur 1.2.13 (1.2.13) running on X11: Linux 3.18.21-1-rackos: Booting servers
<W>2016-02-04 14:38:29.020 1 => Server listening on 0.0.0.0:64738
<W>2016-02-04 14:38:29.036 1 => Failed to set IPV6_RECVPKTINFO for 0.0.0.0:64738
<W>2016-02-04 14:38:29.054 1 => Generating new server certificate.
<W>2016-02-04 14:38:29.807 1 => Announcing server via bonjour
<W>2016-02-04 14:38:29.823 1 => Not registering server as public
<W>2016-02-04 14:38:29.824 Object::connect: No such slot MurmurDBus::userTextMessage(const User *, const TextMessage &)
```

Press `Ctrl-C` to get back to the terminal. To get the IP address and port:

```
$ docker port mumble 64738

172.99.65.46:53453
```

Take a note of the IP address and port, you will need it when connecting to the mumble server.

The image has additional configuration options available. It is possible to configure a password to limit regular users connecting to the server, for example.

### Connect as SuperUser

Install mumble client and add a new connection. Use the special username `SuperUser` and provide the SuperUser password previously supplied to the docker container. The password field will appear automatically when you type `SuperUser` as the username.

![Connect for Setup]({% asset_path 2016-02-05-mumble-on-carina/connect-as-admin.png %})

Once connected, you have access to all Mumble SuperUser permissions, and you can edit the server as you see fit.

![SuperUser]({% asset_path 2016-02-05-mumble-on-carina/admin-window.png %})

### Connect as a user

Disconnect from Mumble and edit the connection (or create a new connection) with your regular username. Use the same IP address and port. In this tutorial, the Mumble server does not require a password for users to be able to connect to it.

![User]({% asset_path 2016-02-05-mumble-on-carina/connect-as-user.png %})