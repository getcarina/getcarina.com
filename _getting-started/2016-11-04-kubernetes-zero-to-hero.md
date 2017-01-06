---
title: From Zero to Hero with Kubernetes on Carina
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2016-11-04
permalink: docs/tutorials/kubernetes-zero-to-hero/
description: A zero to hero guide for getting started with Kubernetes on Carina
kubernetes-versions:
  - 1.4.1
topics:
  - kubernetes
  - beginner
---

In this tutorial you will learn the basics of Kubernetes and be introduced to the concepts that make up a functional Kubernetes cluster. No previous experience with Kubernetes is assumed, but by the end of this tutorial, you will have deployed a secure, multi-component blog application running WordPress and MySQL.

## Prerequisite

[Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster#prerequisite)

## Store secrets

Most web applications must store secrets or credentials in a safe, appropriate manner. Kubernetes makes this storage easy and offers a dedicated `Secret` resource to represent your credentials.

In your WordPress application, the only secret that requires secure storage
is the MySQL password.

### Generate a secure password

If you do not have a secure password already, you can generate one as follows:

**Bash**

```bash
$ base64 < /dev/random | head -c 30
```

**PowerShell**

```powershell
> -join (33..126 | ForEach-Object {[char]$_} | Get-Random -Count 30)
```

### Create a Secret resource

To store the password value in Kubernetes, run the following command, replacing `<mysqlRootPassword>`
with a secure password:

```bash
$ kubectl create secret generic mysql-pass --from-literal password=<mysqlRootPassword>
secret "mysql-pass" created
```

To verify that the `Secret` resource was created, run the following command:

```bash
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
default-token-ea4vq   kubernetes.io/service-account-token   3         6m
mysql-pass            Opaque                                1         15s
```
<!--
# Persistent volumes

In order for your data to live beyond the lifecycle of pods (which are
  considered ephemeral), you need to use a Persistent Volume to persist the
  data.

First step is to create the Manifest file for the persistent volumes:

```bash
$ cat > volumes.yaml <<EOL
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-1
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /tmp/data/pv-1
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-2
  labels:
    type: local
spec:
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /tmp/data/pv-2
EOL
```

In this Manifest, two persistent volumes are created: one for MySQL and one
for WordPress. Both are allocated 20GB of disk space and a path on the host.
`ReadWriteOnce` is selected as the accessMode, meaning that the volume can
only be mounted as read-write by a single node (we are using host
storage and not NAS).

The `metadata` field allows you to assign a human-readable name to the resource
and labels, which are explained in our [Kubernetes glossary]({{ site.baseurl }}/getting-started/kubernetes-glossary).

You will notice that the manifests for each resource have been concatenated
into one file for convenience. This is valid and often done to group related
resources.

To create the resources:

```bash
$ kubectl create -f volumes.yaml
persistentvolume "pv-1" created
persistentvolume "pv-2" created
```

and to verify that the persistent volumes were created, run this command:

```bash
$ kubectl get persistentvolumes
NAME      CAPACITY   ACCESSMODES   STATUS      CLAIM     REASON    AGE
pv-1      20Gi       RWO           Available                       12s
pv-2      20Gi       RWO           Available                       11s
``` -->

## Launch MySQL

In this section, you will create the database used by WordPress to store state.

<!--
## PersistentVolumeClaim

In order for your MySQL database to be stateful, it needs guaranteed access to
one of the persistent volumes you previously created. This is achieved by
persistent volume claims, which allocate a set amount of storage in a persistent
volume for a pod. The manifest looks like so:

```bash
$ cat > mysql_pvc.yaml <<EOL
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
EOL
```

A `PersistentVolumeClaim` is being created with `mysql-pv-claim` as its name,
an `app` label which relates it to its function, and a storage request of 20GB.

To create it:

```bash
$ kubectl create -f mysql_pvc.yaml
persistentvolumeclaim "mysql-pv-claim" created
```

And to verify it was created:

```bash
$ kubectl get persistentvolumeclaims
NAME             STATUS    VOLUME    CAPACITY   ACCESSMODES   AGE
mysql-pv-claim   Bound     pv-1      20Gi       RWO           13s
``` -->

### Create a Deployment resource

The next step is launching a `Deployment` resource. A `Deployment` resource is a way to declaratively manage pods and Replica Sets. You describe the required state of a group of pods, and the controller automatically
manages it for you, instead of you doing it manually.

Create a manifest file for the `Deployment` resource named **mysql_deployment.yaml** and populate it with the following content.

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mysql
  labels:
    app: wordpress
spec:
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
```
<!-- ```bash
$ cat > mysql_deployment.yaml <<EOL
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mysql
  labels:
    app: wordpress
spec:
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
EOL
``` -->

Let's look at each part of the file:

* The `Deployment` resource is named `mysql`.  Note that the API version is not `v1`, but `extensions/v1beta1`. This means that it is a beta extension.

* The resource is assigned a custom `app` label, which describes the purpose of the database pod; it is a member of a group of pods that makes up an app named `wordpress`. You can assign additional labels that provide granular levels of identity to the deployment, such as `tier=backend` or `db_type=mysql`.

* The `strategy` of a deployment refers to the strategy used to replace old pods by new ones. The allowed values are `RollingUpdate` (the default) or `Recreate`. The former enables you to gracefully roll out new pods without service disruption, and the latter is a simple mechanism that deletes existing pods before new ones are created.

* All pods for this deployment are assigned labels. In this case, they are assigned an additional `tier` label.

* There is a single Docker container per pod, named `mysql` and based on the `mysql:5.6` Docker image.

* One environment variable, `MYSQL_ROOT_PASSWORD`, is specified for the Docker container. Its value is retrieved from the `Secret` resource that you created earlier in this article. You specify this relationship with `secretKeyRef`. The `name` refers to the name of the `Secret` resource (`mysql-pass`) and `key` refers to the key assigned in the resource that holds the password (`password`).

* A port mapping is specified for the container too, and allows the 3306 port on the container to receive traffic from the pod.

<!-- * The final detail to notice is how volumes are used. The last `volumes` key
  specifies all of the volumes used by containers in the pod. The pod
  references its persistent volume claim (a Kubernetes resource which
  guarantees storage for a Pod), in this case the one we made in the previous
  step named `mysql-pv-claim`.

  Once this defined, the Docker container itself then has a volume to mount.
  This mount is defined by the `volumeMounts` key. It references the name of
  the volume in the pod, and also specifies the path in the container where it
  should be mounted to. -->

Now you can create the `Deployment` resource:

```bash
$ kubectl create -f mysql_deployment.yaml
deployment "mysql" created
```

To verify that the resources were created, run the following commands:

```bash
$ kubectl get deployments
NAME              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
mysql             1         1         1            1           5s
```
```bash
$ kubectl get pods
NAME                               READY     STATUS    RESTARTS   AGE
mysql-2454340998-3ugcb   1/1       Running   0          29s
```

### Create a Service resource

The final resource to create is the service. A service is the front-end load balancer that accepts traffic and routes to an available pod. The name of the service serves as its hostname, allowing for easy service
discovery within the cluster, which enables you to avoid hardcoding the internal IPv4 addresses of pods.

Create a manifest file for the Service resource named **mysql_service.yaml** and populate it with the following content.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  labels:
    app: wordpress
spec:
  ports:
    - port: 3306
  selector:
    app: wordpress
    tier: mysql
  clusterIP: None
```

Let's look at each part of the file:

* The service is named `mysql`, and like the previous resources, it has an `app` label that helps categorize its purpose.

* The `ports` section declares which ports this service listens on, in this case port 3306.

* The `selector` section declares the pods to which traffic is routed. Note that the selector keys refer exactly to the label keys previously defined in the `Deployment` resource. This is how services are associated with pods: the selector selects pods based on their labels.

* The `clusterIP: None` definition tells Kubernetes not to set up load balancing for this service or assign it a single IP address. Instead, it sets up a DNS A record for each pod that this `Service` resource represents.

Now you can create the Service resource:

```bash
$ kubectl create -f mysql_service.yaml
service "mysql" created
```

To verify that the resource was created, run the following command:

```bash
$ kubectl get services
NAME              CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
kubernetes        10.32.0.1    <none>        443/TCP    9m
mysql             None         <none>        3306/TCP   28s
```

### Test the MySQL connection

To test that MySQL is running, you can run a MySQL client pod, as follows:

```bash
$ kubectl run mysql-client --rm -i --tty --image=mysql -- mysql -hmysql -uroot -p$MYSQL_PASSWORD
Waiting for pod default/mysql-client-285651661-owq8j to be running, status is Pending, pod ready: false
Waiting for pod default/mysql-client-285651661-owq8j to be running, status is Pending, pod ready: false
Waiting for pod default/mysql-client-285651661-owq8j to be running, status is Pending, pod ready: false\

Hit enter for command prompt
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)
> exit;
```

Note that you can address MySQL by its service name `mysql` while inside the cluster. Any pod that has a service associated with it is addressable by its service name by pods throughout the cluster. The `kube-proxy` component works in tandem with the DNS server to resolve these service names to internal cluster IP addresses.

## Configure WordPress

The setup stage for WordPress is almost identical to the one for MySQL. First you create a deployment and then a service.

<!--
### PersistentVolumeClaim

First save the manifest to a file:

```bash
$ cat > wp_pvc.yaml EOL
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wp-pv-claim
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
EOL
```

You will notice it almost identical to the PersistentVolumeClaim for MySQL,
just with a different esource name. To create it:

```bash
$ kubectl create -f wp_pvc.yaml
``` -->

### Create a Deployment resource

Create a deployment manifest file named **wp_deployment.yaml** and populate it with the following content.

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: wordpress
        tier: frontend
    spec:
      containers:
      - image: wordpress:4.4-apache
        name: wordpress
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql
        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 80
          name: wordpress
```
<!-- ```bash
$ cat > wp_deployment.yaml EOL
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: wordpress
        tier: frontend
    spec:
      containers:
      - image: wordpress:4.4-apache
        name: wordpress
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql
        - name: WORDPRESS_DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-pass
              key: password
        ports:
        - containerPort: 80
          name: wordpress
        volumeMounts:
        - name: wordpress-persistent-storage
          mountPath: /var/www/html
      volumes:
      - name: wordpress-persistent-storage
        persistentVolumeClaim:
          claimName: wp-pv-claim
EOL
``` -->

This deployment is similar to the MySQL resource, with just a different resource name, labels, and container spec. The Docker container specification uses the `wordpress:4.4-apache` Docker image and specifies an additional `WORDPRESS_DB_HOST` environment variable, which refers to the hostname of the MySQL pod that you previously created.

To create the deployment, run the following command:

```bash
$ kubectl create -f wp_deployment.yaml
deployment "mysql" created
```

### Service

The final step is to create a WordPress service manifest file named **wp_service.yaml** and populate it with the following content.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  ports:
    - port: 80
      nodePort: 80
  selector:
    app: wordpress
    tier: frontend
  type: NodePort
```

This service listens on port 80 and, unlike the MySQL service, does not set the `clusterIP` value to `None`. Instead the service is assigned a cluster IP address and will use load balancing to evenly distribute traffic to its selected pods.

Another key difference is the `NodePort` service type. Traffic that is sent to the host node on a specified port is proxied into the service itself. The `nodePort: 80` definition means that the host proxies traffic from its own port 80 and forwards it to pods associated with this service (which are themselves listening on port 80).

To create the service, run the following command:

```bash
$ kubectl create -f wp_service.yaml
You have exposed your service on an external port on all nodes in your
cluster.  If you want to expose this service to the external internet, you may
need to set up firewall rules for the service port(s) (tcp:80) to serve traffic.

See http://releases.k8s.io/release-1.2/docs/user-guide/services-firewalls.md for more details.
service "wordpress" created
```

## Test your live blog

To verify that everything is working, open a browser window and go to your node's IP address, as follows:

**Bash**

```bash
$ open http://`kubectl cluster-info | awk 'NF>1{print $NF}' | head -n 1`
```

**PowerShell**

```powershell
> start "http://$($(kubectl cluster-info).Split("//")[2])"
```

You should see the WordPress installation screen.

Congratulations! You have a live blog running on a managed Kubernetes cluster in Carina

## Remove your WordPress site (optional)

If you aren't going to use your WordPress site, we recommend that you remove it. Removing it deletes any data and any posts that you've made in the site.

```
$ kubectl delete deploy/wordpress deploy/mysql svc/wordpress svc/mysql secrets/mysql-pass
```
