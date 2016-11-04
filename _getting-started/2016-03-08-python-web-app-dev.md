---
title: Develop a Python web application
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-08
permalink: docs/tutorials/develop-a-python-web-application/
description: Develop a Python web application locally on VirtualBox and deploy it on Carina
docker-versions:
  - 1.10.2
topics:
  - docker
  - intermediate
---

This tutorial describes how to develop a Python web application locally on VirtualBox and deploy it on Carina with Docker Compose.

The application is a simple guestbook. It's enough to demonstrate a basic three-tier application. To develop the application, you'll use the following technologies:

* NGINX for the load balancer
* For the application server:
 * Python for the programming language
 * Flask for the web framework
 * Gunicorn for the WSGI server
* MySQL for the database

The final result of moving your application from VirtualBox to Carina will look as follows:

![Python Web App Development]({% asset_path python-web-app-dev/pythonwebapp.png %})

### Prerequisites

* [Install Docker Toolbox](https://www.docker.com/products/docker-toolbox)
 * On Windows during installation, check the "Git for Windows" option for easy access to `git` from the Docker Quickstart Terminal.
* [Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)
* [Sign up for an account on Docker Hub](https://hub.docker.com/)

### Clone the repo

Use `git` to clone the `getcarina/examples` repo, which contains all of the Compose files and application code that you need to a location somewhere under your home directory.

```bash
$ git clone https://github.com/getcarina/examples.git carina-examples
Cloning into 'carina-examples'...
remote: Counting objects: 325, done.
remote: Compressing objects: 100% (49/49), done.
remote: Total 325 (delta 11), reused 0 (delta 0), pack-reused 273
Receiving objects: 100% (325/325), 54.60 KiB | 0 bytes/s, done.
Resolving deltas: 100% (114/114), done.
Checking connectivity... done.
```

### Development on VirtualBox

You'll use Docker on VirtualBox as your local development environment (dev). VirtualBox was installed as part of the Docker Toolbox (see [Prerequisites](#prerequisites)).

![VirtualBox]({% asset_path python-web-app-dev/virtualbox.png %})

#### Initialize the environment in dev

1. Open the Docker Quickstart Terminal.

    When you open the terminal for the first time, it should create a default VM.

1. Confirm that the VM was created by running the following `docker-machine` command.

    ```bash
    $ docker-machine create --driver virtualbox default
    Host already exists: "default"

    $ docker-machine ls
    NAME             ACTIVE   DRIVER       STATE     URL                         SWARM                   DOCKER    ERRORS
    default          -        virtualbox   Running   tcp://192.168.99.100:2376                           v1.10.2
    ```

    If the default VM wasn't already created, the `docker-machine create` command creates it.

1. Source the environment for the default VM.

    ```bash
    $ eval $(docker-machine env default)

    $ env | grep DOCKER
    DOCKER_HOST=tcp://192.168.99.100:2376
    DOCKER_MACHINE_NAME=default
    DOCKER_TLS_VERIFY=1
    DOCKER_CERT_PATH=/Users/everett/.docker/machine/machines/default
    ```

    The environment variables that you source into your environment configure the `docker` command line interface (CLI) to communicate with the default VM running a Docker Engine.

1. Log in to Docker Hub.

    Your `<docker-hub-username>` was created as part of signing up for an account on Docker Hub (see [Prerequisites](#prerequisites)).

    ```bash
    $ docker login
    Username: <docker-hub-username>
    Password:
    WARNING: login credentials saved in /Users/everett/.docker/config.json
    Login Succeeded

    $ export DOCKER_HUB_USERNAME=<docker-hub-username>
    ```

#### Run the application in dev

1. Use the `docker-compose` command to run all of the services that make up the application.

    ```bash
    $ cd carina-examples/python-web-app

    $ docker-compose up
    Creating network "pythonwebapp_default" with the default driver
    Creating network "pythonwebapp_backend" with the default driver
    Building app
    Step 1 : FROM python:3.4
    ...
    app_1                | DEBUG: Welcome to Carina Guestbook
    app_1                | DEBUG: The log statement below is for educational purposes only. Do *not* log credentials.
    app_1                | DEBUG: mysql+pymysql://guestbook-admin:my-guestbook-admin-password@pythonwebapp_db/guestbook
    pythonwebapp_db_data exited with code 0
    db_1                 | Initializing database
    ...
    db_1                 | 2016-03-08 03:36:46 1 [Note] mysqld: ready for connections.
    db_1                 | Version: '5.6.29'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
    ```

    The output is interleaved log messages from the services that you started. As you do you development, you can refer back to this terminal to see how the services react to your development and testing.

1. Open another Docker Quickstart Terminal and run the following command.

    ```bash
    $ eval $(docker-machine env default)
    ```

1. Use `docker-compose` to run the `create_db` function from your application to initialize the database.

    ```bash
    $ cd carina-examples/python-web-app

    $ docker-compose run -d --rm --no-deps app python app.py create_db
    pythonwebapp_app_run_1
    ```

1. View the application.

    ```bash
    $ docker-machine ip default
    192.168.99.100
    ```

    You can view the application site by copying and pasting the IP address into your web browser address bar.

#### Change the application in dev

1. Open `app/templates/index.html` for editing and change every occurrence of "Guest" to "Ghost" with a case-sensitive find and replace.

1. Reload your web browser.

1. When you're ready to shut down the application, use **Ctrl+C** in the terminal where you ran `docker-compose`.

#### Build and push the images in dev

To be able to pull your application images to every node on your cluster, you first need to push them to Docker Hub.

1. Build and push the images

    ```bash
    $ declare -a images=(app db lb)

    $ for image in "${images[@]}" ; do
        IMAGE_NAME=pythonwebapp_${image}
        docker build -t ${DOCKER_HUB_USERNAME}/${IMAGE_NAME} ${image}
        docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}
      done
    Sending build context to Docker daemon 13.31 kB
    Step 1 : FROM python:3.4
    ...
    latest: digest: sha256:defc0818f08cfa04fada7bfdd917a93054c833fd6c9142dc3c941689c78967e7 size: 7850
    ```

    The output is the result of pushing your images to Docker Hub. You can view the images online at `https://hub.docker.com/u/<docker-hub-username>/`

### Deployment on Carina

You'll be using a Docker Swarm cluster on Carina as your production deployment environment (prod). This cluster was created as part of creating and connecting to a cluster (see [Prerequisites](#prerequisites)).

When you are satisfied with your development and testing in your local development environment, you can run your application on Carina to share it with the world.

![Carina]({% asset_path python-web-app-dev/carina.png %})

#### Initialize the environment in prod

1. Open a new Docker Quickstart Terminal and initialize it as per the instructions for [connecting to your cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/#connect-to-a-docker-swarm-cluster).

1. Check your environment.

    ```bash
    $ env | grep DOCKER
    DOCKER_HOST=tcp://104.130.0.205:2376
    DOCKER_TLS_VERIFY=1
    DOCKER_CERT_PATH=/Users/everett/.carina/clusters/everett/mycluster
    DOCKER_VERSION=1.10.2
    ```

    The environment variables that were sourced into your environment configure the `docker` CLI to communicate with your Carina cluster.

1. Set environment variables to configure MySQL.

    ```bash
    echo "MYSQL_USER=guestbook-admin" > pythonwebapp-mysql-prod.env
    echo "MYSQL_PASSWORD=my-random-password" >> pythonwebapp-mysql-prod.env
    echo "MYSQL_ROOT_PASSWORD=my-random-root-password" > pythonwebapp-mysql-root-prod.env
    ```

    These environment variables are written to `env` files so that they can be reused in the future.

#### Run the application in prod

1. Use the `docker-compose up` command to run the application. The `--file` flag is used to specify the production environment and the `-d` flag is used to detach from the run so that closing your terminal does not kill the application.

    ```bash
    $ docker-compose --file docker-compose-prod.yml up -d
    Creating network "pythonwebapp_default" with the default driver
    Creating network "pythonwebapp_backend" with the default driver
    Creating pythonwebapp_app_1
    Creating pythonwebapp_lb
    Creating pythonwebapp_db_data
    Creating pythonwebapp_db
    ```

    No log messages are interleaved because you detached from the run.

    To check log messages use the `docker-compose logs`, `docker logs pythonwebapp_app_1`, `docker logs pythonwebapp_db`, or `docker logs pythonwebapp_lb` command.

1. Use `docker-compose` to run the `create_db` function from your application to initialize the database.

    ```bash
    $ docker-compose --file docker-compose-prod.yml run -d --rm --no-deps app python app.py create_db
    pythonwebapp_app_run_1
    ```

1. View the application.

    ```bash
    $ docker port pythonwebapp_lb 80
    104.130.0.205:80
    ```

    You can view the application site by copying and pasting the IP address into your web browser address bar.

#### Change the application in prod

If you change the application in your development environment and you want to see those changes in your production environment, you need to rebuild your images and rerun your containers.

1. Open `app/templates/index.html` for editing and change every occurrence of "Ghost" back to "Guest" with a case-sensitive find and replace.

1. [Build and push the images](#build-and-push-the-images-in-dev). You only need to build and push the images you've changed.

1. Use the `docker-compose up` command to [run the application in production](#run-the-application-in-prod).

1. Reload your web browser.

### More actions on services

Use the following list of useful `docker-compose` subcommands to work with your services after they're running. Run `docker-compose` to see a full list of subcommands.

1. `docker-compose ps` - List services.

1. `docker-compose stop` - Stop services.

1. `docker-compose down` - Stop and remove containers, networks, images, and volumes. **Note**: This will *delete all of your data*.

1. `docker rmi pythonwebapp_lb pythonwebapp_app pythonwebapp_db` - Remove all images.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Overview of Carina]({{ site.baseurl }}/docs/overview-of-carina/)
* [Use data volume containers]({{ site.baseurl }}/docs/tutorials/data-volume-containers/)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)
* [NGINX](https://www.nginx.com/)

### Next steps

Store your data outside of a container by [connecting a Carina container to a Rackspace MySQL Cloud Database]({{ site.baseurl }}/docs/tutorials/data-stores-mysql-prod/)

Acquire free TLS certificates by using [NGINX with Let's Encrypt]({{ site.baseurl }}/docs/tutorials/nginx-with-lets-encrypt/), and use them to secure your application.
