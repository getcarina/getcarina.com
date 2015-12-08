---
title: "Running Shipyard on Carina"
date: 2015-12-08 14:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  With the addition and exposure of docker.sock on Carina, you can run interesting things, like the Shipyard GUI.
categories:
 - Shipyard
 - Swarm
 - Carina
 - GUI
authorIsRacker: true
---

With the addition and exposure of docker.sock on Carina, you can run interesting things, like the [shipyard GUI](https://shipyard-project.com/). I'm going to walk you through how to get it installed so you can experiment with it.

Before we begin I want to note that shipyard not currently maintained. The awesome developers behind it are working at Docker on awesome things, so this is a useful example or management GUI for the time being, but you should expect it to have issues. There are many Docker GUIs out there, and we're exploring supporting each of them in time.

A large restriction is that many Docker tools assume or require `--priviliged` access, which we can’t enable in a multi-tenant environment. docker.sock was blocked until Docker 1.9.1 was released and a full security review could happen.



If you have a UI or tool that you'd like to work with Carina, [definitely reach out to us](https://github.com/getcarina/feedback)!

**Caveat Raptor**: I'm showing you the raw installation of shipyard - by default this starts a set of publicly accessible services, and containers. For the purposes of a demo this is ok, but if you plan on running this for any length of time, **please** set proper firewall rules, listening on [servicenet](https://getcarina.com/docs/tutorials/servicenet/) vs. public internet, lock down port/host access on the etcd container, etc. When we make an official tutorial these instructions will be added. 

On to the fun.

### Follow your dreams.

I'm going to start with a completely fresh cluster. So, assuming you have the Carina CLI installed and configured:

```bash
carina create --wait shipyard \
  && carina credentials shipyard \
  && eval "$(carina env shipyard)"
```

This creates a new cluster for you and loads it into your environment.

From here you could follow the [manual deployment instructions](https://shipyard-project.com/docs/deploy/manual/) for shipyard and it would literally Just Work(tm). However there's a [small bug](https://github.com/shipyard/shipyard/issues/681), and you shouldn't need to type a bunch into the terminal.

So I made you a bash script:

<script src="https://gist.github.com/jnoller/d643ce38ced8548a7dcc.js"></script>

If you load your Carina credentials into the environment (as I did above) and then run  `./shipyard.sh install`; you'll see something like this:

```
$> ./setup.sh install
Performing Install
5bf0561ad062297392a6571162bdfc5580bae026d48e874603b4fa57af20fb16
9a5ad038560a996e6808ec00c5d1576f2f8ffbb48c7fd25f49c61a2df76b9808
5ed629941b2130565cb64cb7993d5b11581a7830bf4ba44c285974134b4b5d7d
67408db188011e7569a2241b91794c6190000b733cd7180546a15c0c5cca0560
c0fbdea855132803b015c5f80c194a3084096c7a6fd76d3ed835d1aaaef11429
61982f948372a624651bbb008373c71c3c4d72a6dfae5e7a7a1b8a87eff42470
```

Then, if you run `docker ps`, you see the following output:

```
$> docker ps
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                                                        NAMES
61982f948372        shipyard/shipyard:latest       "/bin/controller serv"   6 seconds ago       Up 5 seconds        172.99.70.176:8080->8080/tcp                                 e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-controller
5ed629941b21        ehazlett/docker-proxy:latest   "/usr/local/bin/run"     8 seconds ago       Up 7 seconds        172.99.70.176:2375->2375/tcp                                 e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-proxy
9a5ad038560a        microbox/etcd                  "/bin/etcd -name disc"   8 seconds ago       Up 7 seconds        172.99.70.176:4001->4001/tcp, 172.99.70.176:7001->7001/tcp   e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-discovery
5bf0561ad062        rethinkdb                      "rethinkdb --bind all"   9 seconds ago       Up 8 seconds        8080/tcp, 28015/tcp, 29015/tcp                               e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-rethinkdb
```

Victory!

Now that it's running, browse to `http://SWARM-IP:8080` to see the Shipyard GUI; the default username/password is admin/shipyard. You should change this **right now** because it's running on the public IP address.


**Protip**: On OS X you can this to pop open the UI:

```
open http://"$(docker run --net=host --rm racknet/ip public)":8080
```

### Screenshots or it didn't happen!

Here's a quick tour, starting with the shipyard landing page after login. This page shows you everything in the Swarm, uptime, and what image it came from.

![control panel]({% asset_path 2015-12-07-running-shipyard-on-carina/shipyard-cp.png %})

You can use the rightmost buttons to perform actions, view states, and so on. More interesting is the `Deploy Container` button, which lets you launch new containers into your cluster:

![deploy container]({% asset_path 2015-12-07-running-shipyard-on-carina/shipyard-deployment.png %})

One caveat: don’t select the Allow container to run in privileged mode option. As I said before, we can’t allow containers to run in privileged mode.

![deploy container]({% asset_path 2015-12-07-running-shipyard-on-carina/shipyard-nope.png %})

Otherwise, play with it and let us know in the [community](https://community.getcarina.com/) if something is wonky or broken. Because the base [shipyard image](https://github.com/shipyard/shipyard/blob/master/Dockerfile.build) is based on Docker 1.7.0, there could be some "missing things".

Otherwise, have fun!
