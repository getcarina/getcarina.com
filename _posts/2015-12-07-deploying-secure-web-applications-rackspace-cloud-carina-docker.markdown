---
layout: post
title: "Deploying Secure Web Applications on the Rackspace Cloud with Carina and Docker"
date: 2015-12-07 23:59
comments: true
author: Lars Butler <lars.butler@rackspace.com>
authorIsRacker: true
published: true
categories:
    - DevOps
    - Deployment
    - Security
    - Carina
    - Docker
---

It's almost 2016, so I shouldn't need to convince you that making your web
application as secure as possible is an absolute necessity. Security is a
multi-faceted topic, but the biggest application security concerns are in the
deployment and configuration of infrastructure.
Internally, this means that secrets such as passwords and private keys must
be stored and handled in a secure way, and that network access to resources
such as virtual servers is limited only to what is absolutely necessary.
Externally, any communication between your app and a client must take place
over a secure channel, and that usually means setting up SSL (Secure Sockets
Layer) on your web service to communicate over secure HTTP (HTTPS). There are a
lot of security considerations for deploying your application into production.
But if you're a software developer like me, you probably want to spend _more_
time thinking about building the next feature for your application and _less_
time thinking about how to deploy it.

In this post, I'll show you what I found to be the path of least resistance in
getting a secure web application up and running on the Rackspace Cloud. First
I'll take you quickly through the process of creating an SSL certificate, and then
I'll show you how to deploy an application using
[Carina](https://getcarina.com/)--Rackspace's new container service--and
[Docker](https://docker.com). Whether you've deployed HTTPS applications dozens
of times, or you've never done it once, this guide should have something useful
for you.

<!-- more -->

- [What you need](#what-you-need)
- [Create an SSL certificate](#create-an-ssl-certificate)
- [Environment Setup](#environment-setup)
- [Create a web application](#create-a-web-application)
- [Run one container](#run-one-container)
- [Run two containers](#run-two-containers)
- [Add a Cloud Load Balancer](#add-a-cloud-load-balancer)
- [Configure network, SSL, and DNS](#configure-network,-ssl,-and-dns)
- [Conclusion](#conclusion)

## What you need

To follow me on this exercise, you need a couple of things:

- A Carina account. You can sign up for free at
  [getcarina.com](https://getcarina.com).
- A Rackspace Cloud Account. If you don't have one yet, you can sign up
  [here](https://cart.rackspace.com/cloud).
- A computer running Linux or OS X and a knowledge of basic shell commands. If you
  don't have ready access to such a machine, you can install
  [VirtualBox](https://www.virtualbox.org/) and use
  [Vagrant](https://www.vagrantup.com/) to create a local Linux virtual machine.
  See [Vagrant's Getting Started guide](https://docs.vagrantup.com/v2/getting-started/index.html)
  for more information.
- A registered domain name. I'll show you the basics of creating and deploying SSL,
  and you need a valid registered domain name to do this.

You also need a valid SSL certificate. If you have one already, you can skip
ahead to [Environment Setup](#environment-setup). If not, read on and I'll take
you through the process of creating one.

## Create an SSL certificate

Creating an SSL certificate has several steps. This section breaks those steps
down for you.

### Install OpenSSL

First you need to install [OpenSSL](https://www.openssl.org/)
on your Linux or OS X machine. Most system package managers should have an
`openssl` package available to install. For example:

- On Red Hat-based Linux distros (such as Red Hat Enterprise Linux  or CentOS), run
  `sudo yum install openssl`.
- On Debian- or Ubuntu-based Linux distros, run `sudo apt-get install openssl`.
- On OS X you can use [Homebrew](http://brew.sh/) to run `brew install openssl`.

### Generate a CSR

After `openssl` is installed, generate your Certificate Signing Request (CSR)
and a private key for your SSL certificate.

Open a shell session and run the following command:

    openssl req -newkey rsa:2048 -nodes -keyout mydomain.com.key -out mydomain.com.csr

Here's a breakdown of the command:

- `req`: This is a sub-command of `openssl` concerned with the management of CSRs.
- `-newkey rsa:2048`: Create a new RSA key with a length of 2048 bits.
- `-nodes`: Stands for _no DES_, which instructs `openssl` to not encrypt the
  private key file. This enables you to use the private key without having to
  enter a passphrase. (Source:
  [Stackoverflow discussion](http://stackoverflow.com/questions/5051655/what-is-the-purpose-of-the-nodes-argument-in-openssl).)
- `-keyout mydomain.com.key`: Name of the file where the private key will be
  saved. In this case, replace `mydomain.com` with your root domain name.
- `-out mydomain.com.csr`: Name of the file where the CSR will be saved.
   Again, replace `mydomain.com` with your actual domain name.

The command prompts you to enter information to populate your CSR. It should
look like this:

    $ openssl req -newkey rsa:2048 -nodes -keyout mydomain.com.key -out mydomain.com.csr
    Generating a 2048 bit RSA private key
    ......+++
    .........................................+++
    writing new private key to mydomain.com.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [AU]:US
    State or Province Name (full name) [Some-State]:New York
    Locality Name (eg, city) []:New York
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:
    Organizational Unit Name (eg, section) []:
    Common Name (e.g. server FQDN or YOUR name) []:secure.mydomain.com
    Email Address []:your.email@example.com

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:

Most of these inputs are optional, which is nice if you're creating an SSL
certificate for a personal website and you don't actually have a company name.
The important fields are:

- Country Name (2 letter code): If you don't know your country's two letter code,
  you can look it up at
  [https://www.iso.org/obp/ui/#search](https://www.iso.org/obp/ui/#search).
- State or Province Name (full name)
- Locality Name (eg, city)
- Common Name (e.g. server FQDN or YOUR name): Typically you should enter the
  Fully Qualified Domain Name (FQDN) where you will be deploying your app.
  In this example, the FQDN we've specified is `secure.mydomain.com`, with
  `secure` as the subdomain--but you can choose any
  subdomain you like, such as `www`, or whatever. It's also possible to
  generate a
  [wildcard certificate](https://tools.ietf.org/html/rfc2818#page-5),
  such as `*.mydomain.com`, but this is a bit more complicated (and the
  certificate will cost more).
- Email Address

After you provide the required information, `openssl` generates two files:
`mydomain.com.key` and `mydomain.com.csr`. Don't lose these, especially the
`.key` file!

**Important**: `mydomain.com.key` is the private key for your certificate.
Never publish it or put it directly into source control. If you're doing all
of this on a virtual machine, using Vagrant, for example, make sure you copy
the key off of the machine and store it someplace safe before you destroy
the machine. Your certificate is useless without the private key.

### Submit the CSR to a CA and purchase an SSL certificate

Now that you have your CSR (`mydomain.com.csr`), you must submit it to a
[Certificate Authority](https://en.wikipedia.org/wiki/Certificate_authority)
(CA) and purchase an SSL certificate. Many domain registrars offer SSL
certificate services, so if you're not sure where to get one, check with your
domain registrar first. There is a broad range of SSL certificate options
available, so choose one that is appropriate for your application. For testing
purposes, you should be able to get a basic certificate for about $10, but for
a production application, you might need something more than that. (If you're
not sure which SSL certificate is right for you,
[Rackspace can help with that](https://www.rackspace.com/custom-networking/ssl-certs).)
Altogether, it should take a day or less to get your certificate.

When all is done, your certificate comprises three files:

- The private key, which you generated at the beginning, along with your CSR.
- The certificate itself, typically saved as a `.crt` file. This is given to
  you after a successful certificate request.
- The intermediate certificate chain, or Certificate Authority (CA) bundle.
  This is given to you along with your certificate.

You need all three files to set up SSL on your web application.

## Environment Setup

1.  Log in to your Linux or OS X machine and install the Docker Version Manager
    (`dvm`):

        wget https://download.getcarina.com/dvm/latest/install.sh
        sh install.sh

    The output of this command directs you to run `source /home/me/.dvm/dvm.sh`
    (where `/home/me` is your home directory) and then add that command to your
    `.bashrc` or `.bash_profile`.

2.  Run the following commands:

        source /home/me/.dvm/dvm.sh
        echo "/home/me/.dvm/dvm.sh" >> ~/.bashrc

## Create a web application

Now, create a simple web application and run it on Carina.

1.  [Log in to Carina](https://app.getcarina.com/app/login).
2.  In the Carina Control Panel, click **Add Cluster**.
3.  Enter a name for the cluster. You can call it whatever you want. For
    example, you could name your cluster after the FQDN for your site, such as
    `secure-mydomain-com`. (Note: The name can only contain letters, numbers,
    underscores, and hyphens.)
4.  Select **Enable Autoscale** if you like; it's optional for this example. (You
    can read more about
    [Carina's autoscaling feature](https://getcarina.com/docs/reference/autoscaling-carina/).)

    ![Carina - Creating a cluster]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/1-carina-create-cluster.png %})

5.  Click **Create Cluster** and watch it build. It will only take a minute.
6.  After the cluster is done building click **Get Access** and then click
    **Download File**.

    ![Carina - Get access, download credentials]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/2-carina-get-access-download-file.png %})

7.  Save the zip file somewhere convenient. For example, you can save it to your
    home directory.
    **Note**: If you're running a Linux virtual machine with Vagrant, put the zip
    file in the same directory as your `Vagrantfile` and you can access
    the zip file inside the Vagrant box from the `/vagrant` directory.

8.  Change to the directory with the zip file and extract the contents by using
    the `unzip` command:

        unzip secure-mydomain-com.zip

9.  Change to the `secure-mydomain-com` directory. In this directory, create two
    files: a `main.go` file for the web application itself and a `Dockerfile`,
    from which the container for the web application will be built. The example
    web application is written in [Go](https://golang.org), which has a good
    built-in web server and provides a simple and concise example for this
    guide.

10. Create the `main.go` file with the following code (which is borrowed from an
    example in the
    [Go documentation](https://golang.org/pkg/net/http/#ListenAndServe)):

    ```go
    package main

    import (
        "io"
        "net/http"
        "log"
    )

    func HelloHandler(w http.ResponseWriter, req *http.Request) {
        io.WriteString(w, "hello, world!\n")
    }

    func main() {
        http.HandleFunc("/", HelloHandler)
        err := http.ListenAndServe(":8080", nil)
        if err != nil {
            log.Fatal("ListenAndServe: ", err)
        }
    }
    ```

11. Create the `Dockerfile`:

    ```dockerfile
    FROM golang

    RUN mkdir -p /usr/src/app
    ADD main.go /usr/src/app/main.go

    WORKDIR /usr/src/app
    RUN go build main.go

    EXPOSE 8080

    ENTRYPOINT ["./main"]
    ```

    If you're not familiar with Docker, here's what the `Dockerfile` is doing:

    <ul>
    <li>
    <code>FROM golang</code>: Start from a base image which already has Go installed.
    (You can look for additional base images on
    <a href="https://hub.docker.com/">Docker Hub</a>.)
    </li>

    <li>
    <code>RUN mkdir -p /usr/src/app</code>: Create a folder inside the
    container for the application files.
    </li>

    <li>
    <code>ADD main.go /usr/src/app/main.go</code>: Copy <code>main.go</code>
    from the current directory into the target directory in the container.
    </li>

    <li><code>WORKDIR /usr/src/app</code>: Change the working directory to
    <code>usr/src/app</code> All subsequent commands in the
    <code>Dockerfile</code> will be run from this directory.
    </li>

    <li>
    <code>RUN go build main.go</code>: Compile <code>main.go</code> and create
    a binary called <code>main</code>
    </li>

    <li>
    <code>EXPOSE 8080</code> The <code>main</code> web application will
    bind to and listen on port 8080, so that port needs to be exposed to the
    outside world.
    </li>

    <li>
    <code>ENTRYPOINT ["./main"]</code> The command to execute to start the web
    service.
    </li>
    </ul>

12. Build the Docker container image and deploy it:

        source docker.env
        dmv use

    `source docker.env` sets up the environment variables needed in order to talk
    to the Docker service running on Carina, and `dvm use` sets up a compatible
    Docker client to use with the service.

13. Build the Docker image:

    docker build --tag secure-mydomain-com .

After the container image is built, you can deploy a container on Carina by
using that image. You are actually going to deploy your container a couple of
times, each time in a slightly different way, and the entire deployment will
get increasingly complex.

First, you'll deploy a single container and verify that the "hello, world" web
application is online and functions correctly--with just direct HTTP (not HTTPS)
access to the container.

Next, you'll deploy a pair of containers, set up a load balancer to distribute
the load, and then test that the traffic is being routed correctly to the
containers.

Finally, you'll set up SSL on the load balancer, configure DNS, and update the
containers' network configuration to isolate them from the public internet.

**Question**: Why use a load balancer? Putting a load balancer in
place allows you to easily horizontally scale your web application by
simply spinning up more nodes/containers and adding them to your load
balancer configuration. Using a load balancer also makes installing your SSL
certificate easy, in comparison to configuring Apache or NGINX to use your SSL
certificate. It also means that you don't need to deal with SSL termination on
your application containers, which potentially adds a lot of complexity and
security concerns into your build pipeline.

## Run one container

Before you start deploying things, test that the `docker` client is configured
correctly and communicating properly with Carina:

    docker ps

The command should simply return an empty listing because you don't yet have
any containers running. Now run one:

    docker run --detach --publish 8080 secure-mydomain-com

Here's a breakdown of the command:

- `docker run`: This is the subcommand that runs Docker containers. But you
  probably guessed that already.
- `--detach`: Tells the Docker container to run in the background. If you omit
  this flag, your shell will retain an actively attached session to the
  container. (This can be useful to actively view output from your
  containerized application, and for testing and debugging. But for this
  example, use `--detach`.)
- `--publish 8080`: Publish port 8080 to make it available outside the
  container. In this case, Docker figures out how to map this to an IP
  address and port that you can access outside of the container.
- `secure-mydomain-com`: This is simply the name of the container image that
  you built using the `docker build` command.

Run `docker ps` again, and you should see a response like the following one:

    $ docker ps
    CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS              PORTS                           NAMES
    880960711bb6        secure-mydomain-com   "./main"            3 minutes ago       Up 7 seconds        172.99.78.193:32769->8080/tcp   885bbfe5-5fd1-4797-97d1-2ae199906afb-n1/awesome_varahamihira

Look at the PORTS column. In this example, the socket `172.99.78.193:32769` has
been set up to connect the web application to the outside world. (Your IP
address and port will of course be different in your cluster.)

Test the application by using `curl`. The command and output should look like
this:

    $ curl http://172.99.78.193:32769  # replace the IP/port with the output you got from `docker ps`
    hello, world!

## Run two containers

Add another container by using the same `docker run` command as before:

    docker run --detach --publish 8080 secure-mydomain-com

Now when you run `docker ps`, you should see two containers running:

    $ docker ps
    CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS              PORTS                           NAMES
    3acd98aaad21        secure-mydomain-com   "./main"            3 minutes ago       Up 7 seconds        172.99.78.193:32770->8080/tcp   885bbfe5-5fd1-4797-97d1-2ae199906afb-n1/romantic_fermi
    880960711bb6        secure-mydomain-com   "./main"            5 minutes ago       Up 2 minutes        172.99.78.193:32769->8080/tcp   885bbfe5-5fd1-4797-97d1-2ae199906afb-n1/awesome_varahamihira

Test the connectivity on the second container:

    $ curl http://172.99.78.193:32770
    hello, world!

## Add a Cloud Load Balancer

1.  Log in to the [Rackspace Cloud Control Panel](https://mycloud.rackspace.com/).
2.  At the top of the page, click **Networking** and then **Load Balancers**.
3.  Click **Create Load Balancer**.
4.  On the form, enter `secure.mydomain.com` for the load balancer name and
    select **Northern Virginia (IAD)** for the region. The rest of the settings
    can be left as defaults. **Note**: Carina runs in the IAD region, so it's
    important to create your load balancer in the same region. Toward the end
    of this tutorial, you'll see why that's important. You can find more
    information about Rackspace regions
    [in the Rackspace Knowledge Center](http://www.rackspace.com/knowledge_center/article/about-regions).

    ![Create a Load Balancer]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/3-create-load-balancer.png %})

5.  In the **Add Nodes** section, add your docker containers by clicking
    **Add External** node and pasting in the IP address and port combinations of
    your containers (as you saw when running `docker ps`).

    ![Load Balancer - Add Nodes]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/4-create-load-balancer-add-nodes.png %})

    After adding both nodes, your configuration should look something like this:

    ![Load Balancer - Nodes Added]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/5-create-load-balancer-nodes-added.png %})

6.  Click **Create Load Balancer** and watch its progress. It should take a minute
or less to build.

    ![Load Balancer Details]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/6-load-balancer-details.png %})

7.  Test the load balancer by copying the Public IP address from the load
    balancer details page and running the following command:

        $ curl http://146.20.25.93
        hello, world!


## Configure network, SSL, and DNS

Now it's time to put the finishing touches on your application.

### Redeploy containers on an internal network

Currently, your load balancer is communicating with your containers over a
public network. Because this traffic is unencrypted, you need to fix that.
The first thing you need to do is redeploy your containers with a slightly
different network configuration.

1.  Kill the currently running containers by running the 'docker kill' command
    for each container ID:

        docker kill 3acd
        docker kill 8809

    **Note**: You don't have to type the full container ID. You can type just the
    first few characters of the ID and Docker will figure out which container you
    mean. (If there's any ambiguity when matching a partial ID, Docker gives you an
    error.)

    Now you need to deploy some new containers but expose them only to
    [ServiceNet](http://www.rackspace.com/knowledge_center/article/cloud-networks-faq),
    Rackspace's private multi-tenant network partition. (I mentioned earlier that
    your load balancer needs to be in the IAD region--the same as Carina--and this
    is why: ServiceNet provides service-to-service communication, but only within a
    single region.) In order to do that, you need to get the ServiceNet IP address
    of one of the nodes in your cluster.

    The Carina documentation already has a
    [great tutorial](https://getcarina.com/docs/tutorials/servicenet/#run-a-redis-container-exposed-only-on-servicenet)
    about exposing services only to ServiceNet, so you can use some steps from that.

2.  Run `docker info`:

        $ docker info
        Containers: 5
        Images: 4
        Role: primary
        Strategy: spread
        Filters: health, port, dependency, affinity, constraint
        Nodes: 1
         885bbfe5-5fd1-4797-97d1-2ae199906afb-n1: 172.99.78.193:42376
          └ Containers: 5
          └ Reserved CPUs: 0 / 12
          └ Reserved Memory: 0 B / 4.2 GiB
          └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
        CPUs: 12
        Total Memory: 4.2 GiB
        Name: 817f1afe99da

3.  Copy the node ID from the output. In this case, the node ID is
    `885bbfe5-5fd1-4797-97d1-2ae199906afb-n1`. If `docker info` shows that your
    cluster has more than one node, just pick one.

    **Note**: Each of the server nodes in your Carina cluster has both a PublicNet IP
    address and a ServiceNet IP address. You can read more about the differences
    between PublicNet and ServiceNet
    [in the Knowledge Center](http://www.rackspace.com/knowledge_center/article/cloud-networks-faq).

4.  Get the ServiceNet IP for the node:

        $ docker run --net=host \
            --env constraint:node==885bbfe5-5fd1-4797-97d1-2ae199906afb-n1 \
            racknet/ip \
            service ipv4
        10.176.229.17

5.  Copy the resulting IP address and then create a container. The command that
    you need is similar to the `docker run` command you used before, but there are
    a couple of important additions:

        docker run --detach --publish 10.176.229.17::8080 \
            --env constraint:node=885bbfe5-5fd1-4797-97d1-2ae199906afb-n1 \
            secure-mydomain-com

    This command has two key parts:

    <ul>
    <li>
    <code>--publish 10.176.229.17::8080</code>: The format of the
    <code>--publish</code> argument is <code>ip:hostPort:containerPort</code>.
    This means to publish the service that is running on `8080` in the container
    to the ServiceNet IP address on the host, and use a random available port.
    (<a href="https://docs.docker.com/engine/reference/run/#expose-incoming-ports">
    See the <code>docker run</code> reference</a>
    for more information about exposing ports in Docker.)
    </li>

    <li>
    <code>--env constraint:node=885bbfe5-5fd1-4797-97d1-2ae199906afb-n1</code>: This is a
    <a href="https://docs.docker.com/swarm/scheduler/filter/">Docker Swarm scheduling
    filter</a>
    which simply specifies where the container should be hosted.
    </li>
    </ul>

6.  Run the command again to create another container.
7.  Check the results of the `docker run` commands:

        $ docker ps
        CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS              PORTS                           NAMES
        7ac35cf8c9d2        secure-mydomain-com   "./main"            3 minutes ago       Up 28 seconds       10.176.229.17:32771->8080/tcp   885bbfe5-5fd1-4797-97d1-2ae199906afb-n1/prickly_panini
        8398b4e45b1c        secure-mydomain-com   "./main"            3 minutes ago       Up 31 seconds       10.176.229.17:32768->8080/tcp   885bbfe5-5fd1-4797-97d1-2ae199906afb-n1/condescending_tesla

    Take note of the host IP address and port for each container. You need to add
    these to your load balancer.

8.  In the Rackspace Cloud Control Panel, open your load balancer configuration.
9.  In the **Nodes** section, remove the two existing nodes by clicking the gear
    icon next to them and selecting **Remove from load balancer**.
10. Add two entries for your new containers by clicking **Add External Node**.
11. Test the load balancer IP address to verify that everything works:

        curl http://146.20.25.93

### Install the SSL certificate

While you're in the load balancer configuration, you can install your SSL
certificate.

1.  Scroll to the **Optional Features** section and click the pencil icon next to
    **Secure Traffic (SSL)**.
2.  Select **Allow Only Secure Traffic**.
3.  In the **Certificate** box, paste in your SSL certificate contents.
4.  In the **Private Key** box, paste in the contents of the private key that you
    generated with your CSR. (If you followed the previous instructions, paste
    the contents of the `mydomain.com.key` file.)
4.  In the **Intermediate Cert** box, paste the contents of your intermediate
    certificate/CA bundle file.
5.  Click **Save SSL Configuration**.

    ![Load Balancer - Configuring SSL]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/7-configure-ssl-add-keys-certs.png %})

7.  Also under **Optional Features**, click the pencil icon next to
    **HTTPS Redirect** and enable it. This ensures that all HTTP (non-secure HTTP)
    requests submitted to your load balancer are redirected to your secure HTTP
    (HTTPS) endpoint. (You probably noticed that many sites do exactly this! This
    is an important usability detail.)
8.  Test the HTTPS redirect by using a `curl -i` command and then a `curl -L`
    command (to follow the redirect) on the load balancer:

        $ curl -i http://146.20.25.93
        HTTP/1.1 301 Moved Permanently
        Content-Type: text/html
        Content-Length: 0
        Connection: Keep-Alive
        Date: Thu, 26 Nov 2015 15:13:35 GMT
        Location: https://146.20.25.93/
        $ curl -L http://146.20.25.93
        curl: (60) SSL certificate problem: Invalid certificate chain
        More details here: http://curl.haxx.se/docs/sslcerts.html

        curl performs SSL certificate verification by default, using a "bundle"
         of Certificate Authority (CA) public keys (CA certs). If the default
         bundle file isn't adequate, you can specify an alternate file
         using the --cacert option.
        If this HTTPS server uses a certificate signed by a CA represented in
         the bundle, the certificate verification probably failed due to a
         problem with the certificate (it might be expired, or the name might
         not match the domain name in the URL).
        If you'd like to turn off curl's verification of the certificate, use
         the -k (or --insecure) option.

    Basically, this error tells you that you should access your web application
    only by using the domain name associated with your SSL certificate. (If you
    try to access this address in a browser, you'll get a similar security
    warning.)

### Configure DNS

Now for the last piece of the puzzle: You need to point your domain name to the
load balancer.

1.  Go into your DNS management console (wherever your DNS is hosted) and create
    an A record for your domain name. If your domain name is
    `secure.mydomain.com`, make an A record with a host name of `secure` and
    point it to the IP address of your load balancer.
2.  After your DNS changes are fully propagated (which might take a few hours or
    even a day), you can test it:

        $ curl https://secure.mydomain.com
        hello, world!

3.  Test it in a browser, too, and you should get a "green light" on your secure
    connection!

![Browser - Secure HTTP]({% asset_path 2015-12-07-deploying-secure-web-applications-rackspace-cloud-carina-docker/8-https-secure.png %})

## Conclusion

In this tutorial, I've tried to describe a simple and realistic example of
deploying a web application with SSL, without leaving out important
details. Naturally, a real web application is going to be more complex than a
few containers running a "hello, world" program behind a load balancer. At some
point, so you will likely want to add a datastore, a cache, or other services.
The [Carina documentation](https://getcarina.com/docs/#tutorials)
already has several great tutorials for containerizing services like MySQL,
Apache, and MongoDB, so check them out! Happy hacking.
