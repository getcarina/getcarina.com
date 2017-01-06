---
title: "Weekly news: Docker 1.9 and Swarm 1.0 on Carina, Docker Version Manager, Carina Updates"
date: 2015-11-13 13:00
comments: true
author: Kyle Kelley <kyle.kelley@rackspace.com>
published: true
excerpt: >
  In this week's roundup: Docker 1.9 and Swarm 1.0 now on all Carina clusters, updates for the Carina CLI and GUI, official dvm release!
categories:
 - Docker
 - Swarm
 - Carina
 - News
authorIsRacker: true
---

```bash
carina create --wait blog && \
  carina credentials blog && \
  eval "$( carina env blog )" && \
  docker-compose up production
```

with that, we're off to the races with the weekly update!

## Docker 1.9 and Swarm 1.0 available on all new clusters

Launch a cluster, get Docker 1.9 with Swarm 1.0. We don't support overlay networking yet and we're still feeling out all of the nuances. Since swarm relies on overlay networks, you won't be able to use the local isolated networks either. In addition, the new volume drivers are not supported at this time. Stay tuned!

Check out [Docker 1.9's release notes](https://github.com/docker/docker/releases/tag/v1.9.0) for more details on new `docker` options and [Swarm 1.0's release notes](https://github.com/docker/swarm/releases/tag/v1.0.0) for even more.

## Docker Version Manager release

We're proud to launch a cross-platform (Windows, OS X, Linux) and multi-shell (Bash, zsh, csh, powershell, CMD) compatible release of `dvm`, the Docker Version Manager.

This lets you swap between docker versions with a simple shell command, `dvm use`:

```bash
$ dvm use 1.8.2
Now using Docker 1.8.2
$ dvm use 1.9.0
Now using Docker 1.9.0
```

Installing new Docker versions is as simple as:

```
$ dvm install 1.8.3
Installing 1.8.3...
Now using Docker 1.8.3
```

`dvm ls` lists the installed versions:

```
$ dvm ls
	1.8.2
->	1.8.3
	1.9.0
	experimental (1.10.0-dev, build 0cdc96c)
	system (1.9.0)
```

See the [DVM announcement](https://getcarina.com/blog/docker-version-manager/) and tutorial on [Managing Docker client versions with dvm](https://getcarina.com/docs/reference/docker-version-manager/) for more!

## app.getcarina.com updates

Existing Rackspace users can now log in to app.getcarina.com using multi-factor authentication. Multi-factor settings can be edited from the Rackspace Control Panel. Multi-factor authentication is not yet available for users who signed up for Carina without an existing Rackspace cloud account.

![2fa is the way]({% asset_path 2015-11-13-weekly-news/carina-2fa.gif %})

## Carina CLI update

### Carina on Homebrew

You can now install `carina` through [Homebrew on OS X](http://brew.sh/):

```bash
brew update
brew install carina
```

If you were using `carina` before with a direct download, consider deleting that binary, updating any `PATH` variables you previously set and rely on homebrew for updates:

```bash
brew upgrade carina
```

### Notes on carina

* If you have `GITHUB_TOKEN` set, `carina` will rely on that when checking for updates from GitHub releases.
* Tokens for Carina are cached in your `carina` config folder (OS X uses `~/.carina/cache.json`). Turn this off using `--no-cache`.

### Ch-ch-ch-changes

* The `--wait` flag has been fixed and stabilized for `create` and `rebuild`.

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)

