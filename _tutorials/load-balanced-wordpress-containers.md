---
title: Load balancing WordPress in Docker containers
description: How to spin up a multi-container WordPress application running nginx, php-fpm and MySQL on the Rackspace Container Service
topics:
  - docker
  - intermediate
---

In this article we'll be expanding on our previous tutorials by focusing on
how to set up a redundant, load-balanced web application cluster running
WordPress, nginx, php-fpm, Redis and MySQL. We'll decompose our application
into discrete micro-services with the future aims of scalability and
redundancy in mind.

Before we begin, it might be worth reading
[Running WordPress, Apache and MySQL in Docker](../wordpress-apache-mysql) and
[Linking containers using WordPress and nginx](../wordpress-nginx-links) if you
are unsure of the basics, or need a quick refresher.

### Prerequisites

- An active cluster with at least 3 nodes
- [Rack CLI](https://developer.rackspace.com/docs/rack-cli) installed and configured
- git installed

### Step 1: Download environment file

Later on when we'll run our WordPress containers, we'll link to a local
environment file that contains most of our configuration values. So it makes
sense to download it early so we can populate it as we progress through this
guide.

```
git clone https://github.com/rackerlabs/rcs-library
```

If you navigate to the `wordpress` directory, you will see the `env` file (along
  with a few other files) that we will need for this tutorial.

Open up the `env` file and populate the `RS_USERNAME` and `RS_API_KEY` variables
with your Rackspace username and API key respectively.

**Note**: _Never_ check this file into version control or expose it publicly.

### Step 2: Set up Cloud Files containers

One of the considerations to think about when scaling is file storage, and this
is especially a concern with non-cloud-native applications like WordPress. Our
aim is to create stateless, immutable containers that can be destroyed and
redeployed without any detrimental effect. So to do this, we need to shift
the location of asset storage to Rackspace Cloud Files. Apart from the
already mentioned benefit of statelessness, we also get a powerful CDN sitting
in front, which will improve website speed.

We will be using the Rackspace CDN to handle all of the publicly visible assets
on our WordPress site. So to begin, we will need to upload them. The easiest way to
do this is using Rack, a command line tool for Rackspace. If you have not installed
this already, please consult our [Installation Guide](https://developer.rackspace.com/docs/rack-cli/configuration/).

Our first step is to create a new container named `wordpress`:

```
rack files container create --name wordpress --region ord
```

We then download the WordPress source code and unzip it:

```
curl -o /tmp/latest.zip -s https://wordpress.org/latest.zip
unzip /tmp/latest.zip
```

And finally, we upload all of the public assets to the container we just created:

```
cd /tmp/wordpress

rack files object upload-dir \
  --container wordpress \
  --dir . \
  --recurse \
  --region ord

cd -
```

One thing to be aware of is that the above two commands will upload PHP files
too. This is an unfortunate side effect of uploading the entire directories. If
you'd rather _only_ upload public assets (JS, CSS, font files etc.) you can run
the following, but it will be much slower:

```
find . -type f -not -name "*.php" \
  -exec sh -c "rack files object upload --file {} --name {} --region ord --container wordpress" \;
```

### Step 3: Enable CDN on the container

After creating your container and uploading all of the WordPress files to it,
you will need to enable CDN by following these steps:

1. Sign in to https://mycloud.rackspace.com/ using your username and password.
2. Navigate to Storage > Files and ensure the dropdown is set to either
"All Regions (Global)" or "Chicago (ORD)".
3. Find the container named `wordpress`, click on the grey cog to the left of
its name, click "Make Public (Enable CDN)" and confirm by clicking "Publish to CDN".
4. You should now see a blue globe to the left of the name, indicating its visibility.
The final thing we need to do is find out its public URL. To do this, click on
the cog, click "View all links" and copy the "HTTPS" URL to your clipboard.
5. Finally, open up the `env` file we downloaded in Step 1 and set the
following:

  * `RS_CONTAINER` with the name of your container -- which, unless you specified
  otherwise, should be `wordpress`
  * `RS_CNAME` with the HTTPS URL we retrieved in Step 4. **Make sure you strip
  the https:// scheme from the beginning**.

### Step 4: Set up MySQL

The next thing we'll need to do is create a database instance running MySQL. We can do this in the Control Panel by following this instructions:

1. Sign in to https://mycloud.rackspace.com/ using your username and password.
2. Navigate to Databases > MySQL and click on the "Create Instance" button.
3. Call the instance "WordPress" and select "IAD" as the region. For the Engine, be sure to choose MySQL 5.6. For the RAM, 2GB is recommended but you can toggle the value according to your preference (a single WordPress container will not require much RAM). Finally specify 5GB for the disk space.
4. Create a database named wordpress
5. Create a user called wordpress, and assign a strong password to it. Be sure to remember this since we'll need it later on.
6. Click on "Create instance".

This will provision a compute instance with 2GB of RAM and 5GB of disk space running MySQL 5.6. Give it a few minutes to build. The wordpress user created will also be automatically granted full privileges to the new wordpress database.

Open up the `env` file again and specify these variables:

- `WORDPRESS_DB_NAME` with the name of the database from Step 4 which, unless
you specified otherwise, should be `wordpress`.
- `WORDPRESS_DB_USER` with the name of the user from Step 5 which again should
be `wordpress`.
- `WORDPRESS_DB_PASSWORD` with the name of the user password from Step 5.
- `WORDPRESS_DB_HOST` with the hostname outputted after the instance was provisioned.
It should look something like `cdedf98d3852989dc00f4b6bd0e31f98af746a1c.rackspaceclouddb.com`.

### Step 5: Set up Redis

To improve performance, we will be using Redis to cache content in memory. To
run our

```
docker run --detach \
  --name redis \
  --memory 4G \
  --publish 6379 \
  --hostname redis \
  redis
```

Because Redis caches data in-memory, it makes sense to allocate it a protected
chunk of memory, just in case traffic spikes. Once we've got our Redis
containers up and running, we will need to know its host IP:

```
docker inspect redis | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4
```

Once we have that, open up the `env` file again and set the `REDIS_IP` to the
value of the IP just outputted.

### Step 6: Prepare images

The final step is to start our nginx frontend and php-fpm backend containers. We
will be deploying variants of the following base images:

- we add to `nginx` by changing some configuration values to allow higher
  upload sizes, and add a new web config file to point to our volume mount.
- we add to `wordpress:fpm` by:

  - installing the [Redis PHP extension](https://github.com/phpredis/phpredis)
    and downloading a WordPress add-on that allows us to cache content in Redis
  - install the [W3 cache](https://wordpress.org/plugins/w3-total-cache/), enable
    it, and configure it to use our CDN-enabled container. It will transfer _all_
    the assets uploaded via the Admin control panel automatically to the cloud,
    ensuring that there is not a discord between the local state of one container
    against any other.
  - install and enable the [nginx helper](https://wordpress.org/plugins/nginx-helper/) plugin.

So to use these custom images, we have two choices. We can either:

1. build the image locally from the Dockerfiles in the `rcs-library` we
   downloaded in Step 1, and push to your own Docker Hub account; or
2. run a prebuilt image hosted on the `rackspace` Docker Hub account.

If you want to use the prebuilt image, you can skip the next step and head
straight to `Step 7: Deploy WordPress`.

#### Optional: Building your own image

You will need to create two Docker images, one of WordPress and one for nginx.

Firstly, make sure you're inside the directory we cloned with git in Step 1. Then:

```
docker build -t <userNamespace>/wordpress ./wordpress
docker build -t <userNamespace>/nginx-fpm ./nginx-fpm
```

Where `<userNamespace>` is your Docker Hub username. The final step is to then
push your local images to Docker Hub, just like you would with git:

```
docker push <userNamespace>/wordpress
docker push <userNamespace>/nginx-fpm
```

### Step 6: Deploy WordPress

If we followed all the steps, we should have a value for each of the keys in
our `env` configuration file. Now we're ready to create a bunch of WordPress
pairings, each composed of two containers: a nginx frontend and a php-fpm backend.

Let's go ahead and create five of them:

```
echo '#!/bin/bash

for i in {1..5}
do
  UUID=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

  docker run -d \
    --name wp_${UUID} \
    --env-file $(pwd)/env \
    <namespace>/wordpress

  docker run --detach \
    --publish-all \
    --name nginx_${UUID} \
    --link wp_${UUID}:fpm \
    --volumes-from wp_${UUID} \
    --hostname <hostname> \
    --env INTERLOCK_DATA="{\"port\": 80, \"warm\": true}" \
    <namespace>/nginx-fpm
done' > run.sh
```

You will need to substitue the following variables:

- `<hostname>`, such as `foo.com`, of your WordPress site. For now, you can
  make this up and include a test domain. If you're using a made-up domain,
  remember this value because we'll need it again later.
- `<namespace>`. with either your own Docker Hub account name, or `rackspace`
  if you did not build and push your own Docker image. To use Rackspace's
  username, you can replace the occurences in the file with:

```
sed -i -e 's/<namespace>/rackspace/g' run.sh
```

Once that's done, you can run:

```
bash ./run.sh
```

### Step 7: Set up interlock

To load balance our WordPress containers, we'll use a project called
[interlock](https://github.com/ehazlett/interlock). Interlock listens for
new Docker events, such as a new container being started and, according to your
configuration, notifies plugins. In our case, we'll be using HAProxy as a
layer 4 load-balancer, which routes incoming traffic to nginx frontend containers.
The nginx frontends will then proxy requests to the backend php-fpm pool.

To set up our load balancer container, we need to run:

```
docker run --detach \
    --name interlock \
    --publish 80:80 \
    --volumes-from swarm-data \
    ehazlett/interlock \
    --swarm-url $DOCKER_HOST \
    --swarm-tls-ca-cert=/etc/docker/ca.pem  \
    --swarm-tls-cert=/etc/docker/server-cert.pem \
    --swarm-tls-key=/etc/docker/server-key.pem \
    --plugin haproxy start
```

Let's look at what's going on here. We've published `80` as the public port,
since that's the default port for HTTP connections and we've mounted the
volumes from the `swarm-data` container. This may be confusing at first,
because we never created a container under this name, but it's actually a
system container provided to us by the Rackspace Container Service.

Inside `swarm-data` is all the necessary SSL certificates for the parent
cluster, allowing interlock to connect to the Docker API and listen out for
interesting events. The `swarm-` options specify where to find all the elements
necessary for this connection. Lastly, as we already mentioned, we specify
that our plugin of choice will be HAProxy.

### Step 8: Add hosts entry

If, in Step 6, you specified a real domain for nginx - you can skip this step
and go straight to `Step 8: Test!`.

If you provided a test or made-up domain for your nginx configuration, you
will need to add the following line to your system hosts file - since interlock
and nginx will only accept connections that match the given domain:

```
<interlockIPv4> <domain>
```

You can retrieve interlock's IPv4 with `docker port interlock 80` - but make
sure you strip `:80` off the end. Replace `<domain>` with the domain you
specified back in Step 6. So, for example:

```
104.130.0.52 foo.com
```

### Step 9: Test!

We can see whether our stack is running:

```
docker ps
```

And we can visit our load balancer frontend by finding its IPv4 address and
opening it in our default browser:

```
open http://$(docker port interlock 80)
```

We should see the WordPress installation page. This shows us that our
load balancer is distributing requests to 5 different frontend/backend container
pairings split over multiple hosts. We can verify this by checking HAProxy's
stats page:

```
open http://$(docker port interlock 80)/haproxy?stats
```

We will see all of the nginx frontends accepting connections from interlock.
