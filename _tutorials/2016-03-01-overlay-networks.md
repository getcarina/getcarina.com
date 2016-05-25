---
title: Use overlay networks in Carina
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-01
permalink: docs/tutorials/overlay-networks/
description: Use overlay networks to isolate container communication.
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
  - networking
---

An overlay network provides isolation for containers to communicate across all of the nodes in your cluster on Carina. Overlay networks add another layer of security to your application deployments and make it easier for your containers to communicate with one another.

Among the many benefits are a few key features:

* An isolated network for containers that ensures only the services of your choice are exposed outside of your system
* The ability to dynamically connect containers to and disconnect containers from multiple networks
* Automatic name resolution of containers by using DNS

We strongly recommend using an overlay network anytime you need two or more containers to communicate.

<figure>
  <img src="{% asset_path weekly-news/overlay-network.png %}" alt="Overlay network"/>
  <figcaption>
  <a href="https://docs.docker.com/engine/userguide/networking/dockernetworks/#an-overlay-network" target="_blank_">Image source: Docker Inc.</a>
  </figcaption>
</figure>

### Security

Overlay networks run on an underlying network known as ServiceNet. ServiceNet connects cluster nodes to the internal, multi-tenant network within Carina. Any container that publishes a port with the `--publish` or `--publish-all` flags is exposed to both the Internet and ServiceNet. In many cases, exposing a container to both the Internet and ServiceNet is undesirable because it increases the attack surface for your system.

We strongly recommend using the `--net` flag and _not_ using the `--publish` or `--publish-all` flag anytime you run a container that does not need to communicate outside of your system.

### Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)

### Create a network

Use the `docker network create` command to create an overlay network.

```bash
$ docker network create mynetwork
501e123b2904757fe9fe23cb60e64191f3764c6d42e188cb3ba7ad30d845f84b
```

The output of this command is the network ID.

### Inspect a network

Use the `docker network inspect` command to inspect an overlay network.

```bash
$ docker network inspect mynetwork
[
    {
        "Name": "mynetwork",
        "Id": "501e123b2904757fe9fe23cb60e64191f3764c6d42e188cb3ba7ad30d845f84b",
        "Scope": "global",
        "Driver": "overlay",
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "10.0.0.0/24",
                    "Gateway": "10.0.0.1/24"
                }
            ]
        },
        "Containers": {},
        "Options": {}
    }
]
```

The output of this command is all of the details of the specified network.

By default, `docker network create` creates an overlay network that has a subnet with a CIDR block of `10.0.0.0/24` and a gateway of `10.0.0.1`.

### Networks and subnets

A subnet is a subdivision of an IP network. It defines how containers that are connected to a network are addressed. The gateway associated with the network defines how containers communicate outside of their network when they need to. By default, networks are created with a suffix of `/24`, which means that 254 IP addresses are available per network.

Every time you create a network, a subnet is created with a new CIDR block. By default, the CIDR blocks are assigned by incrementing the third octet (the third number in the CIDR). For example, the first network has a `10.0.0.0/24` CIDR block, the second network has a `10.0.1.0/24` CIDR block, the third network has a `10.0.2.0/24` CIDR block, and so on.

The ServiceNet CIDR block is `10.176.224.0/19`. If a container is assigned an IP address that conflicts with an IP address in the ServiceNet CIDR block, the container would experience connectivity issues or failures. However, you would have to create tens of thousands of networks using the default CIDR block incrementing scheme to get an IP address that conflicts with an IP address of ServiceNet.

We recommend using the defaults of the `docker network create` command unless you need a more complex networking configuration.

### Run a container not exposed to the Internet or ServiceNet

1. Run a MySQL instance and specify a network by using the `--net` flag. Do _not_ publish any ports by using the `--publish` or `--publish-all` flag.

    ```bash
    $ docker run \
      --detach \
      --name mysql \
      --net mynetwork \
      --env MYSQL_ROOT_PASSWORD=my-root-pw \
      mysql:5.6
    3cca18511886131f54b6edc03f1a181015735ae0e1ba5654290f3d5ebacb3313
    ```

1. Confirm that the MySQL instance is not exposed publicly

    ```bash
    $ docker port mysql 3306
    Error: No public port '3306/tcp' published for mysql
    ```

The MySQL instance is connected to `mynetwork` but is not exposed to the Internet or ServiceNet, which gives you an additional layer of security for your database. However, the MySQL instance is listening on its `mynetwork` overlay network IP address on port 3306 (the default port for MySQL).

### Run a container exposed to the Internet and ServiceNet

1. Run a WordPress instance and use the `--publish 80:80` flag to expose it publicly. For this particular image, you can use the `--env WORDPRESS_DB_HOST=mysql` flag to refer to the hostname of the MySQL instance that's listening on its `mynetwork` overlay network IP address on port 3306 (the default port for MySQL).

    ```bash
    $ docker run --detach \
      --name wordpress \
      --net mynetwork \
      --publish 80:80 \
      --env WORDPRESS_DB_HOST=mysql \
      --env WORDPRESS_DB_PASSWORD=my-root-pw \
      wordpress:4.4
    3fdf00eb8229ee208d55a211e6823a0bc2343a546ef03f082d1cb5af7afbf74f
    ```

1. Confirm that the WordPress instance is exposed publicly.

    ```bash
    $ docker port wordpress 80
    146.20.68.14:80
    ```

    You can view the WordPress site by copying and pasting the IP address into your web browser address bar.

The WordPress instance is connected to `mynetwork` and is exposed to the Internet and ServiceNet. The hostname `mysql` is resolved to an IP address by using a DNS server embedded in the Docker Engine, which provides automatic service discovery for containers connected to the overlay network.

### More actions on networks

You can perform more actions such as listing networks, removing networks, connecting containers, and disconnecting containers. For a full reference, see [Work with network commands](https://docs.docker.com/engine/userguide/networking/work-with-networks/).

### Overlay networks implementation in Carina

The primary requirement to implement overlay networks on Docker Swarm is the use of a key-value store. The key-value store holds information about the network state that includes discovery, networks, endpoints, IP addresses, and more. For Carina, Consul is the key-value store. An instance of Consul runs in a container on each node in your clusters. You can see these containers in the output of a `docker ps` command.

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
2c226fad0713        carina/consul       "/bin/consul agent -b"   19 hours ago        Up 19 hours                             96afcb76-6483-443e-941d-df9f803a4628-n2/carina-svcd
c715e66154c8        carina/consul       "/bin/consul agent -b"   43 hours ago        Up 43 hours                             96afcb76-6483-443e-941d-df9f803a4628-n1/carina-svcd
```

These Consul containers are for use only by Carina and cannot be accessed by users. It's crucial that you _do not delete the Consul containers_. If you need to remove containers, it's best to do so by name (for example, `docker rm container-name-1 container-name-2`) or by status (for example, `docker rm $(docker ps -qf "status=exited")`). However, if you do accidentally delete the containers, see [How do I rebuild a cluster?]({{site.baseurl}}/docs/reference/faq/#how-do-i-rebuild-a-cluster) and [What does the cluster rebuild action do?]({{site.baseurl}}/docs/reference/faq/#what-does-the-cluster-rebuild-action-do).

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Subnetwork](https://en.wikipedia.org/wiki/Subnetwork)
* [Classless Inter-Domain Routing (CIDR)](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing)
* [Understand Docker container networks](https://docs.docker.com/engine/userguide/networking/dockernetworks/)
* [Get started with overlay networking (also known as multi-host networking)](https://docs.docker.com/engine/userguide/networking/get-started-overlay/)
* [Embedded DNS server in user-defined networks](https://docs.docker.com/engine/userguide/networking/configure-dns/)

### Next

Learn more about how to [Communicate between containers over the ServiceNet internal network]({{ site.baseurl }}/docs/tutorials/servicenet/)
