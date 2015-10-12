---
title: Connect containers using the Ambassador pattern
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-01
permalink: docs/tutorials/connect-docker-containers-ambassador-pattern/
description: Learn how to connect Docker containers using the Ambassador pattern so that they can communicate with each other over the network and across Docker hosts
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - networking
---

This tutorial demonstrates how to connect Docker containers using the Ambassador pattern
so that they can communicate over the network and across Docker hosts. For information about
the Ambassador pattern, see [Docker networking basics][networking-basics].

### Prerequisite

Two Docker hosts using [Linux][docker-linux], [Docker Toolbox][docker-toolbox], or [Rackspace Container Service][rcs]

[docker-linux]: http://docs.docker.com/linux/step_one/
[docker-toolbox]: https://www.docker.com/toolbox
[rcs]: http://mycluster.rackspacecloud.com/

### Steps

1. [Load your first Docker host environment]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-mac/).

2. Create a container named `app`.

    ```bash
    docker run --detach --name app rackerlabs/hello-world-app
    ```

    This is the _source container_. No ports are published for this container,
    so it will only communicate privately with other containers by using links.

3. Inspect the app container and note its exposed port. In the following example, the
    port is `5000`. This is the port number over which the ambassador will
    communicate with the source container.

    ```bash
    $ docker inspect --format "{{ .Config.ExposedPorts }}" app

    map[5000/tcp:{}]
    ```

4. Create an ambassador container named `app-ambassador`.

    ```bash
    docker run --detach --name app-ambassador \
    --link app:helloapp \
    --publish 5000:5000 svendowideit/ambassador
    ```

    This is the _source ambassador_ and it is responsible for forwarding messages
    from other containers to the source container. The source ambassador is linked
    to the source container and publishes the same port number exposed by the source container.

    **Note**: Although it is not required for the ambassador containers to communicate over the same port
    number that is exposed by the source container, it does simplify configuration.

5. Identify the connection information to the source ambassador container, as it will be required
    when configuring the other ambassador container. In the example output,
    the connection information to the source ambassador is `104.130.0.192:5000`.

    ```bash
    $ docker port app-ambassador

    5000/tcp -> 104.130.0.192:5000
    ```

6. [Load your second Docker host environment]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-mac/).

7. Create an ambassador container named `app-ambassador`. Replace `<connectionInformation>` with
    the connection information from step 5.

    ```bash
    docker run --detach --name app-ambassador \
    --env HELLOAPP_PORT_5000_TCP=tcp://<connectionInformation> \
    --expose 5000 svendowideit/ambassador
    ```

    This is the _target ambassador_ and it is responsible for forwarding messages
    to the source ambassador. The target ambassador is provided an environment variable,
    `HELLOAPP_PORT_5000_TCP`, containing the connection information to the source ambassador
    and it exposes the same port number published by the source container.

    **Note**: It is not required to use the same name for the source and target ambassadors.

8. Create a container named `web`.

    ```bash
    docker run --detach --name web \
    --link app-ambassador:helloapp \
    rackerlabs/hello-world-web
    ```

    This is the _target container_ and it communicates with the source container
    via its link to the target ambassador.

    **Note:** The link alias, which in this example is `helloapp`, is not arbitrary and must match the alias expected by the target
    container. When a Docker container is designed to link to another, the expected
    link alias is usually documented on [its Docker Hub page](https://hub.docker.com/r/rackerlabs/hello-world-web/).

9. Identify the port on which the web container is published by running the following command.
    In the example output, the port is `32770`.

    ```bash
    $ docker port web

    5000/tcp -> 104.130.0.177:32770
    ```

10. Open http://_dockerHost_:_webPort_, where _dockerHost_ is the IP address or host name of the second Docker host,
    for example **http://104.130.0.177:32770**. You should see the following output:

      ```bash
      The linked container says ... "Hello World!"
      ```

You now have two containers that can communicate across Docker hosts.

![Docker Ambassador pattern topology]({% asset_path connect-docker-containers-ambassador-pattern/ambassador-pattern-topology.svg %})

### Resources

* [Docker Ambassador pattern documentation](https://docs.docker.com/articles/ambassador_pattern_linking/)
* [Docker networking basics][networking-basics]
* [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)
* [Service discovery 101]({{ site.baseurl }}/tutorials/005-service-discovery-101/)
* [Introduction to container technologies: container networking]({{ site.baseurl }}/best-practices/container-technologies-networking/)

[networking-basics]: {{ site.baseurl }}/docs/tutorials/docker-networking-basics/
