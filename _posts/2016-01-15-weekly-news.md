---
title: "Weekly news"
date: 2016-01-15 13:00
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  In this week's roundup: Connecting to Rackspace data stores and Consul on Carina.
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

This week the team took some time to show you how to connect to Rackspace data stores to keep your data safe and secure. We also give you a taste of Consul on Carina.

## Connect a Carina container to a Rackspace cloud database

<img class="right" style="max-height: 50; width: auto;"  src="{% asset_path data-stores-mysql-prod/carina-and-cloud-databases.png %}" alt="Carina and Cloud Databases"/>Would you like to move your application to containers but are overwhelmed with the complexity of managing stateful services, like a mission-critical production database, in a container? With Carina, you can take advantage of containers without sacrificing the simplicity of Rackspace managed services. Carina containers are connected to the Rackspace ServiceNet network and can communicate directly with Rackspace Cloud Databases, Cloud Queues, and all other managed cloud services.

[Connect a Carina container to a Rackspace cloud database]({{ site.baseurl }}/docs/tutorials/data-stores-mysql-prod/)

## Store private Docker registry images on Rackspace Cloud Files

<img class="right" style="max-height: 50; width: auto;" src="{% asset_path registry-on-cloud-files/docker-registry-and-cloud-files.png %}" alt="Docker Registry and Cloud Files"/>A Docker registry is for storing and distributing Docker images. By default, you pull images from Docker's public registry Docker Hub. You can also push images to a repository on Docker's public registry, if you have a Docker Hub account. However, you might want to store your image in a _private_ Docker registry. This tutorial teaches you how to store private Docker registry images for Carina on Rackspace Cloud Files.

[Store private Docker registry images on Rackspace Cloud Files]({{ site.baseurl }}/docs/tutorials/registry-on-cloud-files/)

## Run Consul on Carina

[Consul](https://www.consul.io) is a tool for discovering and configuring services in your infrastructure. It provides several key features such as service discovery, health checking, and key/value store. Here are some instructions to try it out on Carina.

1. [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/).

1. Get the ServiceNet IP address of the node Consul will advertise on and the public IP address of the node.

    ```
    $ export CONSUL_SERVICENET_IP=$(docker run --rm --net=host racknet/ip service ipv4)
    $ export PUBLIC_IP=$(docker run --rm --net=host racknet/ip public ipv4)
    ```

1. Run Consul.

    ```
    $ docker run --detach \
      --name consul \
      --hostname node \
      --volume /data \
      --publish 8500:8500 \
      --publish 8600:53/udp \
      gliderlabs/consul-server:0.6 \
      -bootstrap-expect 1 -log-level debug -advertise $CONSUL_SERVICENET_IP
    6eeefc0d0a376876592a89adb7dc7d61b24edc8a00861c158658b6a74638b81f
    ```

1. Run a proxy to expose the Consul web application.

    Because Consul is only advertising on a ServiceNet IP, it's not accessible from the public internet. You need to run a proxy that will expose the Consul web application.

    ```
    $ docker run --detach \
      --name consul-proxy \
      --publish 80:80 \
      --env UPSTREAM=$CONSUL_SERVICENET_IP \
      --env UPSTREAM_PORT=8500 \
      carinamarina/nginx-proxy
    10fba2008738e63f7d51f931a82240786411eb6503112c7c12b791abf396db51
    ```

1. View the Consul web application.

    ```
    $ echo `docker run --rm --net=host racknet/ip public ipv4`
    172.99.65.58
    ```

    Open a web browser and go to the IP address returned by the command above. Click around to get a feel for some of things you can do with Consul.

    ![Consul]({% asset_path 2016-01-15-weekly-news/consul.png %})

1. Explore what you can do with Consul.

    You can search the web for what to do with Consul but I recommend taking a look at [Consul Template](https://www.hashicorp.com/blog/introducing-consul-template.html). Consul Template queries a Consul instance and updates any number of specified templates on the filesystem. This allows you to dynamically update your configuration files for Apache, Nginx, HAProxy, or any custom configuration file as services are added, removed, or updated in your system. We'll be writing more detailed tutorials on using Consul on Carina in the near future so stay tuned by [subscribing via RSS](https://getcarina.com/blog/atom.xml) or following [@Rackspace](https://twitter.com/rackspace).

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
