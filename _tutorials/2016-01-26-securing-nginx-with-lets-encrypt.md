---
title: Securing NGINX with Let's Encrypt
author: Ash Wilson <ash.wilson@rackspace.com>
date: 2016-01-26
permalink: docs/tutorials/securing-nginx-with-lets-encrypt/
description: Learn to secure an NGINX server with free TLS certificates from Let's Encrypt
docker-versions:
  - 1.9.1
topics:
  - docker
  - intermediate
  - lets-encrypt
  - tls
  - ssl
  - nginx
---

This tutorial describes acquiring free TLS certificates from [Let's Encrypt](https://letsencrypt.org/) and using them to secure a web site served using NGINX. This encrypts all traffic to and from your site with a certificate that's trusted by your browser and that provides strong enough encryption to get an "A+" rating from SSL Labs.

### Prerequisites

Before you begin, you'll need to be able to [create and connect to a Carina cluster.]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/) You'll need at least one segment with ports 80 and 443 available.

You'll also need to own a domain name and know how to create DNS records. Consult with your domain registrar for documentation on how to do this.

### Steps

1. Create a data volume container to hold the Let's Encrypt certificates and account information.

    A data volume container is a container that exists only to house a Docker volume. It's usually implemented as a container whose process terminates immediately. Generally the command used for a data volume container is irrelevant, but here you'll use it to create a directory within the volume that you'll use from NGINX later.

    ```bash
    $ docker run \
      --name letsencrypt-data \
      --volume /etc/letsencrypt \
      --volume /var/lib/letsencrypt \
      --entrypoint /bin/mkdir \
      quay.io/letsencrypt/letsencrypt \
      -p /etc/letsencrypt/webrootauth/
    ```

    No output is expected here.

1. Generate strong Diffie-Hellman parameters and store them within your data volume container. These will prevent NGINX from using weaker parameters while negotiating the initial TLS connection, and are necessary to reach that "A+" rating on SSL labs.

    ```bash
    $ docker run \
      --rm --interactive --tty \
      --volumes-from letsencrypt-data \
      nginx \
      openssl dhparam -out /etc/letsencrypt/dhparams.pem 2048
    Generating DH parameters, 2048 bit long safe prime, generator 2
    This is going to take a long time
    ............................
    ```

    This will take several minutes to complete.

1. Add a DNS "A" record to your domain pointing to the public IP address of your cluster's segment.

    Even if your cluster has multiple segments, all of your containers will be running on the same segment as the data volume container you just created. To find its public IP address, run:

    ```bash
    $ docker inspect --format "{{ "{{ .Node.IP "}}}}" letsencrypt-data
    172.99.73.144
    ```

    Add an "A" record from your domain pointing to this address. If your domain had previously been pointing elsewhere, you may need to wait for the new DNS entry to propagate before you can use it. You can determine when the entry is ready by checking:

    **Mac OS X and Linux**

    ```bash
    $ dig +short <myDomain>
    172.99.73.144
    ```

    **Windows**

    ```powershell
    > nslookup <myDomain>
    172.99.73.144
    ```

    When the output of these commands matches the address found by `docker inspect`, you're ready to proceed.

1. Run a Let's Encrypt container to issue a new certificate. The Let's Encrypt client must be able to bind to ports 80 and 443 on the segment.

    Notice that running this container will automatically accept the Let's Encrypt [terms of service](https://letsencrypt.org/repository/) on your behalf. Be sure that you're okay with accepting them before you run this!

    The `--server` parameter below will issue certificates from Let's Encrypt's *staging* server, which means that these certificates won't be browser-valid yet. Let's Encrypt rate-limits certificate issuance to [five certificates per domain per seven days](https://community.letsencrypt.org/t/public-beta-rate-limits/4772/3), so it's a good idea to use staging certificates until you're confident that your infrastructure works the way you want it to. When you're ready to go live, omit the `--server` parameter from this step to get a production certificate.

    ```bash
    $ docker run \
      --rm \
      --volumes-from letsencrypt-data \
      --publish 443:443 \
      --publish 80:80 \
      quay.io/letsencrypt/letsencrypt certonly \
      --server https://acme-staging.api.letsencrypt.org/directory \
      --domain <myDomain> \
      --authenticator standalone \
      --email <myEmail> \
      --agree-tos
    ```

    If all goes well, you'll see output like this:

    ```
    IMPORTANT NOTES:
     - If you lose your account credentials, you can recover through
       e-mails sent to <myEmail>.
     - Congratulations! Your certificate and chain have been saved at
       /etc/letsencrypt/live/<myDomain>/fullchain.pem. Your cert will
       expire on <someDate>. To obtain a new version of the certificate in
       the future, simply run Let's Encrypt again.
     - Your account credentials have been saved in your Let's Encrypt
       configuration directory at /etc/letsencrypt. You should make a
       secure backup of this folder now. This configuration directory will
       also contain certificates and private keys obtained by Let's
       Encrypt so making regular backups of this folder is ideal.
     - If you like Let's Encrypt, please consider supporting our work by:

       Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
       Donating to EFF:                    https://eff.org/donate-le
    ```

1. Generate an NGINX configuration that uses the issued TLS credentials and Diffie-Helman parameters. Your exact NGINX configuration will depend on your application's specific needs. Generally, you'll want NGINX to serve static assets and proxy requests to your application container. For now, let's start by serving a static page.

    First, create the page to serve, `index.html`:

    ```html
    <!doctype html>
    <html lang="en-us">
        <head>
            <title>Let's Encrypted</title>
        </head>
        <body>
            <h1>This page is served over https!</h1>
        </body>
    </html>
    ```

    Now create the NGINX configuration itself. Use the [Mozilla SSL configuration generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/) as a starting point to create a `default.conf` that uses up-to-date, secure settings, and adapt it to meet your needs. If you use this example, remember to replace `<myDomain>` with your domain name.

    The `location /.well-known/acme-challenge` stanza near the end is important to remember: it will be used by the Let's Encrypt client during a certificate re-issue.

    ```nginx
    server {
        listen         80;
        server_name    <myDomain>;
        return         301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl;

        # certs sent to the client in SERVER HELLO are concatenated in ssl_certificate
        ssl_certificate /etc/letsencrypt/live/<myDomain>/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/<myDomain>/privkey.pem;
        ssl_dhparam /etc/letsencrypt/dhparams.pem;

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
        ssl_trusted_certificate /etc/letsencrypt/live/<myDomain>/chain.pem;

        resolver 8.8.8.8 8.8.4.4 valid=86400;

        location / {
          root /data/www;
        }

        # Pass the ACME challenge from letsencrypt to a directory within the container

        location /.well-known/acme-challenge {
          alias /etc/letsencrypt/webrootauth/.well-known/acme-challenge;
          location ~ /.well-known/acme-challenge/(.*) {
            add_header Content-Type application/jose+json;
          }
        }
    }
    ```

1. Put it all together with a `Dockerfile.nginx`:

    ```Dockerfile
    FROM nginx

    COPY default.conf /etc/nginx/conf.d/default.conf
    COPY index.html /data/www/index.html
    ```

1. Use these files to build the container image, specifying a [build affinity](https://docs.docker.com/swarm/scheduler/filter/#node-filters) to ensure that the image will be available on the same segment as the volume that's storing your certificates. On Swarm, `docker build` commands only build the container image on *one* node, which can cause problems if a `docker run` command later attempts to schedule a container on a different Carina segment. Specifying `--build-arg affinity:container==letsencrypt-data` ensures that the image is built on the same segment as your data volume container, which is where you'll be running your containers.

    ```bash
    $ docker build \
      --build-arg affinity:container==letsencrypt-data \
      --tag my-nginx \
      --file Dockerfile.nginx \
      .
    Sending build context to Docker daemon 10.24 kB
    Step 1 : FROM nginx
     ---> 9737f81306ee
    Step 2 : COPY default.conf /etc/nginx/conf.d/default.conf
     ---> 463bc1d0812f
    Removing intermediate container 037f7a9e8ec5
    Step 3 : COPY index.html /data/www/index.html
     ---> d6e4979433db
    Removing intermediate container a96d82bb5a4e
    Successfully built d6e4979433db
    ```

1. Launch an NGINX container using your image:

    ```bash
    $ docker run --detach \
      --name my-nginx \
      --volumes-from letsencrypt-data \
      --publish 443:443 \
      --publish 80:80 \
      my-nginx
    6a0d9d85508e0f6f7a555242da57e95e37279c19a676a66c73e608bd26475254
    ```

    The output of the run command is the ID of your running NGINX container.

    Visit your domain in your browser. If it's still a staging certificate, you'll get a security warning, but your site is being served over TLS! If you're unable to connect or you see an error message, instead, check the [troubleshooting section](#troubleshooting) for ways to diagnose your problem.

    You aren't done quite yet, however.

1. Create a script that will reissue your certificates. Let's Encrypt issues certificates that expire in a relatively short 90-day period to mitigate the risk of compromised credentials and to encourage you to automate re-issuance.

    Write `reissue`, substituting your domain and email address. Again, this example uses `--server` to target the Let's Encrypt staging environment; omit the `--server` argument and its parameter for your production infrastructure.

    ```bash
    #!/bin/sh
    set -euo pipefail

    # Re-issue the certificate.
    docker run \
      --rm \
      --volumes-from letsencrypt-data \
      quay.io/letsencrypt/letsencrypt certonly \
      --server https://acme-staging.api.letsencrypt.org/directory \
      --domain <myDomain> \
      --authenticator webroot \
      --webroot-path /etc/letsencrypt/webrootauth/ \
      --email <myEmail> \
      --renew-by-default \
      --agree-tos

    # Send NGINX a SIGHUP to trigger it to reload its configuration without shutting down.
    docker kill --signal=HUP my-nginx
    ```

1. Write a `Dockerfile.cron` that uses `crond` to invoke this script once every month. This example uses [Alpine](https://hub.docker.com/_/alpine/) as a base image to keep the image small. Conveniently, Alpine includes an [`/etc/periodic` directory](http://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#My_cron_jobs_don.27t_run.3F) that can be used to easily run scripts at a variety of intervals. All you need to do is copy the script to the correct directory, ensure that it has no file extension, and make it executable.

    ```Dockerfile
    FROM alpine:3.3

    RUN apk add --no-cache docker

    COPY reissue /etc/periodic/monthly/reissue
    RUN chmod a+x /etc/periodic/monthly/reissue

    # Run the cron daemon with the following flags:
    # -f: Foreground
    # -d 8: Log to stderr, use default log level
    CMD ["/usr/sbin/crond", "-f", "-d", "8"]
    ```

    Use this Dockerfile to build a `my-cron` container, again using `--build-args` to ensure that the image is built on the correct segment:

    ```bash
    $ docker build \
      --build-arg affinity:container==letsencrypt-data \
      --tag my-cron \
      --file Dockerfile.cron \
      .
    Sending build context to Docker daemon 10.24 kB
    Step 1 : FROM alpine:3.3
     ---> 2314ad3eeb90
    Step 2 : RUN apk add --no-cache docker
     ---> Running in 060a4962d1ae
    fetch http://dl-4.alpinelinux.org/alpine/v3.3/main/x86_64/APKINDEX.tar.gz
    fetch http://dl-4.alpinelinux.org/alpine/v3.3/community/x86_64/APKINDEX.tar.gz
    (1/11) Installing iptables (1.4.21-r4)
    # ...
    Step 5 : CMD /usr/sbin/crond -f -d 0
     ---> Running in e85404657bd8
     ---> 1d40ad924e88
    Removing intermediate container e85404657bd8
    Successfully built 1d40ad924e88
    ```

1. Run your cron job in a dedicated cron container. Remember to mount the Docker socket from the host so that the `reissue` script's `docker` commands will work, and to specify an affinity to your data container to run on the correct segment:

    ```bash
    $ docker run \
      --detach \
      --name my-cron \
      --volume /var/run/docker.sock:/var/run/docker.sock \
      --env affinity:container==letsencrypt-data \
      my-cron
    ```

You now have a site served over browser-valid HTTPS, with a certificate that will automatically remain valid! Check your handiwork at [SSL Labs](https://www.ssllabs.com/ssltest/) and make sure you have that green "A+" rating.

### Troubleshooting

If you see a rate-limiting error from the letsencrypt container during certificate issuance:

```
letsencrypt Error: rateLimited :: There were too many requests of a given type :: Error creating new cert :: Too many certificates already issued for: <myDomain>
```

There isn't much you can do but wait; the rate-limiting will expire in a week. In the meantime, you can continue to iterate on your infrastructure by using the staging server.

If you aren't able to reach your domain at all with your browser:

* Verify that the NGINX container is running. It should appear in the output of `docker ps -a` with a "STATUS" of "Up". If you see a status of "Exited" instead, check its logs with `docker logs my-nginx` to see what caused it to stop.
* Ensure that the running NGINX container is listening on public ports 80 and 443. Its line in `docker ps -a` should include a "PORTS" section like the following: `<myIP>:80->80/tcp, <myIP>:443->443/tcp`.
* Double check that the IP your domain is pointed at is the IP of the Carina segment. The output of `dig +short <myDomain>` (or `nslookup <myDomain>` on Windows) and `docker inspect --format "{{ "{{ .Node.IP " }}}}" letsencrypt-data` must match.

If you see an error message instead of your `index.html` file:

* Check the NGINX container's logs for error messages with `docker logs my-nginx`.
* If necessary, increase the logging level of NGINX by adding the following line to your `default.conf`:

    ```
    error_log /var/log/nginx/error.log info;
    ```

If the cron job does not run correctly and your certificate expires:

* Check the cron container's logs with `docker logs my-cron`.
* If necessary, increase the logging level of cron by changing the `CMD` line in the Dockerfile to:

    ```
    CMD ["/usr/bin/crond", "-f", "-d", "0"]
    ```

For general Carina problems, see [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

If you already have a site or a service that's listening for HTTP and you want to add Let's Encrypt-powered TLS as easily as possible, check out [the lets-nginx container]({{ site.baseurl }}/blog/push-button-lets-encrypt/).

For a deeper introduction to data volume containers, read [the data volume container tutorial]({{ site.baseurl }}/docs/tutorials/data-volume-containers/).