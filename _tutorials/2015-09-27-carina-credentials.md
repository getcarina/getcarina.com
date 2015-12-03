---
title: Download Carina credentials
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-27
permalink: docs/references/carina-credentials/
description: Learn how to use your Carina credentials to get started with containers
featured: true
topics:
  - carina
  - beginner
---

Carina clusters are secured with Transport Layer Security (TLS) certificates. Each cluster has its own set of credentials, which are provided as a zip file that you can download from the Carina Control Panel. The credentials zip file contains the following files:

* ca.pem - Certificate Authority, used by clients to validate servers
* cert.pem - Client Certificate, used by clients to identify themselves to servers
* key.pem - Client Private Key, used by clients to encrypt their requests
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates
* docker.env - Bash environment configuration script
* docker.ps1 - PowerShell environment configuration script
* docker.cmd - CMD shell environment configuration script

**Note:** The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

This article provides instructions for downloading the credentials zip file and using the credentials to authenticate to your cluster.

### Download credentials

1. Log in to the [Carina Control Panel](https://app.getcarina.com/app/login).

2. Click the **Get Access** button associated with your cluster and then click **Download File**.

    Your cluster credentials are now saved to **clusterName.zip**, where _clusterName_ is the name of your cluster.

4. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

5. Open a command terminal and change to the credentials directory.

6. Load your credentials and use them to interact with your cluster:
  * _(Linux and Mac OS X users)_ Run `source docker.env`.
  * _(Windows users)_ See [Load Docker environment from the command line on Windows]({{site.baseurl}}/docs/tutorials/load-docker-environment-on-windows/).

7. If you have the [Docker Version Manager (dvm)][dvm] installed, run `dvm use` to switch your
  Docker client to the appropriate version for your cluster.

[dvm]: {{site.baseurl}}/docs/tutorials/docker-version-manager/
