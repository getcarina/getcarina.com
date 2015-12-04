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

* [Carina cluster with only one segment](https://getcarina.com/docs/tutorials/create-connect-cluster/) and Docker environment set up
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

```bash
$ docker run -it -v letsencrypt:/etc/letsencrypt \
    busybox ls /etc/letsencrypt/live/lets.ephem.it
cert.pem       chain.pem      fullchain.pem  privkey.pem
```

Let's launch an nginx container to verify this is all set up. First thing we'll
need is an `nginx.conf`. The one I used comes from the [Mozilla SSL Configuration
Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/).

```nginx
server {
    # Always redirect to the HTTPS endpoint
    listen         80;
    server_name    lets.ephem.it;
    return         301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;

    # certs sent to the client in SERVER HELLO are concatenated in ssl_certificate
    ssl_certificate /etc/letsencrypt/live/lets.ephem.it/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/lets.ephem.it/privkey.pem;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    # modern configuration. tweak to your needs.
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
    ssl_prefer_server_ciphers on;

    # HSTS (ngx_http_headers_module is required) (15768000 seconds = 6 months)
    add_header Strict-Transport-Security max-age=15768000;

    # OCSP Stapling ---
    # fetch OCSP records from URL in ssl_certificate and cache them
    ssl_stapling on;
    ssl_stapling_verify on;

    ## verify chain of trust of OCSP response using Root CA and Intermediate certs
    ssl_trusted_certificate /etc/letsencrypt/live/lets.ephem.it/chain.pem;

    resolver 8.8.8.8 8.8.4.4 valid=86400;

    # Simple static site
    location / {
      root /data/www;
    }
}
```

The most important parts to modify are:

```
ssl_certificate /etc/letsencrypt/live/lets.ephem.it/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/lets.ephem.it/privkey.pem;
...
## verify chain of trust of OCSP response using Root CA and Intermediate certs
ssl_trusted_certificate /etc/letsencrypt/live/lets.ephem.it/chain.pem;
```

Now that you have your own default.conf, we'll need a Docker image to run. Here's
the Dockerfile:

```Dockerfile
FROM nginx
COPY lets.conf /etc/nginx/conf.d/default.conf
COPY index.html /data/www/index.html
```

index.html is just the text "We're Let's Encrypted!"

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

Now run it and `curl` against it:

```bash
$ docker run -d -p 80:80 -p 443:443 \
  -v letsencrypt:/etc/letsencrypt --name nginx nginxcellent
b8afd1744cb390279501bf4f1ee80a55bd1baafa9ae65f52e6b3b17db35a4c7e
$ curl https://lets.ephem.it
We're Let's Encrypted!
```

That's it! You now have encryption set up for a site!

## Clean up

While not necessary, you can do ahead and delete the docker image for letsencrypt
now that you have the certs:

```
docker rmi quay.io/letsencrypt/letsencrypt:latest
```
