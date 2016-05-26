---
title: Connect a Carina container to a Rackspace cloud database
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-01-15
permalink: docs/tutorials/data-stores-mysql-prod/
description: Learn how to connect a Carina container to a Rackspace cloud database and span your infrastructure across both Carina and the Rackspace Cloud
docker-versions:
  - 1.10.1
topics:
  - docker
  - beginner
  - networking
---

Would you like to move your application to containers but are overwhelmed with the complexity
of managing stateful services, like a mission-critical production database, in a container?
With Carina, you can take advantage of containers without sacrificing the simplicity of
Rackspace managed services. Carina containers are connected to the Rackspace ServiceNet network
and can communicate directly with Rackspace Cloud Databases, Cloud Queues,
and all other managed cloud services.

This tutorial describes how to connect a Carina container to a Rackspace Cloud Databases MySQL instance.

![Carina and Cloud Databases]({% asset_path data-stores-mysql-prod/carina-and-cloud-databases.png %})

### Prerequisites

* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)
* A Rackspace cloud account that you can use to access the [Cloud Control Panel][control-panel].
 * If you don't have a Rackspace cloud account, you need to [sign up for one](https://www.rackspace.com/cloud).

### Connect a container to a database

1. If you don't already have a MySQL database instance in the same region
    as your Carina cluster, perform the following steps:

    1. Log in to the [Cloud Control Panel][control-panel].
    1. Navigate to **Databases > MySQL Instance**.
    1. Set the region to IAD and complete the form to create a MySQL database.

    **Note**: The database must be in the same region as your cluster.
    Currently, all Carina clusters are located in the IAD region.

1. In the Cloud Control Panel, view your database instance
    and note the hostname. The hostname format is `<id>.rackspaceclouddb.com` and
    is accessible only on the Rackspace ServiceNet network.

1. Run a container and pass in the database connection information. Replace
    `<username>`, `<password>`, `<host>`, and `<dbname>` with the connection values
    for your database.

    This tutorial uses a demo container, `carinamarina/try-rails`.
    It is a Ruby on Rails application that connects to the provided MySQL database
    and displays whether or not the database connection was successful.

    ```bash
    docker run --name demo \
    --env DATABASE_URL="mysql://<username>:<password>@<host>/<dbname>" \
    --detach \
    --publish-all \
    carinamarina/try-rails
    ```

    **Note**: Ruby on Rails looks for the `DATABASE_URL` environment variable and
    automatically uses it if it is present, without requiring any further configuration.
    If you are using another framework, additional configuration or code changes might be required.

1. Identify the IP address and port on which the container is published by running the following command.
    In the example output, the IP address is `172.99.65.237` and the port is `32800`.

    ```bash
    $ docker port demo
    3000/tcp -> 172.99.65.237:32800
    ```

1. Open http://_ipAddress_:_port_, for example **http://172.99.65.237:32800**.
    If the database connection was successful, you will see the Powered By Carina badge.

    ![Powered by Carina Badge]({% asset_path data-stores-mysql-prod/powered-by-carina-badge.png %})

You now have an application running in a Carina container that connects to a Rackspace
cloud database. So you see, there's no need to move everything at once to containers.
Take it one piece at a time, migrate a single service, and keep your data safe and sound.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

You might encounter the following issues when connecting the container to the database instance:

* **The database is not in the same region as the Carina cluster.**

    When the database is not in the same region as the Carina cluster, the web page
    that you tried to open in step 5 times out and eventually displays the messages
    `Can't connect to MySQL server on '<id>.rackspaceclouddb.com' (110)`.
    Currently, all Carina clusters are located in the IAD region.

* **The database credentials are incorrect.**

    When the database credentials are incorrect, the web page displays
    the message `Access denied for user 'demo'@'<containerIP>'`.
    Verify that the username and password are correct. Ensure that the password is URL encoded,
    for example that characters such as the `@` are escaped. Then try again.

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Communicate between containers over the ServiceNet internal network]({{site.baseurl}}/docs/tutorials/servicenet/)
* [Cloud Databases features](http://www.rackspace.com/cloud/databases)
* [Cloud Databases documentation](http://www.rackspace.com/knowledge_center/getting-started/cloud-databases)

### Next step

If you want develop and test with MySQL in a container, read [Use MySQL on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mysql/).

[control-panel]: http://mycloud.rackspace.com
