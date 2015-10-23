---
title: Configuring Docker to Use Amphora
seo:
  description: Configure the Docker command line client to connect to the Amphora Docker Daemon
featured: true
---

In Docker, there are two main components you interact with during almost every operation: the **client** and the **daemon**. The client is the Docker executable that runs on your machine, and the daemon listens for instructions from your client to build, create, or run images and containers.

To use Docker with Amphora, you have to configure your client to use Amphora as its daemon, instead of whatever daemon it may have been using before.

1. Open the [Amphora Control Panel](#) and find the cluster you would like to control.
1. Click **Download Configuration** to begin the download of .zip file containing all the resources you need to connect to the cluster.
1. Extract the zip file and `cd` to the directory with its contents.
1. Type `source ./docker.env` and press enter. This will configure your shell environment to use Amphora.
1. Type `docker info` to confirm your configuration. You should see information for multiple nodes. (the number of nodes will vary depending on how you’ve scaled the cluster.)
