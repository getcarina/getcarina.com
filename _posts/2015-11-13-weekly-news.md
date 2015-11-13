---
title: "Weekly News, DVM, carina updates"
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

## Docker 1.9 and Swarm 1.0 Available on all new clusters

Launch a cluster, get Docker 1.9 with Swarm 1.0. The biggest feature here is the new `docker network` command. Right now you can use isolated networks per swarm host; overlay networking is not available yet.

Check out [Docker 1.9's release notes](https://github.com/docker/docker/releases/tag/v1.9.0) for more details on new `docker` options and [Swarm 1.0's release notes](https://github.com/docker/swarm/releases/tag/v1.0.0) for even more.

## Docker Version Manager Release

We're proud to launch a cross platform (Windows, OS X, Linux) and multi-shell (bash, zsh, csh, powershell, cmd) compatible release of `dvm`, the Docker Version Manager.

This lets you swap between docker versions with a simple shell command, `dvm use`:

```bash
$ dvm use 1.8.2
Now using Docker 1.8.2
$ dvm use 1.9.0
Now using Docker 1.9.0
```

Installing new Docker versions is simple enough:

```
$ dvm install 1.8.3
Installing 1.8.3...
Now using Docker 1.8.3
```

As well as listing the installed versions:

```
$ dvm ls
	1.8.2
->	1.8.3
	1.9.0
	experimental (1.10.0-dev, build 0cdc96c)
	system (1.9.0)
```

Be sure to check out the [DVM announcement](https://getcarina.com/blog/docker-version-manager/) and tutorial on [Managing Docker client versions with dvm](https://getcarina.com/docs/tutorials/docker-version-manager/) for more!

## app.getcarina.com updates

For Rackspace users on app.getcarina.com, you can now use 2FA for login.

[2fa is the way]({% asset_path img/2015-11-13-weekly-news/carina-2fa.gif %})

## Carina CLI update

### Carina on Homebrew

Carina is now available through [Homebrew on OS X](http://brew.sh/) for installation:

```bash
brew install carina
```

If you were using it before with a direct download, you may want to delete that binary and update any `PATH`s you were setting before. Now a package manager has your back. When an update to the carina CLI is available, run

```bash
brew upgrade carina
```

### Notes on Carina

* If you have `GITHUB_TOKEN` set, `carina` will rely on that when checking for updates from GitHub releases.
* Tokens for Carina are cached in your `carina` config folder (OS X uses `~/.carina/cache.json`). Turn this off using `--no-cache`.

### Ch-ch-ch-changes

* The `--wait` flag has been fixed for `create` and `rebuild` (intermittent golang panics prior).

## User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)

