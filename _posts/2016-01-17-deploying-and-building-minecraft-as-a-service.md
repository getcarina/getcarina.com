---
title: "Deploying and building Minecraft as a Service on Carina"
date: 2016-01-17 18:00
comments: true
author: Geoff Bourne <itzgeoff@gmail.com>
published: true
excerpt: >
  See how to develop a Java application that creates containers on Carina's Docker Swarm
  and build/deploy that application Carina.
categories:
 - Deployment
 - Carina
 - Docker
 - Swarm
 - Java
 - Build
 - Security
authorIsRacker: false
---


Both of my kids have loved Minecraft since the beta days and what they love almost as much are
adventure maps and mods -- customizations/hacks of the official engine to give new features,
creatures, or entire virtual economies.

With the [Docker image I created for running Minecraft servers](https://hub.docker.com/r/itzg/minecraft-server/)
I was able to rapidly satisfy most of their requests: "Forge server running mods X, Y, and Z that oh, by the way,
requires 1.7.8 of Minecraft specifically." Over the past year though I have dreamed of having a way for
them (or any Minecrafters) to fire up a custom server with all kinds of specific nuances without having to
know anything about Docker.

My first attempt at the idea fizzled out since managing multiple Docker daemons was complicated and
tedious. But now the stars have aligned, and I have been able to create and deploy
[Minecraft Container Yard (MCCY)](https://github.com/itzg/minecraft-container-yard)...

### Docker Swarm

[Swarm](https://docs.docker.com/swarm/) is Docker's native clustering technology that allows you to run
containers across any number of physical nodes.  What impresses me the most is that you use all of the same Docker
tools and commands with a Swarm cluster as you do with a single Docker host. By just changing `$DOCKER_HOST`
and associated environment variables you can switch back and forth between a local Docker host and a Swarm cluster.

### Carina by Rackspace

Docker has made it fairly easy to set up a Swarm cluster, but the less time spent locating a host, spinning
up nodes, and configuring Swarm is time you can use to focus on your application and deploy it.
[Carina](https://getcarina.com/) is Rackspace's hosted solution to create on-demand Swarm clusters and
it is just as easy to use as Swarm itself. Since they are providing standard Swarm clusters, there's
no proprietary configuration or commands to learn in order to deploy applications. Like Swarm itself,
what you already know about Docker simply works on Carina.

When I first discovered Carina, my son and I created an account, named a Swarm cluster, downloaded
the access files, and created a Minecraft server container in about the same amount of time it took
to download Docker Toolbox itself. This is when I knew I could finally put the power to create containers
in the hands of any Minecraft player.

### Spotify Docker API for Java

Docker's native client library is written in Go, but I'm a Java developer. Luckily for me, Spotify has
open-sourced their [Docker client](https://github.com/spotify/docker-client). To use the Docker client
in a Java project managed by Maven, just add the dependency to your `pom.xml`:

```xml
<dependency>
    <groupId>com.spotify</groupId>
    <artifactId>docker-client</artifactId>
    <version>3.3.5</version>
</dependency>
```

Their client supports not only the full REST API over http/https, but also UNIX sockets. Along with that
it supports all the aspects of Docker authentication including certificate-based authentication -- so their
Java client works with Carina right out of the box.

Let's write a little bit of Java code that creates a Minecraft server on Carina. Start by downloading the
access files for your cluster from the [Carina web UI](https://app.getcarina.com/):

![Cert download]({% asset_path 2016-01-17-deploying-and-building-minecraft-as-a-service/get-carina-access.png %})

Assuming you have sourced your unzipped Docker settings, this code will pick up the location from the environment:

```java
Optional<DockerCertificates> certs = DockerCertificates.builder()
    .dockerCertPath(Paths.get(System.getenv("DOCKER_CERT_PATH")))
    .build();
```

Now instantiate the client:

```java
final DefaultDockerClient dockerClient = DefaultDockerClient.builder()
    .dockerCertificates(certs.get())
    .uri(URI.create(System.getenv("DOCKER_HOST").replace("tcp://", "https://")))
    .build();
```

At the client API level there is not a `run` equivalent, so you create the container:

```java
final ContainerCreation container =  
    dockerClient.createContainer(ContainerConfig.builder()
    .portSpecs("25565")
    .env("EULA=TRUE")
    .openStdin(true).tty(true)
    .image("itzg/minecraft-server")
    .build());
```

Then, start it:

```java
dockerClient.startContainer(container.id());
```


### Build and deploy

Let's switch gears. Everything above was code that I needed to create containers on a Docker Swarm or
individual Docker daemon. Now, let's build and deploy the thing that creates containers as a container itself.

To keep things flexible, the deployment allows for a *target* cluster that can be different than the
*deployed* cluster. I'm also going to put an Nginx proxy in front of my web application, so we'll
end up with something like this, where I am using [CircleCI](https://circleci.com/) to execute the build:

![BuildAndDeploy]({% asset_path 2016-01-17-deploying-and-building-minecraft-as-a-service/mccy-deployment.svg %})

The first step of the build is to ensure the
[Carina CLI](https://getcarina.com/docs/getting-started/getting-started-carina-cli/) is available.
If it's not cached, then the build script downloads it:

```bash
mkdir -p ~/bin
curl -sL https://download.getcarina.com/carina/latest/$(uname -s)/$(uname -m)/carina -o ~/bin/carina
chmod u+x ~/bin/carina
```

With the `CARINA_USERNAME` and `CARINA_APIKEY` environment variables set, the credentials for the target and deploy
clusters can be obtained:

```bash
~/bin/carina credentials --path=certs $CLUSTER
```

Now we're finally ready to connect, build, and deploy. Since I also wanted to secure the proxy connection
with a Let's Encrypt SSL certificate, there were several moving parts. I combined the volume usage that
I learned from [this article](https://getcarina.com/blog/weekly-news-docker-sock-letsencrypt/)
with the [truly push button, Let's Encrypt image](https://getcarina.com/blog/push-button-lets-encrypt/).

[Docker Compose](https://docs.docker.com/compose/) came to the rescue here to keep all those moving
parts from flying away. It let me define a mix of built image with pulled image, link the two containers,
and configure them.

Here are the (somewhat re-usable) ingredients that go into a MCCY build:

* [Dockerfile](https://github.com/itzg/minecraft-container-yard/blob/master/Dockerfile)
* [Docker Compose definition](https://github.com/itzg/minecraft-container-yard/blob/master/docker-compose.yml)
* [Build Script](https://github.com/itzg/minecraft-container-yard/blob/master/build-deploy-carina.sh)
* [CircleCI project config](https://github.com/itzg/minecraft-container-yard/blob/master/circle.yml)

### Lessons learned about the build

I learned a few lessons as I figured out how to get the build going smoothly and repeatedly.
For one thing, the default version of Docker client on CircleCI is not `docker volume` aware,
so the client needed to be [explicitly upgraded](https://discuss.circleci.com/t/docker-1-9-1-is-available/1009)
in the `circle.yml`:

```yaml
machine:
  pre:
    - sudo curl -L -o /usr/bin/docker 'https://s3-external-1.amazonaws.com/circle-downloads/docker-1.9.1-circleci'
    - sudo chmod 0755 /usr/bin/docker
```

The Swarm scheduler may effectively deploy your container on any one of the nodes in the cluster.
This is a good thing, but not for a proxy where it's public IP address is bound in DNS.
To ensure my proxy always deployed to a specific node in the cluster, I obtained the node's ID
from `docker info` and passed that as `PINNED_NODE` used in the Swarm constraint declared in the `docker-compose.yml`:

```yaml
proxy:
  image: smashwilson/lets-nginx
  links:
    - mccy
  ports:
    - "80:80"
    - "443:443"
  environment:
    - "constraint:node==$PINNED_NODE"
```

To ensure the latest and greatest was getting built I added a couple of steps in my build script
to explicitly build and pull:

```bash
docker-compose build --pull
docker-compose pull
```

Finally, since I am using Docker volumes to persist data and certificates across continuous
deployments, Docker Compose started to run itself in circles trying to preserve the volumes
from one container to the next. I counteracted that whole helpfulness (this is I might be doing it wrong)
by tearing down and re-creating the service containers in my build script:

```bash
docker-compose stop
docker-compose rm -f
docker-compose up -d
```

### Conclusion

So, in conclusion you've seen that I poked and prodded Carina's Docker Swarm clusters from various
angles. It all went quite smoothly since it all works with the Docker clients and tools you're already using.
To prove the point of all this, I have a deployment of MCCY running on Carina (of course) at [https://mccy.itzg.me](https://mccy.itzg.me).
