---
title: "Weekly news: Shakespeare, improved error messages, DVM, and OSCON"
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

This week's highlights include improved error messages, the use of DVM in our tutorials, and Carina representatives. But first, a little Shakespeare.

<!-- more -->

### Shakespeare

Did you know that there's a esoteric programming language inspired by the works of William Shakespeare? Declare variables in a Dramatis Personæ, implement control flow with stage actions, and decrement counters with insults. Jamie Hannaford helped us celebrate the 400th anniversary of Shakespeare's death by [running some Shakespeare code on Carina]({{ site.baseurl }}/blog/celebrating-shakespeare/).

### Improved error messages :bomb:

Because we enforce security controls at the operating system level, running afoul of [Carina's security limitations]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/#apparmor-profiles) has not been a pleasant experience. At best, you may have seen a cryptic error from Docker's internals:

```bash
$ docker run --rm -it --privileged alpine:3.3 /bin/sh
operation not permitted
FATA[0000] Error response from daemon: Cannot start container 38cc65cfe9b63c7d507c322ce673205d806fb7b7ec3c587c23c714ab6425adb6: [8] System error: operation not permitted
```

Even more jarringly, the Docker client itself sometimes panics with a stack trace:

```bash
$ docker run --rm -it -v /:/wat alpine:3.3 /bin/sh
Timestamp: 2016-05-06 14:31:45.978209702 +0000 UTC
Code: System error

Message: permission denied

Frames:
---
0: setupRootfs
Package: github.com/docker/libcontainer
File: rootfs_linux.go@29
---
1: Init
Package: github.com/docker/libcontainer.(*linuxStandardInit)
File: standard_init_linux.go@52
---
2: StartInitialization
Package: github.com/docker/libcontainer.(*LinuxFactory)
File: factory_linux.go@223
---
3: initializer
Package: FATA[0000] Error response from daemon: Cannot start container 046f6ff1c125c73acac6f2ffbb937739ba185d844f5a54275cbf795cec56e7c6: [8] System error: permission denied
```

Soon, disallowed docker commands on newly created Carina clusters will instead return [new and improved error messages]({{ site.baseurl }}/docs/reference/error-codes/) to help you understand what's gone wrong:

```bash
# TODO example CARINA-#### error code output
```

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

### Upcoming conferences

Next week O'Reilly's annual open source convention, [OSCON](http://conferences.oreilly.com/oscon/open-source-us), will take place in Austin, Texas. Catch members of the Carina team at any of these events:

* Tuesday at 9:05am, as part of Open Container Day, our own Everett Toews is hosting an ["Intro to Docker Swarm"](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/50961) tutorial.
* Wednesday at 11:05am, Everett will be presenting ["Effective Docker Swarm"](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/51213) to share additional insights on developing and deploying real-world applications on Docker Swarm.
* Wednesday at 2:40pm, Carolyn Van Slyck, Nick Silkey, and yours truly Ash Wilson will be presenting ["Think outside the container"](http://conferences.oreilly.com/oscon/open-source-us/public/schedule/detail/51253), an exploration of unconventional use-cases for Docker containers.
