---
title: Service Discovery 101
slug: service-discovery-101-introduction
description: Introduction to service discovery concepts, reasons for using it, basic samples, and related software
topics:
  - services
  - service discovery
  - beginner
  - concepts
  - tutorial

---

Services are pieces of software on a machine that you want to call or rely on when running an application. For example, if you have a web application that needs a database, that database is a service. With a potentially large number of services living on multiple hosts, it becomes important to keep track of which services are deployed and where they are located to communicate with them.

###What is service discovery?

In a live system, service locations can change frequently due to scaling, new service deployments, and host failure or replacement.

Service discovery is a two-part process that begins with registration. Service registration is the process of a service registering its location with a central directory. It usually includes information such as host and port, and sometimes authentication details.  Service discovery is when the client application asks the directory for the location of services.

To avoid service interruption, reliable and dynamic service registration and discovery are essential.

###Service discovery tools

There are several service discovery tools available that manage how processes and services across multiple hosts can find and communicate with each other. Most tools involve creating a central directory of services, registering deployed services in the directory, and locating and connecting to any of the registered services.

####Considerations when choosing a tool

Before you choose a service discovery tool, you should consider the following aspects:

* Monitoring
* Load balancing
* Integration style
* Runtime dependencies
* Availability

For example, what happens when a registered service fails? If multiple services are registered, how do the clients balance the load across the services? Does the registry limit which language you can use? Does the tool require a dependency that is incompatible with your environment?

To have a reliable and functional service discovery experience, you must ensure that the tool you choose is compatible with your system and operational needs.

[etcd](https://coreos.com/etcd/) and [Consul](https://www.consul.io/) are both highly-available key value stores for shared configuration and service discovery. Essentially, these tools create a service registry where each service is saved with a human-friendly name rather than service IP addresses, and store arbitrary configuration data that your application might need.

For example, if you have a WordPress application that needs to communicate with MySQL, instead of hardcoding the private IP address, which has a high liklihood of changing over time, Consul can resolve "mysql" to an appropriate container that might be running anywhere in the cluster.
