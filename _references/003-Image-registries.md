---
title: Image Registries
seo:
  description: Docker Hub and other public registries
---

The Registry is an open-source service application that stores and distributes Docker images. A user can run their own registry or use one of the publicly available registries.

To use a specific registry, use

```
docker login {registy address, such as index.docker.io}
```

Once you have invoked `docker login`, all of your `docker push` and `docker pull` commands will be associated with that registry. For more information about how to use Docker images, read the [Find and download a Docker image](/docs/tutorial/run-docker-image.md) tutorial.

Registries
--- 

### Docker Hub

![Docker Hub Images]({% asset_path 003-Image-registries/DockerHub.png %})

The [Docker Hub](https://hub.docker.com/) provides a public, Docker-run registry. It contains official repositories for multiple Linux distributions (such as CentOS or Ubuntu) and applications (such as MySQL, Wordpress, and many more). Official repositories are supported through the [official images](https://github.com/docker-library/official-images) Github repo. Security and maintenance practices are well documented and the community is large and transparent.

The Docker Hub supports both private and public repositories, so users can run and manage their own repositories.

### Artifactory

JFrog Artifactory is an open-source Maven repository manager that supports the Docker Registry API. It is also available as a hosted service for private repositories.

Architecturally, each Docker registry would be supported as a separate artifactory repository. Artifactory will also work as a proxy and caching system for other remote repositories, so that control over build infrastructure can be maintained in a single location.

### Quay.io

Like Docker Hub, Quay.io offers free hosting for public repositories and a paid service for private ones. However, the service is more suited for hosting private repositories, rather than sharing public images.

Build automation and team level access permissions are supported, as well as multiple integration options to enable better CI and deployment.

### Google Container Registry

Google offers a hosted registry service. It comes with a lot of quirks, such as its own client and custom key-based authentication.

Images
---

A number of organizations offer custom docker images that serve specific purposes, such as high-security or easy, opinionated application deployment.

### Bitnami

[Bitnami](https://hub.docker.com/r/bitnami/) focuses on ease-of-use for many popular docker application images. These images are available under the bitnami repository on Docker Hub.

### Tutum

[Tutum](https://hub.docker.com/u/tutum) manages a set of already configured public images on Docker Hub optimized for Tutum. The more popular images are devops related.

### Google

[Google](https://hub.docker.com/u/google) offers popular language environment and linux distro images on Docker Hub.

### Gentoo

[Gentoo](https://hub.docker.com/u/gentoo/) offers a set of hardened Gentoo images.