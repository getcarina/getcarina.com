---
title: "Docker Austin: How Do I Even Swarm?"
date: 2016-04-11
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  Docker Austin is a meetup that runs out of one of the Austin offices of Rackspace on the first Thursday of every month. Last Thursday I gave a presentation there titled "How Do I Even Swarm?"
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

{{ page.excerpt }} I've since changed the title to "Effective Docker Swarm".

I've been attending this meetup for the past year and know everyone pretty well already. If you're in the Austin area, you're always welcome to join us at [Docker Austin](http://www.meetup.com/Docker-Austin/). Thursday night was an audience of 40-50, and they were highly engaged, to say the least. I got a lot of great, detailed questions on Carina and Swarm during the talk. I literally spent 12 minutes on the Carina architecture slide while getting peppered with questions.

Here's the video.

<iframe width="800" height="450" src="https://www.youtube.com/embed/SShmLUlrals?rel=0" frameborder="0" allowfullscreen></iframe>

The [slide deck](https://everett-toews.github.io/effective-docker-swarm/slides/index.html) contains a fair amount of code and commands that you can follow. Click the following presentation, and use the left/right keys or swipe left/right to navigate.

<iframe width="800" height="450" frameborder="0" src="https://everett-toews.github.io/effective-docker-swarm/slides/index.html">
  Effective Docker Swarm slides
</iframe>

I also got a lot of feedback on the presentation itself at the end, which was very helpful. I'm going to rework it a bit, putting more emphasis on the following topics:

* Delineation of Carina and Swarm
* Benefits of Carina
* The competitive landscape (Swarm vs. Kubernetes vs. Mesos)

I'm going to put less emphasis on Carina implementation details:

* An interesting subject, but too easy to get bogged down
* Takes emphasis away from developing and deploying apps on Carina
* Better to say "Let's chat about it after the presentation"

Overall it was a great meetup, and I really learned a lot from the audience. A colleague of mine, Margaret Eker, captured a great quote from an audience member and immortalized it in a tweet.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Carina benefits? ...Spent 4 hours today configuring a Docker swarm cluster. Tried Carina, done in a few seconds. <a href="https://twitter.com/hashtag/getcarina?src=hash">#getcarina</a>, <a href="https://twitter.com/hashtag/DockerAustin?src=hash">#DockerAustin</a></p>&mdash; Margaret Eker (@meker) <a href="https://twitter.com/meker/status/718249490025746436">April 8, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

If you're in Austin on April 26 (perhaps for the OpenStack Summit), join the Carina team at the Rackspace Cantina using this [free invitation](http://www.cvent.com/d/pfq4wl/4W). You can hear from myself on Effective Docker Swarm, Ross Kukulinski of Yodlr on Using Carina in Production, and Tim Hockin of Google on Pain Management for Containerized Apps. Grab a t-shirt, have a drink and a bite to eat, and chat containers with us.

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Use #getcarina on [Twitter](https://twitter.com/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
