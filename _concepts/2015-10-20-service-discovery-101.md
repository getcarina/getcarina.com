---
title: Service discovery 101
author: Stephanie Fillmon <stephanie.fillmon@rackspace.com>
date: 2015-10-20
permalink: docs/concepts/service-discovery-101/
description: Learn how service discovery tracks deployed services to facilitate communication and avoid service disruption.
docker-verions:
  - 1.8.2
topics:
  - service discovery
  - beginner
  - concepts
  - tutorial

---

Services are pieces of software that applications call or rely on. For example, if a web application needs a database, that database is a service. With a potentially large number of services living on multiple hosts, it becomes important to be able to track which services are deployed and where they are located in order to communicate with them.

###What is service discovery?

In a production system, service locations can change frequently because of scaling, scheduling policies, rolling updates, and host failover. Service discovery is about knowing when a service is responsive, and making it available through a human-readable name.

Service discovery is a two-part process that begins with registration. *Service registration* is the process of a service registering its location with a central directory. *Service discovery* occurs when a client application asks the directory for the location of a service. The centralized directory includes each service, saved with a human-readable name, its location, and information such as host, port, and sometimes authentication details.

Centralized service discovery provides the following advantages:

* A single, global registry that connects services over multiple hosts
* More control over authentication and security because of a single access point
* The flexibility of being able to shut down and restart services without having to reconfigure everything that uses it, even if the new service starts up at a different IP address and port

To avoid service interruption, reliable and dynamic service registration and discovery are essential.

###Service discovery tools

Service discovery tools, such as [Consul](https://www.consul.io/) and [etcd](https://coreos.com/etcd/), manage how processes and services across multiple hosts can find and communicate with each other. Most tools involve creating a central directory of services, registering deployed services in the directory, and locating and connecting to any of the registered services.

####Considerations when choosing a tool

Before you choose a service discovery tool, consider the following questions:

* Monitoring - Will services that have crashed, or are running on failed nodes, be made available across the cluster? How advanced is the health checking algorithm?

* Load balancing - When dealing with services that range over multiple hosts, will requests be load balanced? Is the load balancing algorithm configurable and sufficiently useful?

* Integration style - Does the tool require application developers to write their own integration logic, or is the integration more seamless (such as DNS-based discovery)? Does the tool require any dependencies that are incompatible with your environment?

* Availability - How is the service registry data centralized? Does it support distribution across multiple regions or data centers? Are there single points of failure, or are things more distributed and fault-tolerant?

To have a reliable and functional service discovery experience, you must ensure that the tool you choose is compatible with your system and operational needs.

####Discovering services with DNS

Many service discovery tools enable name resolution through DNS records, such as service (SRV) records. Many also exploit time-to-live (TTL) limits to retire services that might be failing or over-capacity and do not announce their availability in a given window of time. The benefit of using DNS is that it's an already established system that works well and does not require complex integration with applications.

For example, suppose that you have a WordPress application that needs to communicate with MySQL. Instead of hardcoding the private IP address, which has a high likelihood of changing over time, a DNS server (backed by a service registry) can resolve the `mysql` hostname to the appropriate service or container that might be running anywhere in the cluster. This means that your database configuration stays relatively simple and abstracted over time.

Consul and etcd are highly available key-value stores for shared configuration and service discovery. These tools create a service registry in which each service is saved with a human-readable name rather than a service IP address, and they store the arbitrary configuration data that your application might need. Both Consul and etcd are also compatible with DNS-based service discovery; Consul has its own DNS service, and with etcd, you can use add-ons such as SkyDNS.
