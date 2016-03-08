---
title: Develop a Python web application
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-08
permalink: docs/tutorials/develop-a-python-web-application/
description: Develop a Python web application locally on VirtualBox and deploy it on Carina
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
---

This tutorial describes how to develop a Python web application locally on VirtualBox and deploy it on Carina with Docker Compose.

The application you're going to develop is a simple guestbook. It's enough to demonstrate a basic 3 tier app. To develop the application you'll be using the following technologies:

* Nginx for the load balancer
* For the app server:
 * Python for the programming language
 * Flask for the web framework
 * Gunicorn for the WSGI server
* MySQL for the database

This is what the final result of moving your application from VirtualBox to Carina will look like.

![Python Web App Development]({% asset_path python-web-app-dev/pythonwebapp.png %})

### Prerequisites

* [Create and connect to a cluster]({{ site.baseurl }}/docs/tutorials/create-connect-cluster/)
* [Install Docker Toolbox](https://www.docker.com/products/docker-toolbox)
* [Sign up for an account on Docker Hub](https://hub.docker.com/)
* [Install Git](https://git-scm.com/downloads)

### Clone the repo

Use `git` to clone the repo that contains all of the Compose files and application code you need.

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

You'll be using Docker on VirtualBox as your local development environment. A Docker Engine will be running on a virtual machine (VM) that is running on VirtualBox.

#### Initialize the environment

1. When you open the Docker Quickstart Terminal for the first time, it should create a default VM. You can confirm this with the `docker-machine` command.

    ```bash
    $ docker-machine create --driver virtualbox default
    Host already exists: "default"

    $ docker-machine ls
    NAME             ACTIVE   DRIVER       STATE     URL                         SWARM                   DOCKER    ERRORS
    default          -        virtualbox   Running   tcp://192.168.99.100:2376                           v1.10.2
    ```

    If the default VM wasn't already created, the `docker-machine create` command will create it.

1. Source the environment for the default VM.

    ```bash
    $ eval "$(docker-machine env default)"

    $ env | grep DOCKER
    DOCKER_HOST=tcp://192.168.99.100:2376
    DOCKER_MACHINE_NAME=default
    DOCKER_TLS_VERIFY=1
    DOCKER_CERT_PATH=/Users/everett/.docker/machine/machines/default
    ```

    The environment variables that were sourced into your environment configure the `docker` command line interface (CLI) to communicate with the default VM running a Docker Engine.

#### Run the application

1. Use the `docker-compose` command to run the application.

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

    The output is interleaved blah

1. Open another terminal

    ```bash
    $ eval "$(docker-machine env default)"
    ```

1. Little bobby tables

    ```bash
    $ cd carina-examples/python-web-app

    $ docker-compose run --rm --no-deps app python app.py create_db
    DEBUG: Welcome to Carina Guestbook
    DEBUG: The log statement below is for educational purposes only. Do *not* log credentials.
    DEBUG: mysql+pymysql://guestbook-admin:my-guestbook-admin-password@pythonwebapp_db/guestbook
    DEBUG: create_db
    ...
    INFO: COMMIT
    ```

1. View the app

    ```bash
    $ docker-machine ip default
    192.168.99.100
    ```

#### Change the application

1. Open `app/templates/index.html` for editing. Change "Guest" to "Ghost" everywhere. Reload browser.

1. When you're ready to shutdown the application, use Ctrl+C in the terminal where you ran `docker-compose`.

### Deployment on Carina

You'll be using Docker Swarm on Carina as your production deployment environment.

#### Initialize the environment

1. Open another terminal. From when you created a cluster, yada yada yada. Source the environment for the Carina cluster.

    ```bash
    $ cd Downloads/mycluster

    $ source docker.env
    ```

    If you use the `carina` CLI

    ```bash
    $ eval $(carina env mycluster)
    ```

    ```bash
    $ env | grep DOCKER
    DOCKER_HOST=tcp://104.130.0.205:2376
    DOCKER_TLS_VERIFY=1
    DOCKER_CERT_PATH=/Users/everett/.carina/clusters/everett/mycluster
    DOCKER_VERSION=1.10.1
    ```

    The environment variables that were sourced into your environment configure the `docker` CLI to communicate with your Carina cluster.

#### Build the images

To be able to pull your application images to every segment on your cluster, you first need to push them to Docker Hub.

1. Login to Docker Hub

    ```bash
    $ docker login
    Username: <docker-hub-username>
    Password:
    WARNING: login credentials saved in /Users/everett/.docker/config.json
    Login Succeeded

    $ export DOCKER_HUB_USERNAME=<docker-hub-username>
    ```

1. Build and push the images

    ```bash
    $ cd carina-examples/python-web-app

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

#### Run the application

1. Configure env vars

    ```bash
    echo "MYSQL_USER=guestbook-admin" > pythonwebapp-mysql-prod.env
    echo "MYSQL_PASSWORD=$(hexdump -v -e '1/1 "%.2x"' -n 32 /dev/random)" >> pythonwebapp-mysql-prod.env
    echo "MYSQL_ROOT_PASSWORD=$(hexdump -v -e '1/1 "%.2x"' -n 32 /dev/random)" > pythonwebapp-mysql-root-prod.env
    ```

1. Use the `docker-compose` command to run the application.

    ```bash
    $ docker-compose --file docker-compose-prod.yml up -d
    Creating network "pythonwebapp_default" with the default driver
    Creating network "pythonwebapp_backend" with the default driver
    Creating pythonwebapp_app_1
    Creating pythonwebapp_lb
    Creating pythonwebapp_db_data
    Creating pythonwebapp_db
    ```

    No output is interleaved blah because `-d`

1. Little bobby tables

    ```bash
    $ docker-compose --file docker-compose-prod.yml run --rm --no-deps app python app.py create_db
    DEBUG: Welcome to Carina Guestbook
    DEBUG: The log statement below is for educational purposes only. Do *not* log credentials.
    DEBUG: mysql+pymysql://guestbook-admin:a51892b52d2df1670a395f6ef32178edbc2b7cf9a9a664ff53db7a4e1b684124@pythonwebapp_db/guestbook
    DEBUG: create_db
    ...
    INFO: COMMIT
    ```

1. View the app

    ```bash
    $ docker port pythonwebapp_lb 80
    104.130.0.205:80
    ```

#### Change the application

Now if you change the application you need to rebuild and rerun........

1. Open `app/templates/index.html` for editing. Change "Ghost" back to "Guest" everywhere.

1. Rebuild

1. Rerun

1. Reload browser

1. When you're ready to shutdown the application, `docker-compose stop`.

### Removing resources

```bash
docker-compose ps
docker-compose down

docker images
docker rmi pythonwebapp_lb pythonwebapp_app pythonwebapp_db
```

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* Carina Overview
* DVC
* Overlay networks
* Nginx

### Next

Let's Nginx

Learn more about how to [Communicate between containers over the ServiceNet internal network]({{ site.baseurl }}/docs/tutorials/servicenet/)
