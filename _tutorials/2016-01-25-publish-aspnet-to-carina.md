---
title: Publish an ASP.NET website to Carina from the command line
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-02-12
permalink: docs/tutorials/publish-aspnet-to-carina/
description: Learn how to publish an ASP.NET website to Carina from the command line on Mac OS X, Linux or Windows
docker-versions:
  - 1.10.1
topics:
  - docker
---

The upcoming version of ASP.NET is a major evolution of the .NET platform.
The name churn alone hints at its complete redesign: first ASP.NET vNext, then ASP.NET 5,
and now ASP.NET Core 1.0. One very welcome feature is official cross-platform
support, no longer requiring Visual Studio, Windows, or even the Mono framework.
Now that you can develop ASP.NET on any platform using free tools and deploy to Linux,
hosting on Carina is a smart next step, whether you are new to ASP.NET or a
veteran who wants to take it to the next level by deploying to containers.

This tutorial describes how to publish an ASP.NET website to Carina from the command line on Mac OS X, Linux, or Windows.

![ASP.NET Powered By Carina]({% asset_path publish-aspnet-to-carina/aspnet-powered-by-carina.png %})

### Prerequisites

* [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)
* [Install the Carina CLI](docs/getting-started/getting-started-carina-cli/)
* Install package managers
  * [Chocolatey](http://chocolatey.org) for Windows
  * [Brew](http://brew.sh) for Mac OS X
  * `apt-get` for Linux (Ubuntu)

### Install the ASP.NET prerelease
These instructions rely on the latest version of the ASP.NET prerelease and the ASP.NET Generator.
If you already have these applications installed, update to the latest version.

1. Install the ASP.NET prerelease by running the following commands:

    **Mac OS X**

    ```
    brew tap aspnet/dnx
    brew install dnvm
    ```

    **Windows**

    ```
    choco install aspnet5
    ```

    **Linux**

    These instructions are for Ubuntu. See [Installing ASP.NET on Linux](https://docs.asp.net/en/latest/getting-started/installing-on-linux.html) for instructions for other distributions.

    ```bash
    bash -c '
    sudo apt-get update
    sudo apt-get install -y curl unzip libunwind8 gettext libssl-dev libcurl4-openssl-dev zlib1g libicu-dev uuid-dev make automake libtool
    curl -sSL https://github.com/libuv/libuv/archive/v1.8.0.tar.gz | sudo tar zxfv - -C /usr/local/src
    cd /usr/local/src/libuv-1.8.0
    sudo sh autogen.sh
    sudo ./configure
    sudo make
    sudo make install
    sudo rm -rf /usr/local/src/libuv-1.8.0 && cd ~/
    sudo ldconfig
    curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh
    '
    source ~/.dnx/dnvm/dnvm.sh
    ```

1. Ensure that the latest release candidate of the .NET runtime is
    installed and active by running the following command:

    ```
    dnvm upgrade -r coreclr
    ```

    `dnvm` is the .NET Version Manager, and it allows you to install multiple
    versions of .NET and switch between them.

1. Install Node.js by running the following commands:

    **Mac OS X**

    ```
    brew install node
    ```

    **Windows**

    ```
    choco install node
    ```

    **Linux**

    These instructions are for Ubuntu. See the
    [Node.js installation instructions](https://nodejs.org/en/download/package-manager/) for other distributions.

    ```bash
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
    sudo apt-get install -y nodejs
    ```

1. Install Yeoman by running the following command:

    **Mac OS X and Linux**

    ```
    sudo npm install -g yo
    ```

    **Windows**

    ```
    npm install -g yo
    ```

1. Install ASP.NET Generator by running the following command:

    **Mac OS X and Linux**

    ```
    sudo npm install -g generator-aspnet
    ```

    **Windows**

    ```
    npm install -g generator-aspnet
    ```

You are now ready to begin developing ASP.NET applications. On Windows,
the recommended editor is still Visual Studio, but is not necessary. You can develop
using your preferred editor or try [Visual Studio Code][vscode], which is cross-platform
and provides autocompletion.

### Create an ASP.NET website
This tutorial uses Yeoman (`yo`) and the ASP.NET Generator plug-in to bootstrap a
new ASP.NET website. It does all the work that normally would be performed by
Visual Studio when starting a new project.

1. Create an ASP.NET website by running the following command:

    ```
    yo aspnet
    ```

    The ASP.NET Generator prompts for the type of application and a name, and then
    creates a new directory within the current directory.

1. Select `Web Application` and accept the default name.

    ```
    $ yo aspnet

         _-----_
        |       |    .--------------------------.
        |--(o)--|    |      Welcome to the      |
       `---------´   |   marvellous ASP.NET 5   |
        ( _´U`_ )    |        generator!        |
        /___A___\    '--------------------------'
         |  ~  |
       __'.___.'__
     ´   `  |° ´ Y `

    ? What type of application do you want to create?
      Empty Application
      Console Application
    ❯ Web Application
      Web Application Basic [without Membership and Authorization]
      Web API Application
      Nancy ASP.NET Application
      Class Library
      Unit test project

    ? What type of application do you want to create? Web Application
    ? What's the name of your ASP.NET application? WebApplication
    ```

    The generator created a directory using the name provided, such as `WebApplication`,
    as a child of the current directory. 


1. Run the following commands to preview your website:

    ```
    cd WebApplication
    dnu restore
    dnx web
    ```

    `dnu` is the .NET Utility tool and is used to retrieve all the
    dependencies for the website from NuGet. `dnx` is the .NET Execution Environment
    tool and is used to execute commands defined in **project.json**.
    By the time the upcoming version of ASP.NET is released, these will
    be replaced by `dotnet`, but as of ASP.NET 5 RC1 these are the correct tools.

1. Open [http://localhost:5000](http://localhost:5000) to view the website.
    You should see a website with the ASP.NET banner.

    ![ASP.NET Banner]({% asset_path publish-aspnet-to-carina/aspnet-screenshot.png %})

You now have an ASP.NET website. The scaffolding is outside the scope of this tutorial,
however a few files are notable:

**Dockerfile**

This file contains the instructions that Docker uses to build a container for
the website. Following is an example Dockerfile with comments added to explain
the steps used to build the container:

```
# Base the container off of the official Microsoft ASP.NET container, version 1.0.0-rc1-update1
FROM microsoft/aspnet:1.0.0-rc1-update1

# Install SQLite 3 in the container
RUN printf "deb http://ftp.us.debian.org/debian jessie main\n" >> /etc/apt/sources.list
RUN apt-get -qq update && apt-get install -qqy sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*

# Copy the website into the container
COPY . /app
WORKDIR /app

# Restore the website dependencies
RUN ["dnu", "restore"]

# Make port 5000 accessible on the container
EXPOSE 5000/tcp

# Run the webserver when the container is started
ENTRYPOINT ["dnx", "-p", "project.json", "web"]
```

**project.json**

This is the project file for the website. It defines the required dependencies
and exposes any supported commands, such as `dnx web`. From the following example,
you can see that `web` is not a global command, and is specific to this project.

```
{
  ...

  "dependencies": {
    "EntityFramework.Sqlite": "7.0.0-rc1-final",
    "Microsoft.AspNet.Mvc": "6.0.0-rc1-final",
    ...
  },

  "commands": {
    "web": "Microsoft.AspNet.Server.Kestrel"
  }

  ...
}
```

### Publish your ASP.NET website to Carina

Now that you have verified that the website can be run locally, publish
it to Carina.

1. Edit the **project.json** file and append `server.urls=http://0.0.0.0:5000` to the web
    command. By default, the Kestrel web server listens on the IP address `127.0.0.1`.
    When this is overridden with `0.0.0.0`, the web server handles all requests
    to the specified port, regardless of the host's IP address.

    ```text
    "commands": {
            "web": "Microsoft.AspNet.Server.Kestrel server.urls=http://0.0.0.0:5000",
            "ef": "EntityFramework.Commands"
        },
    ```

1. If you have not already done so, [create and connect to a cluster](/docs/getting-started/create-connect-cluster/).

1. Build a Docker image of your website by running the following command:

    ```
    docker build --tag aspnet-demo .
    ```

1. Run a container with the image by running the following command:

    ```
    docker run --name demo --detach --publish-all aspnet-demo
    ```

1. Identify the IP address and port on which the container is published by running the following command.
    In the example output, the IP address is `172.99.65.237` and the port is `32800`.

    ```bash
    $ docker port demo
    5000/tcp -> 172.99.65.237:32800
    ```

1. Open http://_ipAddress_:_port_, for example **http://172.99.65.237:32800**.
    You should see the same site published to Carina that you previewed locally.


The .NET platform has been completely reimagined and freed from
many constraints that would have previously prevented you from exploring it further.
With ASP.NET and Carina, you can skip the learning curve of a new operating system
and instead jump straight to the fun part.

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

You might encounter the following issues when publishing:

* `Predefined type 'System.Object' is not defined or imported`

    By default, generated projects target both the traditional .NET framework and .NET Core.
    `dnu build` compiles the application for every framework listed in the `frameworks`
    section in the **project.json** file. If you don't have the full .NET framework installed and configured,
    then when it attempts to build dnx451, the build fails. To resolve this issue,
    remove `"dnx451": { },` from the `frameworks` section of the **project.json** file.

    **Note**: `dnu build` is not necessary for this tutorial.

* `Microsoft.AspNet.Server.Kestrel.Networking.UvException: Error -13 EACCES permission denied`

    The Kestrel web server is configured to use a port that is already in use.
    Edit the **project.json** file and ensure that `server.urls` is configured with an unused port.

    `"web": "Microsoft.AspNet.Server.Kestrel server.urls=http://0.0.0.0:5001",`
* The Docker image is built successfully but warning messages from `apt-get` are displayed.

    You can ignore the following warning messages:

    ```
    W: Duplicate sources.list entry http://ftp.us.debian.org/debian/ jessie/main amd64 Packages (/var/lib/apt/lists/ftp.us.debian.org_debian_dists_jessie_main_binary-amd64_Packages.gz)
    W: Duplicate sources.list entry http://ftp.us.debian.org/debian/ jessie/main amd64 Packages (/var/lib/apt/lists/ftp.us.debian.org_debian_dists_jessie_main_binary-amd64_Packages.gz)
    W: You may want to run apt-get update to correct these problems
    ```

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Learn more about ASP.NET](https://get.asp.net/)
* [Getting started with ASP.NET on Carina with Visual Studio]({{site.baseurl}}/docs/getting-started/aspnet-on-carina-with-visual-studio/)

[vscode]: https://code.visualstudio.com/
