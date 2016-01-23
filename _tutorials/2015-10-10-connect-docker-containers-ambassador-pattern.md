---
title: Connect containers by using the ambassador pattern
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-10
permalink: docs/tutorials/connect-docker-containers-ambassador-pattern/
description: Learn how to connect Docker containers by using the ambassador pattern so that they can communicate with each other over the network and across Docker hosts
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - networking
---

This tutorial demonstrates how to connect Docker containers by using the ambassador pattern
so that they can communicate over the network and across Docker hosts. For information about the ambassador pattern, see [Docker networking basics]({{ site.baseurl }}/docs/concepts/docker-networking-basics/).

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/) named clustera and a cluster named clusterb.

### Connect containers

1. [Connect to your cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster#connect-to-your-cluster) named clustera.

1. Run a container named `app`.

    ```bash
    $ docker run --detach --name app carinamarina/hello-world-app
    ```

    This is the _source container_. No ports are published for this container,
    so it will only communicate privately with other containers by using links.

1. Inspect the app container and note its exposed port. In the following example, the
    port is `5000`. This is the port number over which the ambassador will
    communicate with the source container.

    ```bash
    $ docker inspect --format "{% raw %}{{ .Config.ExposedPorts }}{% endraw %}" app
    map[5000/tcp:{}]
    ```

1. Run an ambassador container named `app-ambassador`.

    ```bash
    $ docker run --detach --name app-ambassador \
      --link app:helloapp \
      --publish 5000:5000 svendowideit/ambassador
    ```

    This is the _source ambassador_ and it is responsible for forwarding messages
    from other containers to the source container. The source ambassador is linked
    to the source container and publishes the same port number exposed by the source container.

    **Note**: Although it is not required for the ambassador containers to communicate over the same port
    number that is exposed by the source container, it does simplify configuration.

1. Identify the connection information to the source ambassador container; it will be required
    when configuring the other ambassador container. In the example output,
    the connection information to the source ambassador is `104.130.0.192:5000`.

    ```bash
    $ docker port app-ambassador
    5000/tcp -> 104.130.0.192:5000
    ```

1. 1. [Connect to your cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster#connect-to-your-cluster) named clusterb.


1. In the second cluster environment, run an ambassador container named `app-ambassador`. Replace `<connectionInformation>` with
    the connection information from step 5.

    ```bash
    $ docker run --detach --name app-ambassador \
      --env HELLOAPP_PORT_5000_TCP=tcp://<connectionInformation> \
      --expose 5000 svendowideit/ambassador
    ```

    This is the _target ambassador_ and it is responsible for forwarding messages
    to the source ambassador. The target ambassador is provided an environment variable,
    `HELLOAPP_PORT_5000_TCP`, containing the connection information to the source ambassador,
    and it exposes the same port number published by the source container.

    **Note**: You do not have to use the same name for the source and target ambassadors.

1. Run a container named `web`.

    ```bash
    $ docker run --detach --name web \
      --link app-ambassador:helloapp \
      --publish-all carinamarina/hello-world-web
    ```

    This is the _target container_ and it communicates with the source container
    via its link to the target ambassador.

    **Note:** The link alias, which in this example is `helloapp`, is not arbitrary and must match the alias expected by the target
    container. When a Docker container is designed to link to another, the expected
    link alias is usually documented on [its Docker Hub page](https://hub.docker.com/r/carinamarina/hello-world-web/).

1. Identify the port on which the web container is published by running the following command.
    In the example output, the port is `32770`.

    ```bash
    $ docker port web
    5000/tcp -> 104.130.0.177:32770
    ```

1. Open http://_dockerHost_:_webPort_, where _dockerHost_ is the IP address or host name of the second Docker host,
    for example **http://104.130.0.177:32770**. You should see the following output:

    ```bash
    The linked container says ... "Hello World!"
    ```

You now have two containers that can communicate across Docker hosts.

![Docker ambassador pattern topology]({% asset_path connect-docker-containers-ambassador-pattern/ambassador-pattern-topology.svg %})

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Docker networking basics]({{ site.baseurl }}/docs/concepts/docker-networking-basics/)
* [Docker ambassador pattern documentation](https://docs.docker.com/articles/ambassador_pattern_linking/)
* [Docker best practices: container linking]({{ site.baseurl }}/docs/best-practices/docker-best-practices-container-linking/)
* [Service discovery 101]({{ site.baseurl }}/docs/concepts/service-discovery-101/)
* [Introduction to container technologies: container networking]({{ site.baseurl }}/docs/best-practices/container-technologies-networking/)

### Next step

[Connect containers with Docker links]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-with-links/)
