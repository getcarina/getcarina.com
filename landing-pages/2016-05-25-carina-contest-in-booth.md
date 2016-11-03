---
title: Carina contest
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-05-25
permalink: lp/carina-contest-in-booth/
description: Sign up for Carina, complete a tutorial, and get a ticket to win a prize!
bodyClass: docs-single
---

<a name="start"></a>

Sign up for Carina, create a Docker Swarm cluster, deploy WordPress, and get a ticket to win a prize!

### Sign up for Carina

⭐️ **You only get one chance to enter your email address and password so be exact!** ⭐️

In the Carina Control Panel (the other tab), sign up for Carina.

### Create your cluster

Click **Add Cluster** and name it **mycluster**

### Get your API Key

In the Carina Control Panel (the other tab)

1. Click your username in the top-right corner
1. Click **Settings**
1. Copy the API Key (Command-C)

### Configure the Carina CLI

In the terminal below set your environment variables to contain these credentials

```bash
$ export CARINA_USERNAME=<email>
$ export CARINA_APIKEY=<apikey>

$ carina ls
ClusterName         Flavor              Nodes               AutoScale           Status
mycluster           container1-4G       1                   false               active
```

### Configure the Docker CLI

In the terminal below configure the Docker CLI using the Carina CLI and the Docker Version Manager (dvm)

```bash
$ eval $(carina env mycluster)

$ dvm use
Now using Docker 1.11.2 
```

### Run your first application

In the terminal below run a WordPress blog with a MySQL database on an overlay network (feel free to copy/paste commands)

1. Create a network to connect your containers.

    ```bash
    $ docker network create mynetwork
    ec98e17a760b82b5c0857e2e0d561019af67ef790170fac8413697d5ee183288
    ```

1. Run a MySQL instance in a container.

    ```bash
    $ docker run --detach \
      --name mysql \
      --net mynetwork \
      --env MYSQL_ROOT_PASSWORD=my-root-pw \
      mysql:5.6
    ab8ca480c46d10143217c0ee323f8420b6ab93737033c937c2f4dbf8578435bb
    ```

1. Run a WordPress instance in a container.

    ```bash
    $ docker run --detach \
      --name wordpress \
      --net mynetwork \
      --publish 80:80 \
      --env WORDPRESS_DB_HOST=mysql \
      --env WORDPRESS_DB_PASSWORD=my-root-pw \
      wordpress:4.4
    6770c91929409196976f5ad30631b0f2836cd3d888c39bb3e322e0f60ca7eb18
    ```

1. Verify that your run was successful by viewing your running containers.

    ```bash
    $ docker ps -n=2
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                        NAMES
    6770c9192940        wordpress:4.4       "/entrypoint.sh apach"   About a minute ago   Up About a minute   104.130.0.124:80->80/tcp   57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress
    ab8ca480c46d        mysql:5.6           "/entrypoint.sh mysql"   6 minutes ago        Up 6 minutes        3306/tcp                     57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/mysql,57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress/mysql
    ```

1. View your WordPress site

    ```bash
    $ open http://$(docker port wordpress 80)
    ```

1. *(Optional)* Remove your WordPress site.

    If you aren't going to use your WordPress site, we recommend that you remove it. Doing so removes both your WordPress and MySQL containers. This will delete any data and any posts you've made in the WordPress site.

    ```bash
    $ docker rm --force --volumes wordpress mysql
    wordpress
    mysql
    ```

1. Run `source ~/cleanup.env`
