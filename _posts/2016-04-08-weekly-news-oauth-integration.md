---
title: "Weekly news: Maintenance, OAuth, and live appearances"
date: 2016-04-08
comments: true
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
published: true
excerpt: >
  This week we have an important announcement that might require action on your part. To make up for the trouble, we have rolled out OAuth integration and upgraded to the latest version of Docker (1.10.3) and Docker Swarm (1.1.3).
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

{{ page.excerpt }}

<h3 id="upcoming-reboot">
  <img alt="Alert" src="{% asset_path 2016-04-08-weekly-news/alert.png %}" style="height: 1em; display: inline; margin: 0;" />
  Upcoming reboot
</h3>

<img class="right" src="{% asset_path 2016-04-08-weekly-news/reboot-for-glory.png %}" style="height: 300px;" alt="Keep Calm and Reboot"/>
The Linux kernel has a bug that affects containers and requires a reboot to resolve.
The Carina team will start rebooting all Carina instances on Tuesday, April 12th, at noon CST.
This process will take approximately 90 minutes. User nodes will be unavailable
for short periods of time throughout this process. Be sure to [check restart settings][restart-policies] and backup your data.

We will provide up-to-the-minute updates during the maintenance window on our [status page](https://carinabyrackspace.statuspage.io/).

For more information, see the [Linux kernel bug][kernel-bug] report.

<div style="clear: both" />

### Integrate your application with Carina using OAuth

<img class="left" src="{% asset_path carina-oauth.png %}" style="height: 150px;" alt="Integrate ALL THE THINGS!"/>
Carina now supports OAuth v2 for integrating external applications!
With Carina OAuth, you can authenticate users, download their cluster credentials,
and create clusters on their behalf. This opens the door to some pretty interesting
"bring your own compute" scenarios, such as [howtowhale.com](https://howtowhale.com),
where Carolyn Van Slyck is using Carina to teach Docker directly in the web browser.

You can find full details about how to integrate can be found in the [OAuth integration][oauth-reference] reference guide.

<div style="clear: both" />

### Effective Swarm

<img class="right" src="{% asset_path 2016-04-08-weekly-news/everett-inception.jpg %}" style="height:250px;" alt="Everett Toews"/>
The intrepid Everett Toews gave Docker Austin the [rundown on Docker Swarm][swarm-talk] last night
covering everything from Docker Swarm basics to advanced topics, such as networking and service discovery.
Those who began the night wondering _"How do I even Swarm?"_ left with best practices for effectively leveraging
Docker Swarm and fun ideas for how to use it.

<div style="clear: both" />

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.

[kernel-bug]: https://tech.vijayp.ca/linux-kernel-bug-delivers-corrupt-tcp-ip-data-to-mesos-kubernetes-docker-containers-4986f88f7a19#.ittf47p9v
[restart-policies]: https://docs.docker.com/engine/reference/run/#restart-policies-restart
[swarm-talk]: http://everett-toews.github.io/effective-docker-swarm/slides/
[oauth-reference]: {{site.baseurl}}/docs/reference/oauth-integration/
