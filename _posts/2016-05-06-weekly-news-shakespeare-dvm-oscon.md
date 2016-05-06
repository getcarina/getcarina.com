---
title: "Weekly news: Shakespeare, DVM, and OSCON"
date: 2016-05-06
comments: true
author: Ash Wilson <ash.wilson@rackspace.com>
published: true
categories:
- News
- Shakespeare
- Conferences
- OSCON
- dvm
authorIsRacker: true
---

This week's highlights include container logs in the Carina web UI, the use of `dvm` in our tutorials, and Carina representation at OSCON. But first, a little Shakespeare.

<!-- more -->

### Shakespeare

Did you know that there's a esoteric programming language inspired by the works of William Shakespeare? Declare variables in a Dramatis Personæ, implement control flow with stage actions, and decrement counters with insults. Jamie Hannaford helped us celebrate the 400th anniversary of Shakespeare's death by [running some Shakespeare code on Carina]({{ site.baseurl }}/blog/celebrating-shakespeare/).

![Shakespeare nods approvingly at your code]({{ asset_path 2015-05-06-weekly-news-shakespeare-dvm-oscon/Shakespeare.jpg }})

### Container logs in the Carina web UI

Watch your containers' logs in real time, right from the [Carina control panel](https://app.getcarina.com/app/login)! Click on a cluster name, scroll to the "Containers" section, and click on the gear icon next to a container to reveal the option:

!["container logs" option]({{ asset_path 2015-05-06-weekly-news-shakespeare-dvm-oscon/container-logs-option.jpg }})

![log viewer]({{ asset_path 2015-05-06-weekly-news-shakespeare-dvm-oscon/log-viewer.jpg }})

Add multiple container names to watch output from many containers at once, like `docker-compose`:

![M-m-m-m-m-multilogs]({{ asset_path 2015-05-06-weekly-news-shakespeare-dvm-oscon/m-m-m-m-multi-logs.jpg }})

### Docker version manager

If you've ever juggled multiple Carina clusters that all use different Docker versions, then you've met the dreaded ["client and server don't have the same version" error]({{ site.baseurl }}/docs/troubleshooting/common-problems/#error-response-from-daemon-client-and-server-don-39-t-have-same-version). Our solution to keep everything synchronized is the [Docker version manager, `dvm`](https://github.com/getcarina/dvm).

```bash
$ eval "$(carina env foo)"
$ dvm use
Now using Docker 1.10.3
$ docker version
Client:
 Version:      1.10.3
 API version:  1.22
 Go version:   go1.5.3
 Git commit:   20f81dd
 Built:        Thu Mar 10 21:49:11 2016
 OS/Arch:      darwin/amd64

Server:
 Version:      swarm/1.2.0
 API version:  1.22
 Go version:   go1.5.4
 Git commit:   a6c1f14
 Built:        Wed Apr 13 05:58:31 UTC 2016
 OS/Arch:      linux/amd64
```

`dvm` has been around for a while, and thanks to the continued efforts of Carolyn Van Slyck, it's now reached a level of maturity that makes us confident in recommending it to our users. Many of our tutorials that previously referenced manual Docker installations now use `dvm` instead.

### Upcoming appearances

The week after next O'Reilly's annual open source convention, [OSCON](http://conferences.oreilly.com/oscon/open-source-us), will take place in Austin, Texas. Catch members of the Carina team at any of these events:

* Tuesday at 9:05am, as part of Open Container Day, our own Everett Toews is hosting an ["Intro to Docker Swarm"](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/50961) tutorial.
* Wednesday at 11:05am, Everett will be presenting ["Effective Docker Swarm"](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/51213) to share additional insights on developing and deploying real-world applications on Docker Swarm.
* Wednesday at 2:40pm, Carolyn Van Slyck, Nick Silkey, and yours truly Ash Wilson will be presenting ["Think outside the container"](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/51253), an exploration of unconventional use-cases for Docker containers.

Don't have a ticket yet? Get a free Expo Plus pass for OSCON with the code SPEXPO. Includes events, All the Bots Day, Open Container Day, [and more](http://oreil.ly/1T0euIj)!
