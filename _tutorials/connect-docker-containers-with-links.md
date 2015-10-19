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
can communicate over the network. For information about Docker links, see [Docker networking basics][networking-basics].

**Note:** Only containers that are on the same Docker host can be linked.

### Prerequisite

A Docker host using [Linux][docker-linux], [Docker Toolbox][docker-toolbox], or [Carina][carina]

[docker-linux]: http://docs.docker.com/linux/step_one/
[docker-toolbox]: https://www.docker.com/toolbox
[carina]: http://app.getcarina.com/

### <a name="connect"></a> Connect two containers with a Docker link

1. [Load your Docker host environment]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-mac/).

2. Create a container named `app`. This is the _source_ container for your Docker link. No ports
    are published for this container, so it will only communicate privately with other
    containers by using links.

    ```bash
    $ docker run --detach --name app rackerlabs/hello-world-app
    ```

3. Inspect the app container and note its exposed port. In the following example, the
    port is `5000`. This is the port number over which the containers will communicate.

    ```bash
    $ docker inspect --format "{{ .Config.ExposedPorts }}" app
    map[5000/tcp:{}]
    ```

4. Create a container named `web`. This is the _target_ container for your link.
    The `--link` flag connects the target container, `web`,
    to the source container, `app`, and names the link `helloapp`.

    ```bash
    $ docker run --detach --name web --link app:helloapp -P rackerlabs/hello-world-web
    ```

    The link alias, which in this example is `helloapp`, is not arbitrary and must match the alias expected by the target
    container. When a Docker container is designed to link to another, the expected
    link alias is usually documented on [its Docker Hub page](https://hub.docker.com/r/rackerlabs/hello-world-web/).

5. Identify the port on which the web container is published by running the following command.
    In the example output, the port is `32770`.

    ```bash
    $ docker port web
    5000/tcp -> 0.0.0.0:32770
    ```

6. Open http://_dockerHost_:_webPort_, for example **http://localhost:32770**.
    You should see the following output:

      ```bash
      The linked container says ... "Hello World!"
      ```

You now have two containers that can communicate via a Docker link.

![Docker Link Topology]({% asset_path connect-docker-containers-with-links/docker-links-topology.svg %})

### <a name="inspect"></a> Inspect the linked containers

Follow these instructions to learn more about the information provided by the Docker link
and how the containers use it to communicate.

1. Log in to the web container by running the following command. Depending on your local configuration
    you might need to use a workaround from [Error running interactive Docker shell on Windows][tty-workaround].

    ```bash
    $ docker exec --interactive --tty web /bin/bash
    ```

2. Run the following command to view the environment variables created by the Docker link.
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

3. Ping the app container by using an environment variable.

    ```bash
    $ ping $HELLOAPP_PORT_5000_TCP_ADDR
    ```

    **Note:** Normally using the environment variables to ping containers is not recommended.
    When the source container is restarted,
    the variables on the target container are not refreshed. In the next steps,
    you will use the host file entries instead, which Docker automatically keeps up to date.

4. View the host entries created by the Docker link by using the following command. The
    host entry that contains the link name enables the web container to
    use **http://helloapp:5000** to connect to the app container.

    ```bash
    $ grep -i helloapp /etc/hosts
    172.17.0.12	helloapp 3432593d47de app
    ```

5. Ping the app container by using both the link alias, `helloapp`, and the container name, `app`.

    ```bash
    $ ping -c 1 helloapp
    PING helloapp (172.17.0.12): 56 data bytes
    64 bytes from 172.17.0.12: icmp_seq=0 ttl=64 time=0.105 ms

    $ ping -c 1 app
    PING helloapp (172.17.0.12): 56 data bytes
    64 bytes from 172.17.0.12: icmp_seq=0 ttl=64 time=0.060 ms
    ```

6. Access the app container's service at **http://helloapp:5000**.

    ```bash
    $ curl http://helloapp:5000
    Hello World!
    ```

7. Log out of the web container.

    ```bash
    $ exit
    ```

8. Log in to the app container by running the following command. Depending on your local configuration
    you might need to use a workarounds from [Error running interactive Docker shell on Windows][tty-workaround].

    ```bash
    $ docker exec --interactive --tty app /bin/bash
    ```

9. Run the following command to view the environment variables. Note that Docker does _not_
    create environment variables for the link on the source container.

    ```bash
    $ env
    PYTHON_VERSION=3.4.3
    LANG=C.UTF-8
    PYTHON_PIP_VERSION=7.1.2
    ```

10. View the host entries created by the Docker link by using the following command. Note that
    an entry is created only for the target container name, and not the link alias.

    ```bash
    $ more /etc/hosts
    127.0.0.1	localhost
    172.17.0.12	app
    172.17.0.13	web
    ```

11. Ping the web container.

    ```bash
    $ ping -c 1 web
    PING web (172.17.0.13): 56 data bytes
    64 bytes from 172.17.0.13: icmp_seq=0 ttl=64 time=0.064 ms
    ```

12. Log out of the app container.

    ```bash
    $ exit
    ```

[tty-workaround]: {{site.baseurl}}/docs/references/troubleshooting-cannot-enable-tty-mode-on-windows/

### Resources

* [Docker links documentation](https://docs.docker.com/userguide/dockerlinks/)
* [Docker networking basics][networking-basics]
* [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)
* [Service discovery 101]({{ site.baseurl }}/tutorials/005-service-discovery-101/)
* [Introduction to container technologies: container networking]({{ site.baseurl }}/best-practices/container-technologies-networking/)

[networking-basics]: {{ site.baseurl }}/docs/tutorials/docker-networking-basics/
