---
title: Use Mumble on Carina
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2016-02-11
permalink: docs/tutorials/2016-02-05-mumble-on-carina/
description: Learn how to use Mumble on Carina
docker-versions:
  - 1.9.0
  - 1.10.2
topics:
  - docker
  - carina
  - intermediate
  - mumble
  - irc  
---

[Mumble](http://wiki.mumble.info/wiki/Main_Page) is a low-latency, multiplatform voice chat software. It has two parts: a server, called Murmur, and a client. Although primarily used for gaming, Mumble has features that make it appealing for various commercial and business uses, such as open source, encryption, and support for multiple simultaneous users.

In the past, you had to run Murmur on an always-on machine that you own, or rent one in the cloud. Now, Docker makes it possible to run Murmur in a container, and Carina enables you to run that container in the cloud, at no cost.

This tutorial describes how to run Mumble on Carina.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Select a Mumble image

This tutorial uses the easily configurable [extra/mumble](https://hub.docker.com/r/extra/mumble/) image. Multiple Mumble images are available on Docker Hub, and you should select one that best matches your needs and operational security requirements, or build your own.

### Start a Mumble container

1. Start a new container named `mumble` by using the `extra/mumble` image, a random port such as `53453` for TCP and UDP, and a SuperUser password `<password>` (be sure to generate your own secure password!):

    ```
    docker run \
    --name mumble \
    --detach \
    --env "MAX_USERS=50" \
    --env "SERVER_TEXT=Welcome to My Mumble Server" \
    --env "SUPW=<password>" \
    --publish 53453:64738 \
    --publish 53453:64738/udp \
    extra/mumble
    ```

1. Check the logs to verify that the image worked properly:

    ```
    docker logs mumble
    ```

    The command displays the following output:

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

1. To get the IP address and port, run the following command:

    ```
    docker port mumble
    ```

    This command displays the following output:

    ```
    64738/tcp -> 172.99.65.46:53453
    64738/udp -> 172.99.65.46:53453
    ```

1. Take a note of the IP address and port. You will need them when connecting to the Mumble server.

The `extra/mumble` image has additional configuration options available. For example, you can configure a password to limit regular users connecting to the server.

### Connect as SuperUser

Install the Mumble client and add a new connection. Use the special username `SuperUser` and provide the SuperUser password that you previously supplied to the Docker container. The password field appears automatically when you type `SuperUser` as the username.

![Connect for Setup]({% asset_path 2016-02-05-mumble-on-carina/connect-as-admin.png %})

After you are connected, you have access to all Mumble SuperUser permissions, and you can edit the server as needed.

![SuperUser]({% asset_path 2016-02-05-mumble-on-carina/admin-window.png %})

### Connect as a user

Disconnect from Mumble and edit the connection (or create a new connection) with your regular username. Use the same IP address and port. In this tutorial, the Mumble server does not require a password for users to be able to connect to it.

![User]({% asset_path 2016-02-05-mumble-on-carina/connect-as-user.png %})
