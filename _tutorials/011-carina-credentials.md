---
title: Download Carina credentials
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-28
permalink: docs/references/carina-credentials/
description: Learn how to use your Carina credentials to get started with containers today
featured: true
topics:
  - carina
  - beginner
---

Carina clusters are secured with TLS certificates. Each cluster
has its own set of credentials, which are provided as a zip file that you can download from the control panel.
The credentials zip file contains the following files:

* ca.pem - Certificate Authority, used by clients to validate servers
* cert.pem - Client Certificate, used by clients to identify themselves to servers
* key.pem - Client Private Key, used by clients to encrypt their requests
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates
* docker.env - Bash environment configuration script
* docker.ps1 - PowerShell environment configuration script
* docker.cmd - CMD shell environment configuration script

**Note:** The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

This article provides instructions for downloading the credentials zip file and
using the credentials to authenticate to your cluster.

### <a name="download"></a> Download credentials

1. Log in to the control panel at [http://mycluster.rackspacecloud.com](http://mycluster.rackspacecloud.com).

2. Click the gear icon next to your cluster name and select **Download Credentials**.

    ![Cluster Context Menu > Download Credentials]({% asset_path carina-credentials/download-credentials.png %})

3. When prompted, click **Download File**.

    ![Confirm Download File]({% asset_path carina-credentials/confirm-download-file.png %})

    Your cluster credentials are now saved to **clusterName.zip**, where _clusterName_ is the name of your cluster.

4. Unzip the file.

    The name of the directory that is created is the same as the name of the cluster. For example, `Downloads/mycluster`.

5. Open a command terminal and change to the credentials directory.

6. Load your credentials and use them to interact with your cluster:
  * (_Linux and Mac OSX users_) Run `source docker.env`.
  * (_Windows users_) See [Load Docker environment from the command line on Windows]({{site.baseurl}}/docs/tutorials/load-docker-environment-on-windows/).
