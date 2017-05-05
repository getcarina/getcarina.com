---
title: Kubernetes on Carina
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2016-11-04
permalink: docs/tutorials/kubernetes-on-carina/
description: An overview of how Kubernetes is installed and operates Carina hosts
kubernetes-versions:
  - 1.4.1
topics:
  - kubernetes
  - beginner
---

## Master components

On every instance which is allocated as a `Master`, several Docker containers are
preinstalled for Kubernetes to function. These include:

- `kube-apiserver`
- `kubelet`
- `kube-controller-manager`
- `kube-scheduler`

We also install an `etcd` cluster onto the master to serve as cluster's
key/value store.

## Node components

On every instance which is allocated as a Node, several Docker containers are
preinstalled for Kubernetes to function. These include:

- `kubelet`
- `kube-proxy`

## Cluster components

Once the Master and Node instances have been configured, we then install a
selection of Kubernetes pods in order to help you get started. These pods
include:

- Flannel
- DNS server
- Ingress controller
- Private Docker registry

These are installed under the `kube-system` namespace, and are visible when you
run this command:

```bash
kubectl --namespace get pods
```

Many of these system components are installed as DaemonSet resources, which
are pods that run on every Node.

## Resource concentration

In order to concentrate resources as much as possible, the first instance in
a cluster functions both as a Master and a Node by default. Each subsequent
instance that is added to the cluster serves as a Node only.

Future infrastructure configurations will allow for dedicated master instances.

## Configuration files

During the cluster creation process, we generate the following configuration
files for you to use in your local development environment:

- `kubectl.config`
- `kubectl.env`
- `kubectl.ps1`
- `kubectl.cmd`
- `kubectl.fish`

## TLS configuration

When a kubernetes cluster is provisioned, the following TLS certificates are
generated on the master:

- `ca.pem` and `ca-cert.pem`
- `apiserver.pem` and `apiserver-key.pem`
- `admin.pem` and `admin-key.pem`
- `node.pem` and `node-key.pem`
- `user.pem` and `user-key.pem`

These enable the inter-cluster communication to operate securely over TLS.

## SSH access

SSH access is available for clusters provisioned on Virtual Machines but
not LXC instances. We disable SSH access on LXC as a security measure,
because many customers reside on the same underlying LXC host.
