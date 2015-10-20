---
Author: Anne Gentle <anne.gentle@rackspace.com>
date: 2015-10-20
permalink: docs/tutorials/getting-started-carina-cli/
description: Learn how to get started with the Carina command-line client (CLI) by installing, configuring, and performing commands
docker-versions:
  - 1.8.2
topics:
  - carina
  - cli
  - intermediate
---

This tutorial demonstrates how to install and configure the Carina client so that you can use it to launch and control Docker Swarm clusters on a Carina endpoint. The Carina CLI ``carina`` is a self-contained binary written in Go, so installation involves downloading a binary, making it executable, adding it to your path, then configuring with credentials.

### Prerequisites

* You have access to a 64-bit operating system. Clients are available for Mac OSX, Linux, and Windows 64-bit.

* You have a working terminal application.

* You have credentials for [Carina](https://mycluster.rackspace.com).

### Download and install the Carina CLI

Note: Instructions to be updated with Windows-specific commands. 

1. Download and save the binary matching your operating system:

* [Mac OSX, 64-bit](https://github.com/rackerlabs/carina/releases/download/0.3.1/carina-darwin-amd64)
* [Linux, 64-bit](https://github.com/rackerlabs/carina/releases/download/0.3.1/carina-linux-amd64)
* [Windows, 64-bit](https://github.com/rackerlabs/carina/releases/download/0.3.1/carina.exe)

2. Rename the binary to `carina`. For example, on Mac OSX, enter:

   mkdir ~/bin
   mv carina-darwin-amd64 ~/bin/carina

3. Make the binary executable. On Mac OSX and Linux enter:

    chmod u+x ~/bin/carina

3. Link the binary to /usr/local/bin/ with these commands:

   mkdir -p /usr/local/bin/
   ln -s ~/bin/carina /usr/local/bin/carina 

4. Add the binary to your path with this command:

    export PATH=$PATH:/usr/local/bin

### Configure with Carina credentials

1. Gather the required information:

* Username (CARINA_USERNAME): a Carina username from https://mycluster.rackspace.com
* API key (CARINA_APIKEY) a Carina API key

2. Set your environment variables to contain these credentials:

   export CARINA_USERNAME=fnamelname
   export CARINA_APIKEY=ddd1233abcdef4a0bc5da6789123ab45c

3. Verify you can issue `carina` commands:

   $ carina list

   If you have some clusters already running, you see:

   ClusterName       Flavor           Nodes    AutoScale    Status
   websocketsrock    container1-2G    2        true         active
   railsanne         container1-4G    4        true         active

### Manage Docker Swarm Clusters with Carina

1. Create a Swarm Cluster using the `carina create...` command. For example:

   $ carina create myswarmcluster --wait --nodes=2 --autoscale
   
   myswarmcluster    container1-4G    2    true    active
   
   Read more about the parameters below:
   * --wait       wait for swarm cluster completion
   * --nodes=1    number of nodes for the initial cluster
   * --autoscale  Turn autoscale on or off. Turning it on means management functions are available for that cluster.

2. Once it completes, download the credentials for the cluster:

   $ carina credentials --path=/tmp/ myswarmcluster

   Where --path=PATH indicates the local directory path to write the credentials files.

   #
   # Credentials written to /tmp/
   #
   source "/tmp/docker.env"
   # Run the command above or eval a subshell with your arguments to carina
   #   eval "$( carina command... )"

3. Source the `docker.env` environment variables for use with `docker info`:

   $ source /tmp/docker.env
   $ docker info

   Containers: 6
   Images: 4
   Role: primary
   Strategy: spread
   Filters: affinity, health, constraint, port, dependency
   Nodes: 2
    4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n1: 104.130.0.48:42376
     └ Containers: 3
     └ Reserved CPUs: 0 / 12
     └ Reserved Memory: 0 B / 4.2 GiB
     └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n2: 104.130.0.42:42376
     └ Containers: 3
     └ Reserved CPUs: 0 / 12
     └ Reserved Memory: 0 B / 4.2 GiB
     └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
   CPUs: 24
   Total Memory: 8.4 GiB
   Name: a1bc2d3456e7

### Next steps
