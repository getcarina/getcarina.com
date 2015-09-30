---
title: Data Stores
slug: data-stores
description: How to store production data with RCS
docker-version: 1.8.2
topics:
  - docker
  - intermediate
  - data-stores
---

This tutorial describes using data stores with RCS so that you can store your production data persistently and securely.

### Prerequisites

1. A RCS account <!-- TODO: link -->

### Concepts

Data is the most important output of your application. In a production environment it must be stored persistently and securely. Ideally it's also in a highly available and redundant data store too.

Containers are good for ephemeral computing but are not so good for persistent storage. There are patterns such as the data volume container that provide persistent volumes but still do not meet the requirements of managing production data at scale. More care and attention is required of your production data than what a containerized environment can provide.

Using data stores in containers for your development, testing, and quality assurance environments is okay but production data should be stored in a service dedicated to handling your data.

### Next

Learn how to use data stores with RCS so that you can store your production data.

* [MongoDB](data-stores-mongo)
* [MySQL](TODO)
