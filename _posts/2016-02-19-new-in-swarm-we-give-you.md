---
title: "Weekly news - Overlay Networks, Consul, and You!"
date: 2016-02-19 11:00
comments: true
author: Anne Gentle <anne.gentle@rackspace.com>
published: true
excerpt: >
  All the news from this week: New release, overlay networking, and we want to work with you.
categories:
 - Docker
 - Affinity
 - Carina
 - News
 - Jobs
authorIsRacker: true
---

Turning clouds upside down, and connecting them ever so cleverly. It's another
weekly update from Carina-land! We now support overlay networks using Consul 
service discovery. This week's release includes upgrades to Docker Engine
and Docker Swarm to give Carina even more punch. Let's get to it.

## Overlay Networks and Consul key-value store

<img class="right" src="{% asset_path weekly-news/upsidedownowl.jpg %}" alt="flickr:theknowlesgallery"/>
<figcaption>
    <a 
    href="https://www.flickr.com/photos/theknowlesgallery/7483719462/in/photolist-qyfv1E-VrJfn-6D3TYJ-avX9ad-6uxyz7-3sTaFX-cpj24U-6v7UrJ-ctDPgq-CWNsNV-BJ9BP2-Do2VFZ-CxMW9b-6JK34g-c2rs3-8C6cWm-4WxMfj-a8hwQA-33mysT-95Lf7f-yXXWwi-Cz8boj-aKB9ZV-fqvkwx-bPHwiM-zZR9oh-zZVbPH-5hgDUw" target="_blank_">Image sourced on Flickr:theknowlesgallery</a>
</figcaption>

Once you see the cloud upside down, you can't unsee it. It's like the arrow in the
FedEx logo. In our [in-depth look at overlay networks]({{ site.baseurl }}/blog/overlay-networks/),
the cloud diagram shows how a key-value store informs all the Docker hosts about the
networks, endpoints, IP address, and DNS. Go read how you can network a couple of
containers and be selective about which ports to expose publicly.

## New releases of Docker and Docker Swarm

Docker 1.10 incorporates many changes including storage for images and layers. While the
[release notes](https://github.com/docker/docker/releases/tag/v1.10.0) mention a [migration engine](https://hub.docker.com/r/docker/v1.10-migrator/), we never upgrade your
running swarms that are already launched, so don't expect to be affected by migration delay.

There's also a [new compose file format](https://docs.docker.com/compose/compose-file/)
that lets you describe your app in a single file, and you can define and describe
relationships between services, networks, and volumes. [Docker has a blog post](https://blog.docker.com/2016/02/compose-1-6/) about the
new file to learn more. You can also specify what IP address a container should use when joining a network. Also, rather than using hosts
files, you can use a [DNS server](https://docs.docker.com/engine/userguide/networking/dockernetworks/#docker-embedded-dns-server)
for domain name resolution.

For Docker Swarm, version 1.1 has experimental rescheduling of containers when a node fails,
but it's definitely experimental so we haven't configured it yet on Carina. We'll keep
you posted on that feature. We are happy we can now see errors from nodes that fail to join
the cluster. And if you want to play around with private registries and authentication,
take a look at the [Swarm API docs](https://docs.docker.com/swarm/swarm-api/#registry-authentication).

[Docker version manager](https://getcarina.com/docs/reference/docker-version-manager/)
makes it so much easier to manage what versions you're running locally and switch between
them as needed. This is a good week to install it!

## Work with us on containers

We want to work with you and are hiring a senior engineer and senior developers. Check out
the job descriptions for our [current openings](https://github.com/getcarina/carina-jobs)
and see if you want to turn the cloud upside down too.

## We want your feedback!

Let me remind you that we design around your feedback and use-cases. We need to hear from you.

In fact, we live on user feedback for breakfast, lunch, and dinner. Got bugs? Want to
suggest some finish or polish? Looking for a pet owl? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Seriously: request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
