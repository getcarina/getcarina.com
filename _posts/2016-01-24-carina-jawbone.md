---
title: "Reading your health data from Jawbone UP on Carina"
date: 2016-01-29 09:00
comments: true
author: Anne Gentle <anne.gentle@rackspace.com>
published: true
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

This post provides a walk-through using Carina and Let's Encrypt along with a Jawbone UP example to make an app called Sleepify. After you log in, the app displays a table with your daily sleep amounts.

The web app is modified from a tutorial on [Sitepoint](http://www.sitepoint.com/connecting-jawbone-up-api-node-js/).

### Get ready: prerequisites

To go through this example, clone my fork of the [JawboneUPNodeDemo](https://github.com/annegentle/JawboneUPNodeDemo) repo. To read your own data, you need a Jawbone device and an account on the Jawbone site. To go through this demo, create a Jawbone developer account on [https://jawbone.com/up/developer](https://jawbone.com/up/developer) by clicking Sign In.

Register your app on the Jawbone developer portal. Mine is called Sleepify with a silly Zzz icon.

![jawboneapp]({% asset_path 2016-01-24-carina-jawbone/justwriteclickapps.png %})

Sign up for a [Carina account](https://getcarina.com).

Register a domain name for the public IP address you get from Carina. This tutorial shows you how to get the IP address.

### Get your Carina cluster

1. Create a Carina cluster for the node server container. The cluster in this example is called `sleepify`; yours will have a different name.

    ```
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

1. Create the app container with a `Dockerfile` that uses a node version 4 image as its base. You can find this `Dockerfile` in the JawboneUPNodeDemo directory.

    ```
    FROM node:4

    MAINTAINER Anne Gentle <annegentle@justwriteclick.com>

    # Create app directory

    RUN mkdir -p /usr/src/app

    WORKDIR /usr/src/app

    # Install app dependencies

    COPY package.json /usr/src/app
    RUN npm install

    # Copy the rest of the app files

    COPY . /usr/src/app

    EXPOSE 5000

    CMD ["npm", "start"]

    ```

1. Build the image. Make sure you are in the JawboneUPDemo directory that contains the `Dockerfile`, and then run this command:

    ```
    $ docker build -t="annegentle/jawbone-demo" .
    ```

1. Run the image, replacing the variables enclosed in `<>` with your domain and Jawbone developer credentials:

    ```
    $ docker run --detach \
      --name jawbone-demo \
      --env DOMAIN=<domain> \
      --env JAWBONE_ID=<id> \
      --env JAWBONE_SECRET=<secret> \
      annegentle/jawbone-demo
    ```
    You get a response like this:
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

1. Get the IP address for the node server. You need this for registering the domain name through your registrar. 

    ```
    $ echo $DOCKER_HOST
    tcp://172.99.73.34:2376
    ```

1. Go to your domain registrar and add the IP address from Carina as A Records. Here's an example screenshot:

![domainarecords]({% asset_path 2016-01-24-carina-jawbone/arecords.png %})

### Create the certificates container for HTTPS

Launch a second container so that the app has HTTPS access, because HTTPS is a requirement from Jawbone. To get HTTPS through Let's Encrpyt, these steps mimic [this tutorial](https://getcarina.com/blog/push-button-lets-encrypt/).

We’ll use those certs, by making another container with your Jawbone app container named "sleepifyapp" as the backend. The image `smashwilson/lets-nginx` is from the [Carina Push Button Let's Encrypt tutorial](https://getcarina.com/blog/push-button-lets-encrypt/).

1. Get the name of the container with `docker ps -a` to use in the `docker run` command. In the example for this tutorial, it's "sleepifyapp". 

    The following example uses `--env STAGING=1`, which is a recommendation from the Let's Encrypt tutorial. This setting lets you make many certificates without reaching their limit. The cert won't be trusted in the browser until you remove `STAGING=1` when running this docker command.

    ```
    $ docker run --detach \
      --name lets-nginx \
      --link jawbone-demo:jawbone-demo \
      --env EMAIL=annegentle@example.com \
      --env DOMAIN=sleepify.me \
      --env UPSTREAM=jawbone-demo:5000 \
      --env STAGING=1 \
      --publish 80:80 \
      --publish 443:443 \
      smashwilson/lets-nginx

    4cf44cec7e139a62da3e544b7cb66c7623437700a632c2659cdf6672f794ae6e
    ```

    You get back a container ID. 

1. Check the progress of the creation by checking the logs for that container ID:

    ```
    $ docker logs lets-nginx
    ```

    At first, you'll see this note in the logs:

    ```
    Generating DH parameters, 2048 bit long safe prime, generator 2
    This is going to take a long time
    ```

    It really takes only a few minutes, but sit back and relax while Let's Encrypt generates your certs.

    After you see the following set of notes in the container logs, you're ready to proceed.

    ```
    IMPORTANT NOTES:
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

1. Go to the domain name you made the A Records for. If you used `STAGING=1`, you get an error in your browser, "NET::ERR_CERT_AUTHORITY_INVALID" because the Let's Encrypt staging server is issuing staging certs. 

1. In Chrome, click Advanced, and then click Proceed to <domainname> (unsafe) to try out your new site. 

1. When you're ready to generate real certificates, remove the `STAGING=1` from the docker run command above and re-run.

    You should get a dashboard login page like so:

    ![jawbonedash]({% asset_path 2016-01-24-carina-jawbone/jawbonedashboard.png %})

1. Click Login to enter your Jawbone credentials. 

![jawboneauth]({% asset_path 2016-01-24-carina-jawbone/jawboneauth.png %})

    The app retrieves your sleep data and displays it in a simple table.

![jawbonesleepdata]({% asset_path 2016-01-24-carina-jawbone/jawbonesleepdata.png %})

### What's next?

If you're interested in building more Jawbone data dashboards, explore their [documented API](https://jawbone.com/up/developer/) to find some more resources you could display. I'll look into my [workout data](https://jawbone.com/up/developer/endpoints) next. To explore more endpoints, modify the `server.js` file to build additional tables for your dashboard. Have fun and let us know how Carina got you started quickly with health data.
