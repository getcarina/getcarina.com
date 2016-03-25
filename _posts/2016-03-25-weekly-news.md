---
title: "Weekly news: Nodes, fixes, and YouTube"
date: 2016-03-25
comments: true
author: Jamie Hannaford <jamie.hannaford@rackspace.com>
published: true
excerpt: >
  This week we have some important updates, including the renaming of
  "segment" to "node", documenting new fix for Docker networks, and a new
  YouTube webcast.
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

As the weekend approaches and a chocolate mountain of Easter eggs piles up,
it's time again for our weekly wrap-up where we talk about all the new shiny
things going on in Carina land. Our engineers and doc writers have continued
to develop new features and content for our users this week, with or without
the help of the Easter bunny.

### Segments are now nodes

When Carina was launched, a conscious decision was made to use the term
"segment" to describe a compute resource that serves as a Docker host. As
time went on, we realized this term wasn't the clearest or easiest to grasp.
Many folks became confused when we attempted to define what a segment was
at meet-ups or talks, and we soon realized it wasn't worth the overall
cognitive burden.

Apart from this widespread sense of confusion, when you think about it, a
segment is also an _implementation detail_ rather than an idiomatic term
within the container community. This goes against one of the founding
principles of Carina: to give people a service that provisions architecture
and gets out of their way, allowing them to use their container tooling and
idioms of choice. We don't want to introduce our own unhelpful abstractions.

With that in mind, and after a [good community discussion](https://github.com/getcarina/feedback/issues/54),
we're announcing the [renaming](https://github.com/getcarina/getcarina.com/pull/777)
of "segment" to "node" in all our documentation and control panels.

### New fix documented

Have you ever accidentally deleted the `carina-svcd` container, attempted to
create a Docker network, and gotten the following error message:

```
Error response from daemon: 500 Internal Server Error: error getting pools config from store: could not get pools config from store: Get http://localhost:12000/v1/kv/docker/network/v1.0/ipam/default/config/GlobalDefault/?consistent=: dial tcp [::1]:12000: getsockopt: connection refused
```

"Yes!", I hear you cry at the top of your voice? Well, we've now [documented the fix](https://getcarina.com/docs/troubleshooting/common-problems/#error-getting-pools-config-from-store).

### Carina on YouTube

A member of the Carina user community has [documented his experience](https://www.youtube.com/watch?v=yWPLQ7QkHLc&index=1&list=PL14f2wvjxFf3JehqasZ61eY_7bgQsSppw) using
the platform on YouTube. In a three part screencast series, he explains:

- How to install and configure Carina
- The Docker client and Carina's environment
- Creating a container and Troubleshooting

It's great to see members of the community using Carina and it's even more
amazing to see people create content that helps others learn about it.

If you have a tutorial, webcast or blog post that explains how you're using
Carina, please contact us by using the information in the following section.
We love feedback!

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
