---
title: Introduction to RCS
author: Constanze Kratel <constanze.kratel@rackspace.com>
date: 2015-10-03
permalink: docs/tutorials/intro-to-rcs/
description: How to get started with Rackspace Container Service
docker-versions:
  - 1.8.2
topics:
  - docker
  - beginner
---

### Before you get started
Before you get started with Rackspace Container Service, you should do the following:

* Watch the [Introduction to Docker](https://sysadmincasts.com/episodes/31-introduction-to-docker) video.
* Ensure that your Rackspace Cloud account is enabled for Rackspace Container Services.
* Familiarize yourself with basic Docker concepts. Read the [Docker documentation](https://docs.docker.com/
) and [Docker 101] (docs/tutorials/docker101).
* Familiarize yourself with the basic container concepts. Read the [Containers 101](docs/tutorials/containers101) document.
* Familiarize yourself with [scheduling strategies](https://docs.docker.com/swarm/scheduler/strategy/) and with [filters](https://docs.docker.com/swarm/scheduler/filter/).
* Learn about the resources and resource limitations of a cluster.
* Install the Docker client on your computer. For installation instructions, see the [Install the Docker client] (link_Install_Docker_Client) section.
* If you already have the Docker client installed, ensure that you have the right version. Rackspace Container Service, currently supports Docker version 1.8.2.

### What is Rackspace Container Service?
**Rackspace Container Service** provides a high-performance service for running and managing Docker containers in a cluster-based infrastructure. Rackspace Container Service gives you a scalable cluster management infrastructure out of the box and allows you to deploy your applications by utilizing one ore more Docker containers across a managed cluster. Rackspace Container Service eliminates the need to install cluster management software and to deploy and operate cluster management hardware. With Rackspace Container Service, you can get started right away and get your containerized application running in a short time.

The following diagram outlines how the Rackspace Container Service works.

[Insert the diagram that Nate is working on here]


### Getting Started

#### Understanding the Rackspace Container Service UI

*Wait until we have the final UI*

#### Using the Actions icons

##### Download credentials icon

Clicking this icon brings up a dialog box that prompts you to save your cluster credentials on your computer. Choose **Save File**, click **OK**, and then select a location on your computer to save the credentials to.

##### Share credentials icon

Clicking this icon brings up a dialog box that lists the URL for your cluster. You can copy this URL and share it with other users.

##### Grow cluster icon

Clicking this icon brings up a dialog box the provides you with the option to grow your cluster by 1 node, 2 nodes, or to grow to the maximum, which is 10 nodes.
##### Rebuild cluster icon
Clicking this icon lets you choose the option to rebuild your cluster services.
##### Delete cluster icon
Clicking this icon lets you choose the option to delete the specific cluster.

#### Create a cluster

Rackspace Container Service is built on the concept of **clusters**. A cluster represents a pool of compute, storage, and networking resources that serves as a host for one or more containerized applications. Rackspace Container Service sets up and manages clusters made up of Docker containers for you. It launches and terminates the containers and maintains complete information about the state of your cluster.

Now that you have successfully installed Docker, you are ready to create your first cluster.

To create your first cluster:

1. Go to [http://mycluster.rackspacecloud.com](http://mycluster.rackspacecloud.com) and sign into Rackspace Container Service by using your Rackspace cloud account credentials.
2. In the **Create New** box type a name for your cluster and click **Create Cluster**. The new cluster will enter the *building* state. If you want to track the cluster’s state, refresh the cluster list manually after a few minutes. Once the cluster is *active*, you can interact with it.

A cluster can be in one of the following states:

| Cluster state | Description                                                                                 |
|---------------|---------------------------------------------------------------------------------------------|
| building      | Indicates that the cluster is currently being built. This process may take several minutes. |
| active        | Indicates that the cluster is currently active.                                             |
| growing       | Indicates that the cluster is in the process of adding new nodes.                           |


#### Download your cluster credentials
After you have created your cluster and it is in active state, you need to connect to it. Connection authorization for clusters is established using TLS certificates.
Before you can connect to your cluster, you need to download these credentials and tell the client to use them.

To download your cluster credentials:

1. Click the download credentials icon.
2. Save the <cluster_name>.zip file to a location on your computer.
2. Extract the zipped credential folder by typing ```unzip {.zip-file-name}-d {/directory/to/extract}``` at a command-line interface.
3. Navigate to the extracted credential folder by typing ```cd\{name of extracted folder}``` at a command-line interface. **Note**: The name of the extracted folder is a multi-digit id that has been auto-generated by Rackspace Container Serve.
4. Point your Docker client to use the contents of the folder by typing ```source docker.env```.
5. Type ```docker info``` at a command-line interface. Running ```docker info``` will display your RCS cluster details as shown in the following example:

```
Containers: 5\s\s
Images: 4
Role: primary
Strategy: spread
Filters: affinity, health, constraint, port, dependency
Nodes: 1
 2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1: 104.130.0.61:42376
  └ Containers: 5
  └ Reserved CPUs: 0 / 12
  └ Reserved Memory: 0 B / 4.2 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.12.36-2-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
CPUs: 12
Total Memory: 4.2 GiB
Name: 9958d3e9d602
```

For more information, see [Download Rackspace Container Service credentials](docs/references/rcs-credentials/)

#### Deploy your first workload
Now that you have assembled all the required ingredients, you can deploy your first workload.

The following example shows how to set up a Wordpress blog with a MySQL database as a backend.

1. Start a MySQL instance, give it a name and use "my-root-pw" as a password by issuing the following command at a command-line interface:

	```
	docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=my-root-pw -d mysql
	```

2. Start a Wordpress instance, give it a name, and map the internal port 80 to the external port 8080 by issuing the following command at a command-line interface:

	```
	docker run --name my-wordpress --link mysql-db:mysql -p 8080:80 -d wordpress
	```

	The container will obtain the db root password from the Docker daemon.

3. To verify that your deployment is successful, type ```docker ps``` at a command-line interface. Running this command returns a response like the following:

	```
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                          NAMES
f75da262c529        wordpress                    "/entrypoint.sh apach"   16 seconds ago      Up 15 seconds       104.130.0.61:8080->80/tcp      2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1/my-wordpress
29a8fc498016        mysql                        "/entrypoint.sh mysql"   53 seconds ago      Up 52 seconds       3306/tcp                       2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1/my-wordpress/mysql,2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1/mysql-db
3cfa246e048e        rackerlabs/hello-world-web   "python web.py"          36 hours ago        Up 36 hours         104.130.0.61:49156->5000/tcp   2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1/web
7388d80304fd        rackerlabs/hello-world-app   "python app.py"          36 hours ago        Up 36 hours         5000/tcp                       2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1/app,2a82d3d7-a726-4fe8-871d-ae5322f2b1d8-n1/web/helloapp

	```
4. Under the **IMAGE** column, look for the row that lists the "wordpress" container and navigate to the **PORTS** column for that container. Copy the  IP address that is followed by a ":" and the port (8080), for example ```104.130.0.61:8080```.

5. Open a Web browser and type the following in the address bar: ```http://{IP_address}:8080``` for example: ```http://104.130.0.61:8080```. This will bring up a Wordpress installation page.

This example takes advantage of Docker links. To learn more about container linking go through the [Connect containers with Docker links] (docs/tutorials/connect-docker-containers-with-links/) tutorial.

#### Best Practices

##### Requirements and Restrictions

Rackspace Container Services currently does not support two-factor authentication.
As a workaround you can create a sub-user by following the instructions described in [How do I create a new user in the Cloud Control Panel](https://community.rackspace.com/products/f/54/t/4551)

#### Next

[Download Rackspace Container Service credentials](docs/references/rcs-credentials/)

[MySQL with RCS](docs/tutorials/mysql-with-rcs/)

[Connect containers with Docker links] (docs/tutorials/connect-docker-containers-with-links/)

[MongoDB with RCS] (docs/tutorials/mongodb-with-rcs/)

[Run Magento in a Docker container](docs/tutorials/magento-in-docker/)

[Introduction to Docker Swarm] (docs/tutorials/introduction-docker-swarm/)

[How to use Drupal on Docker Swarm](docs/tutorials/drupal-and-swarm/)
