---
title: Public Key Infrastructure for your services
author: Kyle Kelley <kyle.kelley@rackspace.com>
date: 2016-04-05
permalink: docs/tutorials/public-key-infrastructure/
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

⚠️ WARNING: This tutorial can not possibly cover all facets of encryption and is not guaranteed to be 100% accurate. Since we don't want to advocate cryptography abstinence, we err on the side of providing as much information, knowledge, and background for you to start your journey in securing your corner of the web. Pull requests are welcome as are issues to help peer review the content. ⚠️

### Prerequisites

* Local Docker (for generating certs)
* OS X or Linux
* node.js
* Go (optional, if you want to try an alternative server)

### Quick mode


The examples for this tutorial are [available on GitHub as rgbkrk/pki-examples](https://github.com/rgbkrk/pki-examples), complete with scripts that automate the whole thing. Feel free to clone https://github.com/rgbkrk/pki-examples to run through this tutorial straight from source.

### Set up your build environment

### Generating certificates

We need to create certificates in a particular order. The first set we'll create
is the Certificate Authority. After that we'll create a server cert + key
followed by a client cert + key.

To make this simpler, we'll be using the `cloudpipe/keymaster` image, though you
can run the OpenSSL commands within keymaster's scripts directly.

We're going to be writing certificates to a local directory, so you'll want to
use your local Docker client. Make sure your `$DOCKER_HOST` is running locally and then we can kick this off. We need a place to store certificates and we'll
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

### TLS over raw TCP sockets

Now that we have the certificates all set up, we can create a simple client and
server. Node.js makes the options setup fairly easy.

`raw-tcp/server.js`:

```js
const tls = require('tls');

const options = {
  key: process.env.SERVER_KEY,
  cert: process.env.SERVER_CERT,
  ca: process.env.CA,
  requestCert: true,
  rejectUnauthorized: true,
};

const server = tls.createServer(options, (socket) => {
  console.log('server connected',
            socket.authorized ? 'authorized' : 'unauthorized');
  socket.write('Echo server\r\n');
  socket.pipe(socket);
});

server.listen(27001, () => {
  console.log('listening on 27001');
});
```

`raw-tcp/cli.js`:

```js

const tls = require('tls');

const options = {
  host: '127.0.0.1',
  port: 27001,
  key: process.env.CLIENT_KEY,
  cert: process.env.CLIENT_CERT,
  ca: process.env.CA,
  rejectUnauthorized: true,
};

const socket = tls.connect(options);

socket.on('secureConnect', () => {
  console.log('client connected',
              socket.authorized ? 'authorized' : 'unauthorized');
  process.stdin.pipe(socket);
  process.stdin.resume();
});

socket.setEncoding('ascii');
socket.on('data', (data) => {
  console.log('response', data);
});

socket.on('end', () => {
  console.log('THE END');
});
```

In both cases, the options object is very similar. We specify a `key`, `cert`,
and `ca`. They both receive the contents of `certificates/ca.pem` (not the CA key).

The important piece for strict PKI based authentication are these two options:

* `requestCert` - the server will request a certificate from clients that connect and attempt to verify the certificate
* `rejectUnauthorized` - the server will reject any connection which is not authorized with the configured CA. For the client, the server certificate is verified against the list of supplied CAs.

The net effect here is that *only* valid clients can connect to the server. All others are rejected.

Let's go ahead and run these each in a separate terminal.

```
$ source certs.env
$ node raw-tcp/server.js
listening on 27001
```

```
$ source certs.env
$ node raw-tcp/cli.js
client connected authorized
response Echo server

Hello
response Hello

It's me
response It's me

I was wondering if after all these years
response I was wondering if after all these years
```


### Now for HTTPS!

`https/cli.js`:

```js
const https = require('https');

const options = {
  host: '127.0.0.1',
  port: 27001,
  key: process.env.CLIENT_KEY,
  cert: process.env.CLIENT_CERT,
  ca: process.env.CA,
  rejectUnauthorized: true,

  path: '/',
  agent: false,
};

https.get(options, (res) => {
  console.log('statusCode: ', res.statusCode);
  console.log('headers: ', res.headers);

  res.on('data', (d) => {
    process.stdout.write(d);
  });
});
```

`https/server.js`:

```js
const https = require('https');

const options = {
  key: process.env.SERVER_KEY,
  cert: process.env.SERVER_CERT,
  ca: process.env.CA,
  requestCert: true,
  rejectUnauthorized: true,
};

const server = https.createServer(options, (req, res) => {
  res.writeHead(200);
  res.end('hello world\n');
});

server.listen(27001, () => {
  console.log('listening on 27001');
});
```

Notice the difference between the raw TLS sockets we setup and the HTTPS options here. You'll notice that they're pretty much the same. You can use the same type of PKI setup whether you're using raw TCP sockets
or HTTPS.

<!-- TODO

### Deployment

Let's now take a simple case of running a remote server with a local client that
can issue API requests. We'll use the same certificates for this while provisioning
the server onto a remote Docker Swarm cluster.

-->

### Troubleshooting

For additional assistance, ask the [community](https://community.getcarina.com/) for help, or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Node.js TLS Documentation](https://nodejs.org/api/tls.html)
* [Node.js HTTPS Documentation](https://nodejs.org/api/https.html)

### Next steps

In the future you're going to want to handle key revocation, issuing new certificates, as well as your strategy for provisioning both certificates and the servers themselves.
