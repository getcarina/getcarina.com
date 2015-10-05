---
title: Magento in Docker
slug: magento-in-docker
description: Running Magento in Docker with Redis
topics:
  - docker
  - beginner
---

Magento is one of the most well-established eCommerce platforms in the PHP
community, but the task of installing it on a virtual machine and configuring
everything can be daunting for beginners and onerous for experienced developers.
With Docker, a lot of the complications are taken away, since we have a
portable and recreatable environment already set up for us: all we need to do
is run it.

In this tutorial we'll be setting up a Docker container running Magento,
alongside a Redis container for cachiner, and an external MySQL database.

### Step 1: Download environment file

Later on when we'll run our Magento container, we'll link to a local environment
file that contains most of our configuration values. So it makes sense to
download it early so we can populate it as we progress through this guide.

```
git clone https://github.com/rackerlabs/rcs-library
```

If you navigate to the `magento` directory, you will see the env file
(along with a few other files) that we will need for this tutorial.

Open up the env file and populate the `RS_USERNAME` and `RS_API_KEY` variables
with your Rackspace username and API key respectively.

**Note**: *Never* check this file into version control or expose it publicly.

### Step 2: Set up Redis

```
docker run --detach \
  --name redis \
  --memory 4G \
  --publish 6379 \
  --hostname redis \
  redis
```

### Step 3: Set up MySQL

The next thing we'll need to do is create a database instance running MySQL. We can do this in the Control Panel by following this instructions:

1. Sign in to https://mycloud.rackspace.com/ using your username and password.
2. Navigate to Databases > MySQL and click on the "Create Instance" button.
3. Call the instance "Magento" and select "IAD" as the region. For the Engine,
be sure to choose MySQL 5.6. For the RAM, 2GB is recommended but you can toggle
the value according to your preference. Finally specify 5GB for the disk space.
4. Create a database named `magento`
5. Create a user called `magento`, and assign a strong password to it. Be sure
to remember this since we'll need it later on.
6. Click on "Create instance".

This will provision a compute instance with 2GB of RAM and 5GB of disk space
running MySQL 5.6. Give it a few minutes to build. The magento user created
will also be automatically granted full privileges to the new magento
database.

### Step 4: Run



# Installer scripts

# Sample data?

# Test!
