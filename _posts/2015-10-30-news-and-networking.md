---
title: "Weekly News, and Carina Networks"
date: 2015-10-30 11:30
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  Product launches are always fun! Especially when you're working on a launch timed across several timezones. I wanted to wrap up the week with some news, pointers and a note about how networking works with <a href="https://getcarina.com/">Carina</a>.
categories:
 - Docker
 - Swarm
 - Carina
 - Networking
 - News
authorIsRacker: true
---

### What a week

Product launches are always fun! Especially when you're working on a launch timed across several timezones. I wanted to wrap up the week with some news, pointers and a note about how networking works with [Carina].

A factoid!
<pre>
<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Fun fact: we considered Carina as one of the names for Kubernetes. Welcome Rackspace to the party! <a href="https://t.co/MdDW7z2PaO">https://t.co/MdDW7z2PaO</a></p>&mdash; Joe Beda (@jbeda) <a href="https://twitter.com/jbeda/status/659784803449860096">October 29, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</pre>

First up, let's cover a few things we uncovered during the launch:

* **SMS Account verification**: For a significant set of international numbers our SMS verification system was not functioning properly. We resolved an initial set of countries, but did not have full resolution until mid-day (CDT) on Wednesday. We followed up directly with every user who was affected by this issue, apologized and got them set up! We were posting live updates in the [community]
* **500 Errors on Community**: During launch night, we had a handful of errors with the [community] OAuth & back-end system. This caused users to get 500 errors or be unable to log in. All known issues using your [Carina] username (email address) and password have been resolved. If you continue to have issues please let us know via [GitHub]
* **Broken Control Panel Links**: Apparently I missed the memo that renaming files in GitHub can trigger the perma url in a jekyll system to change. The links to the tutorials in [https://app.getcarina.com](https://app.getcarina.com) have been fixed.
* **FAQ, other documentation fixes**: We had some missing or incorrect information on some of the [tutorials] and [FAQ](https://getcarina.com/docs/reference/faq/) that have been resolved. You can see the full pile of commits here but here are some highlights:
  * Updated: [Understanding how Carina uses Docker Swarm](https://getcarina.com/docs/concepts/docker-swarm-carina/)
  * Updated: [Getting Started on Carina](https://getcarina.com/docs/getting-started/getting-started-on-carina/)
  * Updated: [Frequently Asked Questions](https://getcarina.com/docs/reference/faq/)
  * New/Updated: [Autoscaling resources in Carina](https://getcarina.com/docs/reference/autoscaling-carina/)

### Where do I file bugs or provide feedback?

Ah! Glad you asked - it's really important for us to hear from users on bugs, feature requests, feedback positive & negative, etc.

* You can file bugs or feature requests for Carina on [GitHub]
* You can file doc issues or website requests on [GitHub as well](https://github.com/getcarina/getcarina.com/issues)
* Want to chat or give general feedback? Check our the [community] or join us in ```#carina``` on irc.freednode.net.
* You can see old IRC logs thanks to the amazing [BotBotMe](https://botbot.me/) team [here](https://botbot.me/freenode/carina/)  

### Now, for networking!

We're working on an official tutorial - but one of the most repeated pieces of feedback is "how do I do internal networking". We missed documenting this for launch time, but let's step through how you can get your stuff talking on the internal network.

First, understand that each node on Carina gets a public facing IP4 & IPv6 address:

```
$> carina credentials bob_ross
#
# Credentials written to "/Users/jesse/.carina/clusters/jesse.noller@rackspace.com/bob_ross"
#
source "/Users/jesse/.carina/clusters/jesse.noller@rackspace.com/bob_ross/docker.env"
# Run the command above to get your Docker environment variables set

$> source "/Users/jesse/.carina/clusters/jesse.noller@rackspace.
com/bob_ross/docker.env"
$> docker info
Containers: 3
Images: 2
Role: primary
Strategy: spread
Filters: affinity, health, constraint, port, dependency
Nodes: 1
 d8a15141-75cb-4a7e-acd1-298146da323f-n1: 104.130.22.185:42376
  └ Containers: 3
  └ Reserved CPUs: 0 / 12
  └ Reserved Memory: 0 B / 4.2 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
CPUs: 12
Total Memory: 4.2 GiB
Name: 9dfcc7b34139
$>
```

In this case, the IPv4 of the swarm host "bob_ross" is ```104.130.22.185``` - I can then fire off:

```
$> docker run -d -p 6379:6379 redis
0ab6d34ec3ef10bf72454c736d40652f68423caffd71f50576f507779acb770b
> docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
0ab6d34ec3ef        redis               "/entrypoint.sh redis"   14 seconds ago      Up 11 seconds       104.130.22.185:6379->6379/tcp   d8a15141-75cb-4a7e-acd1-298146da323f-n1/reverent_aryabhata
$>
```

And I have a redis container running on that IPv4 public address, port mapped to port 6379. This is cool, as it takes about 30 seconds, but really it's bad news bears to be running that on a public port / IP address when it really shouldn't be. The ```-p``` flag is what exposes it and from the official [Docker docs](https://docs.docker.com/reference/run#expose-incoming-ports) you can see that you could put this on the internal network:

```
-P=false   : Publish all exposed ports to the host interfaces
-p=[]      : Publish a container᾿s port or a range of ports to the host
               format: ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort | containerPort
               Both hostPort and containerPort can be specified as a range of ports.
               When specifying ranges for both, the number of container ports in the range must match the number of host ports in the range. (e.g., `-p 1234-1236:1234-1236/tcp`)
```

With Carina, we gain the power of the Rackspace public cloud - existing users of our cloud are familiar with the concept of ServiceNet - this is an internal, multi-tenant network you can use between individual cloud products, servers, etc. In the case of Carina we "inherit" the same ServiceNet construct which means your nodes (Swarm Hosts) get two IP address - the public IPv4 and an internal ServiceNet address. This allows you to have internal networking amongst containers / swarm hosts without exposing them publicly.

Since the information isn't readily apparent (we'll work on exposing it in the UI and CLI as we go) we have a small docker image / tool called "racknet/ip" (for now) that allows dumping the networking information for your swarm host:

```
$> source "/Users/jesse/.carina/clusters/jesse.noller@rackspace.
com/bob_ross/docker.env"
$> docker run --net=host racknet/ip --help
racknet public [ipv4|ipv6]
racknet service [ipv4|ipv6]

Examples:
          $ racknet public
          104.130.0.127

          $ racknet service ipv6
          fe80::be76:4eff:fe20:b452

Examples when run with Docker:
          $ docker run --net=host racknet/ip public
          104.130.0.127
```

So to get the ServiceNet ip address:

```
$> docker run --net=host racknet/ip service
10.176.226.219
```

And now, revisiting the original Redis setup I had earlier:

```
$> docker run --name redis -d -p 10.176.226.219:6378:6379 redis
af7e2c8cd6a1f1bc74ffb9d6d79c554eda6a2499b81f0e4388726196817595be
```
That told docker "run Redis; exposing HOSTIP:PORT:CONTAINERPORT" - I have to change the host port as 6379 is taken by the public Redis I had earlier:

```
$> docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                           NAMES
af7e2c8cd6a1        redis               "/entrypoint.sh redis"   24 seconds ago      Up 21 seconds       10.176.226.219:6378->6379/tcp   d8a15141-75cb-4a7e-acd1-298146da323f-n1/secret_redis
0ab6d34ec3ef        redis               "/entrypoint.sh redis"   2 hours ago         Up 2 hours          104.130.22.185:6379->6379/tcp   d8a15141-75cb-4a7e-acd1-298146da323f-n1/reverent_aryabhata
$>
```

So I ```docker kill 0ab6d34ec3ef``` which removes the Redis container, and do a simple telnet to confirm it's no longer exposed on the swarm host:

```
$> telnet 104.130.22.185 6379
Trying 104.130.22.185...
telnet: connect to address 104.130.22.185: Connection refused
telnet: Unable to connect to remote host
$> telnet 104.130.22.185 6378
Trying 104.130.22.185...
telnet: connect to address 104.130.22.185: Connection refused
telnet: Unable to connect to remote host
```

You can do a quick docker run of a light container image to do the same telnet sniff test:

```
$> docker run -it cirros sh
/ # telnet 10.176.226.219 6378
Console escape. Commands are:

 l	go to line mode
 c	go to character mode
 z	suspend telnet
 e	exit telnet
#
```

There ya go; this means as you add nodes / containers / etc you can communicate via ServiceNet or use normal inter-container networking patterns:

* [Docker networking basics]({{ site.baseurl }}/docs/concepts/docker-networking-basics/)
* [Connect containers with Docker links]({{ site.baseurl }}/docs/tutorials/connect-docker-containers-with-links/)

We're going to fix up / move the "ip" Docker image into the Carina repo, and add full documentation for ServiceNet usage first thing next week!

**Update:** Full documentation on [Communication between containers over the internal network ServiceNet]({{ site.baseurl }}/docs/tutorials/servicenet/)

Have a good weekend.

**Note:** Yes - to existing Rackspace Cloud customers, this means you can use ServiceNet to connect to other cloud products in our portfolio.

[carina]: https://getcarina.com
[tutorials]: https://getcarina.com/docs
[CLI]: https://github.com/getcarina/carina/releases
[community]: https://community.getcarina.com
[GitHub]: https://github.com/getcarina/feedback/issues
