---
title: Load balancing WordPress in Docker containers
description: How to spin up a multi-container WordPress application running nginx, php-fpm and MySQL on the Rackspace Container Service
topics:
  - docker
  - intermediate
---

## Step 1: Create backend cluster

The first step is to create a cluster that will host all of our backend
services: php-fpm containers, nginx servers, MySQL database, and Redis. You
can read our [Getting Started to RCS]() guide if you are unsure of how to do this.

## Step 2: Set up WordPress CF containers

We will be using a CDN to handle all of the publicly visible assets on our
WordPress site. So to begin, we will need to upload them. The easiest way to
do this is using Rack, a command line tool for Rackspace, which you can install
by following the [installation instructions]().

The first thing to do is create a new container:

```
rack files container create --name wordpress --region ORD
```

Then download the WordPress library and unzip it:

```
curl -sO https://wordpress.org/latest.zip
unzip latest.zip
```

And finally, upload all of the public assets to the container we just created:

```
cd wordpress

rack files object upload-dir \
  --container wordpress \
  --dir wp-content/themes/ \
  --recurse \
  --region ord

rack files object upload-dir \
  --container wordpress \
  --dir wp-includes/ \
  --recurse \
  --region ord
```

## Step 3: Enable CDN on the container

After creating your container and uploading all of the WordPress files to it,
you will need to enable CDN. To do this, go to the Control Panel.

## Step 4: Set up MySQL

Our next task is to set up the MySQL database that our WordPress site will
store content in.

```
docker run -d --name db \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_USER=wordpress \
  -e MYSQL_PASSWORD=password \
  -e MYSQL_DATABASE=wordpress \
  mysql

docker run -d \
  --link db:db \
  --name mysql_ambassador \
  -p 3306:3306 \
  svendowideit/ambassador
```

```
export MYSQL_IP=`docker inspect mysql_ambassador | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4`
```

## Step 5: Set up Redis

To improve performance, we will be using Redis to cache content in memory:

```
docker run -d \
  --name redis \
  -p 6379 \
  -h redis \
  redis

docker run -d \
  --link redis:redis \
  --name redis_ambassador \
  -p 6379:6379 \
  svendowideit/ambassador
```

Once we've got our Redis containers up and running, we will need to know its
host IP:

```
export REDIS_IP=`docker inspect redis_ambassador | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4`
```

## Step 6: Deploy WordPress

Our WordPress set up will be as stateless as possible; and for that reason,
we're using a Docker image that extends the base [WordPress image]() by
installing the [W3 cache plugin]().

This plugin automatically uploads assets to the Rackspace CDN on our behalf and
renders these CDN links on the frontend. For that reason, it needs to know our
API credentials.

Create a file named `wp.env` on your filesystem. _Make sure this is never
uploaded to Github or otherwise made public_.

```
RS_USERNAME=
RS_API_KEY=
RS_LOCATION=
RS_CONTAINER=
RS_CNAME=
WORDPRESS_DB_NAME=
WORDPRESS_DB_USER=
WORDPRESS_DB_PASSWORD=
```

Once that's done, you're ready to create a bunch of WordPress nodes. Each node
will be composed of two containers: a nginx web server and a php-fpm container.
Let's go ahead and create five of them:

```
for i in {1..5}
do
  local UUID=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

  docker run -d \
    --name wp_${UUID} \
    --link redis_${UUID}:redis \
    --env-file $(pwd)/wp.env \
    -e WORDPRESS_DB_HOST=$MYSQL_IP \
    -e REDIS_IP=$REDIS_IP \
    jamiehannaford/wp:amphora_v2

  docker run -d -p 80 -P \
    --name nginx_${UUID} \
    --link wp_${UUID}:fpm \
    --volumes-from wp_${UUID} \
    --hostname foo.com \
    -e INTERLOCK_DATA='{"port": 80, "warm": true}' \
    jamiehannaford/nginx-fpm:latest
done
```

## Step 7: Create frontend cluster

Next, create a new cluster named `frontend`.

## Step 8: Transfer backend SSL certs to frontend

We now need to ensure that our frontend can monitor our backend for new
containers. To do this, we'll set up a data container that will store our SSL
certs:

```
docker run -d \
  -v /certs \
  -p 1234:22 \
  --name data_sshd \
  rastasheep/ubuntu-sshd
```

Next, extract its host IP and use scp to transfer the files:

```
export VOLUME_CONTAINER=`docker inspect data_sshd | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4`
scp -o StrictHostKeyChecking=no -P 1234 $(pwd)/backend/* root@${VOLUME_CONTAINER}:/certs
```

We don't need to keep this container running afterwards, so let's shut it down:

```
docker stop data_sshd
```

## Step 9: Set up interlock

To load balance our WordPress containers, we'll use [interlock](). To set up
our load balancer container, we need to run:

```
docker run -d \
    --name interlock \
    -p 80:80 \
    --volumes-from data_sshd \
    ehazlett/interlock \
    --swarm-url $BACKEND_DOCKER_HOST \
    --swarm-tls-ca-cert=/certs/ca.pem \
    --swarm-tls-cert=/certs/cert.pem \
    --swarm-tls-key=/certs/key.pem \
    --plugin haproxy start
```

## Step 10: Test!
