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

## Prerequisities

- A running cluster. To set up follow our tutorial to create a cluster through
  [the UI](./create-kubernetes-cluster) or [CLI](./create-kubernetes-cluster-with-cli).

- Kubectl installed and configured.

# Secrets

Most web applications have to deal with the problem of storing secrets or
credentials in a safe, appropriate manner. Kubernetes makes this storage
very easy and actually offers a dedicated `Secret` resource to represent them.

In your WordPress application, the only secret that requires secure storage
is the MySQL password.

## Generate secure password

If you do not have a secure password already, you can generate one like so:

```bash
$ export MYSQL_PASSWORD=$(base64 < /dev/random | head -c 30)
```

If you do already have a password, set it like so:

```bash
$ export MYSQL_PASSWORD="..."
```

## Create secret resource

To store the password value in Kubernetes, you run:

```bash
$ kubectl create secret generic mysql-pass --from-literal password=$MYSQL_PASSWORD
secret "mysql-pass" created
```

and to verify it was created, you can run:

```bash
$ kubectl get secrets
NAME                  TYPE                                  DATA      AGE
default-token-ea4vq   kubernetes.io/service-account-token   3         6m
mysql-pass            Opaque                                1         15s
```

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
```

# Launch MySQL

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
```

## Deployment

The first step you need to take next is launching a `Deployment` resource. A
deployment resource is a way to declaratively manage Pods and ReplicaSets. You
describe the desired state of a pod set, and the controller will automatically
manage it for you, instead of you doing it manually.

```bash
$ cat > mysql_deployment.yaml <<EOL
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: wordpress-mysql
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
```

A lot is going on here, so let's break it down piece by piece:

* We are creating a `Deployment` resource named `wordpress-mysql`. You will
  notice that the API version is not `v1`, but `extensions/v1beta1`. This means
  it is a beta extension.

* We are assigning the resource a custom `app` label which describes what the
  database pod is for: it is a member of a group of pods that makes up an
  app named `wordpress`. You can assign additional labels if you wish that
  provide granular levels of identity to the deployment, such as `tier=backend`
  or `db_type=mysql`.

* The `strategy` of a Deployment refers to the strategy used to replace old
  Pods by new ones. The allowed values are `RollingUpdate` (the default) or
  `Recreate`. The former allows for you to gracefully roll out new pods without
  service disruption, and the latter is a more simple mechanism which kills
  existing pods before new ones are created.

* All pods for this Deployment are also assigned labels. In this case, they
  are assigned an additional `tier` label.

* There is a single Docker container per pod, named `mysql` and based off the
  `mysql:5.6` Docker image.

* One environment variable, named `MYSQL_ROOT_PASSWORD`, is specified for the
  Docker container. Its value is retrieved from the Secret resource you created
  earlier in this article. You specify this relation with `secretKeyRef`. The
  `name` refers to the name of the Secret resource (`mysql-pass`) and `key`
  refers to the key assigned in the resource which holds the password (`password`).

* A port mapping is specified for the container too, and allows the 3306 port
  on the container to receive traffic from the pod.

* The final detail to notice is how volumes are used. The last `volumes` key
  specifies all of the volumes used by containers in the pod. The pod
  references its persistent volume claim (a Kubernetes resource which
  guarantees storage for a Pod), in this case the one we made in the previous
  step named `mysql-pv-claim`.

  Once this defined, the Docker container itself then has a volume to mount.
  This mount is defined by the `volumeMounts` key. It references the name of
  the volume in the pod, and also specifies the path in the container where it
  should be mounted to.

Now you are ready to create it:

```bash
$ kubectl create -f mysql_deployment.yaml
deployment "wordpress-mysql" created
```

To verify that the resources have been created, run:

```bash
$ kubectl get deployments
NAME              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
wordpress-mysql   1         1         1            0           5s
```

### Service

The final resource that needs to be created is the service. A service is the
front-end load balancer that accepts traffic and routes to an available pod.
The name of the service serves as its hostname, allowing for easy service
discovery within the cluster, allowing you to avoid hard-coding the internal
IPv4s of pods.

```bash
$ cat > mysql_service.yaml <<EOL
apiVersion: v1
kind: Service
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  ports:
    - port: 3306
  selector:
    app: wordpress
    tier: mysql
  clusterIP: None
EOL
```

You are creating a Service named `wordpress-mysql` which, like the previous
resources, has an `app` label which helps categorise what it is used for.

The `ports` section declares which ports this service listens on, in this
case port 3306.

The `selector` section declares which Pods traffic is routed to. You will
notice that the Selector keys refer exactly to the Label keys previously
defined on our Pods resource. This is the way services are associated with pods:
the selector selects pods based on their labels.

The `clusterIP: None` definition tells Kubernetes to not set up load balancing
for this service or assign it a single IP. Instead, it does the bare minimum:
sets up a DNS A record for each Pod which this Service resource represents.

```bash
$ kubectl create -f mysql_service.yaml
service "wordpress-mysql" created
```

To test it was created:

```bash
$ kubectl get services
NAME              CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
kubernetes        10.32.0.1    <none>        443/TCP    9m
wordpress-mysql   None         <none>        3306/TCP   28s
```

### Test

To test that MySQL is up-and-running, we can run a MySQL client pod like so:

```bash
$ kubectl run mysql-client --rm -i --tty --image=mysql -- mysql -hwordpress-mysql -uroot -p$MYSQL_PASSWORD
> show tables;
> exit;
```

You will notice that we can address MySQL by its service name `mysql` whilst
inside the cluster. Any pod that has a Service associated with it is
addressable by its service name by pods throughout the cluster. The kube-proxy
component works in tandem with the DNS server to resolve these service names
to internal cluster IPs.

# Configure WordPress

The set up stage for WordPress is almost identical to MySQL. First we create a
PersistentVolumeClaim, then a Deployment, and finally a Service.

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
```

### Deployment

The next step is to create the deployment manifest file:

```bash
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
          value: wordpress-mysql
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
```

This Deployment is very similar to the MySQL resource, just with a different
 resource `name`, `labels` and container spec. The Docker container specification
 uses the `wordpress:4.4-apache` Docker image and specifies an additional
 `WORDPRESS_DB_HOST` environment variable which refers to the hostname of the
 MySQL pod you previously created.

### Service

The finale step is to create the WordPress service manifest:

```bash
$ cat > wp_service.yaml EOL
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
EOL
```

This service listens on port 80 and, unlike the MySQL service, does not set
the `clusterIP` to `None`. Instead it is assigned a cluster IP and will use
load balancing to evenly distribute traffic to its selected pods.

Another key difference is that is of the `NodePort` service type. This means
that traffic which is sent to the host node on a specified port is proxied into
the service itself. The `nodePort: 80` definition means that the host will
proxy traffic from its own port 80 and forward on to pods associated with this
service (which are themselves listening on port 80).

# Test out your live blog

To verify that everything is working, open up a browser and go to your
node's IP address, like so:

```bash
$ open http://$(kubectl get pod wordpress --template={{.status.hostIP}})
```

You should see the WordPress installation screen. And there you have it! You
have a live blog running on a managed Kubernetes cluster in Carina.
