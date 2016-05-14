---
title: "Weekly news: Whale migration behind a corporate proxy"
date: 2016-05-14
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  This week's highlights include learning how to whale with JupyterHub, migrating to a new cluster, using Carina from behind a corporate proxy, and Carina representation at OSCON.
categories:
- News
authorIsRacker: true
---

{{ page.excerpt }}

### Learning how to whale

[Learn How to Whale]({{ site.baseurl }}/blog/learning-how-to-whale/) with JupyterHub, and use Carina to provide a Bring Your Own Compute experience to users that encourages interactivity, play, and sharing. How to Whale is an online platform that Carolyn Van Slyck created to teach Docker. Just log in with your Carina account and in minutes you have an interactive scripting notebook in your web browser. From there you can run Docker commands without having to install a thing.

![Screenshot of the Try Docker tutorial]({% asset_path learning-howtowhale/try-docker.png %})

### Migrate to a new cluster

Here's how to [migrate to a new cluster]({{ site.baseurl }}/docs/tutorials/migrate-cluster/) to take advantage of new features, security, services, and Docker versions. It demonstrates how to manage different Docker versions and how to move data from one cluster to another, and offers some tips to make the process go more smoothly in the future.

<figure>
  <img src="{% asset_path migrate-cluster/migrate.jpg %}" alt="Canada goose migrating south" title="Canada goose migrating south"/>
  <figcaption>
  Image credit: <a href="https://www.flickr.com/photos/tabor-roeder/" target="_blank_">Phil Roeder</a>
  <a href="https://creativecommons.org/licenses/by/2.0/" target="_blank_">CC BY 2.0</a>
  </figcaption>
</figure>

### Docker client behind corporate proxy

This week we had a very determined user wanting to run the [Docker client behind corporate proxy](https://community.getcarina.com/t/docker-client-behind-corporate-proxy/205) so he could use Carina from his workplace. He came up with a nifty solution in this [docker-proxy](https://github.com/vertigobr/docker-proxy) repository on GitHub. In his own words, "Docker HTTPS proxy - to use when docker client and engine are separated by a corporate proxy (Carina users will love it)."

### Upcoming appearances

Next week, O'Reilly's annual open source convention, [OSCON](http://conferences.oreilly.com/oscon/open-source-us), will take place in Austin, TX. Catch members of the Carina team at any of these events:

* Tuesday at 9:05am, as part of Open Container Day, our own Everett Toews is hosting an [Intro to Docker Swarm](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/50961) tutorial.
* Wednesday at 11:05am, Everett will be presenting [Effective Docker Swarm](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/51213) to share additional insights on developing and deploying real-world applications on Docker Swarm.
* Wednesday at 2:40pm, Carolyn Van Slyck, Nick Silkey, and Ash Wilson will be presenting [Think outside the container](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/51253), an exploration of unconventional use-cases for Docker containers.

Don't have a ticket yet? Get a free Expo Hall Plus pass for OSCON with the code SPEXPO. The pass includes events, "all the bots" day, "open container" day, [and more](http://oreil.ly/1T0euIj)!

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use [#getcarina](https://twitter.com/search?q=%23getcarina) on Twitter
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! [Learn how](https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md).
