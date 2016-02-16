---
title: "Overlay networks"
date: 2016-02-17 13:00
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  Carina has made a major release this week, the biggest release since we launched. This release adds overlay networking to Docker Swarm clusters in Carina. Overlay networks provide complete isolation for containers to communicate across all of the segments in your cluster. This adds a new layer of security to your application deployments and makes it much easier for your containers to communicate with one another. This release also includes upgrades to Docker 1.10.1 and Swarm 1.1.0, which both come with their own significant new features and bug fixes.
categories:
 - Docker
 - Swarm
 - Carina
authorIsRacker: true
---

{{ page.excerpt }}

## Overlay networks

<figure><img class="right" src="{% asset_path weekly-news/overlay-network.png %}" alt="Overlay network"/><figcaption><a href="https://docs.docker.com/engine/userguide/networking/dockernetworks/#an-overlay-network" target="_blank_">Image source: Docker Inc.</a></figcaption></figure>An overlay network provides isolation for containers to communicate across all of the segments in your Docker Swarm cluster on Carina. This adds a new layer of security to your application deployments and makes it much easier for your containers to communicate with one another. Among the many benefits are a few key features:

* a secured and isolated environment for the containers in a network
* automatic name resolution for containers using DNS
* dynamically connect and disconnect containers to multiple networks

Let's get a feel for how you can work with overlay networks on Carina. `docker network create` will create an overlay network by default. For this you'll need to `create and connect to a cluster` with at least 2 segments.

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

Let's run a small Wordpress site and network a couple of containers together by connecting them to the overlay network we just created by using the `--net=mynet` flag. We'll start with a MySQL instance for the database.

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

Our MySQL instance is now connected to `mynet` but it's not exposed publicly, which gives us an additional layer of security for our database.

Next we'll start a Wordpress instance but publish a port to expose it to the world.

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

Our Wordpress instance is now connected to `mynet` and it's exposed publicly, which is exactly what we want. It was easy to connect it to our MySQL instance by simply referring to the container hostname `mysql` in the `--env WORDPRESS_DB_HOST=mysql` flag. The hostname `mysql` is resolved using an DNS server embedded in the Docker Engine to provide automatic service discovery for containers connected to the overlay network, see [Docker embedded DNS server](https://docs.docker.com/engine/userguide/networking/dockernetworks/#docker-embedded-dns-server).

**Note**: No need to use `--env="constraint:node==*n1"` in your deployments! I only use it here to ensure the containers are running on separate segments to illustrate overlay networking across segments in your cluster.

Copy the IP address from the output of the last command into the location bar in your favourite browser. Now go ahead and start blogging in Esperanto like you've always wanted to.

TODO:

* links to Docker networking resources
* mention let's nginx
* consul
* links are legacy

## Docker upgrades

TODO

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
