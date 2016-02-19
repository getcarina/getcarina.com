---
title: "Weekly news - Overlay Networks, Consul, and You!"
date: 2016-02-19 11:00
comments: true
author: Anne Gentle <anne.gentle@rackspace.com>
published: true
excerpt: >
  All the news from this week: Overlay networks offered in a pair of new releases, more
  what's new, and we want to work with you.
categories:
 - Docker
 - Affinity
 - Carina
 - News
 - Jobs
authorIsRacker: true
---

Turning clouds upside down, and connecting them ever so cleverly. It's another
weekly update from Carina-land! We now can offer overlay networks with discovery
enabled with a Consul container running on your cluster. This week's releases of
Docker and Docker Swarm give Carina even more punch. Let's get to it.

<div class="clearfix"></div>

## Overlay Networks and Consul key-value store
Once you see the cloud upside down, you can't unsee it. It's like the arrow in the
FedEx logo. In our [in-depth look at overlay networks]({{ site.baseurl }}/blog/overlay-networks/),
the cloud diagram shows how a key-value store informs all the Docker hosts about the
networks, endpoints, IP address, and DNS. Go read how you can network a couple of
containers and be selective about which ports to expose publicly.

<img class="right" src="{% asset_path weekly-news/upsidedownowl.jpg %}" alt="upsidedown"/>

<div class="clearfix"></div>

## New releases of Docker and Docker Swarm

Docker 1.10 incorporates many changes including storage for images and layers that requires
a migration on your images the first time Docker is run. So be ready for that if you have
a lot of stored images. There is a [migration engine](https://hub.docker.com/r/docker/v1.10-migrator/).

There's also a [new compose file format](https://docs.docker.com/compose/compose-file/)
that lets you describe your app in a single file, and you can define and describe
relationships between services, networks, and volumes. You can also specify what IP
address a container should use when joining a network. Also, rather than using hosts
files, you can use a [DNS server](https://docs.docker.com/engine/userguide/networking/dockernetworks/#docker-embedded-dns-server)
for domain name resolution.

For Docker Swarm, version 1.1 has experimental rescheduling of containers when a node fails,
but it's definitely experimental so we haven't configured it yet on Carina. We'll keep
you posted on that feature. We are happy we can now see errors from nodes that fail to join
the cluster. And if you want to play around with private registries and authentication,
take a look at the [Swarm API docs](https://docs.docker.com/swarm/swarm-api/#registry-authentication).

[Docker version manager](https://getcarina.com/docs/tutorials/docker-version-manager/)
makes it so much easier to manage what versions you're running locally and switch between
them as needed. This is a good week to install it!

<div class="clearfix"></div>

## Work with us on containers

We want to work with you and are hiring a senior engineer and a senior developer. Check out
the job descriptions for our [current openings](https://github.com/getcarina/carina-jobs)
and see if you want to turn the cloud upside down too.
