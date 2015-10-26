---
title: Connect containers with Docker links
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-01
permalink: docs/tutorials/connect-docker-containers-with-links/
description: Learn how to connect Docker containers with links so that they can communicate with each other over the network
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - networking
---

This tutorial demonstrates how to connect Docker containers with links so that they
can communicate over the network.

**Note:** Only containers that are on the same Docker host can be linked.

### Prerequisite

[Create and connect to a cluster](/docs/tutorials/create-connect-cluster/)

### <a name="connect"></a> Connect two containers with a Docker link

1. Create a container named `app`. This is the _source_ container for your Docker link. No ports
    are published for this container, so it will only communicate privately with other
    containers by using links.

    ```bash
    $ docker run --detach --name app carinamarina/hello-world-app
    ```

1. Inspect the app container and note its exposed port. In the following example, the
    port is `5000`. This is the port number over which the containers will communicate.

    ```bash
    $ docker inspect --format "{{ .Config.ExposedPorts }}" app
    map[5000/tcp:{}]
    ```

1. Create a container named `web`. This is the _target_ container for your link.
    The `--link` flag connects the target container, `web`,
    to the source container, `app`, and names the link `helloapp`.

    ```bash
    $ docker run --detach --name web --link app:helloapp -P carinamarina/hello-world-web
    ```

    The link alias, which in this example is `helloapp`, is not arbitrary and must match the alias expected by the target
    container. When a Docker container is designed to link to another, the expected
    link alias is usually documented on its [Docker Hub page](https://hub.docker.com/r/carinamarina/hello-world-web/).

1. Identify the port on which the web container is published by running the following command.
    In the example output, the port is `32770`.

    ```bash
    $ docker port web
    5000/tcp -> 0.0.0.0:32770
    ```

1. Open http://_dockerHost_:_webPort_, for example **http://localhost:32770**.
    You should see the following output:

      ```bash
      The linked container says ... "Hello World!"
      ```

You now have two containers that can communicate via a Docker link.

![Docker Link Topology]({% asset_path connect-docker-containers-with-links/docker-links-topology.svg %})

### <a name="inspect"></a> Inspect the linked containers

Follow these instructions to learn more about the information provided by the Docker link
and how the containers use it to communicate.

1. Log in to the web container by running the following command.

    ```bash
    $ docker exec --interactive --tty web /bin/bash
    ```

1. Run the following command to view the environment variables created by the Docker link.
    Docker creates variables that describe the link, such as `HELLOAPP_PORT`.
    In addition, variables from the source container, `app`, are also exposed with the prefix _linkName_\_ENV.
    For example, Docker created a variable named `HELLOAPP_ENV_PYTHON_VERSION`,
    which contains the value of `PYTHON_VERSION` on the web container.

    ```bash
    $ env | grep HELLOAPP
    HELLOAPP_NAME=/web/helloapp
    HELLOAPP_PORT=tcp://172.17.0.12:5000
    HELLOAPP_PORT_5000_TCP=tcp://172.17.0.12:5000
    HELLOAPP_PORT_5000_TCP_PROTO=tcp
    HELLOAPP_PORT_5000_TCP_ADDR=172.17.0.12
    HELLOAPP_PORT_5000_TCP_PORT=5000
    HELLOAPP_ENV_PYTHON_VERSION=3.4.3
    HELLOAPP_ENV_PYTHON_PIP_VERSION=7.1.2
    HELLOAPP_ENV_LANG=C.UTF-8
    ```

1. Ping the app container by using an environment variable.

    ```bash
    $ ping $HELLOAPP_PORT_5000_TCP_ADDR
    ```

    **Note:** Normally using the environment variables to ping containers is not recommended.
    When the source container is restarted,
    the variables on the target container are not refreshed. In the next steps,
    you will use the host file entries instead, which Docker automatically keeps up to date.

1. View the host entries created by the Docker link by using the following command. The
    host entry that contains the link name enables the web container to
    use **http://helloapp:5000** to connect to the app container.

    ```bash
    $ grep -i helloapp /etc/hosts
    172.17.0.12	helloapp 3432593d47de app
    ```

1. Ping the app container by using both the link alias, `helloapp`, and the container name, `app`.

    ```bash
    $ ping -c 1 helloapp
    PING helloapp (172.17.0.12): 56 data bytes
    64 bytes from 172.17.0.12: icmp_seq=0 ttl=64 time=0.105 ms

    $ ping -c 1 app
    PING helloapp (172.17.0.12): 56 data bytes
    64 bytes from 172.17.0.12: icmp_seq=0 ttl=64 time=0.060 ms
    ```

1. Access the app container's service at **http://helloapp:5000**.

    ```bash
    $ curl http://helloapp:5000
    Hello World!
    ```

1. Log out of the web container.

    ```bash
    $ exit
    ```

1. Log in to the app container by running the following command.

    ```bash
    $ docker exec --interactive --tty app /bin/bash
    ```

1. Run the following command to view the environment variables. Note that Docker does _not_
    create environment variables for the link on the source container.

    ```bash
    $ env
    PYTHON_VERSION=3.4.3
    LANG=C.UTF-8
    PYTHON_PIP_VERSION=7.1.2
    ```

1. View the host entries created by the Docker link by using the following command. Note that
    an entry is created only for the target container name, and not the link alias.

    ```bash
    $ more /etc/hosts
    127.0.0.1	localhost
    172.17.0.12	app
    172.17.0.13	web
    ```

1. Ping the web container.

    ```bash
    $ ping -c 1 web
    PING web (172.17.0.13): 56 data bytes
    64 bytes from 172.17.0.13: icmp_seq=0 ttl=64 time=0.064 ms
    ```

1. Log out of the app container.

    ```bash
    $ exit
    ```

### Troubleshooting

See [Error running interactive Docker shell on Windows](/docs/references/troubleshooting-cannot-enable-tty-mode-on-windows/).

See [Troubleshooting common problems](/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Docker networking basics](/docs/tutorials/networking-basics/)
* [Docker links documentation](https://docs.docker.com/userguide/dockerlinks/)
* [Docker best practices: container linking](/docs/best-practices/docker-best-practices-container-linking/)
* [Service discovery 101](/docs/tutorials/service-discovery-101/)
* [Introduction to container technologies: container networking](/docs/best-practices/container-technologies-networking/)

### Next step

[Connect containers by using the ambassador pattern](/docs/tutorials/connect-docker-containers-ambassador-pattern/)
