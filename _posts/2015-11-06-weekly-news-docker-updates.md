---
title: "Weekly News, Docker 1.9 Jobs and More"
date: 2015-11-06 11:00
comments: true
author: Jesse Noller <jesse.noller@rackspace.com>
published: true
excerpt: >
  In this week’s roundup: We’re hiring, Docker announces Docker 1.9 and Swarm 1.0, and the Carina CLI and GUI add new time-saving features!
categories:
 - Docker
 - Swarm
 - Carina
 - News
authorIsRacker: true
---

### We're Hiring

We're hiring for engineers! Remote is OK (most of us are remote). In true keeping we've put the [contact information and job descriptions in GitHub](https://github.com/getcarina/carina-jobs). We're really excited to add to the team!

*Must have 10 years Docker experience* (no, not really).

### Docker 1.9

Perhaps the biggest announcement in the community this week came from [@docker](https://twitter.com/docker): [Docker 1.9 / Swarm 1.0 was announced](http://blog.docker.com/2015/11/docker-1-9-production-ready-swarm-multi-host-networking/). The Carina team is excited about all the new stuff in [Swarm 1.0](http://blog.docker.com/2015/11/swarm-1-0/) including multi-host networking, bug fixes, scheduler updates and a [heck of a lot more](https://github.com/docker/swarm/releases/tag/v1.0.0).

Also, thank you to the Docker team for the shout-out! If we had a cool animal logo we'd draw it hugging a whale!

The team is hard at work getting Docker 1.9 support into the system; as soon as it's available we'll let you know. We lag slightly behind Docker releases to ensure everything "just works", security changes, compatibility, etc.

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Product bugs](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [Community (any and all feedback)](https://community.getcarina.com/)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)

### Carina CLI update & release!

[Get it!](https://github.com/getcarina/carina/releases)

Introducing a brand new `carina env` command! No more downloading credentials *when you already have them*. This cuts your time to hero down quite a bit. ([carina#52](https://github.com/getcarina/carina/pull/52) and [carina#53](https://github.com/getcarina/carina/pull/53)) This also helps with the network sensitivity (note poor Wi-Fi connection below):

```bash
$ time eval "$( carina env mycluster )"

real	0m0.028s
user	0m0.004s
sys	0m0.040s
$ time eval "$( carina credentials mycluster )"

real	0m5.047s
user	0m0.046s
sys	0m0.200s
```

This release also matches the `docker-machine` semantics better.

```bash
$ eval "$( carina env mycluster )"
$ ### instead of
$ eval "$( carina credentials mycluster )"
```

* If you have `GITHUB_TOKEN` set, `carina` will rely on that when checking for updates ([carina#50](https://github.com/getcarina/carina/pull/50))
* `carina ls` is a hidden command that does `carina list` ([carina#48](https://github.com/getcarina/carina/pull/48))
* Tokens for Carina are now cached in your `carina` config folder (OS X uses `~/.carina/cache.json`). Turn this off using `--no-cache`. This ends up saving about a second on our machines. Your results may vary. ([carina#56](https://github.com/getcarina/carina/pull/56))

### Carina Changes

* **Fixed**: If you're a Carina user and have forgotten your password, password reset is now available [on the control panel](https://app.getcarina.com).
* **New/Updated**: Based on feedback and last weeks blog post we have published a [full tutorial on using the ServiceNet networking](https://getcarina.com/docs/tutorials/servicenet/) for inter-container communication. Take a look, and if something is unclear, please [file a bug](https://github.com/getcarina/getcarina.com/issues).
