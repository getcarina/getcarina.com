---
title: Load balancing WordPress in Docker containers
description: How to spin up a multi-container WordPress application running NGINX, PHP-FPM and MySQL on the Rackspace Container Service
topics:
  - docker
  - intermediate
---

In this article you will be expanding on the previous WordPress tutorials by
focusing on how to set up a redundant, load-balanced web application cluster
running WordPress, NGINX, PHP-FPM, Redis and MySQL. You will decompose a standard
application into discrete microservices with the future aims of scalability and
redundancy in mind.

Before you begin, it might be worth reading
[Running WordPress, Apache and MySQL in Docker](../wordpress-apache-mysql) and
[Linking containers using WordPress and NGINX](../wordpress-nginx-links) if you
are unsure of the basics, or need a quick refresher.

### Prerequisites

- An active cluster with at least 3 nodes
- [Rack CLI](https://developer.rackspace.com/docs/rack-cli) installed and configured
- git installed

### Download environment file

Later on when running your WordPress containers, you will link to a local
environment file that contains most of your configuration. So it makes
sense to download it early so you can populate it as you progress through this
guide.

```
git clone https://github.com/rackerlabs/rcs-library
```

If you navigate to the `wordpress` directory, you will see the `env` file (along
  with a few other files) that you will need for this tutorial.

Open up the `env` file and populate the `RS_USERNAME` and `RS_API_KEY` variables
with your Rackspace username and API key respectively.

**Note**: _Never_ check this file into version control or expose it publicly.

### Set up Cloud Files containers

One of the considerations to think about when scaling is file storage, and this
is especially a concern with non-cloud-native applications like WordPress. Your
aim is to create stateless, immutable containers that can be destroyed and
redeployed without any detrimental effect. So to do this, you need to shift
the location of asset storage to Rackspace Cloud Files. Apart from the
already mentioned benefit of statelessness, you also get a powerful CDN sitting
in front, which will improve website speed.

You will be using the Rackspace CDN to handle all of the publicly visible assets
on your WordPress site. So to begin, you will need to upload them. The easiest way to
do this is using Rack, a command line tool for Rackspace. If you have not installed
this already, please consult our
[Installation Guide](https://developer.rackspace.com/docs/rack-cli/configuration/).

1. Create a new container named `wordpress`:

  ```
  rack files container create --name wordpress --region ord
  ```

2. Once you have created your container, open up the `env` file you downloaded in
  Step 1, and set `RS_CONTAINER` to the name of your container -- which, unless
  you specified otherwise, should be `wordpress`.

3. Next, download the WordPress source code and unzip it:

  ```
  cd /tmp
  curl -sO https://wordpress.org/latest.zip
  unzip latest.zip
  ```

4. Upload all of the public assets to the container you just created:

  ```
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

### Enable CDN on the container

After creating your container and uploading all of the WordPress files to it,
you will need to enable CDN by following these steps:

1. Log in to the [Cloud Control Panel](https://mycloud.rackspace.com/).
2. Navigate to Storage > Files and ensure the dropdown is set to either
   **All Regions (Global)** or **Chicago (ORD)**.
3. Find the container named `wordpress`, click on the gear icon to the left of
   its name, click **Make Public (Enable CDN)** and confirm by clicking
   **Publish to CDN**.

   You should now see a blue globe to the left of the name, indicating its public
   visibility.
4. Click on the gear icon, click **View all links** and copy the "HTTPS" URL to
   your clipboard.
5. Finally, open up the `env` file we downloaded in Step 1 and set `RS_CNAME`
   to the HTTPS URL you retrieved in Step 4. **Make sure you strip the https://
   scheme from the beginning**.

### Set up MySQL

The next step is to create a database instance that is running MySQL. You can
do this in the Rackspace Cloud Control Panel by following these instructions:

1. Navigate to the directory where you cloned the environment file in Step 1.
2. Log in to the [Cloud Control Panel](https://mycloud.rackspace.com/).
3. At the top of the panel, click **Databases > MySQL**.
4. On the Cloud Databases page, click **Create Instance**.
5. Name the instance **WordPress** and select **IAD** as the region.
6. For the engine, select **MySQL 5.6**.
7. For the RAM, **2 GB** is recommended, but use the value that you prefer (a single
   WordPress container does not require much RAM).
8. Specify **5 GB** for the disk space.
9. In the Add Database section, create a database named **wordpress**. Set the
   `WORDPRESS_DB_NAME` in the `env` file to the database name you specified.
10. Specify **wordpress** as the username, and assign a
   [strong password](https://strongpasswordgenerator.com/) to it. Using these
   two values, set `WORDPRESS_DB_USER` and `WORDPRESS_DB_PASSWORD` in the `env` file.
11. Click **Create instance**.

    A compute instance with 2 GB of RAM and 5 GB of disk space running MySQL
    5.6 is provisioned. It might take a few minutes to build. The **wordpress**
    user is automatically granted full privileges to the new **wordpress**
    database.
12. Once it's displayed, set the `WORDPRESS_DB_HOST` variable in the `env` file
    to the instance hostname shown in the Control Panel. It will look like this:

  ```
  cdedf98d3852989dc00f4b6bd0e31f98af746a1c.rackspaceclouddb.com
  ```

### Set up Redis

To improve performance, Redis will be used to cache content in memory. To
start your Redis container, run this command:

```
docker run --detach \
  --name redis \
  --memory 4G \
  --publish 6379 \
  --hostname redis \
  redis
```

You will notice the `--memory` flag, which limits memory usage to a maximum of
4GB. Once your Redis container are up and running, you will need to know its host IP:

```
docker inspect redis | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4
```

Once we have that, open up the `env` file again and set the `REDIS_IP` to the
value of the IP just outputted.

### Prepare images

The final step is to start your NGINX frontend and PHP-FPM backend containers.
You will be deploying variants of the following base images:

- `nginx` - configuration values edited to allow higher upload sizes, and a
  new configuration file added to point to the volume mount directory where your
  WordPress codebase will reside.

- `wordpress:fpm` - edited in the following ways:

  - The [Redis PHP extension](https://github.com/phpredis/phpredis) is installed
    and a WordPress add-on downloaded that allows content to be cached in Redis.
  - A plugin named [W3 cache](https://wordpress.org/plugins/w3-total-cache/) is
    installed, enabled, and configured to use your CDN-enabled container. It
    will transfer _all_ the assets uploaded via the Admin control panel
    automatically to the cloud, ensuring that there is not a discord between
    the local state of one container against any other.
  - A plugin named [NGINX helper](https://wordpress.org/plugins/nginx-helper/) is
    installed and configured.

You have the following options:

- Build the image locally from a Dockerfile and push it to your own Docker Hub account.
- Run a prebuilt image that is hosted on the `rackspace` Docker Hub account.

If you want to use the prebuilt image, you can skip to [Deploy WordPress](#deploy-wordpress).

To build the Docker images, build it locally and push it to a central repository
such as Docker Hub.

1. Navigate to the directory you cloned in Step 1.
2. Build your image as follows, where `<userNamespace>` is your Docker Hub username:

  ```
  docker build -t <userNamespace>/wordpress ./wordpress
  docker build -t <userNamespace>/nginx-fpm ./nginx-fpm
  ```

3. Push your local image to Docker Hub, just like you would with Git:

  ```
  docker push <userNamespace>/wordpress
  docker push <userNamespace>/nginx-fpm
  ```

### Deploy WordPress

Before proceeding, make sure you're in the wordpress directory under the repo
you cloned in step one.

By now you should have a value for each of the keys in the `env` configuration
file. Now you are ready to create a set of WordPress container pairings, each
composed of two containers: a NGINX frontend and a PHP-FPM backend.

To create five of them, run this command:

```
echo '#!/bin/bash

for i in {1..5}
do
  UUID=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

  docker run -d \
    --name wp_${UUID} \
    --env-file $(pwd)/env \
    --env "affinity:container!=redis" \
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

You will need to substitute the following variables:

- `<hostname>`, such as `foo.com`, of your WordPress site. For now, you can
  make this up and include a test domain. If you're using a made-up domain,
  remember this value because we'll need it again later.
- `<namespace>`. with either your own Docker Hub account name, or `rackspace`
  if you did not build and push your own Docker image.

A command that can easily help you replace values in your file is:

```
sed -i -e 's/<namespace>/rackspace/g' run.sh
```

Once that's done, you can run:

```
bash ./run.sh
```

### Set up interlock

To load balance your WordPress containers, you will use a project called
[interlock](https://github.com/ehazlett/interlock). Interlock listens for
new Docker events, such as a new container being started and, according to your
configuration, notifies plugins. In your case, HAProxy will be used as a
layer 4 load-balancer, which routes incoming traffic to NGINX frontend containers.
The NGINX frontends will then proxy requests to the backend PHP-FPM pool.

To set up your load balancer container, run:

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

Let's look at what's going on here. You've published `80` as the public port,
since that's the default port for HTTP connections and we've mounted the
volumes from the `swarm-data` container. This may be confusing at first,
because you never created a container under this name, but it's actually a
system container provided to you by the Rackspace Container Service.

Inside `swarm-data` is all the necessary SSL certificates for the parent
cluster, allowing interlock to connect to the Docker API and listen out for
interesting events. The `swarm-` options specify where to find all the elements
necessary for this connection. Lastly, as has already been mentioned, we specify
that the plugin will be HAProxy.

### Add hosts entry

If, in Step 6, you specified a real domain for NGINX - you can skip this step
and go straight to `Step 8: Test!`.

If you provided a test or made-up domain for your NGINX configuration, you
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

### Test!

You can see whether your stack is running by executing:

```
docker ps
```

And you can visit your load balancer frontend by finding its IPv4 address and
opening it in your default browser:

```
open http://$(docker port interlock 80)
```

You should see the WordPress installation page. This shows you that your
load balancer is distributing requests to 5 different frontend/backend container
pairings split over multiple hosts. You can verify this by checking HAProxy's
stats page:

```
open http://$(docker port interlock 80)/haproxy?stats
```

You will see all of the NGINX frontends accepting connections from interlock.
