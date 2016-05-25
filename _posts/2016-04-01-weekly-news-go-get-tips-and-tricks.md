---
title: "Weekly news: go get tips and tricks"
date: 2016-04-01
comments: true
author: Everett Toews <everett.toews@rackspace.com>
published: true
excerpt: >
  This week we have some technical tips and tricks to share with you. First is an example usage of a Go SDK for Docker and how to use it to filter the result of listing containers. Next is the beginning of a collection of command line tips and tricks you can use when working with Docker and Swarm. Finally, we show you how to proxy traffic to a MySQL server running on Carina.
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
  - News
authorIsRacker: true
---

{{ page.excerpt }}

### Filter the list of containers with a Go SDK for Docker

<img class="right" src="{% asset_path weekly-news/everybody-loves-a-skateboarding-dog.jpg %}" alt="Everybody loves a skateboarding dog"/>If you're writing an application in Go that needs to interact with your Swarm cluster, it's usually a good idea to pick up one of the many Go SDKs for Docker out there and let it do some of the heavy lifting for you. Recently I needed to filter the list of containers by labels using the [samalba/dockerclient](https://github.com/samalba/dockerclient). Once you have a [Go development environment setup](https://golang.org/doc/code.html) and you've [created and connected to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/), here's how to do it.

Create a file called list-containers.go and copy in the following Go code. The complete lack of error handling is an April Fool's Day joke. Ha!

```go
package main

import (
    "encoding/json"
    "fmt"
    "net/url"
    "os"
    "github.com/samalba/dockerclient"
)

func main() {
    tlsConfig, _ := dockerclient.TLSConfigFromCertPath(os.Getenv("DOCKER_CERT_PATH"))
    docker, _ := dockerclient.NewDockerClient(os.Getenv("DOCKER_HOST"), tlsConfig)

    filterMap := map[string][]string{ "label":[]string{"interlock.ext.service.name=myservice"} }
    filterJSON, _ := json.Marshal(filterMap)

    filterStr := string(filterJSON)
    fmt.Printf("filterStr = %s\n", filterStr)

    filterQuery := url.QueryEscape(filterStr)
    fmt.Printf("filterQuery = %s\n", filterQuery)

    containers, _ := docker.ListContainers(false, false, filterQuery)

    for _, container := range containers {
      fmt.Printf("container: names=%s labels=%s\n", container.Names, container.Labels)
    }
}
```

Then run the following `go` commands.

```bash
$ go get
$ go run list-containers.go
filterStr = {"label":["interlock.ext.service.name=myservice"]}
filterQuery = %7B%22label%22%3A%5B%22interlock.ext.service.name%3Dmyservice%22%5D%7D
container: names=[/c2e614ff-7966-4d49-aca5-9c61fee029c8-n1/grave_sammet] labels=map[com.docker.swarm.id:3cc47b7940305a84b4c38b2aedd742578cc54deed05d5c720f7cfab5f8fa4900 interlock.domain:local interlock.ext.service.name:myservice interlock.hostname:test interlock.network:mynetwork]
```

If you don't have a container with the label `interlock.ext.service.name=myservice`, you won't see any output. 😉

### Tips and tricks

We've begun a page to collect some of the [tips and tricks]({{ site.baseurl }}/docs/reference/tips-and-tricks/) we use during our day to day development. For example, I work in a lot of different Docker environments so I find it handy to have an alias that let's me know where I am.

```bash
alias de='env | grep DOCKER | sort'
```

Feel free to click on the [Edit on GitHub](https://github.com/getcarina/getcarina.com/edit/master/_reference/2016-03-30-tips-and-tricks.md) and share your own tips and tricks.

### Proxy traffic to a MySQL server

<img class="right" src="{% asset_path weekly-news/dance-corgi-dance.gif %}" alt="Dance Corgi Dance"/>If you've ever created a database server on Carina (e.g. [Use MySQL on Carina]({{ site.baseurl }}/docs/tutorials/data-stores-mysql/)) and connected it to an overlay network to avoid exposing it to the Internet hobgoblins, you'll find that you can't easily access it from your local machine. That very issue came up recently in the Carina community in [Connecting to DB via Terminal](https://community.getcarina.com/t/connecting-to-db-via-terminal/143) so I created a proxy that can give you temporary access.

Here's how to run the proxy.

```bash
$ docker run -it --rm \
  --name temp-proxy \
  --net pythonwebapp_backend \
  --publish 3306:3306 \
  --env PROTOCOL=TCP \
  --env UPSTREAM=pythonwebapp_db \
  --env UPSTREAM_PORT=3306 \
  carinamarina/nginx-proxy
Proxy TCP for pythonwebapp_db:3306
```

I like to run it with `-it` and `--rm` to ensure it's just a temporary container and gets removed when you Ctrl+C to kill the nginx process.

In another terminal.

```bash
$ docker port temp-proxy 3306
104.130.0.206:3306
```

Then you can point your favourite SQL tool at that IP/Port. I use [Sequel Pro](http://www.sequelpro.com/).

![Sequel Pro]({% asset_path weekly-news/sequel-pro.png %})

Enjoy your weekend and tonight you can fall asleep to the [soothing sounds of your favourite Star Trek vessel](http://www.thinkgeek.com/product/ivmt/?pfm=HP_Carousel_WhiteNoiseGenerator_2).

### User feedback

As a quick reminder, we live and thrive on user feedback. Bugs? Sharp edges? Want a pony? Please get in touch:

* [Community (any and all feedback)](https://community.getcarina.com/)
* [General feedback, bugs, etc.](https://github.com/getcarina/feedback)
* [Website bugs](https://github.com/getcarina/getcarina.com/issues) (Also, request new tutorials here!)
* [#carina on irc.freenode.net](https://botbot.me/freenode/carina/)
* Are you doing something interesting with Carina that you’d like to tell the world about? Share it here! <a href="https://github.com/getcarina/getcarina.com/blob/master/CONTRIBUTING.md">Learn how</a>.
