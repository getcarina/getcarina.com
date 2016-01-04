---
title: "Fallout 4 Service Discovery and Relay"
date: 2015-11-20 18:00
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  Take apart the pip boy app, discover running Fallout 4 games, and relay traffic with
  a bit of Node.js, TCP, and UDP.
categories:
 - nodejs
 - TCP
 - UDP
 - networking
 - relay
 - Fallout 4
authorIsRacker: true
---

This week's post is fairly off-topic, dealing only slightly with some old school
service discovery on a new game that was released. I'll touch on investigating
ports and protocols from an unknown server, using UDP broadcast to find services,
running TCP and UDP relays, and digging into some binary streams.

Like many people this past week, I purchased a game I've been waiting a long
time for: Fallout 4. Like its predecessors, Fallout 4 has you leaving a Fallout
shelter called a vault with only your vault suit and a device on your arm called
a pip boy.

![put a pip in your step]({% asset_path 2015-11-20-fallout-4/pipboy-arm.jpg %})

This time the developers, Bethesda, gave us a wonderful companion app
that gives you remote access to your pip boy. You can navigate the map, view
your inventory, change weapons, and fast travel. It's slick!

After discovering my running PS4, I immediately thought:

> "Hey, how are they discovering the game on my network?"

The first thing I did was scan my network to see where my PS4 was and what servers were listening, using `nmap`.

```
$ nmap 192.168.1.*
Nmap scan report for unknown0CFE45340EE1 (192.168.1.71)

Starting Nmap 6.47 ( http://nmap.org ) at 2015-11-19 22:20 CST
...
Host is up (0.00056s latency).
Not shown: 999 closed ports
PORT      STATE SERVICE
27000/tcp open  flexlm0
...
```

Armed with that, I could tell there's a TCP server running on 27000.

```
$ curl 192.168.1.71:27000
#{"lang":"en","version":"1.1.21.0"}
```

Whoa. HTTP worked. Sadly, without knowing about any REST endpoints, we have **no**
idea what else can be reached.

The pip boy app can't possibly know the IP address for my PS4 though, so it must be running another service to allow others to discover itself. Excited by the prospect of getting data out of this app, my fellow Jupyter developer [Jon Frederic](https://github.com/jdfreder) got some great packet captures that showed what the discovery protocol looks like as well as some of the TCP dump.

Running the scan for consoles from the mobile app while sniffing traffic was enough to see a UDP payload sent from the mobile phone to the broadcast address (255.255.255.255) on port 28000:

```json
{
  "cmd" : "autodiscover"
}
```

as well as the server's response:

```json
{
   "IsBusy" : false,
   "MachineType" : "PS4"
}
```

Service discovery at its simplest.

If you install `socat`, you can do this yourself directly:

```bash
echo '{"cmd":"autodiscover"}' | \
  socat - UDP-DATAGRAM:255.255.255.255:28000,broadcast
```

Perfect, we now know the Fallout 4 server has at least two servers listening: UDP on port 28000 and TCP on port 27000. We don't know the protocol though, so we're going to need to see more legitimate traffic from the pip boy to the console. We can continue on doing more sniffing of traffic, poisoning ARP to do MITM, or we can write a relay. I opted for the last one which I'll explain here.

## Ripping data with a relay

The relay functions by establishing itself as another Fallout 4 server for
mobile apps to connect to, while actually sending packets on to the legitimate one.

![Close to Metal]({% asset_path 2015-11-20-fallout-4/close-to-metal.png %})

You can do this with tools like socat, but I opted to do this in Node.js for
reasons that will become clear later. If you want to skip down to using the
relay, go to [the pipboy relay](#the-pip-boy-relay).

### UDP relay

The relay we're going to write functions by acting as an intermediary between
a real client (the pip boy app) and the Fallout server. To do this, every time a
client connects to the relay, we'll create our own fake client to connect to the
real Fallout server. As the client and server communicate, we'll pass messages to
each while making a copy of the messages they send.

The first thing we'll do is open up our server side socket:

```javascript
var upstreamInfo = {
  address: YOUR_CONSOLE_OR_PC_IP
  port: 28000 // The Fallout 4 UDP Port
}

var server = dgram.createSocket('udp4')
server.bind(upstreamInfo.port, '0.0.0.0')
```

For every message that comes in, we're going to set up another socket to act as
the fake client. We'll then forward messages between the *actual server* and the pip
boy client.

```javascript
server.on('message', function (message, clientInfo) {
  var fakeClient = dgram.createSocket('udp4')
  // fakeClient.on('message', ...) // Defined below
  // fakeClient.bind(...)
})
```

The two parts commented out above are written out below with more detail. Each
time we get a message, we're going to copy it, note the telemetry data, send the
message on to the actual client, and provide the copied buffer and telemetry to
a callback.

```javascript
fakeClient.on('message', function (message, serverInfo) {
  var copiedBuffer = new Buffer(message.length)
  message.copy(copiedBuffer)

  // Now emulate our server
  server.send(message, 0, message.length, clientInfo.port, clientInfo.address)
  var telemetry = {
    'src': serverInfo,
    'dst': clientInfo
  }
  cb(copiedBuffer, telemetry)
})
```

Here's where we actually bind the client, do the same message copying, send the
message to the server, and propagate the data to the callback.

```javascript
// As soon as our client is ready, go ahead and send their message onward
fakeClient.bind(undefined, undefined, function () {
  var copiedBuffer = new Buffer(message.length)
  message.copy(copiedBuffer)

  fakeClient.send(message, 0, message.length, upstreamInfo.port, upstreamInfo.address)
  var telemetry = {
    'src': clientInfo,
    'dst': upstreamInfo
  }
  cb(copiedBuffer, telemetry)
})
```

### TCP relay

The setup for the TCP relay is similar. Here we'll create a `TCPRelay`
that has a `net.Server` underneath. The strongest difference here is that
we'll have to actually maintain all the fake clients that are being used

```javascript
/**
 * Create a TCP relay for an upstream server
 * @constructor
 */

/**
 * Listen for traffic to relay to/from an upstream server
 * @param {Object} upstreamInfo
 * @param {string} upstreamInfo.address
 * @param {number} upstreamInfo.port
 * @param {relayCallback} - callback that handles new data
 */
var TCPRelay = function TCPRelay () {
  this.server = net.createServer({'allowHalfOpen': true})
}
```

We'll slightly imitate `net.Server.listen` by providing `TCPRelay.listen`, taking
the net info structure that is used with the UDP layer.

```javascript
TCPRelay.prototype.listen = function listen (upstreamInfo, cb) {
  this.server.on('connection', function (client) {
    // Now we create our fake client
    var fakeClient = new net.Socket()
    fakeClient.connect(upstreamInfo.port, upstreamInfo.address)

    // Get the actual client info for logging where the traffic really came from
    var actualClientInfo = {}
    actualClientInfo.address = client.remoteAddress
    actualClientInfo.port = client.remotePort
    actualClientInfo.family = client.remoteFamily  

    // Register handlers for the fakeClient
    // These each get explained below but should be inserted here

    // fakeClient.on('connect', function() { ... })
    // fakeClient.on('data', function() { ... })
    // fakeClient.on('close', function() { ... })
    // fakeClient.on('end', function() { ... })
  })
  this.server.listen({'port': upstreamInfo.port})
}
```

After the `fakeClient` is connected, we're ready to register the handler for data
from the `client`. We'll send data on from `client` to the `fakeClient`, which
sends it on to the Fallout 4 server.

```javascript
fakeClient.on('connect', function () {
  // Once we're connected, we can get each message from the client
  client.on('data', function (message) {
    var copiedBuffer = new Buffer(message.length)
    message.copy(copiedBuffer)

    // To the server
    fakeClient.write(message)

    var serverInfo = {}
    serverInfo.address = fakeClient.remoteAddress
    serverInfo.port = fakeClient.remotePort
    serverInfo.family = fakeClient.remoteFamily

    var telemetry = {
      'src': actualClientInfo,
      'dst': serverInfo
    }

    cb(copiedBuffer, telemetry)
  })
})
```

Every time the `fakeClient` receives data, it's coming from the Fallout 4 server
and we send it on to the real client.

```javascript
fakeClient.on('data', function (message) {
  var copiedBuffer = new Buffer(message.length)
  message.copy(copiedBuffer)

  var serverInfo = {}
  serverInfo.address = fakeClient.remoteAddress
  serverInfo.port = fakeClient.remotePort
  serverInfo.family = fakeClient.remoteFamily

  var telemetry = {
    'src': serverInfo,
    'dst': actualClientInfo
  }
  client.write(message)

  cb(copiedBuffer, telemetry)
})
```

We should also handle closing the `fakeClient` as well as the `client` on the
other side. Remembering that we need to mirror operations directly, we'll do
the same for ending the clients, too.

```javascript
fakeClient.on('close', function (hadError) {
  if (hadError) {
    console.log('closure error')
  }
  client.close()
})

fakeClient.on('end', function () {
  client.end()
})
```

## Putting the pieces together

Now we have a `TCPRelay` and a `UDPRelay`. Taking these and autodiscovering a
running server, we can make a nice little tool.

### Libraries

I've wrapped the relays and autodiscovery into a couple packages:

* [pipboylib](https://github.com/RobCoIndustries/pipboylib)
* [pipboyrelay](https://github.com/rgbkrk/pipboyrelay)

The second one, `pipboyrelay`, is a CLI tool that you can use to dump data
yourself that relies on `pipboylib`.

### The pip boy relay

You can run the relay directly yourself if you have a few things:

* Fallout 4 for the PC or PS4. (XBONE has not been diagnosed)
* The pip boy app for Android or iOS
* The pip boy app enabled in-game on Fallout 4
* Node.js and npm

With Node.js and `npm` set up you can install `pipboyrelay` as a CLI tool:

```
npm install -g pipboyrelay
```

Now run the `pipboyrelay` at the command line:

```
$ pipboyrelay
Discovered:  { IsBusy: false,
  MachineType: 'PS4',
  info: { address: '192.168.1.71', family: 'IPv4', port: 28000, size: 50 } }
```

It will autodiscover any games running with an active server on your local
network and create its own endpoints that the Android or iOS app will recognize.
Open up the mobile app and navigate to the connection settings screen.

![One of these things is not like the other]({% asset_path 2015-11-20-fallout-4/two-ps4s.png %})

One of these things is not like the other! Connect to the address that was not
shown in the discovery. You should start seeing data fly by.

```
UDP and TCP Relay created for:  { address: '192.168.1.71', family: 'IPv4', port: 28000, size: 50 }
listening
[TCP Relay] 192.168.1.71:27000 -> ::ffff:192.168.1.67:55232
00000000: 2300 0000 017b 226c 616e 6722 3a22 656e  #....{"lang":"en
00000010: 222c 2276 6572 7369 6f6e 223a 2231 2e31  ","version":"1.1
00000020: 2e32 312e 3022 7d0a                      .21.0"}.

[TCP Relay] 192.168.1.71:27000 -> ::ffff:192.168.1.67:55232
00000000: 754e 0600 0306 5290 0f00 2447 656e 6572  uN....R...$Gener
00000010: 616c 0003 6290 0f00 1e00 0000 0661 900f  al..b........a..
00000020: 004c 6f63 6174 696f 6e73 2044 6973 636f  .Locations.Disco
...
[TCP Relay] 192.168.1.71:27000 -> ::ffff:192.168.1.67:55232
00000000: 7565 002d 910f 0074 6578 7400 2f91 0f00  ue.-...text./...
00000010: 7368 6f77 4966 5a65 726f 0000 0003 3291  showIfZero....2.
00000020: 0f00 0000 0000 0631 910f 0046 6974 7320  .......1...Fits.
...
```

Interesting! Look at byte 0x18 (0x1e), occurring right before
"Locations Discovered".

```
[TCP Relay] 192.168.1.71:27000 -> ::ffff:192.168.1.67:55232
00000000: 754e 0600 0306 5290 0f00 2447 656e 6572  uN....R...$Gener
00000010: 616c 0003 6290 0f00 1e00 0000 0661 900f  al..b........a..
------------------------------^^
00000020: 004c 6f63 6174 696f 6e73 2044 6973 636f  .Locations.Disco
```

That `0x1e` is the current number of locations discovered with the character I
used for this, 30.

It seems like the Fallout 4 format is a binary format and that's in plain text.
This is good news, because it will be easier to figure out the format and build
new things.

Run this relay while you explore the wasteland and you'll see your coordinates
scroll by in the relay output. Can you imagine mapping you and your friends
all together on one map?


## Vanilla stat dump

You don't really need all this code to get your current stats though. On OS X
and Linux, you can use `nc` (netcat) directly to get all your stats from your
console or PC.

```
$ nc 192.168.1.71 27000 | xxd | head -n 16
00000000: 2300 0000 017b 226c 616e 6722 3a22 656e  #....{"lang":"en
00000010: 222c 2276 6572 7369 6f6e 223a 2231 2e31  ","version":"1.1
00000020: 2e32 312e 3022 7d0a 59f0 0600 0306 81cc  .21.0"}.Y.......
00000030: 1e00 2447 656e 6572 616c 0003 91cc 1e00  ..$General......
00000040: 2200 0000 0690 cc1e 004c 6f63 6174 696f  "........Locatio
00000050: 6e73 2044 6973 636f 7665 7265 6400 0092  ns Discovered...
00000060: cc1e 0001 088f cc1e 0003 0091 cc1e 0076  ...............v
00000070: 616c 7565 0090 cc1e 0074 6578 7400 92cc  alue.....text...
00000080: 1e00 7368 6f77 4966 5a65 726f 0000 0003  ..showIfZero....
00000090: 95cc 1e00 0400 0000 0694 cc1e 004c 6f63  .............Loc
000000a0: 6174 696f 6e73 2043 6c65 6172 6564 0000  ations Cleared..
000000b0: 96cc 1e00 0108 93cc 1e00 0300 95cc 1e00  ................
000000c0: 7661 6c75 6500 94cc 1e00 7465 7874 0096  value.....text..
000000d0: cc1e 0073 686f 7749 665a 6572 6f00 0000  ...showIfZero...
000000e0: 0399 cc1e 000a 0000 0006 98cc 1e00 4461  ..............Da
000000f0: 7973 2050 6173 7365 6400 009a cc1e 0001  ys Passed.......
... more data ...
```

## Wrap up

We've done several things here.

* Found our running servers from Fallout 4
* Spoofed a Fallout 4 server, complete with being discoverable
* Dumped traffic from our relay

In a follow on post, I'll show you how to send your stats on to a remote server
for others to view. We can share our levels, our wasteland locations,
number of caps, and anything else we can decode.

Install `pipboyrelay` yourself or just use `nc` to explore. I'm really excited to
create mashups with this. Feel free to discuss your findings on the repository
for the [pip boy library](https://github.com/RobCoIndustries/pipboylib),
the [pipboyrelay](https://github.com/rgbkrk/pipboyrelay), or even on
[this blog](https://github.com/getcarina/getcarina.com).

If you're looking for libraries for your favorite language, check out the [follow
up post about the libraries that are available as well as some work in progresses](https://getcarina.com/blog/decoding-the-pipboy-database-with-vault-community/).

Follow me on Twitter [@rgbkrk](https://twitter.com/rgbkrk) to get more updates!
