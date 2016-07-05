---
title: Release notes
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-17
permalink: docs/reference/release-notes/
description: Notes on Carina releases
topics:
  - docker
---
### July 5, 2016

#### What's new

* [Docker Swarm 1.2.3](https://github.com/docker/swarm/releases/tag/v1.2.3)

### June 17, 2016

#### What's new

* [Docker Engine 1.11.2](https://github.com/docker/docker/releases/tag/v1.11.2)
* This release fixes [Docker bug #22486](https://github.com/docker/docker/issues/22486). Containers should restart properly if `restart=always` is set.

### May 23, 2016

#### What's new

* [Docker Engine 1.11.1](https://github.com/docker/docker/releases/tag/v1.11.1)
* More improvements to error messages related to security restrictions. See [Carina Error Codes](https://getcarina.com/docs/reference/error-codes/) for more info.

### May 5, 2016

#### What's new

* Improved error messages related to security restrictions. See [Carina Error Codes](https://getcarina.com/docs/reference/error-codes/) for more info.

### May 3, 2016

#### What's new

* [Docker Swarm v1.2.0](https://github.com/docker/swarm/releases/tag/v1.2.0)

### April 21, 2016

#### What's new

* Patched [EOF bug](https://github.com/getcarina/feedback/issues/65) in Docker Engine 1.10.3 
* Miscellaneous bug fixes

### April 5, 2016

#### What's new

* [Docker Engine 1.10.3](https://github.com/docker/docker/releases/tag/v1.10.3)
* [Docker Swarm v1.1.3](https://github.com/docker/swarm/releases/tag/v1.1.3)

### March 10, 2016

#### What's new

* [Docker Engine 1.10.2](https://github.com/docker/docker/releases/tag/v1.10.2)

### February 15, 2016

#### What's new

* [Docker Engine 1.10.1](https://github.com/docker/docker/releases/tag/v1.10.1)
* [Docker Swarm v1.1.0](https://github.com/docker/swarm/releases/tag/v1.1.0)
* Docker's [overlay network driver](https://docs.docker.com/engine/userguide/networking/dockernetworks/#an-overlay-network) support.
* Local Swarm discovery instead of public discovery

### November 25, 2015

#### What’s new

* [Docker Engine 1.9.1](https://github.com/docker/docker/releases/tag/v1.9.1)

### November 23, 2015

#### What’s new

* Enable bind mounting `/var/run/docker.sock` from host to container. e.g.

```
docker run -v /var/run/docker.sock:/var/run/docker.sock docker:1.9.0 docker ps
```

### November 13, 2015

#### What’s new

* [Docker Engine 1.9.0](https://github.com/docker/docker/releases/tag/v1.9.0)
* [Docker Swarm 1.0.0](https://github.com/docker/swarm/releases/tag/v1.0.0)
* 2 Factor Authentication

#### Known issues

* Overlay networking unsupported at this time
* Volume drivers unsupported at this time

### October 27, 2015

#### What’s new

* Hello World
* [Docker Engine 1.8.3](https://github.com/docker/docker/releases/tag/v1.8.3)
* [Docker Swarm 0.4.0](https://github.com/docker/swarm/releases/tag/v0.4.0)
