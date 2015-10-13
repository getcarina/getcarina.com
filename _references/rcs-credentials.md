---
title: Download Rackspace Container Service credentials
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-28
permalink: docs/references/rcs-credentials/
description: Learn how to use your Rackspace Container Service credentials to get started with containers today
featured: true
topics:
  - rcs
  - beginner
---

Rackspace Container Service clusters are secured with TLS certificates. Each cluster
has its own set of credentials, which are provided as a zip file that you can download from the control panel.
The credentials zip file contains the following files:

* ca.pem - Certificate Authority, used by clients to validate servers
* cert.pem - Client Certificate, used by clients to identify themselves to servers
* key.pem - Client Private Key, used by clients to encrypt their requests
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates
* docker.env - Shell environment configuration script

**Note:** The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

This article provides instructions for downloading the credentials zip file and
using the credentials to authenticate to your cluster.

### <a name="download"></a> Download credentials

1. Log in to the control panel at http://mycluster.rackspacecloud.com.

2. Click the gear icon next to your cluster name and select **Download Credentials**.

    ![Cluster Context Menu > Download Credentials]({% asset_path rcs-credentials/download-credentials.png %})

3. When prompted, click **Download File**.

    ![Confirm Download File]({% asset_path rcs-credentials/confirm-download-file.png %})

    Your cluster credentials are now saved to **clusterName.zip**, where _clusterName_ is the name of your cluster.

4. Unzip the file.

    By default, the files are unzipped into a unique directory, for example, **70a73a74-140b-4c37-bb06-cc113c8a8713**.
    You might want to rename that directory to something easier to remember, such as the name of the cluster.

5. Open a command terminal and change to the credentials directory.

6. Load your credentials and use them to interact with your cluster:
  * (_Linux and Mac OSX users_) Run `source docker.env`.
  * (_Windows users_) See [Load Docker environment from the command line on Windows](/docs/tutorials/load-docker-environment-on-windows/).
