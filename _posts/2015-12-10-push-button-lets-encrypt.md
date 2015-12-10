---
layout: post
title: "Push Button, Let's Encrypt"
date: 2015-12-10
comments: true
author: Ash Wilson <ash.wilson@rackspace.com>
authorIsRacker: true
published: true
excerpt: >
  An experiment to employ Let's Encrypt to serve any existing HTTP service over HTTPS with one docker command.
categories:
- Encryption
- TLS
- SSL
- Docker
- letsencrypt
- Carina
- News
- Security
---

When [Let's Encrypt](https://letsencrypt.org/) went into public beta, I was curious to see how much farther I could lower the barrier to securing a service with strong TLS. The answer so far: [a single `docker run` command](https://github.com/smashwilson/lets-nginx).

```bash
docker run --detach \
  --name lets-nginx \
  --link backend:backend \
  --env EMAIL=my@email.com \
  --env DOMAIN=mydomain.io \
  --env UPSTREAM=backend:8080 \
  --publish 80:80 \
  --publish 443:443 \
  smashwilson/lets-nginx
```

This container will invoke the [letsencrypt client](https://github.com/letsencrypt/letsencrypt) to issue a browser-trusted certificate valid for your domain. Then, it'll template a basic nginx configuration, a cronjob to re-issue the certificates monthly, and launch the crond and nginx daemons. Your service will have a green lock in browsers and an A+ score from [SSL Labs](https://www.ssllabs.com/ssltest/).

![only the finest locally-source artisanal TLS]({% asset_path 2015-12-10-push-button-lets-encrypt/ssllabs.jpeg %})

Some caveats before we begin: some encryption is a great improvement on no encryption, and TLS certificates signed by a trusted CA are more secure than self-signed ones, but trusting crypto in a container you download from strangers on the Internet does carry risks. I'm no security expert, but offhand I'd give this approach one and a half tin-foil hats out of five.

<img src="{% asset_path tinfoil.png %}" alt="one hat" style="display: inline;">
<img src="{% asset_path tinfoil-half.png %}" alt="half hat" style="display: inline;">
<img src="{% asset_path tinfoil-empty.png %}" alt="empty hat" style="display: inline;">
<img src="{% asset_path tinfoil-empty.png %}" alt="empty hat" style="display: inline;">
<img src="{% asset_path tinfoil-empty.png %}" alt="empty hat" style="display: inline;">

Furthermore, because this approach is automated, it uses the `--agree-tos` flag to accept the Let's Encrypt terms of service on your behalf. Be sure that you're okay with [the terms](https://letsencrypt.org/repository/) before you run the container.

## Get Encrypted

Before you get started, you will need:

 1. [A Carina cluster]({{ site.baseurl }}/docs/getting-started/getting-started-on-carina/) up, running and connected. It'll be easier if your cluster only has a single segment because the container's public IP will be predictable. Otherwise, you'll need to fiddle around with Swarm affinities.
 2. A domain name you own with a DNS A record pointing to your cluster's public IP.
 3. Any backend service that talks HTTP running in a Docker container on your cluster. I have a [Sinatra test service](https://github.com/smashwilson/minimal-sinatra) that's handy for iterating on infrastructure like this. Make a note of the container's name. It **does not** need to be listening on a public port; in fact, it's better if it isn't, because then you can funnel all traffic through the secure entrypoint instead.

Now launch the `lets-nginx` container with the command-line options I showed above. Here's what they all mean:

 * `--detach` runs the container in the background rather than taking over your terminal.
 * `--link <backend>:<backend>`, given the name of your backend service's container, configures iptables on the host to permit traffic between the two containers, and adds an `/etc/hosts` entry within the lets-nginx container that points to your backend.
 * `--env EMAIL=<your email address>` will be used to associate your Let's Encrypt requests with [a registered account](https://community.letsencrypt.org/t/anonymous-registrations/5213/5). You don't need to set this up anywhere ahead of time; Let's Encrypt will handle that automatically when you request your first certificate.
 * `--env DOMAIN=<domain name>` tells letsencrypt and nginx what domain you're using.
 * `--env UPSTREAM=<backend>:<service port>` tells nginx to forward traffic to the right container and port.
 * `--publish 80:80` and `--publish 443:443` bind public ports 80 and 443 to the same ports within the lets-nginx container. These *must* be specified exactly as-is, because Let's Encrypt uses those ports to verify domain ownership.

Additionally, you may wish to specify a few extra flags:

 * `--env STAGING=1` will use the Let's Encrypt *staging server* instead of the production one. I highly recommend using this option to double check your infrastructure before you launch a real service. Let's Encrypt rate limits the production server to issuing [five certificates per domain per seven days](https://community.letsencrypt.org/t/public-beta-rate-limits/4772/3), which (as I discovered the hard way) you can quickly exhaust debugging unrelated problems!
 * `--name <name>` is an optional flag that'll make the container easier to spot in your `docker ps` output.

Once that's running, give the container a minute to start. You can watch its progress with `docker logs -f <name>` if you wish. Once you see nginx launch, your HTTPS service is live. Try visiting it with your browser!

![just look at that sweet green lock]({% asset_path 2015-12-10-push-button-lets-encrypt//greenlock.jpeg %})

## How It Works

The [lets-nginx Dockerfile](https://github.com/smashwilson/lets-nginx/blob/master/Dockerfile) is based on [Alpine](http://www.alpinelinux.org/), a Linux micro-distribution. I've been using Alpine recently to keep my container images small and tidy.

The Dockerfile begins by using `apk`, Alpine's package manager, to install nginx and all of the letsencrypt client's system dependencies, then uses `pip` to install letsencrypt itself.

```
FROM alpine:3.2

RUN apk add --update nginx \
  python python-dev py-pip \
  gcc musl-dev linux-headers \
  augeas-dev openssl-dev libffi-dev ca-certificates dialog \
  && rm -rf /var/cache/apk/*

RUN pip install -U letsencrypt
```

Next, it creates symlinks for nginx's log files, so that nginx output will appear in `docker logs`. It also creates a directory beneath `/etc/letsencrypt` to use as a webroot. We'll use this later to renew our certificates through nginx.

```
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# used for webroot reauth
RUN mkdir -p /etc/letsencrypt/webrootauth
```

All of the container setup work is done by a shell script. The Dockerfile puts it at the root of the container's filesystem and sets it as the entrypoint.

```
ADD entrypoint.sh /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
```

The [`entrypoint.sh` script](https://github.com/smashwilson/lets-nginx/blob/master/entrypoint.sh) does most of the more interesting steps.

After validating the environment variable configuration, it generates [strong Diffie-Helman parameters](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html), a step that's necessary to get that A+. This step does cause a substantial delay during the container's launch. If you wish, you can pregenerate these elsewhere and mount them into the container with a volume.

```bash
# Generate strong DH parameters for nginx, if they don't already exist.
[ -f /etc/ssl/dhparams.pem ] || openssl dhparam -out /etc/ssl/dhparams.pem 2048
```

The nginx configuration is templated as a bash heredoc. `${UPSTREAM}` and `${DOMAIN}` are used to populate a few relevant directives. The static parts of the configuration include the SSL setup, assembled with guidance from SSL Labs documentation and some trial and error; a path with a webroot within `/etc/letsencrypt` to support certificate reissuance; and a redirect from port 80 to 443. (It's a bit long, so I'm not going to paste the [full thing](https://github.com/smashwilson/lets-nginx/blob/master/entrypoint.sh#L29-L89) here.)

```bash
# Template an nginx.conf
cat <<EOF >/etc/nginx/nginx.conf
user nobody;
worker_processes 2;

# ...
# Point to letsencrypt's latest issued TLS certificate chains

ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
ssl_dhparam /etc/ssl/dhparams.pem;

# ...
# Act as a reverse proxy to the service at ${UPSTREAM}

location / {
  proxy_pass http://${UPSTREAM};
  proxy_set_header Host \$host;
  proxy_set_header X-Forwarded-For \$remote_addr;
}

# ...
# Pass the ACME challenge from letsencrypt to a directory within the container

location /.well-known/acme-challenge {
  alias /etc/letsencrypt/webrootauth/.well-known/acme-challenge;
  location ~ /.well-known/acme-challenge/(.*) {
    add_header Content-Type application/jose+json;
  }
}
EOF
```

With that in place, it uses the letsencrypt client to perform the actual certificate request. Because nginx isn't running yet, we can use the *standalone* authenticator plugin, which binds to port 80 for the handshake.

```bash
# Initial certificate request
letsencrypt certonly \
  --domain ${DOMAIN} \
  --authenticator standalone \
  ${SERVER} \
  --email "${EMAIL}" --agree-tos
```

Certificates issued by Let's Encrypt are only valid for 90 days. To keep the cert up to date and valid, the script templates a cron job that'll perform the reissuance once a month. The generated script is placed in [Alpine's `/etc/periodic` directory](http://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#My_cron_jobs_don.27t_run.3F). Notice that the cron script uses the *webroot* authenticator this time, and a `--webroot-path` that corresponds to the path that's mapped in the nginx configuration above.

```bash
cat <<EOF >/etc/periodic/monthly/reissue
#!/bin/sh
set -euo pipefail
# Certificate reissue
letsencrypt certonly --renew-by-default \
  --domain "${DOMAIN}" \
  --authenticator webroot \
  --webroot-path /etc/letsencrypt/webrootauth/ ${SERVER} \
  --email "${EMAIL}" --agree-tos
# Reload nginx configuration to pick up the reissued certificates
/usr/sbin/nginx -s reload
EOF
chmod +x /etc/periodic/monthly/reissue
```

With that in place, everything's ready to go! All that's left to do is kick off the `crond` and `nginx` processes. (`crond` is launched as a background process with `&` rather than the `-b` flag so that its stdout and stderr are also visible in `docker logs`.)

```bash
# Kick off cron to reissue certificates as required
# Background the process and log to stderr
/usr/sbin/crond -f -d 8 &

# Launch nginx in the foreground
/usr/sbin/nginx -g "daemon off;"
```

## Limitations

This is an experiment I cobbled together in a few days out of my own curiosity, so don't roll it into your production architecture! Specifically, it has a few significant limitations that you should be aware of.

**You can't easily use it for services that live behind a load balancer.** If you want to horizontally scale your web heads and distribute them across multiple segments, this won't help you. You'll need to find a different mechanism that will request the certificate *once* and share it among

**It requires the dedicated use of ports 80 and 443.** You can only run one domain and service per segment, and it needs to run on 80 and 443.

**It doesn't provide an easy way to back up your issued certificates and credentials.** A better approach is to [store your credentials on a volume]({{ site.baseurl }}/blog/weekly-news-docker-sock-letsencrypt/#let-39-s-encrypt-with-free-certificates) that you can manage separately, back up, and mount to multiple containers as you wish.

**The nginx configuration doesn't handle websockets or server-sent events.** These special cases would require custom `nginx.conf` wrangling, so you'd have to build your own image.

If you have suggestions to improve it, or better nginx-fu than I do, [pull requests are welcome!](https://github.com/smashwilson/lets-nginx)
