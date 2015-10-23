---
title: Load a Docker environment from the command line on Mac OS X
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-30
permalink: docs/tutorials/load-docker-environment-on-mac/
description: Learn how to load a Docker environment on Mac OS X, so that you can work with Docker from the command line
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
---

**Note:** This tutorial is for Mac OS X users. If you are using another operating system, follow
[the tutorial for Linux]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-linux/) or
[the tutorial for Windows]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-windows/) instead.

This tutorial describes how to load a Docker environment on Mac OS X.

### <a name="prerequisites"></a> Prerequisite

[Docker Toolbox](https://www.docker.com/toolbox)

#### <a name="load"></a> Load the Docker environment
1. Open a command terminal.
2. Load your Docker host environment variables by using one of the following methods:
  * If you are using Carina, [download your credentials][get-cluster-creds].
    Then, run `source docker.env`.
  * Otherwise, run `eval $(docker-machine env default --shell bash)`,
    replacing `default` with the name of your Docker host.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[get-cluster-creds]: {{site.baseurl}}/docs/references/carina-credentials/

### <a name="references"></a> References
* [Install Docker on Mac OS X]({{ site.baseurl }}/docs/tutorials/install-docker-with-mac-os-x/)
* [Docker 101]({{ site.baseurl }}/docs/tutorials/docker-101/)
