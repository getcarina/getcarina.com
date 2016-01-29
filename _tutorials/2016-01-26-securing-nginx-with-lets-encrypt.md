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

This tutorial describes acquiring free TLS certificates from [Let's Encrypt](https://letsencrypt.org/) and using them to secure a web site served using [NGINX](http://nginx.org/en/docs/). This encrypts all traffic to and from your site with a certificate that's trusted by your browser and strong enough encryption to get an "A+" rating from [SSL Labs](https://www.ssllabs.com/ssltest/).

### Prerequisites

Before you begin, you'll need to be able to [create and connect to a Carina cluster.]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/) You'll need at least one segment with ports 80 and 443 available.

You'll also need to own a domain name and know how to create DNS records. Consult with your domain registrar for documentation on how to do this.

### Steps

1. Create a data volume container to hold the letsencrypt certificates and account information.

    A data volume container is a container that exists only to house a Docker volume. It's usually implemented as a container whose process terminates immediately. To learn more, read the [data volume container tutorial]({{ site.baseurl }}/docs/tutorials/data-volume-containers/).

    ```bash
    $ docker run \
      --name letsencrypt-data \
      --volume /etc/letsencrypt \
      --volume /var/lib/letsencrypt \
      --entrypoint /bin/echo \
      quay.io/letsencrypt/letsencrypt
    ```

1. Generate [strong Diffie-Hellman parameters](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html#Forward_Secrecy_&_Diffie_Hellman_Ephemeral_Parameters) and store them within your data volume container. These will prevent NGINX from using weaker parameters while negotiating the initial TLS connection, and are necessary to reach that "A+" rating on SSL labs.

    ```bash
    $ docker run \
      --rm --interactive --tty \
      --volumes-from letsencrypt-data \
      nginx \
      openssl dhparam -out /etc/letsencrypt/dhparams.pem 2048
    ```

    This will take several minutes to complete.

1. Add a DNS "A" record to your domain pointing to the public IP address of your cluster's segment.

    Even if your cluster has multiple segments, all of your containers will be running on the same segment as the data volume container you just created. To find its public IP address, run:

    ```bash
    $ docker inspect --format "{{ .Node.IP }}" letsencrypt-data
    ```

    Add an "A" record from your domain pointing to this address. If your domain had previously been pointing elsewhere, you may need to wait for the new DNS entry to propagate before you can use it. You can determine when the entry is ready be checking:

    **Mac OS X and Linux**

    ```bash
    $ dig +short <myDomain>
    ```

    **Windows**

    ```powershell
    > nslookup <myDomain>
    ```

1. Run a Let's Encrypt container to issue a new certificate. The Let's Encrypt client must be able to bind to ports 80 and 443 on the segment.

    Notice that running this container will automatically accept the Let's Encrypt [terms of service](https://letsencrypt.org/repository/) on your behalf. Be sure that you're okay with accepting them before you run this!

    The `--server` parameter below will issue certificates from Let's Encrypt's *staging* server, which means that these certificates won't be browser-valid yet. Let's Encrypt rate-limits certificate issuance to [five certificates per domain per seven days](https://community.letsencrypt.org/t/public-beta-rate-limits/4772/3), so it's a good idea to use staging certificates until you're confident that your infrastructure works the way you want it to. When you're ready to go live, omit the `--server` parameter from this step to get a production certificate.

    ```bash
    $ docker run \
      --rm \
      --volumes-from letsencrypt-data \
      --publish 443:443 \
      --publish 80:80 \
      quay.io/letsencrypt/letsencrypt auth \
      --server https://acme-staging.api.letsencrypt.org/directory \
      --domain <myDomain> \
      --authenticator standalone \
      --email <myEmail> \
      --agree-tos
    ```

    The `--server` parameter will issue certificates from Let's Encrypt's *staging* server, which means that the certificates won't be browser-valid. Let's Encrypt rate-limits certificate issuance to [five certificates per domain per seven days](https://community.letsencrypt.org/t/public-beta-rate-limits/4772/3).

1. Build an NGINX container that terminates TLS with the issued certificates and Diffie-Helman parameters.
1. Build a `cron` container that will periodically renew your TLS credentials before they expire.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

<!--
* Links to related content
-->

### Next step

<!--
* What should your audience read next?
-->
