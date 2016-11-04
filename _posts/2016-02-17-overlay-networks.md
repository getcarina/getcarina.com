---
title: "Overlay networks"
date: 2016-02-17 13:00
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  Carina had a major release this week, the biggest release since we launched. This release adds overlay networking to Docker Swarm clusters in Carina. Overlay networks provide complete isolation for containers to communicate across all of the nodes in your cluster. This adds a new layer of security to your application deployments and makes it much easier for your containers to communicate with one another. This release also includes upgrades to Docker 1.10.1 and Swarm 1.1.0, which both come with their own significant new features and bug fixes.
categories:
 - Docker
 - Swarm
 - Carina
authorIsRacker: true
---

**Note**: For tutorial information, see [Use overlay networks in Carina](/docs/tutorials/overlay-networks/).

{{ page.excerpt }}

## Overlay networks

<figure class="right">
  <img src="{% asset_path weekly-news/overlay-network.png %}" alt="Overlay network"/>
  <figcaption>
  <a href="https://docs.docker.com/engine/userguide/networking/dockernetworks/#an-overlay-network" target="_blank_">Image source: Docker Inc.</a>
  </figcaption>
</figure>

An overlay network provides isolation for containers to communicate across all of the nodes in your Docker Swarm cluster on Carina. This adds a new layer of security to your application deployments and makes it much easier for your containers to communicate with one another.

Among the many benefits are a few key features:

* A secured and isolated environment for the containers in a network
* Automatic name resolution of containers using DNS
* The ability to dynamically connect containers to and disconnect containers from multiple networks

We strongly recommend using an overlay anytime you need two or more containers to communicate.

## Overlay network example

To get a feel for how you can work with overlay networks on Carina, let’s run through an example. For this example, you need to [create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/) with at least two nodes. Overlay networks are available only on clusters created after February 15, 2016, and existing clusters cannot be upgraded to include overlay networks. If you find yourself juggling clusters with different Docker versions, we recommend that you [manage your Docker clients with the Docker Version Manager (dvm)]({{ site.baseurl }}/docs/reference/docker-version-manager/).

Use the `docker network create` command to create an overlay network.

```bash
$ docker network create mynet
6d9f06d136d22ae8911000c22453c92de2a260e424f3a120eecff6aaeaa57603

$ docker network ls
NETWORK ID          NAME                                                      DRIVER
6d9f06d136d2        mynet                                                     overlay
c3a94fdde28f        96afcb76-6483-443e-941d-df9f803a4628-n1/docker_gwbridge   bridge
60cecf066b00        96afcb76-6483-443e-941d-df9f803a4628-n1/host              host
e08f90ba2281        96afcb76-6483-443e-941d-df9f803a4628-n2/none              null
6eb0c1321cdb        96afcb76-6483-443e-941d-df9f803a4628-n2/docker_gwbridge   bridge
f29a270c5c0f        96afcb76-6483-443e-941d-df9f803a4628-n2/bridge            bridge
3b126dcfc9ea        96afcb76-6483-443e-941d-df9f803a4628-n1/bridge            bridge
33a440068243        96afcb76-6483-443e-941d-df9f803a4628-n1/none              null
a78deab3ef86        96afcb76-6483-443e-941d-df9f803a4628-n2/host              host
```

Now, run a small WordPress site and network a couple of containers together by connecting them to the overlay network that you just created by using the `--net=mynet` flag. Start with a MySQL instance for the database.

```bash
$ docker run \
  --detach \
  --name mysql \
  --net mynet \
  --env="constraint:node==*n1" \
  --env MYSQL_ROOT_PASSWORD=my-root-pw \
  mysql:5.6
1fd9be56364fc7367c7dd12fcf5b8c49dd176e266754c437febfff663a3ee35b

$ docker port mysql 3306
Error: No public port '3306/tcp' published for mysql
```

The MySQL instance is now connected to `mynet` but it's not exposed publicly, which gives you an additional layer of security for your database.

Next, start a WordPress instance, but publish a port to expose it publicly.

```bash
$ docker run --detach \
  --name wordpress \
  --net mynet \
  --publish 80:80 \
  --env="constraint:node==*n2" \
  --env WORDPRESS_DB_HOST=mysql \
  --env WORDPRESS_DB_PASSWORD=my-root-pw \
  wordpress:4.4

$ docker port wordpress 80
146.20.68.14:80
```

<img class="right" src="{% asset_path weekly-news/wordpress-esperanto.png %}" alt="Does anyone actually speak Esperanto?"/>The WordPress instance is now connected to `mynet`, and it's exposed publicly, which is exactly what you want. It was easy to connect it to the MySQL instance by simply referring to the container hostname `mysql` in the `--env WORDPRESS_DB_HOST=mysql` flag. The hostname `mysql` is resolved by using a [DNS server embedded in the Docker Engine](https://docs.docker.com/engine/userguide/networking/dockernetworks/#docker-embedded-dns-server), which provides automatic service discovery for containers connected to the overlay network.

**Note**: You don't need to use `--env="constraint:node==*nX"` in your deployments! I used it here only to ensure the containers are running on separate nodes, to illustrate overlay networking across nodes in your cluster.

Copy the IP address from the output of the last command to the location bar in your favorite browser. Now go ahead and start blogging in Esperanto like you've always wanted to.

If you'd like to secure your site with TLS and get a lovely green lock to appear in your browser location bar, run through how to use [NGINX with Let's Encrypt]({{ site.baseurl }}/docs/tutorials/nginx-with-lets-encrypt/).

## Overlay networks implementation

The primary requirement to implement overlay networks on Docker Swarm is the use of a key-value store. The key-value store holds information about the network state which includes discovery, networks, endpoints, IP addresses, and more. For Carina we chose Consul to be that key-value store. An instance of Consul runs in a container on each node in your clusters. You can see these containers in the output of a `docker ps` command.

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
2c226fad0713        carina/consul       "/bin/consul agent -b"   19 hours ago        Up 19 hours                             96afcb76-6483-443e-941d-df9f803a4628-n2/carina-svcd
c715e66154c8        carina/consul       "/bin/consul agent -b"   43 hours ago        Up 43 hours                             96afcb76-6483-443e-941d-df9f803a4628-n1/carina-svcd
```

These Consul containers are for use only by Carina and cannot be accessed by users. It's crucial that you **do not delete the Consul containers**. If you need to remove containers, it's best to do so by name (for example, `docker rm container-name-1 container-name-2`) or by status (for example, `docker rm $(docker ps -qf "status=exited")`). However, if you do accidentally delete the containers, see [How do I rebuild a cluster?]({{site.baseurl}}/docs/reference/faq/#how-do-i-rebuild-a-cluster) and [What does the cluster rebuild action do?]({{site.baseurl}}/docs/reference/faq/#what-does-the-cluster-rebuild-action-do).

## Learn more about overlay networks

To learn more about overlay networks, read the following Docker resources:

* [Understand Docker container networks](https://docs.docker.com/engine/userguide/networking/dockernetworks/)
* [Work with network commands](https://docs.docker.com/engine/userguide/networking/work-with-networks/)
* [Get started with overlay networking](https://docs.docker.com/engine/userguide/networking/get-started-overlay/)
* [Embedded DNS server in user-defined networks](https://docs.docker.com/engine/userguide/networking/configure-dns/)

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
