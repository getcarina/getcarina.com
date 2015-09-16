---
title: Rolling Deploys with the Container Service
description: Rolling deploy of Docker Containers behind a load balancer
topics:
  - docker
  - rolling deploy
  - devops
  - load balancers
---

In this article, we're going to:

* Create a load balancer
* Launch four independently running HTTP servers on a Swarm cluster
* Add each of those servers to a load balancer

After that, we're going to see how to upgrade each of those while rotating them out of the load balancer for zero-downtime upgrades. For each container/HTTP server:

* Drain that container/node from the load balancer
* Verify dropped connections
* Stop/remove old container
* Run the container with the new image
* Add it back to the load balancer


## Starting off our simple service

Let's say we launch a simple web application served over HTTP

```bash
$ ID=$( docker run -d -P rackerlabs/whoa )
```

Docker automatically set ports for us via `-P`, mapping the `EXPOSE`d port in the container to a random high port:

```bash
$ docker port $ID
8080/tcp -> 104.130.0.117:49162
$ docker port $ID 8080
104.130.0.117:49162
```

## Adding servers to a load balancer

Let's create a new load balancer using the `rack` CLI and store its id in `$LBID`:

```bash
$ rack load-balancers instance create --name whoalb
$ LBID=$( rack load-balancers instance list --name whoalb --fields=id --no-header )
```

Now we can add each newly created to the LB, creating a node entry for each. We'll also label these for easy retrieval later:

```bash
$ CONTAINER_ID=$( docker run -d -P --label=whoa-http rackerlabs/whoa )
$ IFS=':' read IP PORT <<< "$( docker port $ID 8080 )"
$ rack load-balancers node create --load-balancer $LBID --address $IP --port $PORT
```

## Rotating containers in and out of the load balancer

Since we labeled the containers earlier, we can list just those on the lb:

```bash
$ docker ps --filter "label=whoa-http"
CONTAINER ID        IMAGE                    COMMAND             CREATED              STATUS              PORTS                          NAMES
e771ac09fc2d        rackerlabs/whoa:latest   "/whoa"             15 seconds ago       Up 11 seconds       104.130.0.83:49155->8080/tcp   ca30823e-3544-474e-9886-ede2984719c3-n2/furious_almeida
91086c94d914        rackerlabs/whoa:latest   "/whoa"             16 seconds ago       Up 12 seconds       104.130.0.82:49156->8080/tcp   ca30823e-3544-474e-9886-ede2984719c3-n1/goofy_sammet
b949a6b0a8d8        rackerlabs/whoa:latest   "/whoa"             18 seconds ago       Up 14 seconds       104.130.0.83:49154->8080/tcp   ca30823e-3544-474e-9886-ede2984719c3-n2/reverent_lovelace
55c6ad025e08        rackerlabs/whoa:latest   "/whoa"             28 seconds ago       Up 24 seconds       104.130.0.82:49155->8080/tcp   ca30823e-3544-474e-9886-ede2984719c3-n1/determined_torvalds
```

Which means we can iterate through all of these by ID. We'll use `--no-trunc=true` to get the full IDs as well (primarily for swarm affinities later):

```bash
$ docker ps --filter "label=whoa-http" -q --no-trunc=true
e771ac09fc2d980812d540635f768f029acb1bcaf26c749c964f75791fa79083
91086c94d914880a2108c9aa8fbe740b0b0cfc12caf027294ffa53c8d953deb5
b949a6b0a8d8e964d4d52120c97bc9e16e6e829db7c5511d2e943becbfb27c80
55c6ad025e0865f5db2076846a56d56bc3810e87a45a7450427b80a76a3aedbb
6142ea68aea04c93eafbeeaaea9214049c654355f6b01ccc00c410d8c7650f95
```

Assuming you still have the load balancer ID in `$LBID`, we can go ahead and swap each image out:

```bash
docker pull rackerlabs/whoa

# Note: should verify that the image is good, have a fallback strategy

for CONTAINER_ID in $( docker ps --filter "label=whoa-http" --no-trunc=true ); do
  IFS=':' read IP PORT <<< "$( docker port $CONTAINER_ID 8080 )"
  rack load-balancers node set --load-balancer $LBID --address $IP --port $PORT --condition "draining"

  # Note: should verify that all connections have been dropped from this container
  docker stop $CONTAINER_ID
  docker rm $CONTAINER_ID
  rack load-balancers node delete --load-balancer $LBID --address $IP --port $PORT

  # Bring in the replacement
  NEW_CONTAINER_ID=$( docker run -d -P --label=whoa-http rackerlabs/whoa )
  IFS=':' read IP PORT <<< "$( docker port $NEW_CONTAINER_ID 8080 )"
  rack load-balancers node create --load-balancer $LBID --address $IP --port $PORT
done
```

Assuming everything went well, you've now swapped out the old image for the new image.

## Getting the ServiceNet IP

Alternatively, you can use the service net IP with load balancers (assuming they're in the same region). This will replace the `$IP` and `$PORT` generation above. Figuring the address out currently requires a bit of discovery to figure out. We'll be using Swarm affinities to ensure that our service net query runs on the right host with the container we're getting the IP for.

```bash
# TODO: Figure out if we're able to expose this through API
# TODO: Make a super minimal image that does the extraction of IPs nicely
#       (e.g. https://github.com/rgbkrk/peekaboo/blob/master/peekaboo.go#L98-L147)
docker run --rm --net=host -e "affinity:container==$CONTAINER_ID" ubuntu sh -c "ip addr show eth1 | grep -Po 'inet \K[\d.]+'"
10.176.224.18
```

Wrapping this up into a series of commands, we now have:

```bash
IFS=':' read IP PORT <<< "$( docker port $CONTAINER_ID 8080 )"
IP=$( docker run --rm --net=host -e "affinity:container==$CONTAINER_ID" ubuntu sh -c "ip addr show eth1 | grep -Po 'inet \K[\d.]+'" )
```

Which we can use as `$IP`, `$PORT` pairs for the load balancer above.
