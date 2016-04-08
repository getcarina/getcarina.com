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

Here is a collection of tips and tricks for working with Docker Swarm on Carina.

### Use an alias to check your Docker environment

```
$ alias de='env | grep DOCKER | sort'
$ de
DOCKER_CERT_PATH=/Users/octopus/.carina/clusters/octopus/dev
DOCKER_HOST=tcp://xxx.xxx.xxx.xxx:2376
DOCKER_TLS_VERIFY=1
DOCKER_VERSION=1.10.2
```

### Unset all Docker environment variables

```
$ unset ${!DOCKER_*}
```

### Log in to a container
Although it's not technically SSH, this function helps you quickly log in to a
running container so that you can look around and run commands.

1. Add the following Bash function to your Bash profile.

    ```
    docker-ssh() {
      # Try to run bash, then fallback to sh
      docker exec -it $1 /bin/sh -c "if [ -e '/bin/bash' ]; then /bin/bash; else /bin/sh; fi"
    }
    ```

1. Source your Bash profile to load the new function.

    ```
    source ~/.bash_profile
    ```

1. Log in to a running container by running the following command:

    ```
    docker-ssh <container-name>
    ```

### View the logs for the last run container
The following command displays the logs from the last container to run.

```
$ docker logs -f $(docker ps -lq)
Server has started...
Now listening on http://0.0.0.0:8080
```

Optionally, you can define an alias for this in your Bash profile.

```
alias dl='docker logs -f $(docker ps -lq)'
```

### Print the ports assigned to the last run container
The following command displays the ports that are assigned to the last container to run.

```
$ docker port $(docker ps -lq) | cut -d " " -f3
172.99.73.31:80
```

Optionally, you can define an alias for this in your Bash profile.

```
alias dp='docker port $(docker ps -lq) | cut -d " " -f3'
```

### Run a web server and get the same IP address every time

Sometimes you need your publicly accessible web server to run on the same node every time so it keeps the same IP address. You need to use a `constraint` as in the following command.

```
$ docker run --detach --net mynetwork --publish 80:80 --env constraint:node==*n1 nginx:1.9
```

This runs an NGINX web server on node 1 (`n1`) of your cluster. You could also choose `n2` or `n3`.
