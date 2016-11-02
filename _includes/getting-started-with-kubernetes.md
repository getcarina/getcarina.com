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

### Run your first application on Kubernetes

Run a WordPress blog with a MySQL database.

1. Identify the IP address of the cluster. In the following example, the cluster IP address is `23.253.149.70`.

    ```bash
    $ kubectl cluster-info
    Kubernetes master is running at https://23.253.149.70
    KubeDNS is running at https://23.253.149.70/api/v1/proxy/namespaces/kube-system/services/kube-dns
    ```

1. Run a MySQL pod and expose it as a service, available to other pods in the cluster on port 3306.

    ```bash
    $ kubectl run mysql --image mysql:5.6 --port 3306 --expose --env MYSQL_ROOT_PASSWORD=TopSecretRootPassword
    service "mysql" created
    deployment "mysql" created
    ```

1. Run a WordPress pod and connect it to the MySQL service.

    ```bash
    $ kubectl run wordpress --image wordpress:4.4 --env WORDPRESS_DB_HOST=mysql.default.svc.cluster.local --env WORDPRESS_DB_PASSWORD=TopSecretRootPassword
    deployment "wordpress" created
    ```

1. Expose WordPress as a service, available on the public internet. Replace `<clusterIP>` with the IP address of the cluster.

    ```bash
    $ kubectl expose deployment wordpress --port=80 --target-port=80 --external-ip="<clusterIP>"
    ```

1. Verify that MySQL and WordPress are running by viewing your pods.

    ```bash
    $ kubectl get pods
    NAME                         READY     STATUS    RESTARTS   AGE
    mysql-3103110157-80a0v       1/1       Running   0          3m
    wordpress-2748774887-4jpp8   1/1       Running   0          26s
    ```

1. Verify that WordPress is externally accessible on port 80 by viewing your services.

    ```bash
    $ kubectl get services wordpress
    NAME         CLUSTER-IP   EXTERNAL-IP     PORT(S)    AGE
    wordpress    10.32.0.25   23.253.149.70   80/TCP     8m
    ```

1. View your WordPress site by opening a web browser and navigating to `http://<clusterIP>`.

1. *(Optional)* Remove your WordPress site.

    If you aren't going to use your WordPress site, we recommend that you remove it. This will delete any data and any posts you've made in the WordPress site.

    ```bash
    $ kubectl delete service wordpress mysql
    service "wordpress" deleted
    service "mysql" deleted

    $ kubectl delete deployment wordpress mysql
    deployment "wordpress" deleted
    deployment "mysql" deleted
    ```

### Congratulations!

You've successfully run your first containerized application.

Carina has many more features and there is more to learn. Review the [Resources](#resources) and [Next step](#next-step) sections for more information.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
* [Docker Version Manager]({{ site.baseurl }}/docs/tutorials/docker-version-manager/)
* [Carina CLI]({{ site.baseurl }}/docs/reference/carina-cli/)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)
