---
title: Service Discovery 101
author: Stephanie Fillmon <stephanie.fillmon@rackspace.com>
date: 2015-09-30
slug: service-discovery-101-introduction
description: Introduction to service discovery concepts, reasons for using it, and related software
docker-verions:
  - 1.8.2
topics:
  - services
  - service discovery
  - beginner
  - concepts
  - tutorial

---

Services are pieces of software that you call or rely on when running an application. For example, if you have a web application that needs a database, that database is a service. With a potentially large number of services living on multiple hosts, it becomes important to keep track of which services are deployed and where they are located in order to communicate with them.

###What is service discovery?

In a production system, service locations can change frequently due to scaling, scheduling policies, rolling updates, and host failover. Service discovery is about knowing when a service is responsive, and making it available through a human-readble name.

Service discovery is a two-part process that begins with registration. Service registration is the process of a service registering its location with a central directory. Service discovery is when the client application asks the directory for the location of services. The centralized directory includes each service, saved with a human-readable name, its location, and information such as host, port, and sometimes authentication details.

Some advantages of using centralized service discovery include:

* A single, global registry that connects services over multiple hosts
* More control over authentication and security because of a single access point
* The flexibility of being able to shut down and restart services without having to reconfigure everything that uses it, even if the new service starts up at a different IP address and port

To avoid service interruption, reliable and dynamic service registration and discovery are essential.

###Service discovery tools

There are several service discovery tools available that manage how processes and services across multiple hosts can find and communicate with each other. Most tools involve creating a central directory of services, registering deployed services in the directory, and locating and connecting to any of the registered services.

####Considerations when choosing a tool

Before you choose a service discovery tool, you should consider the following aspects:

* Monitoring - Will services that have crashed, or are running on failed nodes, be made available across the cluster? How advanced is the health checking algorithm?

* Load balancing - When dealing with services that range over multiple hosts, will requests be load balanced? Is the load balancing algorithm configurable and sufficiently useful?

* Integration style - Does the tool require application developers to write their own integration logic, or is the integration more seamless (such as DNS-based discovery)? Does the tool require any dependencies that are incompatible with your environment?

* Availability - How is the service registry data centralized? Does it support distribution across multiple regions or data centers? Are there single points of failure, or are things more distributed and fault-tolerant?

To have a reliable and functional service discovery experience, you must ensure that the tool you choose is compatible with your system and operational needs.

[etcd](https://coreos.com/etcd/) and [Consul](https://www.consul.io/) are both highly-available key value stores for shared configuration and service discovery. Essentially, these tools create a service registry where each service is saved with a human-friendly name rather than service IP addresses, and store arbitrary configuration data that your application might need.

For example, if you have a WordPress application that needs to communicate with MySQL, instead of hardcoding the private IP address, which has a high likelihood of changing over time, Consul can resolve "mysql" to an appropriate container that might be running anywhere in the cluster.

###Service discovery and DNS
