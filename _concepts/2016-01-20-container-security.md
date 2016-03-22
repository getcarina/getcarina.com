---
title: Container security
authors:
  - Major Hayden <major.hayden@rackspace.com>
  - Adrian Otto <adrian.otto@rackspace.com>
date: 2016-01-20
permalink: docs/concepts/container-security/
description: Learn about security best practices for safely deploying Docker applications
topics:
  - security
---

Security is a serious issue in any environment, and security risk is inherent in any multi-tenant system. No system that shares resources among multiple tenants can truthfully be considered completely secure. It can be close, but there is always some level of risk. That risk is managed by applying a discipline of security best practices to control access to shared resources so portions of them remain reserved for the correct users. This is the approach taken for the container environment exposed by Carina.

### Securing Linux containers

For detailed information about the security of Linux containers, review the [Securing Linux Containers](https://major.io/2015/08/14/research-paper-securing-linux-containers/) research paper. It covers container security within the Linux kernel, including Linux Security Modules and cgroups. It also contains best practices for keeping containers updated, and how DevOps teams can work together to improve security.

Docker Inc. also has much to say on the topic of security from an [Introduction to Container Security](https://d3oypxn00j2a10.cloudfront.net/assets/img/Docker%20Security/WP_Intro_to_container_security_03.20.2015.pdf) to [Docker Security](https://docs.docker.com/engine/articles/security/).

### Trusted software

Retrieving images is easy with Docker's `docker pull` command. Developers can quickly add their automation on top of the base image and begin deploying it to environments. However, do you _really_ know the source of all the software within your container? Most containers are built by using an operating system's trusted package manager, like yum, dnf, or apt. The default configuration of most package managers enforces a cryptographic check of some sort, usually via GPG, for the package. If the package has been altered on the remote server or during transit, the package manager finds that the signatures don't match and that package won't be installed.

Some operating system and application vendors already have [official repositories](https://hub.docker.com/explore/) on [Docker Hub](https://hub.docker.com). Most of these vendors update their container images frequently, and enable best-practice security controls for their containers. After all, it's in their best interest to ensure that their containers and applications are running properly.

The only way to truly trust a container image is to build the container image yourself. You will have full control of the build system, and you can verify that your package manager is configured to verify the signature on each package.

### Keeping containers updated

For physical servers or virtual machines, many users are accustomed to routinely applying package updates via their package manager. Some users might configure automatic updates for all packages, or just for packages with security vulnerability fixes. Keeping containers updated is a different battle.

First, containers should run only one process. This practice means that a typical LAMP stack should be split into at least two containers: one for Apache/PHP and another for MySQL. This reduces the number of packages that need potential updates in either container.

Second, containers should be rebuilt when developers update configuration files, packages, or other software. Containers are, by nature, ephemeral. Also, if they are running a single daemon, there's no need to run an SSH daemon within the container. If you run a LAMP stack and a critical PHP vulnerability is released, build a new container with updated packages, and replace existing production containers with the new one.

### DevOps and shared security responsibility

Developers appreciate containers because they can package an application, test it alongside its libraries, and verify that it will work in production. Operations teams appreciate containers because they get the applications in a cohesive package with their dependencies and configurations. However, who owns the security of the container operating system, configuration files, and the application in this new world of containers?

Securing the operating system is normally the responsibility of the operations team. However, if developers are writing applications and building a container with their application in it, how do operations teams ensure that the base operating system is secure?

This is where frameworks with layered images, including Docker, can help. Operations teams can carefully maintain a base image with appropriate security controls, configurations, and package updates. As part of that configuration, they can specify where the package manager will receive trusted packages. Development teams can use that base image as the foundation for their containers and then add packages from those trusted repositories. If a serious vulnerability appears, the operations team would quickly update the base image and let the development team know that a container rebuild and redeployment is needed.

### Use overlay networks

At the application layer, users can employ overlay networks to provide isolation for containers to communicate across all of the nodes in their clusters on Carina. An overlay network is an isolated network for containers that ensures only the services of their choice are exposed outside of their system. Isolating containers in a network can greatly decrease the attack surface of a system, which adds another layer of security. For tutorial information, see [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/).

### Use version control

All of your Dockerfiles, configuration files, and deployment code should be kept in a version control repository of some sort. There are several benefits to making this a standard practice in your organization.

Keeping files in version control adds a gate for contributions. Developers must have permission to commit to the repository, and there is an audit trail for commits made to the repository. This security reduces the chance of of unwanted or unauthorized changes to containers. Also, if something goes wrong in production, teams can go through the log of commits to review the changes. Tagging individual commits with version numbers helps teams understand which changes are present in each version of a container.

In an emergency, you might need to rebuild containers very quickly to get back online. Storing all of your container deployment code in a repository enables quick rebuilds of containers.

**Caveat**: Do not commit secrets like passwords or API keys and other sensitive data to version control. For example, use of a `.gitignore` file can greatly reduce the likelihood that you will commit a file with secrets to Git.

### Carina

It is possible to deploy containers in a multi-tenant way that has very little isolation between neighboring containers, and assumes a considerable risk that processes running in one container could fool the kernel into allowing them to access resources in neighboring containers. Carina is not designed in this way. Carina has additional levels of process isolation that extensively use a range of security features within the operating system kernel to provide security isolation that approaches the security isolation level you would expect from neighboring virtual machines.

Security isolation between neighboring containers is different than security isolation between neighboring virtual machines. It's a matter of the attack surface between them. In the case of virtual machines, the attack surface is the hardware virtualization interface, which is a relatively narrow attack surface that is relatively straightforward to secure. There is some risk, and vulnerabilities are possible, but fixing them is usually not difficult. In the case of containers, the attack surface is the syscall interface (a set of instructions used by processes to interact with the kernel), which by comparison is a wider attack surface that requires more effort to secure. Operating systems like Linux offer a wealth of features for securing this attack surface by using a variety of techniques.

Carina uses a hardened host operating system that helps reduce the system attack surface, and leverages the mandatory access control (MAC) features within the Linux kernel. These features are what SELinux and AppArmor use to control how processes may interact with the system.

Carina also employs a multiple-level encapsulation of capacity nodes that is beyond the scope of what other container management systems offer. This arrangement is considerably more secure than approaches that are not designed for multi-tenant use. Carina has been extensively audited to this end.

### Next step

Read [Understanding how Carina uses Docker Swarm]({{ site.baseurl }}/docs/concepts/docker-swarm-carina/), which provides information about how Docker is secured by Carina.
