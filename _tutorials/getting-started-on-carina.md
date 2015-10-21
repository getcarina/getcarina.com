---
title: Getting started on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-09-28
permalink: docs/tutorials/getting-started-on-carina/
description: Learn how to get your first containerized application up and running on Carina in a minimal amount of time
docker-versions:
  - 1.8.3
topics:
  - docker
  - beginner
---

This tutorial shows you how to get your first containerized application up and running on Carina in a minimal amount of time.

No prior knowledge of containers or Docker is necessary. This tutorial works on Linux, Mac, and Windows.

### Sign up for Carina

To run applications on Carina, get an account by following the [sign up process](https://mycluster.rackspacecloud.com/managed/).

### Create your cluster

A cluster is a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications.

To create your cluster, perform the following steps:

1. Sign in to [mycluster.rackspacecloud.com/managed/](https://mycluster.rackspacecloud.com/managed/).
1. Enter a cluster name in the **Create New** field. For example: `mycluster`
1. Click **Create Cluster**.
1. Click the **Refresh** button until your cluster reaches a status of **active**.

### Connect to your cluster

Connect to your cluster by sourcing the cluster credentials and configuration. The cluster credentials and configuration are a set of files that allow you to securely access your cluster.

If you have any problems, consult the [Troubleshooting](#troubleshooting) section.

1. Click **Download credentials** [insert-download-icon-here].

1. Unzip the file to a location on your computer. For example:

    ```bash
    Downloads/mycluster
    ```

1. Download the Docker 1.8.3 client into the unzipped directory.

    On Linux, download the [Linux client](https://get.docker.com/builds/Linux/x86_64/docker-1.8.3) to `Downloads/mycluster`.

    On Mac OS X, download the [Mac client](https://get.docker.com/builds/Darwin/x86_64/docker-1.8.3) to `Downloads/mycluster`.

    On Windows, download the [Windows client](https://get.docker.com/builds/Windows/x86_64/docker-1.8.3.exe) to `Downloads/mycluster`.

1. Open an application to run commands.

    On Linux and Mac OS X, open a terminal.

    On Windows, open a Command Prompt or PowerShell.

1. Configure the client.

    Note: If you already have the Docker client in your home bin directory, make a backup of it first.

    On Linux and Mac OS X terminal, run the commands.

    ```bash
    $ cd Downloads/mycluster
    $ mkdir $HOME/bin
    $ mv docker-1.8.3 $HOME/bin/docker
    $ chmod u+x $HOME/bin/docker
    $ export PATH=$HOME/bin:$PATH
    $ if [ -f ~/.bash_profile ]; then echo 'export PATH=$HOME/bin:$PATH' >> $HOME/.bash_profile; fi
    $ source docker.env
    ```

    On Windows Command Prompt, run the commands.

    ```
    $ cd Downloads\mycluster
    $ md "%USERPROFILE%\bin"
    $ move docker-1.8.3.exe "%USERPROFILE%\bin\docker.exe"
    $ setx PATH "%PATH%;%USERPROFILE%\bin"
    $ PATH="%PATH%;%USERPROFILE%\bin"
    $ docker.cmd
    ```

    On Windows PowerShell, run the commands.

    ```
    $ cd Downloads\mycluster
    $ mkdir "$env:USERPROFILE\bin"
    $ mv docker-1.8.3.exe "$env:USERPROFILE\bin\docker.exe"
    $ $env:PATH += ";$env:USERPROFILE\bin"
    $ [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
    $ Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    $ .\docker.ps1
    ```

    On Windows, use `docker.exe` instead of `docker` in all of the commands below.

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

1. (Optional) Remove your WordPress site

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

### Resources

* If you're new to Docker, learn more at [Docker 101](/docs/tutorials/002-docker-102).

### Next step

On Linux, Mac OS X, or Windows, put the Docker client somewhere on your system's path.

Learn about all of the features available to you in the [Overview of Carina](/docs/tutorials/overview-of-carina)

### Troubleshooting

* If you get the error message `Error response from daemon: client and server don't have same version (client : x.xx, server: x.xx)` then read the [Version Conflict](/docs/references/version-conflict) guide.

* If you had trouble downloading your credentials, see [Download Carina credentials](/docs/references/carina-credentials/) guide.

* If you're behind a firewall or VPN and it's blocking port 2376 (a port used by Docker), you will get the error message `Cannot connect to the Docker daemon. Is "docker - d" running on this host?`. To resolve this error, request your network administrator to open that port or try this tutorial from a location where port 2376 isn't blocked.
