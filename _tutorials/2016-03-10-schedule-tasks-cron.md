---
title: Schedule tasks with a cron container
author: Keith Bartholomew <keith.bartholomew@rackspace.com>
date: 2016-03-10
permalink: docs/tutorials/schedule-tasks-cron/
description: Create a small container
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
---

This tutorial explains how to configure a container that runs arbitrary tasks on a schedule. Scheduled tasks are commonly used to run backups, clean up temporary files, or perform other routine maintenance.

### Prerequisites

Before you begin, you need to be able to [create and connect to a Carina cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/).

### Create a cron image

1. Run the following command to create empty directories for each of the default cron intervals:

    ```bash
    mkdir -p tasks/{15min,hourly,daily,weekly,monthly}
    ```
1. Create a file named `hello-world` in the `tasks/15min` folder, with the following contents:

    ```bash
    #!/bin/sh

    docker run --rm hello-world
    ```

    This very simple shell script will run the official [`hello-world`](https://hub.docker.com/_/hello-world/) Docker image. Because you created the file in `tasks/15min/`, cron will run this script every 15 minutes. You can place files in the other directories you created to have them run every hour, day, week, or month as the names of each directory indicate.

1. Create a file named `Dockerfile` with the following contents:

    ```Dockerfile
    FROM alpine:3.3

    RUN apk add --update --no-cache docker

    COPY tasks/ /etc/periodic/
    RUN chmod -R +x /etc/periodic/

    RUN mkdir -p /var/run/docker && \
      ln -s /etc/docker/ca.pem /var/run/docker/ca.pem && \
      ln -s /etc/docker/server-cert.pem /var/run/docker/cert.pem && \
      ln -s /etc/docker/server-key.pem /var/run/docker/key.pem

    CMD ["crond", "-f", "-d", "8"]
    ```

    In this simple Dockerfile, you’re doing the following:

    1. Extending the [Alpine Linux Docker Image](https://github.com/gliderlabs/docker-alpine).
    1. Using Alpine's package manager, `apk`, to install Docker, allowing this container to run Docker commands.
    1. Copying all the files/folders you created in the `tasks/` directory to the location in Alpine where scheduled tasks are stored, and making sure they can be executed by cron.
    1. Creating a directory and symlinks for the certificates this container will need to communicate with your Carina cluster.
    1. Running the `crond` daemon in the foreground (so your container doesn't exit right away) and outputting the logs to stderr (so you can see the output of your scheduled tasks using `docker logs`)

1. Build the image and assign it a tag by running the following command:

    ```bash
    docker build -t cron .
    ```

### Run the cron container

Start the cron container with the following command:

```bash
docker run \
--env DOCKER_HOST=${DOCKER_HOST} \
--env DOCKER_TLS_VERIFY=${DOCKER_TLS_VERIFY} \
--env DOCKER_CERT_PATH=/var/run/docker/ \
--detach \
--name my-cron-container \
--volumes-from swarm-data \
cron
```

Docker will return the ID of the newly created container. The cron container will now run forever (hopefully) and run the `hello-world` image once every 15 minutes.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next steps

Do something more useful with your cron container, like [renew Let's Encrypt SSL certificates]({{ site.baseurl}}/docs/tutorials/nginx-with-lets-encrypt/#reissue-certificates-with-a-cron-container).
