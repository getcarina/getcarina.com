---
title: Docker best practices: image repository
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/docker-best-practices-image-repository/
description: Docker best practices, powered by the Rackspace Container Service
docker-versions:
topics:
  - best-practices
  - planning
---

*Create containers consistently and rapidly from saved container images.*

Creating containers from saved container images enables you to
quickly create containers from a consistent starting point.
This is similar to the advantage that [Rackspace Cloud Images] (https://developer.rackspace.com/docs/user-guides/infrastructure/cloud-config/compute/cloud-images-product-concepts/image-properties/) provides when you
create [Rackspace Cloud Servers] (https://developer.rackspace.com/docs/user-guides/infrastructure/cloud-config/compute/cloud-servers-product-concepts/#cloud-servers-product-concepts): the setup process is predefined
and repeatable,
saving you from the potential delays and inconsistencies that are likely in
a manual, multi-step process.

You can create your containers from publicly-available images saved by the
community or from custom images that you saved privately for your own reuse.

### Community images

One of the main advantages of using Docker containers is that
the community has created
many Docker container images that you can use for your own purposes.
Many of the images created
by users have been uploaded to the [Docker Hub Registry]
(https://registry.hub.docker.com/) and this allows everyone to examine and use
them.

You can retrieve or pull an image by identifying the
<user/image_name> and passing it to Docker. For example, `docker pull
cpuguy83/openvpn` asks for an image named `openvpn`
owned by a user named `cpuguy83`.

In addition to images contributed by individual community members,
the Docker Hub Registry has official images from software providers, including
companies that provide operating systems.
Providers of official images in the Docker Hub Registry include Ubuntu,
MySQL, Golang, and many others.

You can pull official images with shortened calls.
For example, `docker pull mysql` asks for all official images
contributed by MySQL.

### Personal images

You can upload your own custom images to several repositories, including
the Docker Hub Registry,
[CoreOS’ Quay.io](https://quay.io/), or
your own private image registry available from a variety of providers [(1)](#resources).
Each image repository has its own method of
accepting contributions.
For example, to contribute an image to
the Docker Hub Registry,
log in using `docker login` and then issue
`docker push <user/image_name>`.
You can also tag the image if you wish to give it a label
such as "dev", "production", or "v2" to distinguish among several flavors
of your image.

The default behavior for `docker push` is to push to the central
Docker Hub Registry, but if you prefer your own private
Docker registry there is an image for that too. Once your image is running,
you can save it to your private registry simply by
logging into your private registry as opposed to the central one. That switch is as
easy as `docker login http(s)://<YOUR_DOMAIN>:<PORT>`.

<a name="resources"></a>
### Resources

Numbered citations in this article

1. <http://www.activestate.com/blog/2014/01/deploying-your-own-private-docker-registry>

Other recommended reading

- [Rackspace Cloud Images](https://developer.rackspace.com/docs/user-guides/infrastructure/cloud-config/compute/cloud-images-product-concepts/image-properties/)

- [Rackspace Cloud Servers](https://developer.rackspace.com/docs/user-guides/infrastructure/cloud-config/compute/cloud-servers-product-concepts/#cloud-servers-product-concepts)

- [Docker Hub Registry](https://registry.hub.docker.com/)

- [CoreOS’ Quay.io](https://quay.io/)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations and instructions, explore the *tutorials* collection.
* For detailed information about how to solve specific issues or work with specific architectures,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on Twitter: @mikemetral.
