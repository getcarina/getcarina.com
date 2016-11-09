---
title: 'Docker best practices: image repository'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-12
permalink: docs/best-practices/docker-best-practices-image-repository/
description: Explore reusable container images
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

You can create your containers from publicly available images saved by the
community or from custom images that you saved privately for your own reuse.

### Community images

One of the main advantages of using Docker containers is that
the community has created
a variety of Docker container images that you can use for your own purposes.
Many of the images created
by users have been uploaded to the
[Docker Hub Registry](https://registry.hub.docker.com/), which allows everyone to examine and use
those images.

Anyone who has a Docker Hub account can retrieve an image from the Docker Hub Registry.
To retrieve an image, log in to Docker Hub and ask Docker for the image by providing the image's
<user/image_name> identifier.

For example, `docker pull cpuguy83/openvpn` asks for an image named `openvpn`
owned by a user named `cpuguy83`.

In addition to images contributed by individual community members,
the Docker Hub Registry has official images from software providers, including
companies that provide operating systems.
Providers of official images in the Docker Hub Registry include Ubuntu,
MySQL, Golang, and many others. You can pull official images with shortened calls that are consistent with the name of the images' providers.

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
the Docker Hub Registry, create a Docker account,
log in to that account using `docker login`, and then issue
`docker push <user/image_name>`.

You can also tag your image if you wish to give it a label
to distinguish among several flavors. Careful use of tags makes it possible to identify an image based on its purpose or status, such as `dev`, `v2`, or `production`.

For example, `docker tag openvpn dev` applies a `dev` tag to an image named `openvpn`. If you use `docker push openvpn` to push that image to the repository without specifying any tags, all the image's tags are preserved in the the repository. If multiple tags have been applied to an image but you only want one tag pushed with it to the repository, you can accomplish that by specifying the tag. For example, `docker push openvpn:dev` adds the `openvpn` image, tagged only as `dev`, to the repository; any other tags you may have applied are not preserved in the repository.

The default behavior for `docker push` is to push to the central
Docker Hub Registry; alternatively, you can push your image to your own private
Docker registry. After your image is running, log in to your private registry rather than the central registry with `docker login http(s)://<YOUR_DOMAIN>:<PORT>`.

### Resources

Numbered citations in this article:

1. <http://www.activestate.com/blog/2014/01/deploying-your-own-private-docker-registry>

Other recommended reading:

- [Rackspace Cloud Images](https://developer.rackspace.com/docs/user-guides/infrastructure/cloud-config/compute/cloud-images-product-concepts/image-properties/)

- [Rackspace Cloud Servers](https://developer.rackspace.com/docs/user-guides/infrastructure/cloud-config/compute/cloud-servers-product-concepts/#cloud-servers-product-concepts)

- [Docker Hub Registry](https://registry.hub.docker.com/)

- [CoreOS’ Quay.io](https://quay.io/)

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping OpenStack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner RightScale; aided in the assessment, development, and evolution of Rackspace Private Cloud; and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
