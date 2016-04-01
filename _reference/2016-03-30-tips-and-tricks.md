---
title: Tips and tricks
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-30
permalink: docs/reference/tips-and-tricks/
description: Tips and tricks for working with Carina
docker-versions:
  - 1.10.2
topics:
  - tips
---

A collection of tips and tricks for working with Docker Swarm on Carina.

### Alias to check your Docker environment.

```
$ alias de='env | grep DOCKER | sort'
$ de
DOCKER_CERT_PATH=/Users/octopus/.carina/clusters/octopus/dev
DOCKER_HOST=tcp://xxx.xxx.xxx.xxx:2376
DOCKER_TLS_VERIFY=1
DOCKER_VERSION=1.10.2
```

### Unset all Docker environment variables.

```
$ unset ${!DOCKER_*}
```

### Log into a container
While it's not technically SSH, this function helps you quickly log into a
running container so that you can look around and run commands.

1. Add the following bash function to your bash profile.

    ```
    docker-ssh() {
      # Try to run bash, then fallback to sh
      docker exec -it $1 /bin/sh -c "if [ -e '/bin/bash' ]; then /bin/bash; else /bin/sh; fi"
    }
    ```

1. Source your bash profile to load the new function.

    ```
    source ~/.bash_profile
    ```

1. "SSH" into a running container by running the following command:

    ```
    docker-ssh <container-name>
    ```

### View the logs for the last run container
This displays the logs from the last container to run.

```
$ docker logs -f $(docker ps -lq)
Server has started...
Now listening on http://0.0.0.0:8080
```

Optionally, you can define an alias for this in your bash profile.

```
alias dl='docker logs -f $(docker ps -lq)'
```

### Print the port(s) assigned to the last run container
This displays the port(s) assigned to the last container to run.

```
$ docker port $(docker ps -lq) | cut -d " " -f3
172.99.73.31:80
```

Optionally, you can define an alias for this in your bash profile.

```
alias dp='docker port $(docker ps -lq) | cut -d " " -f3'
```
