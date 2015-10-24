---
title: "Announcing Carina by Rackspace"
date: 2015-10-26 00:01
comments: true
author: Jesse Noller
bio: >
  Boat
published: true
categories:
 - Docker
 - Swarm
 - Announcements
authorIsRacker: true
---

Today on behalf of the entire Carina & Rackspace team, I'm proud to introduce you to [Carina] by Rackspace. This is an open, free beta designed for developers. Signup is fast, takes no credit card and you can get started using containers via Docker & Docker Swarm in under a minute.

[Carina] is designed with you - developers & operators first in mind. We've focused on the developer experience from our comprehensive [tutorials], a [command line interface] that is super easy to [get started] with to a streamlined user interface.

You're going to want to take a look at three key tutorials:

* [Overview of Carina]({{site.baseurl}}/docs/overview-of-carina/)
* [Getting started with Carina]({{site.baseurl}}/docs/tutorials/getting-started-on-carina/)
* [Getting started with the CLI]({{site.baseurl}}/docs/tutorials/getting-started-carina-cli/)

## Details
Your containers run in a bare-metal libvirt/lxc environment avoiding the "hypervisor tax" on performance and running the containers you deploy 60% faster than the same deployment on a full Virtual Machine. The Carina environment builds on the standard restrictions set out by libcontainer by using an AppArmor profile as an additional security layer to keep your resources isolated.

Quite simply Carina is a light weight provisioning system for securely deploying container orchestration environments. When you "get" a cluster, you get direct access to Docker Swarm. Later, other COEs such as Kubernetes, other "surfaces" (virtual machines vs. libvirt/lxc) will be supported.

Here's a diagram!
![Carina overview]({% asset_path overview-of-carina/carina-cluster.svg %})



## End to End experience

Ok, let's start with the control panel:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-control-panel.png %}

Clicking on the big "+" box, you immediately jump into creation:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-create-cluster.png %}

It jumps straight into the building phase:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cluster-building.png %}

So some quick notes:

1. We just created a Docker Swarm cluster - for the Beta, you are limited to a total of 3 clusters. Let us know if you need/want more though, we're happy to oblige!

2. You see something called "segments" in the screenshot - the Docker Swarm clusters are housed in. A Carina segment is an LXC container provisioned by libvirt. TL;DR: a segment is a Docker host. For the Beta, you are limited to 3 total segements in a cluster.

So, ok. you have a thing - now what do you do? Click on the "Get Access" button and you will get a zip file containing all TLS certificates and a fully functional docker.env file:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cluster-creds.png %}

Now, let me switch to the carina [command line interface] - you're going to want to snag your API key as shown here:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-api-key.png %}

Assuming you've downloaded the CLI; time to configure the CLI and run the most basic command - "list", which as it's named, just lists your clusters:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-env-list.png %}

Remember the credentials download I showed from the UI before? The Carina CLI makes this easier, you call "credentials <clustername>" and it will grab the zipfile, unpack it and tell you what docker.env file to source:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-credentials.png %}

We source the docker.env file and, well:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-docker-info.png %}

You have a Docker Swarm! Let's test it out:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-whoa.png %}

That's pretty easy.

## Growing up

Another cool thing is the idea of segments / nodes that you add (Docker hosts in the same cluster). This is also really easy (using the UI or CLI), for example click on the cog in the UI and "edit cluster":

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-edit-cluster.png %}

Click on add segments (remember, max 3 for now) and you'll see the cluster go into a "growing" state:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-add-segments.png %}
{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-state-growing.png %}

But what did that do? Let's check back on the command line:

{% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-lotsofsegments.png %}

Yeah, that's 3 independent docker hosts. You get a host, you get a host, and you and you!

{% asset_path 2015-10-26-announcing-carina-by-rackspace/clustersclustersclusters.png %}

## Wrap it up, Jesse

I really hope you sign up and try Carina out - the entire team was focused on making something developers would love and experiment with. It's a Beta; and we acknowledge there's going to bugs. Thats ok! Talk with us, share - and share with your friends. Honest and candid feedback is always welcome.

Thanks - and welcome to Carina!

## More Reading, community, GitHub!:
* [Understanding how Carina uses Docker Swarm](https://getcarina.com/docs/tutorials/docker-swarm-carina/)
* [Documentation](https://getcarina.com/docs/)
* [Community Forums](https://community.getcarina.com/)
* IRC: **irc.freenode.net - #carina**
* GitHub: [https://github.com/getcarina](https://github.com/getcarina)

{% asset_path 2015-10-26-announcing-carina-by-rackspace/clustersclustersclusters.png %}



[carina]: https://getcarina.com
[tutorials]: https://getcarina.com/docs
[command line interface]: https://github.com/getcarina/carina/releases
[get started]:https://getcarina.com/docs/tutorials/getting-started-carina-cli/
