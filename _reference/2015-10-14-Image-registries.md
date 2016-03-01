---
title: Image registries
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2015-10-14
permalink: docs/reference/image-registries/
description: Learn about Docker Hub and other public registries that house Docker images
topics:
 - docker

---

A *registry* is an open-source service application that stores and distributes Docker images. You
can run your own registry or use one of the publicly available registries.

To use a specific registry, run the following command:

```
docker login {registry address, such as index.docker.io}
```


After you invoke `docker login`, all of your `docker push` and `docker pull` commands are associated with that registry. For more information about how to use Docker images, read the [Find and download a Docker image]({{ site.baseurl }}/docs/tutorials/run-docker-image/) tutorial.

Registries
---

Multiple Docker registries are available online. Following are some of the more popular ones.

### Docker Hub

[Docker Hub](https://hub.docker.com/) is the public registry provided by Docker. It contains official repositories for multiple Linux distributions (such as CentOS and Ubuntu) and applications (such as MySQL, WordPress, and many more). Official repositories are supported through the [official images](https://github.com/docker-library/official-images)  repo.

![Docker Hub Images]({% asset_path 003-Image-registries/DockerHub.png %})

The Docker Hub supports both private and public repositories, so users can run and manage their own repositories.

### Artifactory

JFrog Artifactory is an open-source Maven repository manager that supports the Docker Registry API. It is also available as a hosted service for private repositories.

Architecturally, each Docker registry would be supported as a separate Artifactory repository. Artifactory also works as a proxy and caching system for other remote repositories, so that control over build infrastructure can be maintained in a single location.

### Quay.io

Like Docker Hub, Quay.io offers free hosting for public repositories and a paid service for private ones. However, the service is more suited for hosting private repositories rather than sharing public images.

Build automation and team-level access permissions are supported, as well as multiple integration options to enable better continuous integration (CI) and deployment.

### Google Container Registry

Google offers a hosted private registry service. It has some uncommon features for a registry and is not fully compatible with Docker tools. It has its own client and custom key-based authentication.

Images
---

A number of organizations offer custom Docker images that serve specific purposes, such as high-security or easy, opinionated application deployment.

### Bitnami

[Bitnami](https://hub.docker.com/r/bitnami/) focuses on ease-of-use for many popular Docker application images. These images are available under the **bitnami** repository on Docker Hub.

### Tutum

[Tutum](https://hub.docker.com/u/tutum) manages a set of already configured public images on Docker Hub that are optimized for Tutum. The more popular images are DevOps related.

### Google

[Google](https://hub.docker.com/u/google) offers popular language environment and Linux distribution images on Docker Hub.

### Gentoo

[Gentoo](https://hub.docker.com/u/gentoo/) offers a set of hardened Gentoo images.
