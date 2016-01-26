---
title: "Reading your Health Data from Jawbone UP on Carina"
date: 2016-01-26 09:00
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


It's the fourth week of January and all that health data you got over the holidays is simply waiting to be studied! Let's see how we can make our own health data dashboards using the Jawbone UP API on node.js. I know my intent is to sleep more in 2016. So, how about a chart of my sleeping habits? Thanks Jawbone!

This post offers a walk-through using Carina and Let's Encrypt along with a Jawbone UP example to make an app called Sleepify. Once you log in, the app displays a table with your daily sleep amounts.

First, the code itself is in https://github.com/annegentle/JawboneUPNodeDemo. This is from a tutorial on [Sitepoint](http://www.sitepoint.com/connecting-jawbone-up-api-node-js/).

### Get ready: prerequisites

To go through this example, clone my fork of the JawboneUPNodeDemo repo. To read your own data, you'll need a Jawbone UP and an account on their site. To go through this demo, create a Jawbone Developer account on https://jawbone.com/up/developer by clicking Sign In.

Register your app on the Jawbone developer portal. Mine is called sleepify with a silly Zzz icon.

![BuildAndDeploy]({% asset_path 2016-01-24-carina-jawbone/justwriteclickapps.png %})

Register a domain name for the public IP you get from Carina. The tutorial shows you how to get the IP address below.

### Get your Carina cluster

Create a Carina cluster for the node server container. 

1. Source your Carina credentials first. The cluster in this example is called `sleepify`; yours will have a different name.

```
source ~/tools/carinaenv
carina create sleepify
```

1. Get the credentials for it with the `carina` CLI.

```
$ carina credentials sleepify
```

1. Set these variables for your environment.

```
$ carina env sleepify
$ eval $(carina env sleepify)
```

### Create the app container

Create the app container with a Dockerfile that has node as its base. On Carina, you want to understand bind mounting as described in [Volumes](https://getcarina.com/docs/concepts/docker-swarm-carina/#volumes) so
that you know where to put the files we'll upload and run for the app.

You can find this Dockerfile in the JawboneUPNodeDemo directory.

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

Build the image. Make sure you are in the JawboneUPDemo directory containing the `Dockerfile`, and then run this command:

```
$ docker build -t="annegentle/jawbone-demo" .
```

Run the image:

```
$ docker run --interactive --tty -p 5000:5000 \
  --name sleepifyapp \
  annegentle/jawbone-demo
```

```
npm info it worked if it ends with ok
npm info using npm@2.14.12
npm info using node@v4.2.5
npm info prestart JawboneUpNodeDemo@0.0.1
npm info start JawboneUpNodeDemo@0.0.1

> JawboneUpNodeDemo@0.0.1 start /usr/src/app
> node server.js

UP server listening on 5000
```

Get the IP address for the node server. You need this for registering the domain name through your registrar. 

```
$ echo $DOCKER_HOST
tcp://172.99.73.34:2376
```

Go to your domain registrar and add the IP address from Carina as A Records for all subdomains. Here's an example screenshot:

![BuildAndDeploy]({% asset_path 2016-01-24-carina-jawbone/arecords.png %})

### Create the certificates container for HTTPS

Launch a second container so that the app has HTTPS access, because HTTPS is a requirement from Jawbone. To get https through Let's Encrpyt, we'll go through [this tutorial](https://getcarina.com/blog/push-button-lets-encrypt/).

We’ll use those certs, by making another container with your Jawbone app container named "sleepifyapp" as the backend. The image `smashwilson/lets-nginx` is from the [Carina Push Button Let's Encrypt tutorial](https://getcarina.com/blog/push-button-lets-encrypt/).

Get the name of the container with `docker ps -a` to use in the `docker run` command. In the example below, it's "sleepifyapp".

```
$ docker run --detach \
  --link sleepifyapp:sleepifyapp \
  --env EMAIL=annegentle@gmail.com \
  --env DOMAIN=sleepify.me \
  --env UPSTREAM=sleepifyapp:8080 \
  --name sleepify-nginx \
  --publish 80:80 \
  --publish 443:443 \
  smashwilson/lets-nginx

4cf44cec7e139a62da3e544b7cb66c7623437700a632c2659cdf6672f794ae6e
```

You get back a container ID, and you can see the progress of the creation by checking the logs for that container ID:

```
$ docker logs 4cf
```

Once you see this set of notes in the container logs, you're good to proceed.

```IMPORTANT NOTES:
 - If you lose your account credentials, you can recover through
   e-mails sent to annegentle@gmail.com.
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/sleepify.me/fullchain.pem. Your cert will
   expire on 2016-04-24. To obtain a new version of the certificate in
   the future, simply run Let's Encrypt again.
 - Your account credentials have been saved in your Let's Encrypt
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Let's
   Encrypt so making regular backups of this folder is ideal.
 - If you like Let's Encrypt, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

Ready
crond: crond (busybox 1.23.2) started, log level 8
```

Now, when you go to the domain name you made the A Records for, you should get a dashboard like so:

![BuildAndDeploy]({% asset_path 2016-01-24-carina-jawbone/jawbonedashboard.png %})

Now that the container running the node server can serve over https, you can go to https://sleepify.me -- or the clever domain name you registered earlier -- and log in with your Jawbone credentials. I'm sleeping well, how about you?

![BuildAndDeploy]({% asset_path 2016-01-24-carina-jawbone/jawbonesleepdata.png %})