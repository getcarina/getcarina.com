---
title: "ScoutaPark Runs Production on Carina"
date: 2016-03-07 09:00
comments: true
author: Dan Sheppard <dan@scoutapark.com>
published: true
excerpt: >
  Hear from ScoutaPark on how they are leveraging Carina for their production application and what excites them most about the future of Carina.
categories:
 - Deployment
 - Carina
 - Docker
 - Production
 - Customer
authorIsRacker: false
---

[ScoutaPark] (http://scoutapark.com/?utm_source=Carina&utm_medium=Blog&utm_term=Carina&utm_content=Production%20Hosting&utm_campaign=Carina%20Production) is a new application to help connect park departments and park patrons. Municipalities are slow to adopt technology and with limited budgets are frequently left with more demands than funds. This leaves a gap between what park patrons come to expect in our connected life and what these municipalities can deliver. Insert ScoutaPark. Our goal is to fill this gap between municipalities and connected users through our web and mobile application.

![ScoutaPark]({% asset_path 2016-03-07-ScoutaPark-Runs-On-Carina/scoutapark.png %})

## A single deployment method

As an early stage startup, ScoutaPark depends on technology to help our small team keep focused on our minimum viable product and build a scalable cloud native application. When we started, we were using Rackspace’s public cloud to provide us with our production and staging environments which we provisioned with Chef. This made our staging and production environments different than our development environment where we use `docker-compose` to spin up our services (web, api, and database) in containers. This added risks in our development process and caused delays in code migration and increased our testing efforts. Ideally, we wanted to use the exact same tooling for development and production, but we accepted the risks of different environments in order to keep our dedicated local development environments. Since we are such a young company, our team works remotely and this makes our local development instances invaluable to us.

Having already utilized Docker heavily in these development environments we were very excited when Rackspace announced Carina, their new container service. The fact that it provides a Docker Swarm cluster was especially interesting to us as we could potentially use Docker Compose to deploy all the way through to production. A single deployment method could help reduce our development cycle time and bring to life a true continuous integration and continuous deployment (CI/CD) workflow.

On top of that, moving to a container based architecture meant that we would be able to begin architecting microservices as we add features. This approach to architecture helps us build an application that uses a minimal amount of resources when idle and can scale up as ScoutaPark grows. Which not only sounds cool, but is also one of the ways we keep our operating costs low.

## Docker Swarm in less than 10 minutes with Carina

Once Carina was announced, one of our engineers decided to experiment with it. Since we had been using Docker for our development environment we were already familiar with Docker and we found the experience with Carina was incredibly simple. We signed up for an account, clicked the button to get a new Docker Swarm cluster, and then downloaded the config files.  Once we had the config, it was as simple as running:

```
$ source ~/development/carina/scout/docker.env
$ docker-compose up
```

In less than 10 minutes of creating the account we had ScoutaPark running in Carina. This alone was a great step forward for us, we now had a way to create development and/or demonstration environments in minutes that we can share with each other, our partners, and perhaps most importantly future investors!

## From staging to production

The next obvious step was running our staging environment on it. We already had our staging database running in Cloud Databases and a Load Balancer so all we needed to do was remove the database container from our Docker Compose file and instead pass in the hostname and database credentials of the staging database.

We use [confd](https://github.com/kelseyhightower/confd) to write out our config files based on service discovery (in this case just using environment variables) and it was just a matter of using the standard Docker methods of passing environment variables.

From there, we ran `docker-compose` and our staging environment was running both our API and Web servers in containers connecting back to our cloud database.  By setting Docker Swarm's anti-affinity rules and running `docker-compose scale web=3 api=3` we were able to run three of each container while ensuring that they didn't all run on the same cluster node for a fault tolerant design.

We then pointed our Rackspace Cloud Load Balancer at the Docker Swarm cluster and after some testing removed the old VMs from the load balancer and destroyed them. After a few weeks of running staging in Carina with no issues, we decided it was time to move our production environment in as well.

To prepare to run production, we assumed we would have a lot of work to do around monitoring and logging since Carina doesn't offer the same monitoring as Rackspace's public cloud. To our surprise we discovered that we could easily integrated with several SaaS solutions for both. For logging we used a combination of [logspout](https://github.com/gliderlabs/logspout) and [PaperTrail](https://papertrailapp.com); For monitoring we used the Docker stats API to push out metrics to [Librato](librato.com).

## The future

Recently Carina introduced support for overlay networks which we have been eagerly awaiting as our Docker stack is capable of using it. With this available we are starting to experiment with using full on service discovery as well as running our MySQL databases in Carina using the work on a [Percona/Galera Docker image](https://hub.docker.com/r/paulczar/percona-galera/) by Paul Czarkowski, an advisor to ScoutaPark. This is especially exciting to us as we look to run our full stack in Carina since it offers us significant advantages in both scale and operations as we add revenue generating features and look to take on our first round of investors.
