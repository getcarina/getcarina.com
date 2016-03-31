---
title: "Moving ChatOps Into Carina"
date: 2016-03-15 16:00
comments: true
author: Nick Silkey <nick.silkey@rackspace.com>
published: true
excerpt: >
  The Rackspace Cloud DNS team migrated their ChatOps workloads into Carina with great success and little effort.
categories:
 - Deployment
 - Carina
 - Docker
 - Production
 - ChatOps
 - Heroku
 - ObjectRocket
authorIsRacker: true
---

I am a systems engineer on the Rackspace Cloud DNS product team.  We are a small nimble team who have been able to move [quickly and accurately](https://speakerdeck.com/filler/the-ops-must-be-crazy-hack-your-teams-ops-culture-with-one-weird).  Like many other teams within Rackspace, we have been leveraging [ChatOps](https://speakerdeck.com/jnewland/chatops-at-github) as a tool to both [enable clear communications](https://www.pagerduty.com/blog/what-is-chatops/) and [automate routine tasks](http://blog.flowdock.com/2014/11/11/chatops-devops-with-hubot/) in the open for full transparency across the team.

## The Preamble

Our ChatOps journey began like most teams in that we quickly spun up a proof-of-concept [Hubot](https://hubot.github.com/) instance on [Heroku](https://www.heroku.com/home).  The barrier to entry was really low and the deployment story was great.  We were able to track our ChatOps bot instance as version-controlled code, with peer review, with options to roll updates in a streamlined fashion to maximize availability.  We were quickly enamored with not only that but all the other values that ChatOps brings to the table.

As our [product development matured](http://blog.rackspace.com/sign-now-early-access-rackspace-managed-dns-powered-openstack/), we realized that we needed to better [own the availability](http://www.whoownsmyavailability.com/) of our Hubot instance .  We were running on a skunkworks, no-cost plan at Heroku.  Moreover Heroku recently changed its service offering to enforce that said free plans enforce a ['sleep' policy](https://devcenter.heroku.com/articles/dyno-sleeping) on apps hosted in their fleet.  This means that there would be times where our instance would be unavailable.  Not good for a 3am on-call issue where ChatOps is integral to your team's incident response workflows!  While there are [some tactics to help maximize availability of your instance](https://github.com/hubot-scripts/hubot-heroku-keepalive), we realized that we would have to change things up for something so integral to our team's operations.

Our initial thought was to bring the Hubot instance and its Redis-based datastore into a Rackspace Public Cloud instance.  We started assembling the necessary configuration management code to do the needful.  However at the OpenStack Summit in Tokyo we got to see how easy Carina was to both get started with and to manage the lifecycle of container-based applications.

![A Bright Idea]({% asset_path 2016-03-15-moving-chatops-into-carina/lloyd-idea.gif %})

## Why Not Carina?

Our team rallied behind the idea of moving our ChatOps instance into Carina.  We were reasonably savvy using [Docker](https://www.docker.com/) for things like peer-reviewing the team's [Jenkins Job Builder](http://docs.openstack.org/infra/jenkins-job-builder/) changes.  Also [one of our developers](http://ionrock.org/) was able to bring a [proof of concept of our stack](https://github.com/rackerlabs/designate-carina), powered by [OpenStack Designate](http://docs.openstack.org/developer/designate/), into Carina via [`docker-compose`](https://docs.docker.com/compose/).

One thing we were still having to evaluate was what to do about the persistent datastore component of Hubot's redis-brain.  We were using the free RedisToGo offering bundled with Heroku.  One option was using a [data container running Redis in Carina](https://getcarina.com/docs/tutorials/data-stores-redis/) linked to a ChatOps container via docker-swarm networking.  The other option on the table was leveraging [ObjectRocket's hosted Redis service](http://objectrocket.com/).  Since ObjectRocket is considered best of breed when it comes to datastore availability and management, we opted for that solution.

One afternoon a team member bit off the story in the product's backlog to migrate our ChatOps instance from Heroku to Carina.  The nature of the task was to shutdown the Heroku-hosted instance, backup the RedisToGo-hosted datastore, restore the datastore dump into ObjectRocket, build a ChatOps Docker container, and run said container in Carina.

And it literally took under an hour to do all that.  Color me impressed.

![Color me impressed]({% asset_path 2016-03-15-moving-chatops-into-carina/aha.gif %})

## Migrating To Carina

The RedisToGo instance's connection information was available as the `REDISTOGO_URL` environment variable of the Hubot instance via the [`heroku-toolbelt`](https://toolbelt.heroku.com/) by way of a `heroku config --app=${APP}`.  Using this connection string information, we were able to use the `redis-cli` to pull down an `rdb` dump of the Redis instance which powered Hubot's redis-brain.

```bash
# Set some env vars
DUMP=designate.hubot.`date +%Y%m%d`.rdb
HOST=host.redistogo.com
PORT=10411
PASS=awesomerandopass

# Dump Redis to a local backup
redis-cli \
-h ${HOST} \
-p ${PORT} \
-a ${PASS} \
--rdb ${DUMP}
```

After successfully capturing the dump, we verified the state of the dump was healthy via `redis-check-dump`:

```bash
redis-check-dump ${DUMP}
```

Finally, we provisioned a Redis instance in ObjectRocket.  At the time of this blog, ObjectRocket's Redis offering features a highly available two node Redis pod managed via [Sentinel](http://redis.io/topics/sentinel).  It is available in the three US-based Rackspace regions and the London region.

One thing that contrasts ObjectRocket's Redis offering from RedisToGo is that its ingress filtered by default ... which is a good thing!  Once provisioned we were able to use the ObjectRocket panel to allow an ingress permit from the host where we captured the RedisToGo dump to.  Using [`rdbtools`](https://github.com/sripathikrishnan/redis-rdb-tools), we were able to push our rdb-based dump into our newly-provisioned ObjectRocket Redis instance:

```bash
HOST=lengthyhash.publb.rackspaceclouddb.com
PORT=6379
PASS=awesomerandopass

rdb --command protocol ${DUMP} | \
redis-cli \
-h ${HOST} \
-p ${PORT} \
-a ${PASS} \
--pipe
```

With the redis-brain migrated, we set out to build the hubot container for use in Carina.

## We Can Rebuild Him!

As was done with the `heroku config` function to retrieve the `REDISTOGO_URL` environment variable from the Heroku-based Hubot instance, we were able to retrieve all the other bootstrapped environment variables of varying use.  Examples here include GitHub, Jenkins, PagerDuty, and Slack related strings necessary for their respective integrations.

With all those configuration values, we were able to setup a simple `Dockerfile` which setup all that was necessary to run the Hubot instance in Carina.

```
FROM node:4
MAINTAINER Cloud DNS, dnsaas@rackspace.com

ENV HUBOT_GITHUB_ORG                    rackerlabs
ENV HUBOT_GITHUB_TOKEN                  somegithubtoken
ENV HUBOT_RACKSPACE_API                 someracktoken
ENV HUBOT_PAGERDUTY_USER_ID             somepagertoken
ENV HUBOT_SLACK_TOKEN                   someslacktoken
ENV REDIS_URL                           redis://objectrocket:someredispass@someobjectrockethash.publb.rackspaceclouddb.com:6379/

ENV BOTDIR /opt/bot

RUN mkdir ${BOTDIR}

COPY package.json ${BOTDIR}
WORKDIR ${BOTDIR}
RUN npm install
COPY . ${BOTDIR}

CMD bin/hubot -a slack
```

Voila!

One other thing to note is that you do have to set another ingress permit from your swarm cluster in Carina into your ObjectRocket Redis instance.  As mentioned, its firewalled off by default.  You can grab the IPv4 egress IP of your Carina cluster via a `docker info`.  Taking that IPv4 address to the ObjectRocket control panel to permit access into your hosted Redis instance should be all you need to have your Hubot instance talking to ObjectRocket-hosted redis-brain!

## `make` All The Things!

One thing my team has some love for is using `Makefile`s in order to automate commonly-used tasks.  We setup some simple `make` targets which aim to help streamline Carina-based operations as they relate to Hubot.

This takes advantage of [withenv](http://withenv.readthedocs.org/en/latest/), a little Python utility written by an [awesome team member](http://ionrock.org/) which chomps YAML and renders environment variables.  We seed a `.creds.yml` file with our Carina username (`CARINA_USERNAME`) and API key (`CARINA_APIKEY`) and voila!  Each `make` target prepends its operation with seeding the env with these vars to make `carina` and `docker` commands work without implicit steps to setup environment variables in your shell.

```bash
.PHONY: help
.DEFAULT_GOAL := help

SHELL := /bin/bash
VENV := .venv
CARINA_CREDS_YML := .creds.yml
CARINA_CLUSTER_NAME := 'designate-hubot'
CONTAINER := $(CARINA_CLUSTER_NAME)
WITH_CLUSTER := eval `$(VENV)/bin/we -e $(CARINA_CREDS_YML) carina env $(CARINA_CLUSTER_NAME)`

# Inspired by http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# The pipe to sort in here sorts our friends, ignoring target places in the Makefile
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## Setup dependencies via homebrew, pop venv
	@brew install carina docker npm jq
	@if [ ! -d "$(VENV)" ]; then virtualenv $(VENV) ; fi
	@$(VENV)/bin/pip install withenv

carina-create: ## Create carina swarm cluster
	@$(WITH_CLUSTER) && carina create --segments=1 --autoscale --wait $(CONTAINER)

carina-delete: ## Delete carina swarm cluster
	@$(WITH_CLUSTER) && carina delete $(CONTAINER)

carina-info: ## Show carina stats via docker info
	@$(WITH_CLUSTER) && docker info

d-ps: ## Check on running docker containers

	@$(WITH_CLUSTER) && docker ps -a

d-build: ## Build designate-hubot docker container
	@$(WITH_CLUSTER) && docker build -t $(CONTAINER) .

d-run: ## Run designate-hubot docker container
	@$(WITH_CLUSTER) && docker run --name $(CONTAINER) -d $(CONTAINER)

d-rm: ## Remove designate-hubot docker container
	@$(WITH_CLUSTER) && docker rm $(CONTAINER)

d-clean: ## Remove all exited docker containers
	@$(WITH_CLUSTER) && docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm

d-start: ## Start designate-hubot docker container
	@$(WITH_CLUSTER) && docker start $(CONTAINER)

d-stop: ## Stop designate-hubot docker container
	@$(WITH_CLUSTER) && docker stop $(CONTAINER)

d-kill: ## Kill designate-hubot docker container
	@$(WITH_CLUSTER) && docker kill $(CONTAINER)

d-roll: d-stop d-rm d-build d-run ## Kicks off stop, build, start

d-restart: d-stop d-start ## Kicks off stop, start

d-logs: ## Pulls logs from designate-hubot docker container
	@$(WITH_CLUSTER) && docker logs $(CONTAINER)

d-compose: ## Calls docker-compose up
	@$(WITH_CLUSTER) && docker-compose up -d

check-pkg-var:
ifndef HUBOT_PACKAGE
	$(error HUBOT_PACKAGE is undefined.  Try again with make target HUBOT_PACKAGE=hubot-awesome-package)
endif

pkg-add: check-pkg-var ## Adds an npm package to hubots manifest
	@$(WITH_CLUSTER) && npm install $(HUBOT_PACKAGE) --save

pkg-search: check-pkg-var ## Searches for an npm package upstream
	@$(WITH_CLUSTER) && npm search $(HUBOT_PACKAGE)

pkg-up: ## Updates all packages in hubots manifest
	@$(shell $(WITH_CLUSTER) && for pkg in `cat package.json | jq .dependencies | \
		grep \" | awk -F\" {'print $2'}` ; do \
		npm install $pkg@\* --save ; done)
```

This allows us to do some powerful things via some simple `make` targets which are close to the code.

```bash
$ make
carina-create                  Create carina swarm cluster
carina-delete                  Delete carina swarm cluster
carina-info                    Show carina stats via docker info
d-build                        Build designate-hubot docker container
d-clean                        Remove all exited docker containers
d-compose                      Calls docker-compose up
d-kill                         Kill designate-hubot docker container
d-logs                         Pulls logs from designate-hubot docker container
d-ps                           Check on running docker containers
d-restart                      Kicks off stop, start
d-rm                           Remove designate-hubot docker container
d-roll                         Kicks off stop, build, start
d-run                          Run designate-hubot docker container
d-start                        Start designate-hubot docker container
d-stop                         Stop designate-hubot docker container
pkg-add                        Adds an npm package to hubots manifest
pkg-search                     Searches for an npm package upstream
pkg-up                         Updates all packages in hubots manifest
setup                          Setup dependencies via homebrew, pop venv
$ make d-build
Sending build context to Docker daemon  85.5 kB
Step 1 : FROM node:4
 ---> 3538b8c69182
...
Step 55 : CMD bin/hubot -a slack
 ---> Using cache
 ---> 13115b0a1a31
Successfully built 13115b0a1a31
$ make d-ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
82498aee00d1        swarm:1.1.0         "/swarm manage -H=tcp"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-manager
84f8c076d7ff        swarm:1.1.0         "/swarm join --addr=1"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-agent
78e398317263        cirros              "/sbin/init"             3 weeks ago                                                 5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-data
2c7497c66de7        carina/consul       "/bin/consul agent -b"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/carina-svcd
073068bcc147        cirros              "/sbin/init"             3 weeks ago                                                 5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/carina-svcd-data
$ make d-run
64f69ec5117ff40a9ce50f98eecbfb16f6298702b1fd396f0f0f1ecd383a1c6c
$ make d-ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
64f69ec5117f        designate-hubot     "/bin/sh -c 'bin/hubo"   23 seconds ago      Up 23 seconds                           5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/designate-hubot
82498aee00d1        swarm:1.1.0         "/swarm manage -H=tcp"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-manager
84f8c076d7ff        swarm:1.1.0         "/swarm join --addr=1"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-agent
78e398317263        cirros              "/sbin/init"             3 weeks ago                                                 5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-data
2c7497c66de7        carina/consul       "/bin/consul agent -b"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/carina-svcd
073068bcc147        cirros              "/sbin/init"             3 weeks ago                                                 5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/carina-svcd-data
$ make d-roll
designate-hubot
Sending build context to Docker daemon  85.5 kB
Step 1 : FROM node:4
 ---> 3538b8c69182
...
Step 55 : CMD bin/hubot -a slack
 ---> Using cache
 ---> cc96dedbab4f
Successfully built cc96dedbab4f
5426b8a6d1931d395d6cba7faac05258f21c29f043be3568ec698a192b2c5164
$ make d-ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
  5426b8a6d193        designate-hubot     "/bin/sh -c 'bin/hubo"   5 seconds ago       Up 4 seconds                            5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/designate-hubot
  82498aee00d1        swarm:1.1.0         "/swarm manage -H=tcp"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-manager
  84f8c076d7ff        swarm:1.1.0         "/swarm join --addr=1"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-agent
  78e398317263        cirros              "/sbin/init"             3 weeks ago                                                 5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/swarm-data
  2c7497c66de7        carina/consul       "/bin/consul agent -b"   3 weeks ago         Up 3 weeks                              5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/carina-svcd
  073068bcc147        cirros              "/sbin/init"             3 weeks ago                                                 5b26b03f-f3ed-4b0c-835e-2d69745aacb4-n1/carina-svcd-data
$ make d-logs
npm info it worked if it ends with ok
npm info using npm@2.14.12
npm info using node@v4.3.2
npm info preinstall designate-hubot@0.0.0
npm info package.json githubot@1.0.0 No license field.
npm info package.json htmlparser@1.7.7 No license field.
npm info package.json hubot-reactgif@1.0.0 No license field.
npm info package.json hubot-scripts@2.16.2 No license field.
npm info package.json kg@1.0.0 license should be a valid SPDX license expression
npm info package.json nodepie@0.7.0 No license field.
npm info build /opt/bot
npm info linkStuff designate-hubot@0.0.0
npm info install designate-hubot@0.0.0
npm info postinstall designate-hubot@0.0.0
npm info prepublish designate-hubot@0.0.0
npm info ok
[Thu Mar 31 2016 15:27:57 GMT+0000 (UTC)] INFO Connecting...
[Thu Mar 31 2016 15:27:57 GMT+0000 (UTC)] INFO Logged in as hubot of Cloud DNS, but not yet connected
[Thu Mar 31 2016 15:27:57 GMT+0000 (UTC)] INFO Slack client now connected
[Thu Mar 31 2016 15:27:57 GMT+0000 (UTC)] INFO /opt/bot/scripts/popapad.coffee is using deprecated documentation syntax
(node) sys is deprecated. Use util instead.
[Thu Mar 31 2016 15:28:01 GMT+0000 (UTC)] INFO hubot-redis-brain: Discovered redis from REDIS_URL environment variable
[Thu Mar 31 2016 15:28:01 GMT+0000 (UTC)] INFO hubot-redis-brain: Successfully authenticated to Redis
[Thu Mar 31 2016 15:28:01 GMT+0000 (UTC)] INFO hubot-redis-brain: Data for hubot brain retrieved from Redis
```

This makes it trivial to hand these operations over to continuous integration in order to allow code changes to Hubot to lifecycle manage our always running ChatOps container in Carina!  Its as simple as a `make d-roll` to CI!

One final thing we do is set a `.dockerignore` in the Hubot repository to keep cruft which doesnt need to go to the Docker daemon from going.  This keeps the 'context' thats sent to the Docker daemon lean for more rapid builds, rolls, etc.

Our example `.dockerignore`:

```
.git
node_modules
```

## Onward and Upward

Some additional stuff we would like to do is fold the shell-prep steps into the Makefile as appropriate.  And also perhaps move the ENV setting as is done in the `Dockerfile` to something like service discovery with Consul.

Another thing we are interested in pursuing is the idea of moving configuration management operations into ChatOps.  Our team uses a combination of [Chef](https://www.chef.io/) and [Ansible](https://www.ansible.com/) to achieve both persistent declarative state and imperative orchestration operations respectively.  Carina enables our team to bring tooling like the [chefdk](https://downloads.chef.io/chef-dk/) and the relevant [`knife.rb`](https://docs.chef.io/config_rb_knife.html) and related keys into the container and have [chat-based `knife`](https://github.com/hubot-scripts/hubot-chef) operations succeed.  Quick proof of concept attempts at making this work are promising (eg "@hubot knife role show rax_resolver")!

![Impressive!]({% asset_path 2016-03-15-moving-chatops-into-carina/impressive.gif %})

Overall the Cloud DNS product team was extremely impressed with how easy it was to get started using Carina.  Also the deployment story and workflows that teams can use to manage their containers in their swarm clusters is pretty powerful stuff.  The turnkey nature of Heroku is almost completely captured by Carina in addition to allowing for some deeper functionality if desired!

## Update

I circled back and corrected some inaccuracies in this writeup.  Namely I added a 'login' to the `REDIS_URL` string.  Its arbitrary, but something that the existing `redis-brain` plugin expects when it reads the Redis string and chomps the authentication bits.  Without this arbitrary 'login', you would not see the hubot instance successfully binding to your `redis-brain`.

Also I included some additional `Makefile` improvements that my team has iterated on.  The big takeaway is that the targets in this `Makefile` are 'self-documenting' via a [recent writeup](http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html).  This makes it trivial to onboard new targets that perform some sort of named function.  It means you dont have to remember to carry your 'docs' to the `help` target block to provide helper text to your users.  A++++ WOULD MAKE AGAIN!
