---
title: "Weekly news"
date: 2016-01-29 13:00
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  In this week's roundup: A deeper dive into the security behind Carina, how to read your health data from Jawbone UP on Carina, and a tip on checking available disk space on your nodes.
categories:
 - Docker
 - Swarm
 - Carina
 - Rackspace
 - News
authorIsRacker: true
---

We've got a mix of things to share with you this week, from security to nodes.

## Container security

<img class="right" src="{% asset_path 2015-12-11-weekly-news/lock.png %}" alt="Securitae"/>Security is a serious issue in any environment, and security risk is inherent in any multi-tenant system. No system that shares resources among multiple tenants can truthfully be considered completely secure. It can be close, but there is always some level of risk. That risk is managed by applying a discipline of security best practices to control access to shared resources so portions of them remain reserved for the correct users. This is the approach taken for the container environment exposed by Carina.

[Container security]({{ site.baseurl }}/docs/concepts/container-security/)

## Reading your health data from Jawbone UP on Carina

<img class="right" style="max-height: 200px; width: auto;"  src="{% asset_path 2016-01-24-carina-jawbone/jawbonesleepdata.png %}" alt="Jawbone"/>It's the fourth week of January and all that health data you got over the holidays is simply waiting to be studied! Let's see how we can make our own health data dashboards using the Jawbone UP API on node.js. I know my intent is to sleep more in 2016. So, how about a chart of my sleeping habits? Thanks Jawbone!

This post provides a walk-through using Carina and Let's Encrypt along with a Jawbone UP example to make an app called Sleepify. After you log in, the app displays a table with your daily sleep amounts.

[Reading your health data from Jawbone UP on Carina]({{ site.baseurl }}/blog/carina-jawbone/)

## Check the remaining disk space on your nodes

Every node in your Carina cluster comes with 20 GB of disk space. Use the following commands to check the remaining disk space on your nodes.

```bash
$ SEGMENTS=$(docker info | grep Nodes | awk '{print $2}')
$ for (( i=1; i<=$SEGMENTS; i++ )); do
   echo "*** Node $i ***"
   docker run -it --rm --env constraint:node==*-n$i alpine:3.3 df -h /
  done
*** Node 1 ***
Filesystem                Size      Used Available Use% Mounted on
none                     19.4G      1.6G     16.8G   9% /
*** Node 2 ***
Filesystem                Size      Used Available Use% Mounted on
none                     19.4G      1.1G     17.3G   6% /
```

The output of these commands is the output of the `df` command being run on every node in your cluster. You can clearly see How much disk space is used and how much is available per node.

To reclaim disk space when you remove containers, use the `--volumes` flag (`-v` for short). However, take extreme care when you do because any data in the volumes associated with that container will be lost permanently.

```bash
$ docker rm -v my-container-name-or-id
```

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
