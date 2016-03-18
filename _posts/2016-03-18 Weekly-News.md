---
title: "Weekly news: Backups, patching security vulnerabilities, scheduling tasks and a testimonial"
date: 2016-03-18 13:00
comments: true
author: Kim Tryce <kim.tryce@rackspace.com>
published: true
excerpt: >
Some important updates including how to back up and restore container data, patching security vulnerabilities with Watchtower, and scheduling tasks with a cron container.  We also have a guest post by a Rackspace team who use Carina to run their ChatOps operation.
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

Follow the rainbow to the pot of gold and check out the St. Patrick's Day edition of Carina: Operational Maturity!  We have a few tutorials that lead you down the path towards a backedup and secure system.  To wrap it up, one of our product teams at the Rack decided to use Carina to run a high dependency tool, Chatops.

## Tutorial: Patching security vulnerabilities with Watchtower
Who wants to get hacked?! Security + Vulnerabilities = Buzzwords, but important ones.  Yes, it's true folks. Security vulnerabilities exist and it's important to keep your systems up to date with the latest versions.  This protects your investment of time/energy/money.  [Jamie](https://twitter.com/jamiehannaford) provides an [introduction tutorial](https://getcarina.com/docs/tutorials/patching-security-vulnerabilities/) on using [Watchtower](https://github.com/getcarina/watchtower) to detect, patch, and redeploy containers running out-of-date [Docker](https://www.docker.com/) images.

![Follow the rainbow]({% asset_path 2016-03-18-Weekly-News/security-rainbow.jpg %})

## Tutorial: Back up and restore container data
One of the most important aspects of your data is backing it up!  As Carina is in beta, we want to make sure that our users don't have a bad day and find out there has been a data loss.  In order to prevent this from happening, [Keith](https://twitter.com/ktbartholomew) provides an [example](https://getcarina.com/docs/tutorials/backup-restore-data/) using MySQL and provides concepts that can be utlized for any backup.  Knowing you have your data backed up = a good night's sleep.

![Backups!]({% asset_path 2016-03-18-Weekly-News/backup-all-the-things.jpg %})

## Tutorial: Schedule tasks with a cron container
To follow up [Keith's tutorial](https://getcarina.com/docs/tutorials/backup-restore-data/) on backing up your data, he goes the extra mile to help with the next step: automation! In [this tutorial](https://getcarina.com/docs/tutorials/schedule-tasks-cron/) Keith teaches you how to run cron job using containers to wrap up the operational aspects of protecting your backups.  But chron jobs are not just for backups! For the devops folks out there running systems and maintain environments, this tutorial is for you.    

## User Story: Moving ChatOps Into Carina
Our own [Nick](https://twitter.com/filler) from the Cloud DNS product team weaves [the tale](https://getcarina.com/blog/moving-chatops-into-carina/) of how the DNS ops team picked up their entire ChatOps operation running a Hubot instance on Heroku with a RedisToGo redis-based datastore and move the Hubot instance to Carina using Docker Compose and OjectRocket redis datastore. And it took one hour. He also touches on the `makefile` command and its usefullness. 

"The deployment story and workflows that teams can use to manage their containers in their swarm clusters is pretty powerful stuff."

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
