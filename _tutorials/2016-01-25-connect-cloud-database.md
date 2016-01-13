---
title: Connect a Carina container to a Rackspace Cloud Database
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-01-25
permalink: docs/tutorials/connect-cloud-database/
description: Learn how to connect a Carina container to a Rackspace Cloud Database and span your infrastructure across both Carina and Rackspace Cloud
docker-versions:
  - 1.9.1
topics:
  - docker
  - beginner
  - networking
---

Would you like to move your application to containers but are overwhelmed with the complexity
of managing stateful services, like a mission-critical production database, in a container?
With Carina, you can take advantage of containers without sacrificing the simplicity of
Rackspace managed services. Carina containers are connected to the Rackspace [ServiceNet][servicenet] network
and can communicate directly with your Cloud Database, Cloud Queue,
and every other managed cloud service.

This tutorial describes how to connect a Carina container to a Rackspace Cloud MySQL Database.

### Prerequisites

[Create and connect to a cluster](/docs/tutorials/create-connect-cluster/)

### Steps

1. If you don't already have a Rackspace Cloud MySQL Database in the same region
    as your Carina cluster, follow the steps below:

    1. Log into the [Rackspace Cloud Control Panel][control-panel].
    2. Navigate to `Databases > MySQL Instance...`.
    3. Set the region to IAD and complete the form to create a MySQL database.

    **NOTE**: The database must be in the same region as your cluster.
    At the time of writing, all Carina clusters are located in the IAD region.

3. In the [Rackspace Cloud Control Panel][control-panel], view your database instance
    and note the hostname. The hostname format is `<id>.rackspaceclouddb.com` and
    is only accessible on the Rackspace ServiceNet network.

4. Run a container and pass in the database connection information. Replace
    `<username>`, `<password>`, `<host>`, and `<dbname>` with the connection values
    for your database.

    For the purposes of this tutorial, we are using a demo container, `rackerlabs/try-rails`.
    It is a Ruby on Rails application that connects to the provided MySQL database
    and displays whether or not the database connection was successful.

    ```bash
    docker run --name demo \
    --env DATABASE_URL="mysql://<username>:<password>@<host>/<dbname>" \
    --detach \
    --publish-all \
    rackerlabs/try-rails
    ```

    **NOTE**: Ruby on Rails looks for the `DATABASE_URL` environment variable and
    automatically uses it if present, without requiring any further configuration.
    If you are using another framework, additional configuration or code changes may be required.

5. Identify the port on which the container is published by running the following command.
    In the example output, the port is `32800`.

    ```bash
    $ docker port demo
    3000/tcp -> 172.99.65.237:32800
    ```

6. Open http://_dockerHost_:_webPort_, for example **http://172.99.65.237:32800**.
    You should see the Powered By Carina badge, if the database connection was successful.

    ![Powered by Carina Badge]({% asset_path connect-cloud-database/powered-by-carina-badge.png %})

[control-panel]: http://mycloud.rackspace.com

You now have an application running in a Carina container which connects to a Rackspace
Cloud Database. So you see, there's no need to jump head first into containers. Dip a toe in, migrate a single service,
and keep your data safe and sound.

### Troubleshooting
See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

* **The database is not in the same region as the Carina cluster.**

    When the database is not in the same region as the Carina cluster, the page
    times out and eventually displays `Can't connect to MySQL server on '<id>.rackspaceclouddb.com' (110)`.
    At the time of writing, all Carina clusters are located in the IAD region.

* **The database credentials are incorrect.**

    When the database credentials are incorrect, the page displays `Access denied for user 'demo'@'<containerIP>'`.
    Verify the username and password are correct. Make sure the password is URL encoded,
    for example that characters such as the `@` are escaped. Then try again.

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Communicate between containers over the ServiceNet internal network][servicenet]

[servicenet]: {{site.baseurl}}/docs/tutorials/servicenet/
