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

Normally, running a custom Docker image on a Kubernetes cluster requires that you
build the Docker image on your local machine, and then publish the image to a
Docker registry. However, with Carina you can build and run a custom Docker image
directly on your Kubernetes cluster.

**Note**: At this time, you can only run a custom Docker image, without using a
Docker registry, on single-node clusters.

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
The `hello-world-app` image is a Python web application, running on port 5000, which prints "Hello World!".

1. Clone the Carina Examples repository:

    ```
    $ git clone https://github.com/getcarina/examples.git carina-examples
    ```

1. Change to the `hello-world-app` directory.

    ```
    $ cd carina-examples/hello-world-app
    ```

### Build a custom image
The following command builds the image directly on your Kubernetes
cluster.

```
$ docker build -t hello-world-app:v1 .
```

### Run a custom image
Now that the image has been built directly on your Kubernetes worker node,
the image is available to be run without first pulling it from a registry.

1. Create a deployment of the image:

    ```
    $ kubectl run hello-world --image hello-world-app:v1
    ```
1. Verify that the deployment was successful. If the number in **Available** column
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

1. Expose the application as a service, available on the public internet.
    Replace `<clusterIP>` with the IP address of the cluster.

    ```
    $ kubectl expose deployment hello-world --port 80 --target-port 5000 --external-ip <clusterIP>
    ```

1. View the application by opening a web browser and navigating to `http://<clusterIP>`.
    You should see "Hello World!".

1. Remove the application.

    ```
    $ kubectl delete deploy/hello-world service/hello-world
    ```

### Use a custom image in a configuration file
While the kubectl commands are useful when learning how Kubernetes works, most
of the time you will be using configuration files. Here is a workflow for
using a custom Docker image with Kubernetes configuration files.

1. Build the image on your Kubernetes cluster.

    ```
    docker build -t hello-world-app:latest .
    ```

1. Create a file named `hello-world.yaml` and populate it with the following contents,
    replacing `<clusterIP>` with the IP address of the cluster.

    **Note**: Since the tag of the image is `latest`, the container's `imagePullPolicy`
    is set to `IfNotPresent` to prevent Kubernetes from pulling the image from a registry.

    ```yaml
    apiVersion: v1
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

1. Remove the application.

    ```
    $ kubectl delete hello-world.yaml
    ```

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

If you did not specify a tag for your custom image, or used `latest`, then the
`kubctl run` command completes successfully but the deployment fails with `ErrImagePull`.

1. Find the name of the failed pod:

    ```
    $ kubectl get pods
    NAME                                 READY     STATUS         RESTARTS   AGE
    hello-world-4125925501-3va8a         0/1       ErrImagePull   0          4s
    ```

1. Inspect the pod to view the error message by running the following command:

    ```
    $ kubectl describe pod <podName>
    ```

    From the output below, the error reason: `ImagePullBackOff` indicates that
    Kubernetes was unable to pull the image. Scroll to the bottom of the output
    to view the full error message under the `Events` section: `Error syncing pod, skipping: failed to "StartContainer" for "hello-world" with ImagePullBackOff: "Back-off pulling image \"hello-world-app\""`.

    ```
    Name:		hello-world-4125925501-3va8a
    Namespace:	default
    Node:		10.223.64.14/10.223.64.14
    Start Time:	Thu, 22 Dec 2016 10:40:15 -0600
    Labels:		pod-template-hash=4125925501
    		run=hello-world
    Status:		Pending
    IP:		172.20.69.4
    Controllers:	ReplicaSet/hello-world-4125925501
    Containers:
      hello-world:
        Container ID:
        Image:		hello-world-app
        Image ID:
        Port:
        State:		Waiting
          Reason:		ImagePullBackOff
        Ready:		False
        Restart Count:	0
        Volume Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-b1xol (ro)
        Environment Variables:	<none>
    Conditions:
      Type		Status
      Initialized 	True
      Ready 	False
      PodScheduled 	True
    Volumes:
      default-token-b1xol:
        Type:	Secret (a volume populated by a Secret)
        SecretName:	default-token-b1xol
    QoS Class:	BestEffort
    Tolerations:	<none>
    Events:
      FirstSeen	LastSeen	Count	From			SubobjectPath			Type		Reason		Message
      ---------	--------	-----	----			-------------			--------	------		-------
      2m		2m		1	{default-scheduler }					Normal		Scheduled	Successfully assigned hello-world-4125925501-3va8a to 10.223.64.14
      2m		52s		4	{kubelet 10.223.64.14}	spec.containers{hello-world}	Normal		Pulling		pulling image "hello-world-app"
      2m		51s		4	{kubelet 10.223.64.14}	spec.containers{hello-world}	Warning		Failed		Failed to pull image "hello-world-app": Error: image library/hello-world-app not found
      2m		51s		4	{kubelet 10.223.64.14}					Warning		FailedSync	Error syncing pod, skipping: failed to "StartContainer" for "hello-world" with ErrImagePull: "Error: image library/hello-world-app not found"

      2m	7s	8	{kubelet 10.223.64.14}	spec.containers{hello-world}	Normal	BackOff		Back-off pulling image "hello-world-app"
      2m	7s	8	{kubelet 10.223.64.14}					Warning	FailedSync	Error syncing pod, skipping: failed to "StartContainer" for "hello-world" with ImagePullBackOff: "Back-off pulling image \"hello-world-app\""
    ```
1. Delete the failed deployment:

    ```
    $ kubectl delete deploy/hello-world
    ```

1. Repeat the deployment, this time instructing Kubernetes to skip pulling
    the image by including `--image-pull-policy IfNotPresent`:

    ```
    $ kubectl run hello-world --image hello-world-app --image-pull-policy IfNotPresent
    ```

For simplicity, we recommend building the Docker image with a tag, instead
of using `latest`. However by explicitly specifying the image pull policy, you can
use the latest tag. The image pull policy can be specified either as a flag to
the `kubectl run` command, or defined in the resource file with `imagePullPolicy: IfNotPresent`.
See [Use a custom image in a configuration file](#use-a-custom-image-in-a-configuration-file)
for an example of how to use the `latest` tag with `imagePullPolicy`.

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).
