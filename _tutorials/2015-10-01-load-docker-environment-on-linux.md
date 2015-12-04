---
title: Load a Docker environment from the command line on Linux
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-10-01
permalink: docs/tutorials/load-docker-environment-on-linux/
description: Learn how to load a Carina Docker environment on Linux, so that you can work with your Docker cluster from the command line
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

### Prerequisite

[Install Docker on Linux](/docs/tutorials/docker-install-linux/)

### Load the Docker environment

1. Open a command terminal.
2. If you are using Carina, [download your credentials][get-cluster-creds].
    Then, run `source docker.env`.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[get-cluster-creds]: {{site.baseurl}}/docs/references/carina-credentials/

### References
[Docker 101]({{ site.baseurl }}/docs/tutorials/docker-101/)
