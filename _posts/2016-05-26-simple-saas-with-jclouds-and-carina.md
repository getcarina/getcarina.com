---
layout: post
title: "Build Simple SaaS with jclouds and Carina"
date: 2016-06-08 08:00
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

Traditionally, creating and monetizing an online software solution has been a difficult process. With Docker and Carina, it has become much easier to set up software as a service (SaaS) solutions online. This post provides an example of a Tomcat application that directly controls Carina by using the Docker API to instantly start up user-specific software services on demand. 

<!-- more -->

### Prerequisites

You need the following set of tools to follow along.

- [A Carina cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Java 8 JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- [Apache Maven](https://maven.apache.org/install.html)

### Goal

The goal is to deploy an example Tomcat web application that can, on demand, provide a [Mumble](https://wiki.mumble.info/wiki/Main_Page) server to a user online. Mumble is a server/client VOIP telecommunication application.

![Mumble]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/mumble_client.png %})

### Set up credentials

1. Using Git, get the source code for the example application:

    ``` 
    $ git clone https://github.com/getcarina/examples.git
    ```

2. Log in to Carina.
3. In the area for your cluster, click **Get access** and then download the access file.

![Carina Access]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/carina_access.png %})

4. Extract the contents of the access file into the directory `access` within the repo that you cloned. 

The example web application parses the extracted files to connect to your Carina account and to start and stop Mumble containers on demand.

### Set up the project

This example project uses Maven to handle building, packaging, and dependencies, as defined in the `pom.xml` file.

1. Set up the project name, version, and packaging:

    ```
    <groupId>carina</groupId>
    <artifactId>cse</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    ```

2. Because the code uses some bug fixes and features that have not been released, you need to include the Apache snapshot repository in the project:

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

3. Include the Tomcat servlet dependency, which enables the application to run on Tomcat as a servlet:

    ```
    <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>javax.servlet-api</artifactId>
       <version>3.0.1</version>
       <scope>provided</scope>
    </dependency>
    ```

4. Because the project uses Java and Java Server Pages, include the JSP Standard Tag Library to provide templates for displaying container data:

    ```
    <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>javax.servlet-api</artifactId>
       <version>3.0.1</version>
       <scope>provided</scope>
    </dependency>
    ```

5. Include Apache jclouds in the project. It is an open-source multi-cloud SDK that supports the Docker API (Carina uses the Docker API). Use the snapshot version of the jclouds dependency:       

    ```
    <dependency>
       <groupId>org.apache.jclouds.labs</groupId>
       <artifactId>docker</artifactId>   
       <version>2.0.0-SNAPSHOT</version>
    </dependency>
    ```

6. To generate a cryptographically secure password, use a dependency that provides a secure random algorithm from Apache Commons:

    ```
    <dependency>
       <groupId>org.apache.commons</groupId>
       <artifactId>commons-lang3</artifactId>
       <version>3.4</version>
    </dependency>
    ```

7. Enter the Maven build settings:

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

    The first plug-in enables building the project as a war package. The war package is an archive format that contains a Java application that Tomcat can run. The second plug-in allows you to run the project by using an embedded Tomcat server. Thus, you don't need to deploy the project and can run it locally for debugging purposes.

### View

You define the servlet's mapping in the `web.xml` file. This mapping tells Tomcat how to route requests to the application. Routing is configured to use the ContainerController controller, which automatically redirects requests to the `listcontainer.jsp` page. This page lists all the available Mumble servers and provides a link to create a new Mumble container. When a new Mumble container is created by ContainerController, details about it are displayed in the `newcontainer.jsp` page. In the ContainerController.java file, you can see how the different variables displayed in the JSP views are populated, and see all the logic needed to create, list, and delete Mumble containers.

### Controller

Obtain a "connection" to the Docker API in the ContainerController constructor:

```
if("true".equals( System.getProperties().getProperty("cse.embeddedTomcat") )) {
   dockerApi = getDockerApiFromCarinaDirectory("access"); // From maven
} else {
   dockerApi = getDockerApiFromCarinaDirectory("/usr/local/access"); // From docker
}
```

If Tomcat is running embedded, you parse the local "access" directory. Otherwise, the credentials files are located on a Tomcat container, within the `/usr/loca/access` directory. That's right, you will be running and testing the Tomcat example application within a Docker container as well, and it will control other Docker containers. This example runs everything containerized.

The `doGet` method handles `GET` requests against the controller. The action that is executed is determined by the `action` get parameter:

```
String action = request.getParameter("action");
```

The variable `forward` determines which JSP view is used after the action is processed.

##### List existing containers

The default behavior (when no other action is specified) is to list all the existing Mumble containers.

```
request.setAttribute("containers", filter(dockerApi.getContainerApi().listContainers(), Utils.isMumble));
```

`Utils.isMumble` is a predicate that filters containers that have a name containing `mumble`. This also means that when the controller starts a new Mumble container, it has to include `mumble` in the name.

##### Delete a container

To delete a container, use the `delete` action and specfy a `containerId` value:

```
String containerId = request.getParameter("containerId");
dockerApi.getContainerApi().stopContainer(containerId);
dockerApi.getContainerApi().removeContainer(containerId);
```

##### Creat a new container

The `create` action is the most complex.

1. Use `Utils.getSecurePassword()` to get a secure password using `SecureRandom`.

    ```
    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    return RandomStringUtils.random( 10, 0, 0, false, false, characters.toCharArray(), new SecureRandom() );
    ```

2. Create and start the container:

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

The jclouds Docker API provides a `createContainer` method that accepts a name and a configuration object. The configuration object here specifies the [Docker Hub](https://hub.docker.com/) container image `extra/mumble`, requires all service ports to be open, and configures Mumble server configuration options - such as maximum number of users, welcome text, and server administrator password - through environment variables. The `createContainer` method returns a Container object, which then the `startContainer` method starts.

The ContainerController then populates the view variables for `ports` and `password` and redirects to the page responsible for displaying new containers.

### Run the application locally

Use the following code to run the application locally, without deploying to a Tomcat
container:

```
$ mvn clean tomcat7:run-war
```

To run in debug mode, use `mvndebug` instead of `mvn`.

###  Deploy the Tomcat application to Docker

The project includes a `DOCKERFILE` that creates a custom image based on the official Docker Hub Tomcat 8 image. The following additional files are added:

- `cse.war`, the archived application; The file is available after a Maven build has been executed.
- `docker.ps1`, `cert.pem`, `key.pem`. These files are used for authentication to Carina and are placed in the `access` directory during project setup.

To build the custom image, run the following command:

```
$ docker build -t cse .
```

After the custom image is ready, deploy it to Carina (you need to have Docker configured to connect to Carina): 

```
$ docker run --name cse -d -p 8080:8080 cse
```

This uses port 8080 for the Tomcat application server. Connect to **http://[address]:8080/cse** to view the example application's List Containers page.

Listing Mumble containers from the application:

![Carina Access]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/listcontainer.png %})

A new Mumble server:

![Carina Access]({% asset_path 2016-05-26-simple-saas-with-jclouds-and-carina/createcontainer.png %})