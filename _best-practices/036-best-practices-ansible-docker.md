---
title: Best practices using Ansible and Docker
author: Ash Wilson <ash.wilson@rackspace.com>
date: 2015-10-01
permalink: docs/best-practices/036-best-practices-ansible-docker/
description: Best practices for using Ansible and Docker to deploy containers
topics:
  - best practices
  - Ansible
  - Docker
---

###Best Practices using Ansible and Docker
It can seem that [Ansible](http://www.ansible.com/) and [Docker](https://www.docker.com/) are redundant; both offer solutions to configuration management problems through very different mechanisms. While each one has a reliable and repeatable process on their own, it is when they are used together where the result is a fast, clean deployment process.

There are two methods for combining Ansible and Docker:

* Use Ansible to orchestrate the deployment and configuration of the Docker containers on the host.
* Use Ansible to construct Docker container images based on Ansible playbooks as alternative to Dockerfiles.

###Deploying Docker containers with Ansible

While Docker containers provide a powerful way to deliver a consistent environment for software from your laptop to a cluster of production machines, there are many responsibilities where Ansible provides additional responsibilities. Ansible can provision [servers](http://docs.ansible.com/rax_module.html), [networks](http://docs.ansible.com/rax_network_module.html), [load balancers](http://docs.ansible.com/rax_clb_module.html), and [more](http://docs.ansible.com/list_of_cloud_modules.html#rackspace). If the server image doesn't have Docker installed, you will need to get that installed before moving forward with other container-related tasks.

Where Ansible provides management assistance is with Docker daemon configuration, or to help modify [Linus kernel parameters](http://docs.docker.com/installation/ubuntulinux/#adjust-memory-and-swap-accounting). The most important feature provided by Ansible is to manage how and where each container runs: image versions, environment variables, volumes and links.

###The Ansible Docker module

Ansible includes a [Docker Module](http://docs.ansible.com/docker_module.html) that manages the hosts' active Docker containers. It supports a large number of module parameters, but only a few are needed for this example.

The minimum information needed is the name of an image. It is a best practice to be explicit about the desired state, even though there is a default value. Naming the containers is also a best practice so that:

* The output of `docker ps` is readable.
* The container is easy to reference from other containers and tools later.

```
-   name: Database
    docker:
        name: database
        image: postgres:9.4
        state: started
```

This task will pull the latest Postgres image from DockerHub if it is not present, and then launches a single container. However, if any container called "database" is already running on the current host, it won't launch anything.

The previous recommendations provide a good starting point, but if the code  and the application images are changing on a regular basis, then the previous task will never incorporate those updates into the container. To deploy new versions of software, take advantage of the `pull` parameter and the `reloaded`state.

###`pull=always` and `state=reloaded`

These two options were added in the recent Ansible 1.9.0 release, and they enable the Docker module to deploy containers in a more idempotent fashion. `pull=always` performs a `docker pull` on the server before anything else is done, even if the image is already present -- this ensures that the latest build is running of all of the containers. Using `state=reloaded` instead of `state=started` invokes more powerful logic about the container's state: it asserts that, not only is a container with the same *name* (or matching image and command) running, but that it is a container with the same *configuration*. If anything changed in the container image or the settings in the playbook (for example, a new build of the image, a different value for an environment variable, or a redeployed container that was linked to this one) the existing container or containers are stopped, and new containers are started with the new configuration. If everything is unchanged, nothing is done, and the module reports `changed=false`.

Using Ansible and Docker together keeps a container and its configuration up to date, and automatically propagates container restarts to any dependent containers. The following code shows how to use these common parameters to gracefully handle the occasional restart. It is not recommended to use them on containers that provide infrastructure services, like a database, because of the need to limit restarts.

```
-   name: My application
    docker:
        name: web
        image: quay.io/smashwilson/minimal-sinatra:latest
        pull: always
        state: reloaded
        env:
            SOMEVAR: value
            SHH_SCRET: "{{ from_the_vault }}"
       link:
       - "database:database"
```


###`restart_policy=always`

Another recommended option to use is `restart_policy` that uses Docker as a process supervisor, like upstart, monit, or forever.js. This capability is important for production environments, because it protects against extended downtime when there is an uncaught exception.

The Docker daemon can be instructed to restart the container any time its process terminates by adding the `restart_policy` parameter:

```
-   name: My application
    docker:
        name: web
        image: quay.io/smashwilson/minimal-sinatra:latest
        pull: always
        restart_policy: always
```

A couple of additional considerations when setting the `restart_policy`:

* Setting the `restart-policy` to `on-failure` allows the container to exit if its process exits cleanly (with a 0 status).
* The number of restarts before Docker gives up is controlled by setting `restart_policy_retry`to a nonzero count.

###Using Ansible to build Docker images

Most of the time Dockerfiles are the preferred mechanism for creating Docker container images, but the benefit of using Ansible is that you create playbooks that are *idempotent*, which means that when the playbook is re-run  only the tasks that require changes have any effect. However, when creating a Docker container image, each step is performed from a consistent starting state. Also, because the Ansible build is performed as a single "step", delegating image creation to Ansible prevents using the build cache purposefully. Managing the build cache is important, because it keeps image build times short when iterating rapidly.

In spite of this limitation, there are several reasons why using an Ansible playbook can be beneficial:

* If you have existing infrastructure that's already using a pure Ansible approach, it's a simple way to kick start container migration.
* Ansible can use Jinja2 templates to create files from templates, allowing the use of variables to reduce duplication and to derive values from the environment.
* Ansible's [extensive module library](http://docs.ansible.com/modules_by_category.html) helps simplify common administrative tasks.
* Use of roles published on [Ansible Galaxy](https://galaxy.ansible.com) that allow you to benefit from community expertise.

To accomplish this, write a Dockerfile that is based on one of [the official base images](https://github.com/ansible/ansible-docker-base) that ship with Ansible pre-installed, and execute `ansible-playbook` with a `RUN` step:

```
FROM ansible/ubuntu14.04-ansible:stable

# Add your playbooks to the Docker image
ADD ansible /srv/example
WORKDIR /srv/example

# Execute Ansible with your playbook's primary entry point.
# The "-c local" argument causes Ansible to use a "local connection" that won't attempt to
# ssh in to localhost.
RUN ansible-playbook site.yml -c local

EXPOSE 443
ENTRYPOINT ["/usr/local/bin/myapp"]
CMD ["--help"]
```


###Conclusion

Using Ansible and Docker to ship projects allows a developer to utilize powerful tools to manage deployments consistently, reliably, and rapidly, using a foundation of version controlled.

###About the Author
Ash Wilson is a software developer on Rackspace's Developer Experience team. His interests include programming languages, continuous deployment, and plugging things into other things (we had to cover all the wall sockets). You can follow him [on Twitter](https://twitter.com/smashwilson) or watch him code [on Github](https://github.com/smashwilson).
