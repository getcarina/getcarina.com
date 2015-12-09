---
title: Getting started on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-25
permalink: docs/getting-started/getting-started-on-carina/
description: Learn how to get your first containerized application up and running on Carina in a minimal amount of time
docker-versions:
  - 1.9.0
topics:
  - docker
  - beginner
---

This tutorial shows you how to get your first containerized application up and running on Carina in a minimal amount of time.

No prior knowledge of containers or Docker is necessary. This tutorial works on Linux, Mac, and Windows.

**Note**: This guide uses the graphical user interface to create a cluster. To use the command line interface see [Getting started with the Carina CLI]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).

### Sign up for Carina

To run applications on Carina, create a free account (no credit card required) by following the [sign up process](https://app.getcarina.com/app/signup).

### Create your cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

To create your cluster, perform the following steps:

1. Log in to [the Carina Control Panel](https://app.getcarina.com).

1. On the Clusters page, click **Add Cluster**.

1. On the Create Cluster page, enter a name for the cluster. For example, `mycluster`.

1. Click **Create Cluster**.

    After a few moments, your cluster reaches a status of **active**.

### Connect to your cluster

Connect to your cluster by loading the cluster credentials and downloading the Docker client. The cluster credentials and configuration are a set of files that allow you to securely access your cluster.

If you have any problems, see the [Troubleshooting](#troubleshooting) section.

1. On the Carina Control Panel, click the **Get Access** button associated with your cluster and click **Download File**.

1. Save the zip file to a location on your computer. For example, the `Downloads` folder.

    The name of the zip file is the same as the name of your cluster.

1. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

1. Download the Docker 1.9.0 client into the unzipped directory.
    - On Linux, download the [Linux client](https://get.docker.com/builds/Linux/x86_64/docker-1.9.0) to `Downloads/mycluster`.
    - On Mac OS X, download the [Mac client](https://get.docker.com/builds/Darwin/x86_64/docker-1.9.0) to `Downloads/mycluster`.
    - On Windows, download the [Windows client](https://get.docker.com/builds/Windows/x86_64/docker-1.9.0.exe) to `Downloads/mycluster`.

1. Open an application in which to run commands.
    - On Linux and Mac OS X, open a terminal.
    - On Windows, open a PowerShell.

1. Configure the client.

    **Note**: If you already have the Docker client in your home bin directory, make a backup of it first.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ mkdir -p $HOME/bin
    $ mv docker-1.9.0 $HOME/bin/docker
    $ chmod u+x $HOME/bin/docker
    $ export PATH=$HOME/bin:$PATH
    $ if [ -f ~/.bash_profile ]; then echo 'export PATH=$HOME/bin:$PATH' >> $HOME/.bash_profile; fi
    $ source docker.env
    ```

    On Windows PowerShell, run the following commands:

    ```
    $ cd Downloads\mycluster
    $ mkdir "$env:USERPROFILE\bin"
    $ mv docker-1.9.0.exe "$env:USERPROFILE\bin\docker.exe"
    $ $env:PATH += ";$env:USERPROFILE\bin"
    $ [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
    $ Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    $ .\docker.ps1
    ```

    **Note**: On Windows PowerShell, use `docker.exe` instead of `docker` in all of the following commands.

1. Connect to your cluster and display information about it.

    ```bash
    $ docker info
    Containers: 3
    Images: 2
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 1
     57d513b9-ed36-487d-8415-4ac65b6d41a8-n1: 104.130.0.124:42376
      └ Containers: 3
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 4.2 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    CPUs: 12
    Total Memory: 4.2 GiB
    Name: 3e867f7a955f
    ```

### Run your first application

Run a WordPress blog with a MySQL database.

1. Run a MySQL instance in a container. Give it a name and use **my-root-pw** as a password.

    ```bash
    $ docker run --detach --name mysql --env MYSQL_ROOT_PASSWORD=my-root-pw mysql:5.6
    ab8ca480c46d10143217c0ee323f8420b6ab93737033c937c2f4dbf8578435bb
    ```

    The output of this `docker run` command is your running MySQL container ID.

1. Run a WordPress instance in a container. Give it a name, link it to the MySQL instance, and publish the internal port 80 to the external port 8080.

    ```bash
    $ docker run --detach --name wordpress --link mysql --publish 8080:80 wordpress
    6770c91929409196976f5ad30631b0f2836cd3d888c39bb3e322e0f60ca7eb18
    ```

    The output of this `docker run` command is your running WordPress container ID.

1. Verify that your run was successful by viewing your running containers.

    ```bash
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                        NAMES
    6770c9192940        wordpress           "/entrypoint.sh apach"   About a minute ago   Up About a minute   104.130.0.124:8080->80/tcp   57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress
    ab8ca480c46d        mysql:5.6           "/entrypoint.sh mysql"   6 minutes ago        Up 6 minutes        3306/tcp                     57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/mysql,57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress/mysql
    ```

    The output of this `docker ps` command is your running containers.

1. View your WordPress site by running the following command and pasting the result into the address bar of a browser.

    ```bash
    $ docker port wordpress 80
    ```

    The output of this `docker port` command is the IP address and port that WordPress is using.

1. *(Optional)* Remove your WordPress site.

    If you aren't going to use your WordPress site, we recommend that you remove it. Doing so removes both your WordPress and MySQL containers. This will delete any data and any posts you've made in the WordPress site.

    ```bash
    $ docker rm --force wordpress
    wordpress
    $ docker rm --force mysql
    mysql
    ```

    The output of this `docker rm` command are the names of the WordPress and MySQL containers that you removed.

### Congratulations!

You've successfully run your first containerized application.

Carina has many more features and there is more to learn. Review the [Resources](#resources) and [Next step](#next-step) sections for more information.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Docker 101]({{ site.baseurl }}/docs/tutorials/docker-101/)
* [Carina documentation]({{ site.baseurl }}/docs/)
* If you're likely to be running multiple versions of Docker, use the [Docker Version Manager (dvm)]({{ site.baseurl }}/docs/tutorials/docker-version-manager/).

### Next step

Learn how to [install the Carina CLI and use it to manage your clusters]({{ site.baseurl }}/docs/getting-started/getting-started-carina-cli/).
