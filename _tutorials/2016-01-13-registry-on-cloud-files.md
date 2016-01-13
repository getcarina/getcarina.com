---
title: Store private Docker registry images on Cloud Files
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-01-13
permalink: docs/tutorials/registry-on-cloud-files/
description: Learn store private Docker registry images for Carina on Rackspace Cloud Files
docker-versions:
  - 1.9.1
topics:
  - docker
  - intermediate
---

A Docker registry is for storing and distributing Docker images. By default, you pull images from Docker's public registry Docker Hub. You can also push images to a repository on Docker's public registry, if you have a Docker Hub account.

However, you may want to store private Docker registry images for a variety of reasons such as

* Having the images stored in your registry close to where you run your containers for fast and efficient image pulls.
* Secure integration with your continuous integration and continuous deployment pipeline.
* Safe storage for images with potentially sensitive data.

This tutorial teaches you how to store private Docker registry images for Carina on Rackspace Cloud Files for these reasons.

### Prerequisites

* [Create and connect to a cluster](/docs/tutorials/create-connect-cluster/)
* [A Rackspace public cloud account](https://www.rackspace.com/cloud)
 * **Note**: Your Rackspace public cloud account is separate from your Carina account.

### Get your cluster ID and number of segments

```
$ export CLUSTER_ID=3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c
$ export NUM_SEGMENTS=1
```

### Run Docker registry servers

Docker maintains an image for the image registry service. You need to run this service on every segment in your cluster and configure it to use Cloud Files as its storage. To use Cloud Files, the registry needs to know your Rackspace username and password

```
$ export RS_USERNAME=your-rackspace-cloud-username
$ export RS_PASSWORD=your-rackspace-cloud-password
```

This container uses the `--publish` flag so that the registry service only listens on port 5000 of the localhost IP address of 127.0.0.1. That means that only clients authenticated with your cluster credentials can access this service registry.

This container also uses many `--env` flags to configure access to Cloud Files.

```
$ for (( i=1; i<=$NUM_SEGMENTS; i++ )); do
    docker run -d \
      --name registry-$i \
      --publish 127.0.0.1:5000:5000 \
      --restart=always \
      --env constraint:node==${CLUSTER_ID}-n$i \
      --env REGISTRY_STORAGE=swift \
      --env REGISTRY_STORAGE_SWIFT_USERNAME=$RS_USERNAME \
      --env REGISTRY_STORAGE_SWIFT_PASSWORD=$RS_PASSWORD \
      --env REGISTRY_STORAGE_SWIFT_AUTHURL=https://identity.api.rackspacecloud.com/v2.0/ \
      --env REGISTRY_STORAGE_SWIFT_INSECURESKIPVERIFY=true \
      --env REGISTRY_STORAGE_SWIFT_REGION=IAD \
      --env REGISTRY_STORAGE_SWIFT_CONTAINER=docker \
      --env REGISTRY_STORAGE_SWIFT_ROOTDIRECTORY=/registry \
      registry:2
  done
e7a91c5874003c31de6173c08390c25a2a949acaabd6072c2d7e160f40e09a25
be461e804d33972593aeeeac81d33c5e56ae1f37449f241ca81329b6aa8b7766
```

The output of these `docker run` commands are your registry service container IDs.

### Build and distribute an image

Build an image on a segment, store that image in the registry, and pull that image down to all segments.

1. Copy the code below to a file called Dockerfile.

```
FROM alpine:3.3
RUN apk add --update nginx && rm -rf /var/cache/apk/*
RUN echo "Hello Carina" >> /usr/share/nginx/html/index.html
CMD ["nginx", "-g", "daemon off;"]
```

1. Build the image

This `docker build` command uses ...

```
$ docker build --tag 127.0.0.1:5000/$RS_USERNAME/web .
Sending build context to Docker daemon 279.6 kB
Step 1 : FROM alpine:3.3
 ---> 74e49af2062e
Step 2 : RUN apk add --update nginx && rm -rf /var/cache/apk/*
 ---> Running in 3d979b080307
fetch http://dl-4.alpinelinux.org/alpine/v3.3/main/x86_64/APKINDEX.tar.gz
fetch http://dl-4.alpinelinux.org/alpine/v3.3/community/x86_64/APKINDEX.tar.gz
(1/3) Installing nginx-initscripts (1.8.0-r0)
Executing nginx-initscripts-1.8.0-r0.pre-install
(2/3) Installing pcre (8.38-r0)
(3/3) Installing nginx (1.8.0-r3)
Executing busybox-1.24.1-r7.trigger
OK: 6 MiB in 14 packages
 ---> 36cd591ceeb6
Removing intermediate container 3d979b080307
Step 3 : RUN echo "Hello Carina" >> /usr/share/nginx/html/index.html
 ---> Running in 301372c59450
 ---> 3c4ed78a4356
Removing intermediate container 301372c59450
Step 4 : CMD nginx -g daemon off;
 ---> Running in 7c8618c75eeb
 ---> 91ad61e86283
Removing intermediate container 7c8618c75eeb
Successfully built 91ad61e86283
```

```
docker push 127.0.0.1:5000/$RS_USERNAME/web
The push refers to a repository [127.0.0.1:5000/octopus/web] (len: 1)
91ad61e86283: Pushed
3c4ed78a4356: Pushed
36cd591ceeb6: Pushed
74e49af2062e: Pushed
latest: digest: sha256:aff2a308412e6fc59a529a9eac8732c587f721e9b0ae74e248b1c23399e2772f size: 6021
```

```
docker pull 127.0.0.1:5000/$RS_USERNAME/web
Using default tag: latest
3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c-n2: Pulling 127.0.0.1:5000/octopus/web:latest... : downloaded
3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c-n1: Pulling 127.0.0.1:5000/octopus/web:latest... : downloaded
```

### Run a container from your image

```
$ for (( i=1; i<=$NUM_SEGMENTS; i++ )); do
    docker run -d \
      --name web-$i \
      --publish 80:80 \
      --env constraint:node==${CLUSTER_ID}-n$i \
      127.0.0.1:5000/$RS_USERNAME/web
  done
a81d2691aa56b96635939836c96a2569d20b5428d109e63679f139a652d6c812
0af8b1de968ef263fa12e70d70259f50c6c4f5cc5ae07d671cc716adcfd85d23
```

```
$ docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                      NAMES
0af8b1de968e        127.0.0.1:5000/octopus/web   "nginx -g 'daemon off"       3 minutes ago       Up 3 minutes        172.99.65.146:80->80/tcp   3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c-n2/web-2
a81d2691aa56        127.0.0.1:5000/octopus/web   "nginx -g 'daemon off"       3 minutes ago       Up 3 minutes        172.99.70.112:80->80/tcp   3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c-n1/web-1
be461e804d33        registry:2                       "/bin/registry /etc/d"   20 minutes ago      Up 20 minutes       127.0.0.1:5000->5000/tcp   3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c-n2/registry-2
e7a91c587400        registry:2                       "/bin/registry /etc/d"   20 minutes ago      Up 20 minutes       127.0.0.1:5000->5000/tcp   3f8cc9fa-84bc-4bfd-a5bd-b3e38986ed9c-n1/registry-1
```

### View the images in Cloud Files

To view where the actual Docker image files are stored check Cloud Files.

1. Go to the [Rackspace Cloud Control Panel](https://mycloud.rackspace.com/).
1. Login with the same Rackspace username and password you used for the tutorial.
1. From the top menu choose Storage and then Files.
1. In your list of containers click on the container called `docker`.
1. Continue to click on subfolders to explore the structure that your Docker images are stored in.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/tutorials/troubleshooting/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Docker Registry](https://docs.docker.com/registry/)
* This tutorial was inspired by the blog post [Flexible Private Docker Registry Infrastructure](http://tech.paulcz.net/2016/01/flexible-docker-registry-infrastructure/) by [Paul Czarkowski](https://twitter.com/pczarkowski)

### Next step

Learn about all of the features available to you in the [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/).
