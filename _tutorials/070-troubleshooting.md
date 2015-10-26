---
title: Troubleshooting common problems
author: Everett Toews <everett.toews@rackspace.com>
date: 2015-10-26
permalink: docs/tutorials/troubleshooting/
description: Troubleshooting common problems on Carina
docker-versions:
  - 1.8.3
topics:
  - troubleshooting
---

### Is your docker daemon up and running?

If your environment isn't configured properly, you may get the following error when attempting to run any `docker` command.

```
Get http:///var/run/docker.sock/v1.20/info: dial unix /var/run/docker.sock: no such file or directory.
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

To resolve this error, make sure you have gone through each step of [Connect to your cluster](/docs/tutorials/create-connect-cluster#connect-to-your-cluster).
