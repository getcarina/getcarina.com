---
title: Load balance WordPress in Docker containers
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
date: 2015-10-09
permalink: docs/tutorials/load-balance-wordpress-docker-containers/
description: Learn how to spin up a multi-container WordPress application running NGINX, PHP-FPM and MySQL on Carina
published: false
topics:
  - docker
  - intermediate
---

In this tutorial you will be expanding on the previous WordPress tutorials by
focusing on how to set up a redundant, load-balanced web application cluster
running WordPress, NGINX, PHP-FPM, Redis, and MySQL. You will decompose a standard
application into discrete microservices, keeping in mind the future goals of
scalability and redundancy.

Before you begin, read
[Running WordPress, Apache and MySQL in Docker](../wordpress-apache-mysql) and
[Run WordPress across linked front end and back end containers](../wordpress-nginx-links)
if you are unsure of the basics or need a quick refresher.

### Prerequisites

- An active cluster with at least three nodes
- [Rack CLI](https://developer.rackspace.com/docs/rack-cli) installed and configured
- Git installed

### Download an environment file

When you run your WordPress containers later in this tutorial, you will link to
a local environment file that contains most of your configuration. So it makes
sense to download it early so you can populate it as you progress through this
tutorial.

1. Run the following commands:

  ```
  git clone https://github.com/getcarina/examples.git
  ```

2. Navigate to the **wordpress** directory to find the **env** file (and a few
  other files) that you will need for this tutorial.

3. Open the **env** file and populate the RS_USERNAME and RS_API_KEY variables
  with your Rackspace username and API key.
  Your username is the one that you use to log in to the Cloud Control Panel. You
  can find your API key by logging in to the Cloud Control Panel and selecting
  **Account > Account Settings**.

**Note**: _Never_ check this file into version control or expose it publicly.

### Set up Cloud Files containers

One consideration when scaling is file storage, and this is especially a
concern with applications that are not native to the cloud, like WordPress. Your
goal is to create stateless, immutable Docker containers that can be destroyed and
redeployed without any detrimental effect. To do this, you need to shift
the location of asset storage to Rackspace Cloud Files. Apart from the
benefit of statelessness, you also get a powerful CDN, which will improve
website speed.

You will use Rackspace CDN to handle all of the publicly visible assets
on your WordPress site. So to begin, you need to upload them. The easiest way to
do this is by using `rack`, a command line tool for Rackspace. If you have not
installed this tool already, see the
[Rackspace CLI installation instructions](https://developer.rackspace.com/docs/rack-cli/configuration/).

**Note**: Cloud Files calls folders (or directories if you're using UNIX) _containers_.
These are simply folders on a CDN; they are not Docker containers.

1. Using the `rack` command-line tool, create a new container named **wordpress**:

  ```
  rack files container create --name wordpress --region ord
  ```

2. Open up the **env** file that you downloaded in the preceding section and
  set the value of RS_CONTAINER to the name of your container. Unless
  you specified otherwise, this name should be **wordpress**.

3. Download the WordPress source code and unzip it:

  ```
  cd /tmp
  curl -sO https://wordpress.org/latest.zip
  unzip latest.zip && cd wordpress
  ```

4. Delete all of the PHP files, since you only want to upload public assets:

  ```
  find . -regex ".*\.php$" -type f | xargs rm
  ```

5. Upload all of the files to your Cloud Files container:

  ```
  rack files object upload-dir \
    --container wordpress \
    --dir . \
    --recurse \
    --region ord
  ```

### Enable CDN on the Cloud Files container

After creating your Cloud Files container and uploading all of the WordPress
files to it, you need to enable CDN by following these steps:

1. Log in to the [Cloud Control Panel](https://mycloud.rackspace.com/).
2. Navigate to **Storage > Files** and ensure that the region menu is set to
  either **All Regions (Global)** or **Chicago (ORD)**.
3. Click the gear icon next to the container named **wordpress**, select
  **Make Public (Enable CDN)**, and confirm by clicking **Publish to CDN**.

   A blue globe appears to the left of the container name, indicating its public
   visibility.
4. Click the gear icon again, click **View all links** and copy the HTTPS URL to
   your clipboard.
5. Open up the **env** file that you downloaded in
   [Download an environment file](#download-an-environment-file) and set the
   value of RS_CNAME to the HTTPS URL that you just copied. Be sure to omit
   the *https://* scheme from the beginning of the URL.

### Create MySQL container

The first step is to create the container that will be running MySQL.

1. Open up the **env** file that you downloaded in
   [Download an environment file](#download-an-environment-file).

2. Generate two [strong passwords](https://strongpasswordgenerator.com/): a
   root password and a password for the `wordpress` user. Set them as
   environment variables so that you do not forget them:

   ```
   export ROOT_PASSWORD=<rootPassword>
   export WORDPRESS_PASSWORD=<wordpressPassword>
   ```

3. In the **env** file, set WORDPRESS_DB_PASSWORD to the value of
    `<wordpressPassword>` previously specified.

4. Create the container by running the following terminal command. Name the
  container `mysql` and use the password variables that you just created:

 ```
 docker run --detach \
   --name mysql \
   --env MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
   --env MYSQL_USER=wordpress \
   --env MYSQL_PASSWORD=$WORDPRESS_PASSWORD \
   --env MYSQL_DATABASE=wordpress \
   mysql
 ```

 The output should show the container ID.

5. In the **env** file, set the WORDPRESS_DB_NAME value to `wordpress` and the
   WORDPRESS_USER to `wordpress`.

6. To verify that the container is running, execute the following command:

 ```
 docker ps
 ```

 The output shows the full details of the `mysql` container, listening on port
 `3306/tcp`.

7. After your MySQL container is up and running, run the following command to
   find its IP address:

  ```
  docker inspect mysql | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4
  ```

8. In the **env** file, set WORDPRESS_DB_HOST to the value of the IP address
   from the previous step.

### Set up Redis

To improve performance, you will use Redis to cache content in memory.

1. Start a Docker container for Redis by running the following command:

  ```
  docker run --detach \
    --name redis \
    --memory 4G \
    --publish 6379 \
    --hostname redis \
    redis
  ```

  Note the `--memory` flag, which limits memory usage to a maximum of 4 GB.

2. After your Redis container is up and running, run the following command to
   find its IP address:

  ```
  docker inspect redis | egrep -e ".*HostIp.*[0-9]" | cut -d \" -f 4
  ```

3. Open the **env** file again and set the value of REDIS_IP to the IP address
   just returned.

### Prepare images

The final step is to start your NGINX front-end and PHP-FPM back-end containers.
You will be deploying variants of the following base images:

- `nginx` - Configuration values are edited to allow higher upload sizes, and a
  new configuration file added to point to the volume mount directory where your
  WordPress codebase will reside.

- `wordpress:fpm` - This image is edited in the following ways:

  - The [Redis PHP extension](https://github.com/phpredis/phpredis) is installed
    and a WordPress add-on that allows content to be cached in Redis
    is downloaded.
  - A plug-in named [W3 cache](https://wordpress.org/plugins/w3-total-cache/) is
    installed, enabled, and configured to use your CDN-enabled Cloud Files
    container. It will transfer _all_ the assets uploaded via the WordPress
    Admin control panel automatically to the cloud, ensuring that there is not
    a discord between the local state of one Docker container against any other.
  - A plugin named [NGINX helper](https://wordpress.org/plugins/nginx-helper/) is
    installed and configured.

You have the following options:

- Build the image locally from a Dockerfile and push it to your own Docker Hub account.
- Run a prebuilt image that is hosted on the `carinamarina` Docker Hub account.

If you want to use the prebuilt image, you can skip to [Deploy WordPress](#deploy-wordpress).

To build the Docker images, build it locally and push it to a central repository
such as Docker Hub.

1. Navigate to the directory that you cloned at the beginning of this tutorial.
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

By now you should have a value for each of the keys in the **env** configuration
file. Now you are ready to create a set of five WordPress container pairings,
each composed of two containers: a NGINX front end and a PHP-FPM back end.

1. Ensure that you're in the **wordpress** directory in the repo that you
   cloned at the beginning of this tutorial.

2. To create five different container pairings, run the following command:

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

  You need to substitute the following variables:

  - For `<hostname>`, use the hostname of your WordPress site. For now, you can
    make this up and include a test domain. If you use a made-up domain,
    remember this value because you'll need it again later.
  - For `<namespace>`, use your own Docker Hub account name or, if you did not
    build and push your own Docker image, use `carinamarina`.

  You can use the following command to help you replace values in your file:

  ```
  sed -i -e 's/<namespace>/rackspace/g' run.sh
  ```

3. After the containers are created, run the following command:

  ```
  bash ./run.sh
  ```

### Set up interlock

To load balance your WordPress containers, you will use a project called
[interlock](https://github.com/ehazlett/interlock). Interlock listens for
new Docker events, such as a new container being started and, according to your
configuration, notifies plugins. In your case, HAProxy will be used as a
layer 4 load-balancer, which routes incoming traffic to NGINX frontend containers.
The NGINX front ends will then proxy requests to the backend PHP-FPM pool.

To set up your load balancer container, run the following command:

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

Following are some details about this command:

- You publish `80` as the public port because that's the default port for HTTP
  connections.
- You mount the volumes from the `swarm-data` container. This might be confusing
  because you never created a container under this name, but it's a system
  container provided to you by Carina. The `swarm-data`
  container has all the necessary SSL certificates for the parent cluster,
  allowing interlock to connect to the Docker API and listen for interesting
  events.
- The `swarm-` options specify where to find all the elements necessary for
  this connection.
- You specify the plug-in as HAProxy.

### Add a hosts entry

If, in [Deploy WordPress](#deploy-wordpress), you specified a real domain for
NGINX, you can skip this step.

If you provided a test or made-up domain for your NGINX configuration, add the
following line to your system **hosts** file, because interlock
and NGINX accept only connections that match the given domain:

```
<interlockIPv4> <domain>
```

- Retrieve the interlock IPv4 address by running `docker port interlock 80`. Be
  sure to omit the `:80` from the end of the returned value.
- Replace `<domain>` with the domain that you specified back in
  [Deploy WordPress](#deploy-wordpress). For example `104.130.0.52 foo.com`.

### Test!

Verify that your stack is running by executing the following command:

```
docker ps
```

You can visit your load balancer front end by finding its IPv4 address and
opening it in your default browser:

```
open http://$(docker port interlock 80)
```

You should see the WordPress installation page. This shows you that your
load balancer is distributing requests to five different frontend/backend container
pairings split over multiple hosts. You can verify this by checking the HAProxy
stats page:

```
open http://$(docker port interlock 80)/haproxy?stats
```

You will see all of the NGINX front ends accepting connections from interlock.
