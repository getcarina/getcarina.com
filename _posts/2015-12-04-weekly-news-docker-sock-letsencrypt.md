---
title: "Weekly news: docker.sock access and letsencrypt!"
date: 2015-12-04 13:00
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  In this week's roundup, we give you docker.sock, configure free Let's Encrypt
  TLS/SSL certificates, and announce our status page.
categories:
 - Encryption
 - TLS
 - SSL
 - Docker
 - letsencrypt
 - Carina
 - News
 - Security
authorIsRacker: true
---

In this week's roundup we announce our status page, give you `docker.sock`, and
configure free letsencrypt TLS/SSL certs.

## Status page

We now have a [status page](https://carinabyrackspace.statuspage.io/). We'd like to keep
you apprised of issues anywhere on our platform.

Recently there have been issues with the public Swarm discovery service. We'll be migrating
off of the public Swarm discovery service as soon as we can. HugOps to the Swarm team
at Docker.

## docker.sock is now available

You can now mount `docker.sock` directly and use it:

```bash
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED                  STATUS                  PORTS                                      NAMES
a0581acf56c4        docker              "docker-entrypoint.sh"   Less than a second ago   Up Less than a second                                              kickass_perlman
b8afd1744cb3        nginxcellent        "nginx -g 'daemon off"   18 minutes ago           Up 18 minutes           0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   nginx
423c16bf838d        swarm:1.0.0         "/swarm manage -H=tcp"   27 hours ago             Up 27 hours             2375/tcp, 0.0.0.0:2376->2376/tcp           swarm-manager
e7a9df39621d        swarm:1.0.0         "/swarm join --addr=1"   27 hours ago             Up 27 hours             2375/tcp                                   swarm-agent
```

## Let's Encrypt with free certificates

Yesterday, [Let's Encrypt](https://letsencrypt.org/) went public, providing
TLS certificates to all, for *free*.

On Carina or any Docker host, you can set this up pretty quickly.

Prerequisites:

* A public facing Docker host or a [Carina cluster with only one node](https://getcarina.com/docs/getting-started/create-connect-cluster/)
* Your Docker environment set up
* DNS "A" record set to the IP of your host

Note: If you're on Docker < 1.9, your commands will [differ just a little bit](#note-for-previous-docker-versions).

### Set up the volume for letsencrypt data

```bash
$ docker volume create --name letsencrypt
```

### Set up the volume for letsencrypt backups (optional, recommended)

```bash
$ docker volume create --name letsencrypt-backups
```

### Let's Encrypt!

Now you can use Let's Encrypt's Docker image to automate acceptance of the terms
of service (recommended reading) as well as generate certificates for a domain. You'll
want to set both the domain that you want to use and the email address to be
the point of contact.

⚠️  You *must* have an A record set to this host (`$DOCKER_HOST`) in order
for Let's Encrypt to be able to verify you own the domain. ⚠️

```bash
$ docker run -it --rm -p 443:443 -p 80:80 \
    -v letsencrypt:/etc/letsencrypt \
    -v letsencrypt-backups:/var/lib/letsencrypt \
    quay.io/letsencrypt/letsencrypt:latest \
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

### Create the Diffie Hellman parameters

In order to get the best rating from Qualys SSL Labs, you'll want to generate
Diffie Hellman parameters for the host.

```bash
$ docker run -it --rm \
    -v letsencrypt:/etc/letsencrypt \
    nginx openssl \
    dhparam -out /etc/letsencrypt/live/lets.ephem.it/dhparams.pem 2048
```

This will take a good while to generate. While optional, this is a security
related post, so I'll pretend that you're going to copy paste everything from
here which means I better leave sensible defaults.

For bonus points crank 2048 to 4096.

#### Note for previous Docker versions

Docker 1.9 introduced both volumes and volume drivers, which made the above a bit simpler. For previous versions of Docker,
you have to change the commands a bit:

```bash
$ docker create -v '/etc/letsencrypt' -v '/var/lib/letsencrypt' --name certs cirros
$ docker run -it --rm -p 443:443 -p 80:80 \
    --volumes-from certs \
    --name letsencrypt quay.io/letsencrypt/letsencrypt:latest \
    auth -d lets.ephem.it --email rgbkrk@gmail.com --agree-tos
$ docker run -it --rm \
    --volumes-from certs \
    nginx openssl \
    dhparam -out /etc/letsencrypt/live/lets.ephem.it/dhparams.pem 2048
```

### Accessing the certificates

The certificates are available on the `letsencrypt` volume at `{mountpoint}/live/{domain}/`.

```bash
$ docker run -it -v letsencrypt:/etc/letsencrypt \
    busybox ls /etc/letsencrypt/live/lets.ephem.it
cert.pem       chain.pem      fullchain.pem  privkey.pem
```

Let's launch an NGINX container to verify this is all set up. The first thing
needed is an `nginx.conf`. The one I used comes from the [Mozilla SSL Configuration
Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/).

```nginx
{% include_relative _2015-12-04-weekly-news-docker-sock-letsencrypt/lets.conf %}
```

The most important parts to modify are:

```
ssl_certificate /etc/letsencrypt/live/lets.ephem.it/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/lets.ephem.it/privkey.pem;
ssl_dhparam /etc/letsencrypt/live/lets.ephem.it/dhparams.pem;
...
## verify chain of trust of OCSP response using Root CA and Intermediate certs
ssl_trusted_certificate /etc/letsencrypt/live/lets.ephem.it/chain.pem;
```

Now that you have your own `lets.conf` file, you need a Docker image to run. Here's
the Dockerfile:

```Dockerfile
{% include_relative _2015-12-04-weekly-news-docker-sock-letsencrypt/Dockerfile %}
```

`index.html` is just the text "We're Let's Encrypted!" with a link to this blog post.

Go ahead and build it:

```bash
$ docker build -t nginxcellent .
Sending build context to Docker daemon 5.632 kB
Step 1 : FROM nginx
 ---> 198a73cfd686
Step 2 : COPY lets.conf /etc/nginx/conf.d/default.conf
 ---> 8934baea98eb
Removing intermediate container 35bc1da7d8a3
Step 3 : COPY index.html /data/www/index.html
 ---> 41e0e1ef05b8
Removing intermediate container 922f6c7890e8
Successfully built 41e0e1ef05b8
```

Now run it and `curl` against lets.ephem.it:

```bash
$ docker run -d -p 80:80 -p 443:443 \
  -v letsencrypt:/etc/letsencrypt --name nginx nginxcellent
b8afd1744cb390279501bf4f1ee80a55bd1baafa9ae65f52e6b3b17db35a4c7e
$ curl https://lets.ephem.it
We're Let's Encrypted!
```

That's it! You now have encryption set up for a site! You will need to renew the
certificates every 90 days, which is worth another post.

### Clean up

Although not necessary, you can delete the docker image for Let's Encrypt
now that you have the certificates:

```bash
$ docker rmi quay.io/letsencrypt/letsencrypt:latest
```

## Wrap up

That's all folks! See you next time.
