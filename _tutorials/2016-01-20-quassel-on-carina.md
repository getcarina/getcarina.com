---
title: Use Quassel on Carina
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2016-01-20
permalink: docs/tutorials/2016-01-20-quassel-on-carina/
description: Learn how to use Quassel on Carina
docker-versions:
  - 1.9.0
topics:
  - docker
  - carina
  - intermediate
  - quassel
  - irc  
---

This tutorial describes using Quassel on Carina.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/)

### On Quassel and Carina

[Quassel](http://www.quassel-irc.org/about) IRC is a multiplatform distributed IRC client.  In some ways, it behaves like a very smart and advanced IRC bouncer.

Quassel has two parts - core and client. The core is an always-on service that stays permanently connected to your IRC channels online and preserves your chat history and settings. You can connect to your core using Quassel-client from multiple devices, thus keeping your history and settings in sync across all of them.

In the past, you had to run Quassel core on an always-on machine you own, or rent one in the cloud. But now, Docker makes it possible to run Quassel in a container. And Carina allows you to run that container in the cloud - for free.

### Run a Quassel-core instance on Carina

1. Create a docker [volume container](https://docs.docker.com/engine/userguide/dockervolumes/) to store your data

Before we make a container to run Qassel-core, we need to consider data persistence. Data in Carina is not guaranteed to be persisted in a fault-tolerant way, but there are easy ways to work around that. First, we will make a separate volume container. As long as that container exists (it does not need to be running), data will be preserved, even if the main Quassel-core container is restarted or removed.

Because in some cases even the volume data might be wiped, later on in this tutorial we will also learn how to automatically backup (and restore if needed) Quassel data.

Creating a volume container to store data:

```
docker create \ 
--name quassel-data \ 
--volume /config \
linuxserver/quassel-core
```

If you are using PowerShell to connect to Carina, you can replace \ with ` to use multiline commands.

We are using the linuxserver/quassel-core image for Quassel. It updates automatically and is already configured to use docker volume containers. 

1. Start the Quassel-core container and make it use the quassel-data volume container.

```
docker run \ 
--name quassel-core \ 
--volumes-from quassel-data \ 
--publish 4242:4242 \
linuxserver/quassel-core
```

This may take a while, as the container will self-update. The expected output will be:

```
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
```

After the container displays that it is ready `Core is currently not configured! Please connect with a Quassel Client for basic setup.`, Ctrl-C to go back to the terminal. Expose the port.

```
docker port quassel-core 4242
```

This will output the IP and Port of your quassel instance in the format `IPAddress:Port`, for example:

```
172.99.66.49:4242
```

1. Take note of the IP address and port, and connect to quassel-core using your quassel client. Configure your core as needed. You can use any username/password for your first login when configuring with the guided wizard. 

![Connect for Setup]({% asset_path 2016-01-20-quassel-on-carina/first-time-setup-connect.png %})

You will likely get a warning about the self-signed quassel-core security certificate, ignore it, and continue. Accept the certificate forever.

![Setup Core Account]({% asset_path 2016-01-20-quassel-on-carina/setup-core-account.png %})

Setup your account. A single administrative user is usually sufficient for most purposes. The rest of the setup wizard will establish your IRC identity, and is beyond the scope of this tutorial.

1. Ensure Quassel has properly generated your data in the right location:

```
docker run --rm --volumes-from quassel-data busybox ls -a /config
```

should display:


```
.
..
.config
quassel-storage.sqlite
quasselCert.pem
quasselcore.conf
```

This ensures Quassel is storing data to the /config directory. This directory is saved in the quassel-data volume container.

1. Now we need to ensure we have automatic backup for our quasel-data volume. In this tutorial, we will be backing up to Rackspace [Cloud Files](https://www.rackspace.com/cloud/files), but there are docker images that would support virtually any provider. In this case, we will use the carinamarina/cf-backup and carinamarina/cf-restore images. You will need a Rackspace username and API key for the next part.

```
docker run \
--name backup \
--env RS_USERNAME='[redacted]' \ 
--env RS_API_KEY='[redacted]' \
--env RS_REGION_NAME='DFW' \
--env DIRECTORY='/config' \
--env CONTAINER='quassel-backup' \
--volumes-from quassel-data \
carinamarina/cf-backup
```

This will display a cronlog. Watch it for a bit until you see `Successfully uploaded object [backup.tar.gz] to container [quassel-backup]` to ensure your data is being backed up. You will have to create a "quassel-backup" container if you don't have one.

This will backup your data every minute. This is not a rolling backup - only the last instance of your data is saved automatically, to reduce storage costs (data is overwritten on upload). Ctrl-C to get back to the terminal.

1. In case your data is lost and you need to restore your data.

```
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
```

Should output:

```
+ [  = true ]
+ rack files object download --container quassel-backup --name backup.tar.gz
+ tar -zxvf backup.tar.gz -C /config/..
config/
config/quasselCert.pem
config/.config/
config/.config/Trolltech.conf
config/quasselcore.conf
config/quassel-storage.sqlite
```

This will download your data from Rackspace Cloud Files to the quassel-backup volume container a single time.