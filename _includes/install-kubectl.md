### Install the Kubernetes client

1. Install the Kubernetes client (kubectl).

    On Mac OS X with Homebrew, run the following commands:

    ```bash
    $ brew update
    $ brew install kubectl
    ```

    On Mac OS X without Homebrew, run the following commands:

    ```bash
    $ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/darwin/amd64/kubectl
    $ chmod u+x kubectl
    $ mv kubectl ~/bin/kubectl
    ```

    On Linux, run the following commands:

    ```bash
    $ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/linux/amd64/kubectl
    $ chmod u+x kubectl
    $ mv kubectl ~/bin/kubectl
    ```

    On Windows PowerShell, run the following command, and then move `kubectl.exe` to a directory on your `%PATH%`.

    ```powershell
    > (New-Object System.Net.WebClient).DownloadFile("https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/windows/amd64/kubectl.exe", "$pwd\kubectl.exe")
    > mkdir  ~\.kube
    ```

1. Configure `kubectl`.

    On Mac OS X and Linux, run the following commands:

    ```bash
    $ cd Downloads/mycluster
    $ source kubectl.env
    ```

    On Windows PowerShell, run the following commands:

    ```
    > cd Downloads\mycluster
    > Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    > .\kubectl.ps1
    ```

1. Connect to your cluster and display information about it.

    ```bash
    $ kubectl cluster-info
    Kubernetes master is running at https://172.99.125.8
    KubeDNS is running at https://172.99.125.8/api/v1/proxy/namespaces/kube-system/services/kube-dns

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
    ```
