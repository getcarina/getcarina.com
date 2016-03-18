---
title: "Weekly news: Backups, patching security vulnerabilities, scheduling tasks and a testimonial"
date: 2016-03-18
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
  This week we have some important updates, including backing up and restoring container data, patching security vulnerabilities with watchtower, and scheduling tasks with a cron container.  We also have a guest post from a Rackspace team who uses Carina to run their ChatOps operation.
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - Watchtower
  - Cron
  - News
authorIsRacker: true
---

Follow the rainbow to the pot of gold and check out the St. Patrick's Day edition of Carina: Operational Maturity!  To start it off, one of the Rackspace product teams decided to use Carina to run a high dependency tool, ChatOps.   We also have a few tutorials that lead you down the path toward a backed up and secure system.

### User story: Moving ChatOps into Carina

Our own [Nick](https://twitter.com/filler) from the Cloud DNS product team tells [the tale](https://getcarina.com/blog/moving-chatops-into-carina/) of how the team moved their entire ChatOps platform from Heroku to Carina in <i>one hour</i>. Nick also talks about the `makefile` command and its usefulness.

"The deployment story and workflows that teams can use to manage their containers in their swarm clusters is pretty powerful stuff."

### Patching security vulnerabilities with watchtower

Who wants to get hacked?! Security + Vulnerabilities = Buzzwords, but important ones.  Security vulnerabilities exist, and it's important to keep your systems up-to-date with the latest versions.  This protects your investments of time, energy, and money.  [Jamie](https://twitter.com/jamiehannaford) provides an [introduction tutorial](https://getcarina.com/docs/tutorials/patching-security-vulnerabilities/) on using [watchtower](https://github.com/getcarina/watchtower) to redeploy containers that are running out-of-date [Docker](https://www.docker.com/) images.

### Back up and restore container data

One of the most important aspects of your data is backing it up!  As Carina is in beta, we want to ensure that our users don't have a bad day and finding out that data has been loss.  To prevent this from happening, [Keith](https://twitter.com/ktbartholomew) provides an [example](https://getcarina.com/docs/tutorials/backup-restore-data/) using MySQL and provides concepts that can be used for any backup.  Knowing you have your data backed up = a good night's sleep.

### Schedule tasks with a cron container

To follow up [Keith's tutorial](https://getcarina.com/docs/tutorials/backup-restore-data/) on backing up your data, he goes the extra mile to help with the next step: automation! In [this tutorial](https://getcarina.com/docs/tutorials/schedule-tasks-cron/), Keith teaches you how to run cron job by using containers to wrap up the operational aspects of protecting your backups.  But cron jobs are not just for backups! For the Devops folks out there running systems and maintaining environments, this tutorial is also for you.    

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
