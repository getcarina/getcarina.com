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
* [Create and connect to a cluster](/docs/tutorials/create-connect-cluster/)
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

We're going to be writing 


### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help, or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources


### Next steps
