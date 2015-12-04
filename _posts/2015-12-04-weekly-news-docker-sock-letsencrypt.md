---
title: "Weekly news: docker.sock access, service discovery and letsencrypt!"
date: 2015-12-04 13:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  In this week's roundup: We give you docker.sock, free SSL certs, and more!
categories:
 - Consul
 - Swarm
 - Carina
 - News
 - Security
authorIsRacker: true
---

Yesterday [Let's Encrypt](https://letsencrypt.org/) went public, providing
TLS certificates to all, for *free*.

On Carina, you can set this up pretty quickly.

Prerequisites:

* Carina cluster with only one segment and Docker environment set up
* DNS "A" record set to the IP of your node
* `docker` at your fingertips

## Setup the volume for lets-encrypt data

```
docker volume create --name letsencrypt
```

## Setup the volume for lets-encrypt backups (optional, recommended)

```
docker volume create --name letsencrypt-backups
```

## Let's Encrypt!

Now we'll use Let's Encrypt's Docker image to automate acceptance of the terms
of service (recommended reading) as well as generate certs for a domain. You'll
want to set both the domain you want to use as well as the email address to be
the point of contact.

:warning: You *must* have an A record set to this host (`$DOCKER_HOST`) in order
for letsencrypt to be able to verify you own the domain. :warning:

```
docker run -it --rm -p 443:443 -p 80:80 \
  -v letsencrypt:/etc/letsencrypt \
  -v letsencrypt-backups:/var/lib/letsencrypt \
  --name letsencrypt quay.io/letsencrypt/letsencrypt:latest \
  auth -d lets.ephem.it --email rgbkrk@gmail.com --agree-tos
```

After that, you should see output like the following:

```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/lets.ephem.it/fullchain.pem. Your cert will
   expire on 2016-03-02. To obtain a new version of the certificate in
   the future, simply run Let's Encrypt again.
 - If like Let's Encrypt, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

## Accessing the certificates

The certs are available on the `letsencrypt` volume at `{mountpoint}/live/{domain}/`.

```
$ docker run -it -v letsencrypt:/etc/letsencrypt \
    busybox ls /etc/letsencrypt/live/lets.ephem.it
cert.pem       chain.pem      fullchain.pem  privkey.pem
```

## Clean up

While not necessary, you can do ahead and delete the docker image for letsencrypt
now that you have the certs:

```
docker rmi quay.io/letsencrypt/letsencrypt:latest
```
