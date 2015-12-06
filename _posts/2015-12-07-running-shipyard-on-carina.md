---
title: "Running Shipyard on Carina"
date: 2015-12-07 13:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: false
excerpt: >
  With the addition/exposure of docker.sock on Carina, you can run interesting things, like the Shipyard GUI.
categories:
 - Shipyard
 - Swarm
 - Carina
 - GUI
authorIsRacker: true
---

With the addition/exposure of docker.sock on Carina, you can run interesting things, like the [shipyard GUI](https://shipyard-project.com/). I'm going to run you through how to get it installed so you can experiment with it.

Before we begin I want to note that shipyard is not maintained at this time - the awesome developers behind it are now working at Docker, so this is a nice to have example or management GUI for the time-being, but you should expect it to have issues. There's a large raft of Docker GUIs out there, and we're exploring supporting each of them in time.

A large restriction is that many Docker tools assume/require `--priviliged` access which we can not enable in a multi-tenant environment. `docker.sock` was blocked until Docker 1.9.1 and a full security review could happen.

If you have a UI or tool that you'd like to work, or doesn't, definitely reach out to us!

On to the fun.

### Follow your dreams.

I'm going to start with a completely fresh cluster - so, assuming you have the Carina CLI installed and configured:

```bash
carina create --wait shipyard \
  && carina credentials shipyard \
  && eval `carina env shipyard`
```

This will pop a new cluster for you and load it into your environment.

From here you could follow the [manual deployment instructions](https://shipyard-project.com/docs/deploy/manual/) for shipyard and it would literally Just Work(tm) however there's a [small bug](https://github.com/shipyard/shipyard/issues/681), and you shouldn't need to type a bunch into the terminal.

So I made you a bash script:

<script src="https://gist.github.com/jnoller/d643ce38ced8548a7dcc.js"></script>

If you load your Carina credentials into the environment (as I did above) and then run  `./script.sh install`; you'll see something like:

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

And a `docker ps` will show:

```
$> docker ps
CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS              PORTS                                                        NAMES
61982f948372        shipyard/shipyard:latest       "/bin/controller serv"   6 seconds ago       Up 5 seconds        172.99.70.176:8080->8080/tcp                                 e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-controller
5ed629941b21        ehazlett/docker-proxy:latest   "/usr/local/bin/run"     8 seconds ago       Up 7 seconds        172.99.70.176:2375->2375/tcp                                 e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-proxy
9a5ad038560a        microbox/etcd                  "/bin/etcd -name disc"   8 seconds ago       Up 7 seconds        172.99.70.176:4001->4001/tcp, 172.99.70.176:7001->7001/tcp   e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-discovery
5bf0561ad062        rethinkdb                      "rethinkdb --bind all"   9 seconds ago       Up 8 seconds        8080/tcp, 28015/tcp, 29015/tcp                               e9e1fa6d-b3b0-4ab0-bdd0-8d378d0a88ee-n1/shipyard-rethinkdb
```

Victory!

Now that it's running; browsing to http://<SWARM-IP>:8080 will show you the shipyard GUI - the default username/password is admin/shipyard. You should change this **right now** since it's on the public internet.

**Protip**: On OS X you can this to pop the UI:

```
open http://`docker run --net=host --rm racknet/ip public`:8080
```

### Screenshots or it didn't happen!

Yes! Here's a quick tour starting with the landing page after login; this page shows you everything in the Swarm, uptime, what image it came from.

![control panel]({% asset_path 2015-12-07-running-shipyard-on-carina/shipyard-cp.png %})

You can use the rightmost buttons to perform actions, view state, etc. More interesting is the `Deploy Container` button:

![deploy container]({% asset_path 2015-12-07-running-shipyard-on-carina/shipyard-deployment.png %})

This of course let's you launch new containers into your cluster - but there is a gotcha - don't click this button:

![deploy container]({% asset_path 2015-12-07-running-shipyard-on-carina/shipyard-nope.png %})

Otherwise, play around - let us know in the [community](https://community.getcarina.com/) if something is wonky or broken. I'd imagine since the base [shipyard image](https://github.com/shipyard/shipyard/blob/master/Dockerfile.build) is based on Docker 1.7.0, there could some "missing things".

Otherwise, have fun!
