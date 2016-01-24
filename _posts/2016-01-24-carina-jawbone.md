---
title: "Reading your Health Data from Jawbone UP on Carina"
date: 2016-01-24 09:00
comments: true
author: Anne Gentle <anne.gentle@rackspace.com>
published: false
excerpt: >
  Learn about health tracking data through a Jawbone UP example web application, then build and deploy that application to HTTPS on Carina using Let's Encrypt.
categories:
 - Deployment
 - Carina
 - Docker
 - Swarm
 - IoT
 - Encrypt
authorIsRacker: true
---


It's the third week of January and all that health data you got over the holidays is simply waiting to be studied! Let's see how we can make our own health data dashboards using the Jawbone UP API on node.js. I know my intent is to sleep more in 2016. So, how about a chart of my sleeping habits? Thanks Jawbone!

This post offers a walk-through using Carina and Let's Encrypt along with a Jawbone UP example to make an app called Sleepify. Once you log in, the app displays a table with your daily sleep amounts.

First, the code itself is in https://github.com/annegentle/JawboneUPNodeDemo. This is from a tutorial on [Sitepoint](http://www.sitepoint.com/connecting-jawbone-up-api-node-js/).

###Get ready: prerequisites

To go through this example, clone my fork of the JawboneUPNodeDemo repo. To read your own data, you'll need a Jawbone UP and an account on their site. To go through this demo, create a Jawbone Developer account on https://jawbone.com/up/developer by clicking Sign In.

Register your app on the Jawbone developer portal. Mine is called sleepify with a silly Zzz icon.

![BuildAndDeploy]({% asset_path 2016-01-24-carina-jawbone/justwriteclickapps.png %})

Register a domain name for the public IP you get from Carina. The tutorial shows you how to get the IP address below.

### Get your Carina cluster

Create a Carina cluster for the node server container. Source your Carina credentials first. The cluster in this example is called `sleepify`; yours will have a different name.

```
source ~/tools/carinaenv
carina create sleepify
```

Get the credentials for it with the `carina` CLI.

```
$ carina env sleepify
$ eval $(carina env sleepify)
```

### Get the Let's Encrpyt certificate files

We'll also make sure these match for the `Dockerfile` instructions to make sure the certs are copied correctly.

### Create the certificates container for HTTPS

Launch a container so that the app has HTTPS access, a requirement from Jawbone. To get https through Let's Encrpyt, go through [this tutorial](https://getcarina.com/blog/push-button-lets-encrypt/), first using the simple Sinatra app to create the certs. Later we’ll use those certs, by making another container with your Jawbone app container named "sleepifydemo" as the backend.

Get the name of the container with `docker ps -a` to use in the `docker run` command. In the example below, it's "sleepifydemo".

```
docker run --detach \
  --name lets-nginx \
  --link sleepifydemo:sleepifydemo \
  --env EMAIL=anne@example.com \
  --env DOMAIN=sleepifydemo.me \
  --env UPSTREAM=sleepifydemo:3000 \
  --name sleepify \
  --publish 80:80 \
  --publish 443:443 \
  smashwilson/lets-nginx
```

Copy those cert files locally to your JawboneUPDemo directory, as they’re used when creating the app container below.

### Create the app container

Create the app container with a Dockerfile that has node as its base. On Carina, you want to understand bind mounting as described in [Volumes](https://getcarina.com/docs/concepts/docker-swarm-carina/#volumes) so
that you know where to put the files we'll upload and run for the app.

Save this Dockerfile in the JawboneUPNodeDemo directory.

```
FROM node:4

MAINTAINER Anne Gentle <annegentle@justwriteclick.com>

# Create app directory

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# Install app dependencies

COPY package.json /usr/src/app
RUN npm install

COPY server.* /usr/src/app

COPY public/images/ /usr/src/app

COPY views/ /usr/src/app

EXPOSE 8080

CMD ["npm", "start"]

```

Build the image. 

```
docker build -t="annegentle/node-demo" .
```

Run the image.

```
$ docker run --interactive --tty \
  --name sleepifydemo \
  annegentle/node-demo
```

Get the IP address for the node server. You need this for registering the domain name through your registrar. 

```
$ docker port sleepifydemo 8080 
```


### Go get your sleep data

Now that the container running the node server can serve over https, you can go to https://sleepify.me -- or the clever domain name you registered earlier -- and log in with your Jawbone credentials. I'm sleeping well, how about you?
