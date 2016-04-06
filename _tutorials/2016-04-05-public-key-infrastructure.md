---
title: Public Key Infrastructure for your services
author: Kyle Kelley <kyle.kelley@rackspace.com>
date: 2016-04-05
permalink: docs/tutorials/backup-restore-data/
description: >
  Learn how to set up your own public key infrastructure and strictly connect
  between services.
topics:
  - node
  - go
  - PKI
  - encryption
---

This tutorial explains how to set up Public Key Infrastructure (PKI) for
deployed services and how to connect clients and servers in a few common
languages. The end game is to connect a server and a client (which can also be
a service itself).

<!-- TODO: show picture of ENDPOINT1 --- ENDPOINT2 -->

<!-- TODO: Show picture of CA, client key+cert --- server key + cert -->

⚠️ WARNING: This tutorial can not possibly cover all facets of encryption and is not guaranteed to be 100%. Since we don't want to advocate cryptography abstinence, we err on the side of providing as much information, knowledge, and background for you to start your journey in securing the web. Pull requests are welcome as are issues to help peer review the content. ⚠️

### Prerequisites

* Local Docker (for generating certs)
* OS X or Linux
* node.js
* Go (optional, if you want to try an alternative server)

### Quick mode


The examples for this tutorial are [available on GitHub as rgbkrk/pki-examples](https://github.com/rgbkrk/pki-examples), complete with scripts to automate the whole thing. Feel free to clone https://github.com/rgbkrk/pki-examples to run through this tutorial straight from source.

### Set up your build environment

### Generating certificates

We need to create certificates in a particular order. The first set we'll create
is the Certificate Authority. After that we'll create a server cert + key
followed by a client cert + key.

To make this simpler, we'll be using the `cloudpipe/keymaster` image, though you
can run the OpenSSL commands within keymaster's scripts directly yourself.

We're going to be writing certificates to a local directory, so you'll want to
use your local Docker client. Make sure your `$DOCKER_HOST` is running locally  and then we can kick this off. We need a place to store certificates and we'll
want a password for the CA.

```
mkdir -p certificates

touch certificates/password
chmod 600 certificates/password
```

With `./certificates` ready to receive a password, we'll go ahead and create a random string for the password:

```
cat /dev/random | head -c 128 | base64 > certificates/password
```

If you rewound this tutorial, you'll want to make sure to clean out *.csr, *.pem, and *.srl out of the certificates folder before proceeding.


Now, let's make keymaster easy to use for scripting:

```
export KEYMASTER="docker run --rm -v $(pwd)/certificates/:/certificates/ cloudpipe/keymaster"
```

First, generate the CA using `${KEYMASTER} ca`:

```
${KEYMASTER} ca
```

The output should look like:

```
[>>] Generating a CA certificate.
Generating RSA private key, 2048 bit long modulus
......................................+++
..+++
e is 65537 (0x10001)
[<<] CA certificate generated.
```

Next we'll create the server cert and key

```
${KEYMASTER} signed-keypair -n server -h 127.0.0.1 -s IP:127.0.0.1 -p server
```

followed by a client cert and key

```
${KEYMASTER} signed-keypair -n client -h 127.0.0.1 -s IP:127.0.0.1 -p client
```

The arguments to `signed-keypair` are

* `-n` the name for the cert holder
* `-p` the purpose (client, server, or both)
* `-h` the hostname
* `-s` the alt name

### Sourcing the certificates

In following with the 12-factor app manifesto, we're going to provide the certificates
as environment variables. Go ahead and create a file called certs.env with the
following contents:

```bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/certificates"

export CLIENT_CERT=`cat $DIR/client-cert.pem`
export CLIENT_KEY=`cat $DIR/client-key.pem`
export SERVER_CERT=`cat $DIR/server-cert.pem`
export SERVER_KEY=`cat $DIR/server-key.pem`
export CA=`cat $DIR/ca.pem`
```

Now run `source certs.env`. You'll have all your certs set up as environment
variables for the rest of this tutorial.



### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help, or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources


### Next steps
