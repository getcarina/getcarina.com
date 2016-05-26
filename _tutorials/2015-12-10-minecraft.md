---
title: Explore Minecraft on Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-12-10
permalink: docs/tutorials/minecraft/
description: Learn how to run a Minecraft server on Carina
docker-versions:
  - 1.9.1
topics:
  - docker
  - intermediate
  - minecraft
---

Minecraft is a multi-player game that lets you explore a vast 3D world, craft items from world's bountiful resources, and survive nights filled with monstrous mobs. This tutorial describes running a Minecraft server on Carina so that you can explore the world of Minecraft with your friends and family.

![minecraft]({% asset_path minecraft/minecraft.png %})

### Prerequisites

* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)
* [Purchase Minecraft](https://minecraft.net/store/minecraft)
* [Download and install the Minecraft game](https://minecraft.net/download)

### Create a data volume container

Create a data volume container (DVC) to store your Minecraft world data in. A DVC creates a persistent volume that's easy to access from other containers.

This container uses the `--volume` flag to mount a volume in the container at the path `/data`. That path is used because that's where the `itzg/minecraft-server` Docker image expects to persist the Minecraft world data.

```
$ docker create \
  --name minecraft-data \
  --volume /data \
  itzg/minecraft-server
bf1e5afceadbc4731f3785947e99e42d2cd9af4f559af3602e8262834d4e4d1e
```

The output of this `docker create` command is your application container ID.

**Note**: Take extreme care not to remove this container. If this container is removed you will lose all of your Minecraft world data.

### Run a Minecraft server

If you want to play with friends and family in the same house or around the world, you can run a Minecraft server that everyone can connect to.

This container is connected to the DVC by using the `--volumes-from` flag. It uses the `--publish` flag to expose the server on the standard Minecraft port. Many `--env` flags are used to configure Minecraft server settings. You'll need to change the `OPS` and `WHITELIST` lists to include your own Minecraft username. You can find a full description of all of the settings in the [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server/) Docker Hub page.

```
$ docker run --detach --interactive --tty \
  --name minecraft \
  --volumes-from minecraft-data \
  --publish 25565:25565 \
  --restart always \
  --env VERSION=LATEST \
  --env OPS=my-username,my-dogs-username \
  --env WHITELIST=my-username,my-dogs-username,my-cats-username \
  --env EULA=TRUE \
  --env MOTD="Carina World" \
  itzg/minecraft-server
7b4ae87a63408a7b99d550f83f30902512b4ab9ac1a1a05509263459a2b1ad48
```

The output of this `docker run` command is your running application container ID.

### Inspect the Minecraft server

Now that you have a Minecraft server running, you can learn more about what's going on inside the container.

1. List the files in the `/data` directory.

    ```
    $ docker run --rm \
      --volumes-from minecraft-data \
      itzg/minecraft-server \
      ls /data
    banned-ips.json
    banned-players.json
    eula.txt
    logs
    minecraft_server.1.8.8.jar
    ops.json
    ops.txt.converted
    server.properties
    usercache.json
    white-list.txt.converted
    whitelist.json
    world
    ```

    The output of this `docker run` command is a list of all of the files in the `/data` directory.

1. Inspect a single file.

    ```
    $ docker run --rm \
      --volumes-from minecraft-data \
      itzg/minecraft-server \
      cat /data/whitelist.json
    [
      {
        "uuid": "86479556-d684-42b6-a64b-98484e87efdf",
        "name": "my-username"
      }
    ]
    ```

    The output of this `docker run` command is the contents of the `/data/whitelist.json` file, which is the whitelist of all of the users allowed to log in to your server.

1. Inspect the logs.

    ```
    $ docker logs minecraft
    usermod: no changes
    ...switching to user 'minecraft'
    Checking version information.
    ...
    [04:07:25] [Server thread/INFO]: Done (12.736s)! For help, type "help" or "?"
    ```

    The output of this `docker logs` command is all of the logging information that the Minecraft server sent to the console when it was starting up.

1. Check the version of Minecraft.

    ```
    $ docker logs minecraft | grep "server version"
    [04:07:11] [Server thread/INFO]: Starting minecraft server version 1.8.8
    ```

    The output of this `docker logs` command is a single log line that shows the version of Minecraft that your server is running.

### Control the Minecraft server

You can run commands directly on the Minecraft server to affect the players and the environment while the game is running.

#### Attach to the container

```
$ docker attach minecraft
```

There is no output from this `docker attach` command because the server is waiting for input. To run commands on the server, type in the commands in the following sections.

When you've finished running commands, press **Ctrl-p** and then **Ctrl-q** to detach from the container. Do not use **Ctrl-c**! That will kill your server and you'll need to restart it by going through [Run a Minecraft server](#run-a-minecraft-server) again

#### Get help

```    
/help
[04:22:07] [Server thread/INFO]: --- Showing help page 1 of 9 (/help <page>) ---
[04:22:07] [Server thread/INFO]: /achievement <give|take> <stat_name|*> [player]
[04:22:07] [Server thread/INFO]: /ban <name> [reason ...]
[04:22:07] [Server thread/INFO]: /ban-ip <address|name> [reason ...]
[04:22:07] [Server thread/INFO]: /banlist [ips|players]
[04:22:07] [Server thread/INFO]: /blockdata <x> <y> <z> <dataTag>
[04:22:07] [Server thread/INFO]: /clear [player] [item] [data] [maxCount] [dataTag]
[04:22:07] [Server thread/INFO]: /clone <x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> [maskMode] [cloneMode]
```

The output of this `/help` command gives you all of the commands that you can possibly run on the server. You can jump to different help pages by running a command like `/help 2`.

#### Whitelist a player

It's important to know how to add users to the whitelist so others can join your server.

```
/whitelist add my-fishs-username
[04:24:11] [Server thread/INFO]: Added my-fishs-username to the whitelist
```

The output of this `/whitelist add` command shows you the player that you just whitelisted.

```
/whitelist list
[04:22:38] [Server thread/INFO]: There are 4 (out of 0 seen) whitelisted players:
[04:22:38] [Server thread/INFO]: my-username, my-dogs-username, my-cats-username and my-fishs-username
```

The output of this `/whitelist list` command lists all of the currently whitelisted players.

#### Make a player an operator

```
/op my-fishs-username
[04:24:48] [Server thread/INFO]: Opped my-fishs-username
```

The output of this `/op` command shows you the player that you just opped. That player can now run all operator-level commands in the game.

### Connect to the Minecraft server

Connect to the Minecraft server and start exploring.

1. Discover the IP address where the server is running.

    ```
    $ docker port minecraft 25565
    172.99.78.222:25565
    ```

    The output of this `docker port` command is the ip:port that you need to use to connect to the Minecraft server.

1. Connect to the Minecraft server.

    1. Open the Minecraft game.
    1. Log in by using your Minecraft username from the `WHITELIST` above.
    1. On the home screen click **Multiplayer**
    1. Click **Add server** and enter the following information:
      1. Server Name: Minecraft Server on Carina
      1. Server Address: [ip:port from step 1]
      1. Click **Done**
    1. Choose that server
    1. Click **Join Server**

Go explore the world of Minecraft! But don't forget to start building a shelter because nightfall is coming and the monstrous mobs will be out to get you.

When you want others to join your Minecraft server, give them the ip:port and [add their Minecraft username to the whitelist](#whitelist-a-player).

### Upgrade to the next version of Minecraft

New versions of Minecraft are constantly being released. Because you created a DVC to store your world data, it's easy to upgrade to the next version of Minecraft. You can even upgrade to the latest snapshot version.

1. Ask all of your players to log off.

1. Write any server changes to disk.

    ```
    $ docker attach minecraft
    /save-all
    [05:10:04] [Server thread/INFO]: Saving...
    [05:10:04] [Server thread/INFO]: Saved the world
    ```

    Press **Ctrl-p** and then **Ctrl-q** to detach from the container.

1. Remove the current Minecraft server

    ```
    $ docker rm --force minecraft
    minecraft
    ```

    The output of this `docker rm` command is the name of the container that you just removed.

1. Run the next version or snapshot of Minecraft

    ```
    $ docker run --detach --interactive --tty \
      --name minecraft \
      --volumes-from minecraft-data \
      --publish 25565:25565 \
      --restart always \
      --env VERSION=LATEST \
      --env OPS=my-username,my-dogs-username \
      --env WHITELIST=my-username,my-dogs-username,my-cats-username \
      --env EULA=TRUE \
      --env MOTD="Carina World" \
      itzg/minecraft-server
    6c6c2cc89368d93686bb13b057959d22ebc5f38553d8f16526d92948a74fc31c
    ```

    The output of this `docker run` command is your running application container ID.

1. Check the version of Minecraft.

    ```
    $ docker logs minecraft | grep "server version"
    [05:14:50] [Server thread/INFO]: Starting minecraft server version 1.8.9
    ```

    The output of this `docker logs` command is a single log line that shows the version of Minecraft that your new server is running.

1. Open the Minecraft game and reconnect to your server.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Minecraft](https://minecraft.net/)
* [Minecraft Commands](http://minecraft.gamepedia.com/Commands)
* [Minecraft Tutorials - How to Survive & Thrive](https://www.youtube.com/playlist?list=PL7326EF82122776A9)
* [Use data volume containers]({{site.baseurl}}/docs/tutorials/data-volume-containers/)

### Next step

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
