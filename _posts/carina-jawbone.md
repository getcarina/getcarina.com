---
title: "Reading your Health Data on Carina with Jawbone UP"
date: 2016-01-22 09:00
comments: true
author: Anne Gentle <anne.gentle@rackspace.com>
published: false
excerpt: >
  Learn about health tracking data through a Jawbone UP example web application
  and build/deploy that application Carina.
categories:
 - Deployment
 - Carina
 - Docker
 - Swarm
 - IoT
authorIsRacker: true
---


It's the third week of January and all that health data you got over the holidays is simply waiting to be studied! Let's see how we can make our own health data dashboards using the Jawbone UP API on node.js. I know my intent is to sleep more in 2016. So, how about a chart of my sleeping habits? Thanks Jawbone!

This post offers a walk-through using Carina and Let's Encrypt along with a Jawbone UP example to make an app called Sleepify. Once you log in, the app displays a table with your daily sleep amounts.

First, the code itself is in https://github.com/annegentle/JawboneUPNodeDemo. This is from a tutorial on [Sitepoint](http://www.sitepoint.com/connecting-jawbone-up-api-node-js/).

###Get ready: prerequisites

To go through this example, clone my fork of their repo. To read your own data, you'll need a Jawbone UP and an account on their site. To go through this demo, create a Jawbone Developer account on https://jawbone.com/up/developer by clicking Sign In.

Register your app on the Jawbone developer portal. Mine is called sleepify with a silly Zzz icon.

![BuildAndDeploy]({% asset_path 2016-01-22-carina-jawbone/justwriteclickapps.png %})

Register a domain name for the public IP you get from Carina.

### Get your Carina cluster

Create a Carina cluster for the node server container. Source your Carina credentials first.

```
source ~/tools/carinaenv
carina create sleepify
```

Get the credentials for it with the `carina` CLI.

```
$ carina env sleepify
$ eval $(carina env sleepify)
```


### Create the app container

Create the app container with a Dockerfile that has node as its base. On Carina, you want to understand bind mounting as described in [Volumes](https://getcarina.com/docs/concepts/docker-swarm-carina/#volumes) so
that you know where to put the files we'll upload and run for the app.

```
FROM node:4

MAINTAINER Anne Gentle <annegentle@justwriteclick.com>

# Create app directory

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# Install app dependencies

COPY package.json /usr/src/app
RUN npm install

COPY server.js /usr/src/app

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
$ docker run -it --name sleepifydemo
```


Get the IP address for the node server. You need this for registering the domain name through your registrar. 

```
$ 
```

### Create the certificates container for HTTPS

Launch a second container so that the app has HTTPS access, a requirement from Jawbone. To get https through Let's Encrpyt, go through this tutorial, making your Jawbone app container the backend.

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

### Go get your sleep data

Now that the container running the node server can serve over https, you can go to https://sleepify.me and 
