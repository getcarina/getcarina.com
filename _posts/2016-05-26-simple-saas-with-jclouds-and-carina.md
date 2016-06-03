---
layout: post
title: "Simple SaaS with jclouds and Carina"
date: 2016-05-26 08:00
comments: false
author: Zack Shoylev
published: true
categories:
    - jclouds
    - saas
    - docker
    - api
    - sdk
---

Traditionally, attempting to create and monetize an online software solution has been a difficult process. With Docker and Carina, it has become much easier to setup Software as a Service solutions online. This tutorial will provide an example of a Tomcat application that directly controls Carina using the Docker API to instantly start up user-specific software services on demand. 

<!-- more -->

### Prerequisites

You will need a set of tools to be able to follow along.

1. [Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)
2. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
3. [Java 8 JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
4. [maven](https://maven.apache.org/install.html)

### Goal

The purpose of this tutorial is to deploy an example Tomcat web application that can, on demand, provide a [Mumble](https://wiki.mumble.info/wiki/Main_Page) server to a user online. Mumble is a server/client VOIP telecommunication application.

![Mumble]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/mumble_client.png %})

### Credentials Setup

Using git, get the source code for this tutorial:

``` 
$ git clone https://github.com/getcarina/examples.git
```

Log into Carina at getcarina.com. Download your access file.

![Carina Access]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/carina_access.png %})

Extract the contents of your access file into the directory `access` within the cloned repo. The example web application will parse the extracted files to connect to your Carina account and start/stop Mumble containers on demand.

### Project Setup

This tutorial will use maven to handle building, packaging, and dependencies, as defined in the `pom.xml` file.

Setting up project name, version, and packaging:

```
<groupId>carina</groupId>
<artifactId>cse</artifactId>
<version>1.0-SNAPSHOT</version>
<packaging>war</packaging>
```

The code uses some bugfixes and features that have not been released yet. To allow this, the Apache snapshot repository has to be included in the project:

```
<repositories>
  <repository>
      <id>apache.snapshots</id>
      <name>Apache Development Snapshot Repository</name>
      <url>https://repository.apache.org/content/repositories/snapshots/</url>
      <releases>
          <enabled>false</enabled>
      </releases>
      <snapshots>
          <enabled>true</enabled>
      </snapshots>
  </repository>
  </repositories>
```

Include the Tomcat servlet dependency. This will allow the application to run on Tomcat as a servlet:

```
<dependency>
   <groupId>javax.servlet</groupId>
   <artifactId>javax.servlet-api</artifactId>
   <version>3.0.1</version>
   <scope>provided</scope>
</dependency>
```

Since the project uses Java and Java Server Pages, it needs templates to make displaying container data easier. This is what the JSP Standard Tag Library is for.

```
<dependency>
   <groupId>javax.servlet</groupId>
   <artifactId>javax.servlet-api</artifactId>
   <version>3.0.1</version>
   <scope>provided</scope>
</dependency>
```

The most important part here is being able to talk to Carina. Apache jclouds is an open-source multi-cloud SDK that supports the Docker API (Carina uses the Docker API). The Apache snapshot repo configuration included earlier was needed because the example project uses the snapshot version of the jclouds dependency.

```
<dependency>
   <groupId>org.apache.jclouds.labs</groupId>
   <artifactId>docker</artifactId>   
   <version>2.0.0-SNAPSHOT</version>
</dependency>
```

To generate a cryptographically secure password, we are going to use a dependency that provides a secure random algorithm from Apache Commons:

```
<dependency>
   <groupId>org.apache.commons</groupId>
   <artifactId>commons-lang3</artifactId>
   <version>3.4</version>
</dependency>
```

Finally, the maven build settings:

```
<build>
    <finalName>cse</finalName>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
      </plugin>
      <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.2</version>
        <configuration>
          <systemProperties>
            <!-- Letting the application know we are running embedded -->
            <cse.embeddedTomcat>true</cse.embeddedTomcat>
          </systemProperties>
        </configuration>
      </plugin>
    </plugins>
</build>
```

The first plugin enables building the project as a war package. The war package is an archive format that contains a Java application Tomcat can run. The second plugin allows us to run the project using an embedded Tomcat server. Thus, we don't need to deploy the project and can run it locally for debugging purposes.

### View

In `web.xml` we define our servlet's mapping. This tells Tomcat how to route requests to our application. Routing is configured to use the ContainerController controller. The ContainerController will automatically redirect requests to `listcontainer.jsp`, a page that lists all available Mumble servers, and also provides a link tp create a new Mumble container. When a new Mumble container is created by ContainerController, details about it will be displayed in `newcontainer.jsp`. In ContainerController.java, we can see how the different variables displayed in our JSP views are populated, as well as all the logic to create, list, and delete Mumble containers.

### Controller

First, we need to obtain a "connection" to the Docker API in the ContainerController constructor:

```
if("true".equals( System.getProperties().getProperty("cse.embeddedTomcat") )) {
   dockerApi = getDockerApiFromCarinaDirectory("access"); // From maven
} else {
   dockerApi = getDockerApiFromCarinaDirectory("/usr/local/access"); // From docker
}
```

If running embedded, we parse the local "access" directory. Otherwise, the credentials files will be located on a Tomcat container, within the `/usr/loca/access` directory. That's right, the we will be running and testing the Tomcat example application within a Docker container as well, and it will control other Docker containers. This example runs everything containerized. 

The `doGet` method handles `GET` requests against our controller. The action executed is determined by the `action` get parameter:

```
String action = request.getParameter("action");
```

The variable `forward` determines which JSP view is used after the action is processed.

##### Listing existing containers

The default behavior (when no other action is specified) is to list all the existing mumble containers.

```
request.setAttribute("containers", filter(dockerApi.getContainerApi().listContainers(), Utils.isMumble));
```

`Utils.isMumble` is a predicate that filters containers that have a name containing `mumble`. This also means that when the controller starts a new mumble container, it has to include `mumble` in the name.

##### Deleting a container

A container is deleted with the `delete` action with a `containerId` specified.

```
String containerId = request.getParameter("containerId");
dockerApi.getContainerApi().stopContainer(containerId);
dockerApi.getContainerApi().removeContainer(containerId);
```

##### Creating a new container

The `create` action is the most complex.

Fist, `Utils.getSecurePassword()` provides a secure password using `SecureRandom`.

```
String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
return RandomStringUtils.random( 10, 0, 0, false, false, characters.toCharArray(), new SecureRandom() );
```

Then, create and start the container:

```
Container container = dockerApi.getContainerApi().createContainer("mumble" + UUID.randomUUID().toString(),
               Config.builder()
                     .image("extra/mumble")
                     .hostConfig(
                           HostConfig.builder()
                                 .publishAllPorts(true)
                                 .build())
                     .env(
                           ImmutableList.of(
                                 "MAX_USERS=50",
                                 "SERVER_TEXT=Welcome to My Mumble Server",
                                 "SUPW=" + password
                           ))
                     .build());
String id = container.id();
dockerApi.getContainerApi().startContainer(id);
```

The jclouds Docker API provides a `createContainer` method that accepts a name and a configuration object. The configuration object here specifies the [Docker Hub](https://hub.docker.com/) container image `extra/mumble`, requires all service ports be open, and also configures Mumble server configuration options through environment variables, such as maximum number of users, welcome text, and server administrator password. The `createContainer` method returns a Container object, which then the `startContainer` call starts.

The ContainerController then populates the view variables for `ports` and `password` and redirects to the page responsible for displaying new containers.

### Running embedded

```
$ mvn clean tomcat7:run-war
```

This will run the application locally, without deploying to a tomcat container. Use `mvndebug` instead of `mvn` to run in debug mode.

###  Deploying the Tomcat application to Docker

There is a `DOCKERFILE` included in the project. It creates a custom image based on the official Docker Hub Tomcat 8 image. The only additional files added:

1. `cse.war`, the archived application; it will be available after a maven build has been executed.
2. `docker.ps1`, `cert.pem`, `key.pem` - files used for authentication to Carina, placed in the `access` directory during project setup.

To build the custom image:

```
$ docker build -t cse .
```

After the custom image is ready, deploy to Carina (you need to have docker configured to connect to Carina): 

```
$ docker run --name cse -d -p 8080:8080 cse
```

This uses port 8080 for the Tomcat application server. Connect to http://[address]:8080/cse to view the example application's List Containers page.

Listing Mumble containers from the application:

![Carina Access]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/listcontainer.png %})

A new Mumble server:

![Carina Access]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/createcontainer.png %})