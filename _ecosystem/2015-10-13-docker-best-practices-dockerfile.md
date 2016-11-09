---
title: 'Docker best practices: Dockerfile'
author: Mike Metral <mike.metral@rackspace.com>
date: 2015-10-13
permalink: docs/best-practices/docker-best-practices-dockerfile/
description: Explore methods of creating and customizing container images
docker-versions:
topics:
  - best-practices
  - planning
---

*Create and customize your container images with a Dockerfile.*

You can save a customized Docker image in either of two ways:

- Use a Dockerfile.

- Create a container from an image,
  update the container,
  and commit the changes to an image.

The specifics of your application and its dependencies will determine which of these methods you must use. However, if both options are available to you,
consider using a Dockerfile.

### Build image from Dockerfile

Using a Dockerfile is the preferred method of creating and customizing your
container images because Dockerfile enables you to use
the `docker build` command to
build images from scratch. In a Dockerfile, you can prescribe the base
operating system for the container. You can also add the instructions you want to
execute inside the image, such as installing packages and setting and
configuring options.

Following is an example of a simple Dockerfile:

```
# This is a comment
FROM ubuntu:14.04
MAINTAINER Kate Smith ksmith@example.com
RUN apt-get update && apt-get install -y ruby ruby-dev
RUN gem install sinatra
```

An image provides the foundation layer for a container.
Based on the instructions in your Dockerfile,
new tools, applications, content, and patches form additional layers
on the foundation [(1)](#resources).

An image cannot have more than 127 layers regardless of the
storage driver. This limitation is set globally to encourage
optimization of the overall size of images [(2)](#resources).

Most newcomers to containers choose to provide their containers with
the base operating system that they are most accustomed to working with
in non-container-based configurations. For example, Ubuntu, CentOS, and Fedora
are common choices.

However, most of the interaction with the container's
operating system revolves around the filesystem layout and its binaries.
For example,
if you chose Ubuntu as your base operating system and you aren’t doing anything
unusual in terms of the operating system itself, then you could potentially
switch to the Debian without worrying about a lack of familiarity with the operating system. In this scenario, the Debian image most likely has everything that you would need from the Ubuntu image, but
saves you at least 100MB in size.

You must investigate this on a case-by-case basis,
but if you are utilizing a full-size operating system such as Linux
when a stripped-down operating system such as BusyBox could suffice,
then you are not only consuming more space than needed, you are also adding
time to Docker builds and image repository interactions.

### Update and commit image

The update-and-commit method requires that you begin with a previously created
Docker image that you have retrieved from a container
image registry such as Docker Hub.
Image registries can be public or private and are available from several providers.
You can read more about image registries at
[Docker best practices: image repository](../docker-best-practices-image-repository/).

After you retrieve a container,
you must instantiate the container on your host that is running the Docker daemon,
preferably with an activated TTY. Once you
have access to the container, you can make any changes required to
personalize it. After you make those changes, you exit the container and
save a copy of the container to your local or
remote registry with `docker commit`.

Using the update-and-commit methodology is the simplest way of
extending an image, but the updated image is not easy to maintain or share.

### Recommendations

Following is a collection of recommendations and tips
for using Dockerfile.
Keep these tips in mind so that you can ultimately improve
creation and utilization of Dockerfiles to build your container images.

- Maintain a .dockerignore file to exclude directories and/or files from
  the build process.

- Keep the number of instructions and layers to a minimum as this
  ultimately affects build performance and time.

- Consolidate similar instructions into a single layer.
  For example, in the sample snippet of a simple Dockerfile,
  `gem install sinatra` could be included in the line preceding it.

- Take advantage of cacheing.

  - During the process of building an image, Docker steps
    through the instructions in your Dockerfile, executing each instruction in
    the order specified. As each instruction is examined, Docker looks
    for an existing image in its cache that it can reuse, rather
    than creating a new (duplicate) image.

  - In the case of ADD and COPY instructions, the contents of
    the file(s) being put into the image are examined.
    Specifically, a checksum is created for the file(s) and then that
    checksum is used during the cache lookup. If anything, including metadata, has
    changed in the file(s), then the cache
    is invalidated and a fresh copy of the file must be obtained.

  - Aside from the ADD and COPY commands, cache checking does not
    look at the files in the container to determine a cache match.
    For example, when processing a `RUN apt-get -y` update
    command, the files updated in the container are not
    examined to determine whether a cache hit exists. In that case, only
    the command string itself is used to find a match [(3)](#resources).

- Build every time. Building is very fast because Docker re-uses
  previously cached build steps whenever possible.
  By building every time, you can use containers as reliable artifacts.
  For example,
  you can go back and run a container from four changes ago to inspect a
  problem, or you can run long tests on a version while editing the code.

- When testing an edit to your codebase, write a simple Dockerfile
  describing your build process and then
  build a new container from that source with `docker build`.
  Such a Dockerfile is usually short, probably between five and ten lines long.

- For a development environment, map your source code on the host to
  a container using a volume. This enables you to use your editor of
  choice on the host and test right away in the container.
  This is done by mounting the current folder as a volume
  rather than using the ADD command in the Dockerfile.

- Know the differences Between CMD and ENTRYPOINT.
  The CMD and ENTRYPOINT instructions are similar in that they both specify
  commands that run in an image, but there is an important
  difference: CMD simply sets a command to run in the image if
  no arguments are passed to `docker run`, while ENTRYPOINT is
  meant to make your image behave like a binary. The rules are
  essentially:

  - If your Dockerfile uses only CMD, the specified command is executed
    if no arguments are passed to `docker run`.

  - If your Dockerfile uses only ENTRYPOINT, the arguments passed to
    `docker run` are always passed to the entrypoint; the entrypoint
    is executed if no arguments are passed to `docker run`.

  - If your Dockerfile declares both ENTRYPOINT and CMD
    and no arguments are passed to `docker run`, then the argument(s)
    to CMD are passed to the declared entrypoint.

  - Be careful with using ENTRYPOINT; it can make it more difficult to
    get a shell inside your image. While this may not be an issue if your
    image is designed to be used as a single command, it can frustrate or
    confuse users that expect to be able to use the idiom [(4)](#resources).

Expressing exactly what you want is key
to ensuring that users of your image have the right experience.

### Resources

Numbered citations in this article:

1. <http://www.projectatomic.io/docs/docker-building-images/>

2. <https://docs.docker.com/userguide/dockerimages/>

3. <https://docs.docker.com/articles/dockerfile_best-practices/#build-cache>

4. <http://www.projectatomic.io/docs/docker-image-author-guidance/>

Other recommended reading:

- [Docker best practices: image repository](../docker-best-practices-image-repository/)

- <http://www.busybox.net/about.html>

The purpose of this article is to help you understand Carina by introducing you
to the ecosystem of container-related tools.
To begin learning about Carina itself, see
[Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
To begin using Carina, see
[Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).

### About the author

Mike Metral is a Product Architect at Rackspace. He works in the Private Cloud Product organization and is tasked with performing bleeding edge R&D and providing market analysis, design, and strategic advice in the container ecosystem. Mike joined Rackspace in 2012 as a Solutions Architect with the intent of helping Openstack become the open standard for cloud management. At Rackspace, Mike has led the integration effort with strategic partner Rightscale, aided in the assessment, development, and evolution of Rackspace Private Cloud, and served as the Chief Architect of the Service Provider Program. Prior to joining Rackspace, Mike held senior technical roles at Sandia National Laboratories, a subsidiary of Lockheed Martin, performing research and development in cybersecurity with regard to distributed systems, cloud, and mobile computing. Follow Mike on [Twitter](https://twitter.com/mikemetral).
