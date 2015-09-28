---
title: Rackspace Container Service credentials
permalink: /docs/references/rcs-credentials/
topics:
  - rcs
---

Rackspace Container Service clusters are secured with TLS certificates. Each cluster
has its own set of credentials that are provided as a zip file download from the control panel.
The credentials zip file contains the following files:

* ca.pem - Certificate Authority, used by clients to validate servers.
* cert.pem - Client Certificate, used by clients to identify themselves to servers.
* key.pem - Client Private Key, used by clients to encrypt their requests.
* ca-key.pem - Certificate Authority Key, private file used to generate more client certificates.
* docker.env - Shell environment configuration script.

**Note:** The credential files are _sensitive_ and should be safe-guarded. Do not check them into source control.

## <a name="steps"></a> Steps

1. Sign into the control panel.

2. Click the icon next to your cluster name and select **Download Credentials**.

    ![Cluster Context Menu &rarr; Download Credentials]({% asset_path rcs-credentials/download-credentials.png %})

3. When prompted, click **Download File**. Your cluster credentials are now saved to **clustername.zip**, where **clustername** is the name of your cluster.

    ![Confirm Download File]({% asset_path rcs-credentials/confirm-download-file.png %})

4. Unzip your credentials. By default the files are unzipped into a unique directory, for example **70a73a74-140b-4c37-bb06-cc113c8a8713**.
    You might want to rename that directory to something easier to remember, such as the name of the cluster.

5. If you are on Windows and use CMD or PowerShell, follow the instructions in the [Create Windows Scripts](#windows)
    section.

6. You can now load your credentials and use them to interact with your cluster:
  * Linux and Mac OSX users: Run `source docker.env`.
  * Windows users: See [Load Docker environment from the command line on Windows](/docs/tutorials/load-docker-environment-on-windows/).

## <a name="windows"></a> Create Windows Scripts
The cluster credentials zip file only includes a Bash script, **docker.env**,
that defines the environment variables necessary for authenticating to your cluster.
Follow the instructions below to create an equivalent script in CMD and PowerShell.

### <a name="cmd"></a> CMD

1. Open **docker.env** and note the ip address of your cluster. It is on the line defining the **DOCKER_HOST** variable.
2. Create a file named **docker.cmd** and populate it with the following content. Replace **{ip-address}** with the ip address of your cluster.

    ```batch
    set DOCKER_HOST=tcp://{ip-address}:2376
    set DOCKER_TLS_VERIFY=1
    set DOCKER_CERT_PATH=%~dp0
    ```

### <a name="powershell"></a> PowerShell

1. Open **docker.env** and note the ip address of your cluster. It is on the line defining the **DOCKER_HOST** variable.
2. Create a file named **docker.ps1** and populate it with the following content. Replace **{ip-address}** with the ip address of your cluster.

    ```powershell
    $env:DOCKER_HOST="tcp://{ip-address}:2376"
    $env:DOCKER_TLS_VERIFY=1
    $env:DOCKER_CERT_PATH=$PSScriptRoot
    ```
