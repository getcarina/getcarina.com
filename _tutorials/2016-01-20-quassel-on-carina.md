---
title: Use Quassel on Carina
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2016-01-20
permalink: docs/tutorials/quassel-on-carina/
description: Learn how to use Quassel on Carina
docker-versions:
  - 1.9.0
  - 1.10.2
topics:
  - docker
  - carina
  - intermediate
  - quassel
  - irc  
---

[Quassel](http://www.quassel-irc.org/about) IRC is a multiplatform distributed IRC client.  In some ways, it behaves like a very smart and advanced IRC bouncer.

Quassel has two parts, core and client. The core is an always-on service that stays permanently connected to your IRC channels online and preserves your chat history and settings. You can connect to your core by using a Quassel client from multiple devices, thus keeping your history and settings in sync across all of them.

In the past, you had to run Quassel core on an always-on machine you own, or rent one in the cloud. But now, Docker makes it possible to run Quassel in a container. And Carina enables you to run that container in the cloud, at no cost.

This tutorial describes how to run a Quassel core instance on Carina.

### Prerequisites

* [Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)
* A Rackspace cloud account that you can use to access the [Cloud Control Panel](https://mycloud.rackspace.com/).
 * If you don't have a Rackspace cloud account, you need to [sign up for one](https://www.rackspace.com/cloud).

### Create a docker [volume container](https://docs.docker.com/engine/userguide/dockervolumes/) to store your data

Before you create a container to run Quassel core, you need to consider data
persistence. Data in Carina is not guaranteed to be persisted in a fault-tolerant way, but there are easy ways to work around that. First, you make a separate volume container. As long as that container exists (it does not need to be running), data is preserved, even if the main Quassel core container is restarted or removed.

Because in some cases even the volume data might be wiped, a later section of this
tutorial also describes how to automatically back up (and restore if needed) Quassel
data.

Create a volume container to store data:

    docker create \
    --name quassel-data \
    --volume /config \
    linuxserver/quassel-core

If you are using PowerShell to connect to Carina, you can replace the backslash with a backtick to use multiline commands.

This tutorial uses the `linuxserver/quassel-core` image for Quassel. It updates automatically and is already configured to use Docker volume containers.

### Start a Quassel core container

1. Start the Quassel-core container and make it use the `quassel-data` volume container.

        docker run \  
        --name quassel-core \  
        --volumes-from quassel-data \  
        --publish 4242:4242 \
        linuxserver/quassel-core

    This process might take a while, as the container will self-update. The expected output is as follows:


        *** Running /etc/my_init.d/00_regen_ssh_host_keys.sh...
        *** Running /etc/my_init.d/05_check_ssl.sh...
        Generating a 4096 bit RSA private key
        .........................................................++
        ....................................................................................++
        writing new private key to '/config/quasselCert.pem'
        -----
        *** Running /etc/my_init.d/10_add_user_abc.sh...

        -----------------------------------
                  _     _ _
                 | |___| (_) ___
                 | / __| | |/ _ \
                 | \__ \ | | (_) |
                 |_|___/ |_|\___/
                         |_|

        Brought to you by linuxserver.io
        -----------------------------------
        GID/UID
        -----------------------------------
        User uid:    911
        User gid:    911
        -----------------------------------

        *** Running /etc/my_init.d/20_apt_update.sh...
        We are now refreshing packages from apt repositorys, this *may* take a while
        Update: OK
        *** Running /etc/rc.local...
        *** Booting runit daemon...
        *** Runit started as PID 48
        ("QSQLITE")
        Core is currently not configured! Please connect with a Quassel Client for basic setup.
        2016-01-20 19:43:36 Info: Listening for GUI clients on IPv6 :: port 4242 using protocol version 10
        Jan 20 19:43:36 3f53a80b691d syslog-ng[57]: syslog-ng starting up; version='3.5.3'

    When the following message is displayed, the container is ready: `Core is currently not configured! Please connect with a Quassel Client for basic setup.`

1. Press Ctrl-C to go back to the terminal.
1. Run the following command to expose the port.

        docker port quassel-core 4242

    The output is the IP address and port of your Quassel instance in the format `IPAddress:Port`, for example:

        172.99.66.49:4242

    Note the IP address and port number to use in the next section.

### Connect to the Quassel core from the client

1. Open the Quassel client.
1. Add a core account, and enter the IP address and port that you discovered in the
preceding section. You can use any username and password for your first login
when you use the wizard to configure the core

    ![Connect for Setup]({% asset_path 2016-01-20-quassel-on-carina/first-time-setup-connect.png %})

1. If you get a warning about the self-signed quassel-core security certificate, you can continue and then accept the certificate forever.

1. Set up your account. A single administrative user is usually sufficient for most
purposes.

    ![Setup Core Account]({% asset_path 2016-01-20-quassel-on-carina/setup-core-account.png %})

    The rest of the setup wizard establishes your IRC identity, and is beyond the scope of this tutorial.

### Verify that your data is generated in the right location

Run the following command.

    docker run --rm --volumes-from quassel-data busybox ls -a /config

The output shows that Quassel is storing data to the `/config` directory. This directory is saved in the `quassel-data` volume container.

    .
    ..
    .config
    quassel-storage.sqlite
    quasselCert.pem
    quasselcore.conf

### Automatically back up your data and restore it as necessary

1. Now you need to ensure that you have an automatic backup for your `quasel-data` volume. This tutorial uses Rackspace [Cloud Files](https://www.rackspace.com/cloud/files), but there are Docker images that would support virtually any provider. In this case, you will use the `carinamarina/cf-backup` and `carinamarina/cf-restore` images. You will also need a Rackspace Cloud account username and API key.

1. Run the following command.

        docker run \
        --name backup \
        --env RS_USERNAME='[redacted]' \
        --env RS_API_KEY='[redacted]' \
        --env RS_REGION_NAME='DFW' \
        --env DIRECTORY='/config' \
        --env CONTAINER='quassel-backup' \
        --volumes-from quassel-data \
        carinamarina/cf-backup

    The output displays a cronlog. Watch it for a bit until you see `Successfully uploaded object [backup.tar.gz] to container [quassel-backup]` to ensure that your data is being backed up.

    Your data will be backed up every minute. This is not a rolling backup; only the last instance of your data is saved automatically, to reduce storage costs (data is overwritten on upload).

1. Press Ctrl-C to get back to the terminal.

1. If your data is lost and you need to restore it, run the following command.

        docker run \
        --name restore \
        --rm \
        --env RS_USERNAME='[redacted]' \
        --env RS_API_KEY='[redacted]' \
        --env RS_REGION_NAME='DFW' \
        --env DIRECTORY='/config' \
        --env CONTAINER='quassel-backup' \
        --volumes-from quassel-data \
        carinamarina/cf-restore

    This command downloads your data from Rackspace Cloud Files to the `quassel-backup` volume container a single time. The output should look as follows:

        + [  = true ]
        + rack files object download --container quassel-backup --name backup.tar.gz
        + tar -zxvf backup.tar.gz -C /config/..
        config/
        config/quasselCert.pem
        config/.config/
        config/.config/Trolltech.conf
        config/quasselcore.conf
        config/quassel-storage.sqlite
