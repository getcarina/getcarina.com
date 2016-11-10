---
title: "Announcing Carina by Rackspace"
date: 2015-10-26 00:01
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
categories:
 - Docker
 - Swarm
 - Announcements
authorIsRacker: true
---

Today on behalf of the entire Carina and Rackspace teams, I'm proud to introduce you to Carina by Rackspace. An easy to use, instant-on, native container environment (instant Docker Swarm, literally).

This is an open, free Beta designed for developers. Signup is fast, no credit card is required, and you can get started using containers via Docker and Docker Swarm in under a minute.

[Carina] is designed with you—developers and operators—in mind. We've focused on the developer experience, from our comprehensive tutorials, to a [command line interface] that is easy to [get started] with, to a streamlined user interface.

You're going to want to take a look at three key tutorials:

* [Overview of Carina]({{site.baseurl}}/docs/overview-of-carina/)
* [Getting started with Carina]({{site.baseurl}}/docs/getting-started/getting-started-on-carina/)
* [Getting started with the Carina CLI]({{site.baseurl}}/docs/getting-started/getting-started-carina-cli/)

## Details
Your containers run in a bare-metal libvirt/LXC environment, which avoids the "hypervisor tax" on performance. You can run the containers that you deploy 60% faster than the same deployment on a full virtual machine. The Carina environment builds on the standard restrictions set out by libcontainer by using an AppArmor profile as an additional security layer to keep your resources isolated.

Quite simply Carina is a lightweight provisioning system for securely deploying container orchestration environments (COEs). When you "get" a cluster, you get direct access to Docker Swarm. Later, other COEs such as Kubernetes, and other "surfaces" (virtual machines vs. libvirt/lxc) will be supported.

Here's a diagram!
![Carina overview]({% asset_path overview-of-carina/swarm-cluster.svg %})

## End to End experience

Ok, let's start with the control panel:

![control panel]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-control-panel.png %})

When you click on Add Cluster, you immediately jump into cluster creation and creation jumps straight into the building phase::

![create cluster]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-create-cluster.png %})

![cluster building]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cluster-building.png %})

So some quick notes:

1.	We just created a Docker Swarm cluster. For the Beta, you are limited to a total of 3 clusters. Let us know if you need or want more though; we're happy to oblige!

2.	The clusters house nodes. A Carina node are the resources available in a cluster. A Carina node is an LXC container provisioned by libvirt. Nodes are composed of a Swarm agent and a Docker Engine. For the Beta, you are limited to 3 total nodes. See also [Docker Swarm and Carina].

So now you have this thing - what do you do next? Click on the Get Access button to get a zip file containing all TLS certificates and a fully functional docker.env file:

![cluster credentials]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cluster-creds.png %})

Now, let me switch to the Carina [command line interface]. You’ll want to grab your API key, as shown here:

![API key]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-api-key.png %})

Assuming you've downloaded the CLI; time to configure the CLI and run the most basic command - "list", which as it's named, just lists your clusters:

![CLI env list]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-env-list.png %})

Remember the credentials download I showed from the UI before? The Carina CLI makes this easier, you call "credentials <clustername>" and it will grab the zipfile, unpack it and tell you what docker.env file to source:

![CLI credentials]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-credentials.png %})

We source the docker.env file and, well:

![CLI docker info]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-docker-info.png %})

You have a Docker Swarm! Let's test it out:

![CLI whoa]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-whoa.png %})

That's pretty easy.

## Growing up

Another cool thing is the ability to scale up the cluster via nodes to expand available resources for your containers (nodes are Docker Swarm hosts in the same cluster). This is also really easy (using the UI or CLI), for example click on the cog in the UI and "edit cluster":

![edit cluster]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-edit-cluster.png %})

Click on add nodes (remember, max 3 for now) and you'll see the cluster go into a "growing" state:

![add nodes]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-add-nodes.png %})
![state growing]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-state-growing.png %})

But what did that do? Let's check back on the command line:

![CLI lots of nodes]({% asset_path 2015-10-26-announcing-carina-by-rackspace/blog-cli-lotsofnodes.png %})

Yeah, that's 3 independent docker hosts. You get a host, you get a host, and you and you!

And if you want to go crazy, check out the [Running interlock, the event driven Docker Swarm plugin system, on Carina](https://getcarina.com/docs/tutorials/interlock-on-carina/)

## Wrap it up, Jesse

I really hope you sign up and try Carina out - the entire team was focused on making something developers would love and experiment with. It's a Beta; and we acknowledge there's going to bugs. Thats ok! Talk with us, share - and share with your friends. Honest and candid feedback is always welcome.

As an early adopter of Carina - [Andrew Odewahn](https://twitter.com/odewahn), CTO of O'Reilly Media (also, a [great developer](https://github.com/odewahn)) has been key in helping shape the platform. Hear it from him first hand:

<video width="480" height="320" controls="controls">
  <source src="http://brightcove04.brightcove.com/23/2660431281001/201510/178/2660431281001_4566909632001_4566880863001.mp4" type="video/mp4">
</video>

Thanks - and welcome to Carina!

## More Reading, community, GitHub!:
* [Understanding how Carina uses Docker Swarm](https://getcarina.com/docs/concepts/docker-swarm-carina/)
* [Documentation](https://getcarina.com/docs/)
* [Community Forums](https://community.getcarina.com/)
* IRC: **irc.freenode.net - #carina**
* GitHub: [https://github.com/getcarina](https://github.com/getcarina)




[Docker Swarm and Carina]: https://getcarina.com/docs/concepts/docker-swarm-carina/
[carina]: https://getcarina.com
[tutorials]: https://getcarina.com/docs
[command line interface]: https://github.com/getcarina/carina/releases
[get started]: https://getcarina.com/docs/getting-started/getting-started-carina-cli/
[glossary]: https://getcarina.com/docs/reference/glossary/
