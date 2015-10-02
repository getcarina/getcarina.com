---
title: Docker best practices: Dockerfile
permalink: docs/_best-practices/docker-best-practices-dockerfile/
description: Docker best practices, powered by the Rackspace Container Service
author: Mike Metral
date: 2015-10-01
topics:
  - best-practices
  - planning
---

*Create and customize your container images with a Dockerfile.*

You can save a customized Docker image in either of two ways:

-   Use a Dockerfile.

-   Create a container from an image, update the container,
    and commit the changes to an image.

Specifics of your application and its dependencies can determine which
of these methods you must use. If both options are available to you,
consider using a Dockerfile.

## Dockerfile

Using a Dockerfile is the preferred method of creating and customizing your
container images, as Dockerfile enables you to use
the `docker build` command to
build images from scratch. In a Dockerfile, you can prescribe the base
operating system for the container. You can add the instructions you want to
execute inside the image, such as installing packages and setting and
configuring options.

Here is a snippet of a simple Dockerfile:

    # This is a comment
    FROM ubuntu:14.04
    MAINTAINER Kate Smith ksmith@example.com
    RUN apt-get update && apt-get install -y ruby ruby-dev
    RUN gem install sinatra

Each instruction creates a new layer of the image. At the time of this
report, an image cannot have more than 127 layers regardless of the
storage driver. This limitation is set globally to encourage
optimization of the overall size of images [(1)](#resources).

Most newcomers to containers choose to provide their containers with
the base operating system that they are most accustomed to working with
in non-container-based configurations. For example, Ubuntu, CentOS, and Fedora
are common choices.

However, it becomes evident that most of the interaction with the container's
operating system revolves around the filesystem layout and its binaries.
For example,
if you chose Ubuntu as your base operating system and you aren’t doing anything
extravagant in terms of the operating system itself, then you could potentially
switch to the Debian image as it will most likely have everything you need and
can save you at least 100MB in size. You must investigate this on a per case basis,
but if you are utilizing a bloated operating system base when BusyBox could suffice,
then you are not only consuming more space than needed, you are also adding
time to Docker builds and image repository interactions.

## Update and commit

The update-and-commit method requires that you begin with a previously created
Docker image that you have retrieved from a container
image registry. Image registries can be public or private;
you can read more about image registries at
[Docker best practices: image repository](/docker-best-practices-image-repository/).

After you retrieve a container, you must
instantiate the container on your host
running the Docker daemon, preferably with an activated TTY. Once you
have access to the container, you can make any changes required to
personalize it. After you make those changes, you exit the container and
save a copy of the container to your local or
remote registry with `docker commit`.

Using the update-and-commit methodology is the simplest way of
extending an image, but the updated image is not easy to maintain or share.

## Recommendations

The following is a collection of unordered recommendations and tips
that don’t get enough upfront attention when starting off with Dockerfile.
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
    the command string itself is used to find a match [(2)](#resources).

- Build every time. Building is very fast because Docker re-uses
  previously-cached build steps whenever possible.
  By building every time, you can use containers as reliable artifacts.
  For example,
  you can go back and run a container from four changes ago to inspect a
  problem, or you can run long tests on a version while editing the code.

- When testing an edit to your codebase, write a simple Dockerfile
  describing your build process, then
  build a new container from that source with `docker build`.
  Such a Dockerfile is usually short, probably between five and ten lines long.

- For a development environment, map your source code on the host to
  a container using a volume. This enables you to use your editor of
  choice on the host and test right away in the container.
  This is done by mounting the current folder as a volume
  rather than using the ADD command in the Dockerfile.

- Know the differences Between CMD and ENTRYPOINT.
  Expressing exactly what you want is key
  to ensuring that users of your image have the right experience.
  The CMD and ENTRYPOINT nstructions are similar in that they both specify
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
    confuse users that expect to be able to use the idiom [(3)](#resources).

<a name="resources"></a>
## Resources

*Numbered citations in this article*

1. <https://docs.docker.com/userguide/dockerimages/>

2. <https://docs.docker.com/articles/dockerfile_best-practices/#build-cache>

3. <http://www.projectatomic.io/docs/docker-image-author-guidance/>

*Other recommended reading*

- [Docker best practices: image repository](/docker-best-practices-image-repository/)

In addition to *best-practices* articles such as this one,
Rackspace Container Service documentation includes *tutorials* and *references*:

* For step-by-step demonstrations, explore the *tutorials* collection.
* For detailed descriptions of reference architectures designed
  for specific use cases,
  explore the *references* collection.
* For discussions of key ideas, recommendations of useful methods and tools, and
  general good advice, explore the *best-practices* collection.

## About the author

Mike Metral is a Product Architect at Rackspace. You can follow him in GitHub at https://github.com/metral and at http://www.metralpolis.com/.
