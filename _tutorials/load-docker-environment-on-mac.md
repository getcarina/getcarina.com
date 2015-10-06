---
title: Load a Docker environment from the command-line on Mac OS X
permalink: docs/tutorials/load-docker-environment-on-mac/
topics:
  - docker
  - beginner
---

**Note:** This tutorial is for Mac OS X users. If you are using another operating system, follow
[the tutorial for Linux]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-linux/) or
[the tutorial for Windows]({{ site.baseurl }}/docs/tutorials/load-docker-environment-on-windows/) instead.

This tutorial describes how to load a Docker environment on Mac OS X.

### <a name="prerequisites"></a> Prerequisites

[Docker Toolbox](https://www.docker.com/toolbox)

#### <a name="steps"></a> Steps
To load a Docker environment, perform the following steps:

1. Open a command terminal.
2. Load your Docker host environment variables by using one of the following methods:
  * If you are using the Rackspace Container Service, follow the instructions on [Working with Your Cluster Credentials][get-cluster-creds]
    to download your credentials. Then, run `source docker.env`.
  * Otherwise, run `eval $(docker-machine env default --shell bash)`,
    replacing `default` with the name of your Docker host.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[get-cluster-creds]: /docs/references/rcs-credentials/

### <a name="references"></a> References
* [Install Docker on Mac OS X]({{ site.baseurl }}/docs/tutorials/install-docker-with-mac-os-x/)
* [Docker 101]({{ site.baseurl }}/docs/tutorials/docker-101/)
