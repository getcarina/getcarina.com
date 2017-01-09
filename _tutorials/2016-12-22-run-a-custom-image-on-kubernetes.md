---
title: Run a custom Docker image on Kubernetes
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-12-22
permalink: docs/tutorials/run-a-custom-image-on-kubernetes/
description: Learn how to build and run a custom Docker image on a Kubernetes cluster.
docker-versions:
  - 1.11.2
topics:
  - docker
  - kubernetes
---

Normally running a custom Docker image on a Kubernetes cluster requires that you
build the Docker image on your local machine, and then publish the image to a
Docker registry. With Carina, however, you can build and run a custom Docker image
directly on your Kubernetes cluster.

**Note**: At this time, you can run a custom Docker image, without using a
Docker registry, only on single-node clusters.

### Prerequisites

* [Install the Carina CLI](docs/getting-started/getting-started-carina-cli/)
* [Install the Docker Version Manager](docs/reference/docker-version-manager/)
* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)

After connecting to your cluster, verify that `docker` is connected to your
Kubernetes cluster by running the following commands:

```
$ dvm use
$ docker info
```

### Create a Dockerfile
The `hello-world-app` image is a Python web application, running on port 5000, that prints "Hello World!".

1. Clone the Carina Examples repository:

    ```
    $ git clone https://github.com/getcarina/examples.git carina-examples
    ```

1. Change to the `hello-world-app` directory:

    ```
    $ cd carina-examples/hello-world-app
    ```

### Build a custom image
Run the following command to build the image directly on your Kubernetes cluster:

```
$ docker build -t hello-world-app:v1 .
```

Kubernetes treats images tagged with `latest` as a special case, always pulling
the latest version of the image from the registry. For simplicity, we recommend
building the image with a tag, instead of using `latest` or omitting the tag.

### Run a custom image
Now that the image has been built directly on your Kubernetes worker node,
the image is available to be run without first pulling it from a registry.

1. Create a deployment of the image:

    ```
    $ kubectl run hello-world --image hello-world-app:v1
    ```

    If the image is tagged with `latest`, or the tag is not specified, you must
    specify `--image-pull-policy IfNotPresent`. This flag stops Kubernetes from
    attempting to pull the latest version of the image from the registry.

1. Verify that the deployment was successful. If the number in the **Available** column
    is 0, then the deployment failed, and you should following the steps in the
    [Troubleshooting](#troubleshooting) section.

    ```
    $ kubectl get deployment hello-world
    NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    hello-world   1         1         1            1           11s
    ```

1. Identify the IP address of the cluster. In the following example, the cluster IP address is `23.253.149.70`.

    ```
    $ kubectl cluster-info
    Kubernetes master is running at https://23.253.149.70
    KubeDNS is running at https://23.253.149.70/api/v1/proxy/namespaces/kube-system/services/kube-dns
    ```

1. Expose the application as a service, available on the public Internet.
    Replace `<clusterIP>` with the IP address of the cluster.

    ```
    $ kubectl expose deployment hello-world --port 80 --target-port 5000 --external-ip <clusterIP>
    ```

1. View the application by opening a web browser and navigating to `http://<clusterIP>`.
    You should see "Hello World!".

1. Remove the application:

    ```
    $ kubectl delete deploy/hello-world service/hello-world
    ```

### Use a custom image in a configuration file
Although the kubectl commands are useful when you are learning how Kubernetes works, most
of the time you will be using configuration files. Here is a workflow for
using a custom Docker image with Kubernetes configuration files.

1. Build the image on your Kubernetes cluster:

    ```
    docker build -t hello-world-app:latest .
    ```

1. Create a file named `hello-world.yaml` and populate it with the following contents,
    replacing `<clusterIP>` with the IP address of the cluster.

    **Note**: Because the tag of the image is `latest`, the container's `imagePullPolicy`
    is set to `IfNotPresent` to stop Kubernetes from pulling the image from the registry.

    ```yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: hello-world
      labels:
        app: hello-world
    spec:
      template:
        metadata:
          labels:
            app: hello-world
        spec:
          containers:
          - image: hello-world-app:latest
            name: hello-world
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 5000
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: hello-world
    spec:
      selector:
        app: hello-world
      externalIPs:
      - <clusterIP>
      ports:
      - port: 80
        targetPort: 5000
    ```

1. Run the application:

    ```
    $ kubectl create -f hello-world.yaml
    ```

1. View the application by opening a web browser and navigating to `http://<clusterIP>`.
    You should see "Hello World!".

1. Remove the application:

    ```
    $ kubectl delete -f hello-world.yaml
    ```

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

#### The pod status is ErrImagePull

There are two possible reasons why Kubernetes was unable to find the custom image:

* **The cluster has multiple nodes**

    You cannot run a custom image on a multi-node cluster without publishing the image to a registry.
    Verify that current cluster only contains a single node by running the following command:

    ```
    $ carina get <clusterName>
    ```

    **Note**: The name of the current cluster is available in the `CARINA_CLUSTER_NAME` environment variable.

    <a id="image-pull-policy"></a>

* **The image pull policy was not specified**

    If the image is tagged with `latest`, or the tag was omitted, then the image pull
    policy must be explicitly set to `IfNotPresent`.

    * See [Run a custom image](#run-a-custom-image) for an example of how to specify
      the image pull policy in `kubectl run`.
    * See [Use a custom image in a configuration file](#use-a-custom-image-in-a-configuration-file)
      for an example of how to specify the image pull policy in a configuration file.

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).
