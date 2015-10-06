---
title: Load a Docker environment from the command-line on Linux
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-30
permalink: docs/tutorials/load-docker-environment-on-linux/
description: Learn to load a Rackspace Container Service Docker environment on Linux, so that you can work with your Docker cluster from the command-line
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
---

**Note:** This tutorial is for Linux users. If you are using another operating system, follow
[the tutorial for Mac OS X]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-mac/) or
[the tutorial for Windows]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-windows/) instead.

This tutorial describes how to load a Docker environment on Linux.

### <a name="prerequisites"></a> Prerequisites

[Docker](https://docs.docker.com/installation/ubuntulinux/)

#### <a name="steps"></a> Steps
To load a Docker environment, perform the following steps:

1. Open a command terminal.
2. Load your Docker host environment variables by using one of the following methods:
  * If you are using the Rackspace Container Service, follow the instructions on [Working with Your Cluster Credentials][get-cluster-creds]
    to download your credentials. Then, run `source docker.env`.
  * Otherwise, no additional setup is required.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[get-cluster-creds]: {{site.baseurl}}/docs/references/rcs-credentials/

### <a name="references"></a> References
* [Install Docker on Linux]({{ site.baseurl }}/docs/tutorials/docker-install-linux/)
* [Docker 101]({{ site.baseurl }}/docs/tutorials/docker-101/)
