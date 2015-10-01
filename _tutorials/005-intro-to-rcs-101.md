---
title: Introduction to Rackspace Container Service 
description: Introduction to Rackspace Container Service
topics:
  - containers
  - beginner
---

**Containers** let you install software and run applications just like you would on a normal server, but instead of having multiple applications sharing the same server directly, each one is tucked away into a sandbox. This sandbox is achieved by using several features that are already built into the Linux kernel.

**Docker** provides a standard interface that makes building, running, and sharing containers relatively easy. Ironically, the most difficult part of using Docker is just getting it installed in the first place.

#What is Rackspace Container Service?#
**Rackspace Container Service** helps you get a quick start with Docker and containers. RCS has been designed to make running and managing containers easier for you. It does so by focusing on the essentials: fast provisioning times, bare-metal performance, and an easy-to-use user inerface. Rackspace Container Service provides the following benefits for users:

* Provides an infrastructure for cluster management.
* Manages the scaling of your pool of Docker nodes. 
* Enables you to utilize all the benefits of containers (packaging and performance).
* Supports new use-cases with extremely dynamic application lifecycles.
* Enables you to quickly go from zero to a running application. 
 
##Before you get started##
Before you get started with Rackspace Container Service, you should do the following:

* Watch the `Introduction to Docker video <Introduction-to-Docker>`. This 15-minute video teaches you about Docker and provides you with helpful information, for example how it is different from virtualization, why people are so excited about it, and the type of workflow it enables.
* Ensure that your Rackspace Cloud account is enabled for Rackspace Container Services.
* Familiarize yourself with basic Docker concepts. Read the `Docker documentation`_.
* Familiarize yourself with the basic container concepts. Read the Containers 101 (add link) document.
* Familiarize yourself with scheduling strategies (`Strategy`) and with filters (`Filters`).
* Learn about the resources and resource limitations of a cluster.
* Install the Docker client on your computer. For installation instructions, see the :ref:`Install the Docker client <Install Docker Client>` section.
* If you already have the Docker client installed, ensure that you have the right version. Rackspace Container Service, currently supports Docker version 1.8.2. 


.._ Docker documentation https://docs.docker.com/
.._ Strategy https://docs.docker.com/swarm/scheduler/strategy/
.._ Filters https://docs.docker.com/swarm/scheduler/filter/
.._ Introduction-to-Docker https://sysadmincasts.com/episodes/31-introduction-to-docker

###System Requirements###
None

###How does Rackspace Container Service work?###
Rackspace Container Service started with the assumption that anything of scale at Rackspace begins with OpenStack. As a result, Rackspace has productized the existing Linux Container (LXC) support in Nova. 
Rackspace has configured Docker to run inside these containers.

The following diagram outlines how the Rackspace Container Service works.
<show diagram here>

####Install Docker Client###
.. _Install Docker Client

To use Rackspace Container Service, you first need to install the Docker client.
The Docker client is available for download from http://www.docker.com.
To install the Docker client on a Mac, follow the installation instructions provided on `_Install Docker on Mac OS X`.
To install the Docker client on Windows, follow the installation instructions provided on `_Install Docker on Windows`.
To install the Docker client on a Linux computer, follow the installation instructions provided on `_Install Docker on Linux`.


.. _Install Docker on Mac OS X https://docs.docker.com/mac/step_one/
.. _Install Docker on Windows https://docs.docker.com/mac/step_one/
.. _Install Docker on Linux 

##What you should know##


##Getting Started (Detailed)##

###Create a cluster###
After you have successfully installed Docker, you are ready to create your first cluster.

To create your first cluster

1. Go to http://mycluster.rackspace.cloud.com and sign into Rackspace Container Service by using your Rackspace cloud account credentials.
2. In the **Create New** box type a name for your cluster and click **Create Cluster**. The new cluster will enter the *building* state. If you want to track the cluster’s state, refresh the cluster list manually after a few minutes. Once the cluster is *active*, you can interact with it.

###Retrieve your cluster credentials###
After you have created your cluster and it is in active state, you need to connect to it. Connection authorization for clusters is established using TLS certificates. 
Before you can connect to your cluster, you need to download these credentials and to tell the client to use them.

To download your cluster credentials:

1. Click the download credentials action-icon.
2. Save the <cluster_name>.zip file to a location on your computer.
2. Extract the zipped credential folder.
3. Navigate to the extracted credential folder. Note that the name of the extracted folder is a multi-digit id that has been auto-generated by Rackspace Container Serve. 
4. Point your Docker client to use the contents of the folder by typing ```source docker.env```. 
5. Run the ```docker info``` command.

If everything worked, running docker info should now display your RCS cluster details.


###Deploy your first workload###
Now that you have assembled all the required ingredients, you can deploy your first workload.
For example you can deploy a simple Wordpress blog with a MySQL database. 
To do this, run the following two commands:
  
```
# start mysql, name it my-wordpress and use my-root-pw as a password
# more details at: https://registry.hub.docker.com/_/mysql/
docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=my-root-pw -d mysql

# start wordpress, name it my-wordpress, map internal port 80 to external port 8080
# the container will get the db root password from the docker daemon
# more details at: https://registry.hub.docker.com/_/wordpress/
docker run --name my-wordpress --link mysql-db:mysql -p 8080:80 -d wordpress

```

###Cluster states###

A cluster can be in one of the following states:
* building
* active
* growing

##Best Practices##

###Requirements and Restrictions###

Rackspace Container Services currently does not support two-factor authentication. 	

##Frequently Asked Questions##





