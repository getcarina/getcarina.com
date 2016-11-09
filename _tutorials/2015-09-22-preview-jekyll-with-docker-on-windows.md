---
title: Preview a Jekyll site with Docker on Windows
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2015-09-22
permalink: docs/tutorials/preview-jekyll-with-docker-on-windows/
description: Learn how to preview a Jekyll site in a Docker container, so that you do not need to install Ruby or Jekyll on your local machine
docker-versions:
  - 1.10.1
topics:
  - docker
  - intermediate
  - windows
---

**Note:** This tutorial is for Windows users. If you are using another operating system, follow
[the tutorial for Mac OS X]({{ site.baseurl }}/docs/tutorials/preview-jekyll-with-docker-on-mac/) or
[the tutorial for Linux]({{ site.baseurl }}/docs/tutorials/preview-jekyll-with-docker-on-linux/) instead.

[Jekyll][jekyll] is a popular static site generator, most commonly used for blogging on GitHub Pages.
It is written in Ruby and sometimes getting your machine setup properly to preview your
changes before publishing can be difficult, especially on Windows.

This tutorial describes how to preview a Jekyll site in a Docker container, so that
you do not need to install Ruby or Jekyll on your local machine.

[jekyll]: https://jekyllrb.com/

## Prerequisites
* [Docker Toolbox][docker-toolbox]
* An existing Jekyll site on your local file system. If you do not have
  an existing site, a good way to get started quickly is to download a [Jekyll theme][jekyll-themes].

    You must place your site in a sub-directory of **C:\Users**,
    though it can be more deeply nested, for example, **C:\Users\myuser\repos\my-site**.
    The **Users** directory is the only directory exposed by default from your local machine
    to the Docker host via VirtualBox. If you want to use a different directory,
    you must manually share it with the Docker host by using VirtualBox.

[docker-toolbox]: https://www.docker.com/toolbox
[jekyll-themes]: https://github.com/jekyll/jekyll/wiki/Themes

## Steps

1. Open a command terminal and change to your Jekyll site directory.

2. Create a new file named **Dockerfile** and populate it with the following content.

    **Note:** If you are using GitHub Pages or are not using any Jekyll plug-ins,
    you do not need to create a custom Docker image. Skip to the next step.

    ```text
    FROM grahamc/jekyll:latest

    # Install whatever is in your Gemfile
    WORKDIR /tmp
    ADD Gemfile /tmp/
    ADD Gemfile.lock /tmp/
    RUN bundle install

    # Change back to the Jekyll site directory
    WORKDIR /src
    ```

3. Using your preferred scripting language, create a script from the following options.
    You might want to customize the `DOCKER_MACHINE_NAME` and `DOCKER_IMAGE_NAME`
    variables defined at the top of the file.

    **PowerShell**

    Create a file named **preview.ps1** and populate it with the following content.

    ```powershell
    # Set to the name of the Docker machine you want to use
    $DOCKER_MACHINE_NAME='default'

    # Set to the name of the Docker image you want to use
    $DOCKER_IMAGE_NAME='my-site'

    # Stop on first error
    $ErrorActionPreference = "Stop"

    # Create a Docker host
    if( !(@(docker-machine ls) -like "$DOCKER_MACHINE_NAME *" ) ) {
      docker-machine create --driver virtualbox $DOCKER_MACHINE_NAME
    }

    # Start the host
    if( @(docker-machine ls) -like "$DOCKER_MACHINE_NAME * Stopped *" ) {
      docker-machine start $DOCKER_MACHINE_NAME
    }

    # Load our docker host's environment variables
    docker-machine env $DOCKER_MACHINE_NAME --shell powershell | Invoke-Expression

    if( Test-Path Dockerfile ) {
      # Build a custom Docker image that has custom Jekyll plug-ins installed
      docker build --tag $DOCKER_IMAGE_NAME --file Dockerfile .

      # Remove dangling images from previous runs
      @(docker images --filter "dangling=true" -q) | % {docker rmi -f $_}
    }
    else {
      # Use an existing Jekyll Docker image
      $DOCKER_IMAGE_NAME='grahamc/jekyll'
    }

    echo "***********************************************************"
    echo "  Your site will be available at http://$(docker-machine ip $DOCKER_MACHINE_NAME):4000"
    echo "***********************************************************"

    # Translate your current directory into the file share mounted in the Docker host
    $host_vol = $pwd.Path.Replace("C:\", "/c/").Replace("\", "/")
    echo "Mounting $($pwd.Path) ($host_vol) to /src on the Docker container"

    # Start Jekyll and watch for changes
    docker run --rm `
      --volume=${host_vol}:/src `
      --publish 4000:4000 `
      $DOCKER_IMAGE_NAME `
      serve --watch --drafts --force_polling -H 0.0.0.0
    ```

    **Bash**

    Create a file named **preview.sh** and populate it with the following content.

    ```bash
    #!/usr/bin/env bash

    # Set to the name of the Docker machine you want to use
    DOCKER_MACHINE_NAME=default

    # Set to the name of the Docker image you want to use
    DOCKER_IMAGE_NAME=my-site

    # Stop on first error
    set -e

    # Create a Docker host
    if !(docker-machine ls | grep "^$DOCKER_MACHINE_NAME "); then
      docker-machine create --driver virtualbox $DOCKER_MACHINE_NAME
    fi

    # Start the host
    if (docker-machine ls | grep "^$DOCKER_MACHINE_NAME .* Stopped"); then
      docker-machine start $DOCKER_MACHINE_NAME
    fi

    # Load your Docker host's environment variables
    eval $(docker-machine env $DOCKER_MACHINE_NAME)

    if [ -e Dockerfile ]; then
      # Build a custom Docker image that has custom Jekyll plug-ins installed
      docker build --tag $DOCKER_IMAGE_NAME --file Dockerfile .

      # Remove dangling images from previous runs
      docker rmi -f $(docker images --filter "dangling=true" -q) > /dev/null 2>&1 || true
    else
      # Use an existing Jekyll Docker image
      DOCKER_IMAGE_NAME=grahamc/jekyll
    fi

    echo "***********************************************************"
    echo "  Your site will be available at http://$(docker-machine ip $DOCKER_MACHINE_NAME):4000"
    echo "***********************************************************"

    # Start Jekyll and watch for changes
    docker run --rm \
      --volume=/$(pwd):/src \
      --publish 4000:4000 \
      $DOCKER_IMAGE_NAME \
      serve --watch --drafts --force_polling -H 0.0.0.0
    ```

4. If you created **preview.sh** by using Bash, mark it as executable by running the following command:

    ```bash
    $ chmod +x preview.sh
    ```

5. Execute the preview script to start Jekyll. You can also double-click on the
    script from Windows Explorer.

    **CMD**

    ```batch
    > powershell.exe -f preview.ps1
    ```

    **PowerShell**

    ```powershell
    > .\preview.ps1
    ```

    **Bash**

    ```bash
    $ ./preview.sh
    ```

6. In a web browser, navigate to the URL specified in the output.
    The following is an example of the output:

    ```
    ***********************************************************
      Your site will be available at http://192.168.99.100:4000
    ***********************************************************
    Configuration file: /src/_config.yml
                Source: /src
           Destination: /src/_site
          Generating...
                        done.
     Auto-regeneration: enabled for / src
    Configuration file: /src/_config.yml
        Server address: http://0.0.0.0:4000/
      Server running... press ctrl+c to stop.
    ```
<br/>

You can now modify your site and preview the changes.
After you save a file, it will be automatically regenerated by Jekyll.
Refresh the page in your web browser to see your changes.

[jekyll-image]: https://hub.docker.com/r/grahamc/jekyll/

## Troubleshooting
You might encounter the following issues when running the preview script.

* <a name="troubleshooting-stop-jekyll"></a>Ctrl + C does not stop Jekyll

PowerShell sometimes doesn't catch **Ctrl + C** the first time; pressing
the key combination twice in quick succession usually works.

* <a name="troubleshooting-missing-config"></a> The \_config.yml file is not picked up by Jekyll

If you see the following output where the configuration file is listed as `none`,
the most likely cause is that the [Docker data volume][docker-volume], which exposes the Jekyll site on your local file
system to the Docker container, is configured incorrectly.

```text
Configuration file: none
            Source: /src
       Destination: /src/_site
      Generating...
```

Verify that the Jekyll site is located in a directory that is exposed via VirtualBox shared folders, for example, **C:\Users**.
See the [Prerequisites](#prerequisites) section for additional information.

[docker-volume]: https://docs.docker.com/userguide/dockervolumes/

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Jekyll documentation](https://jekyllrb.com/docs/home/)
* [Using Jekyll with GitHub Pages](https://jekyllrb.com/docs/github-pages/)

### Next

For further information on how to get up and running with Carina, read [Getting started with Docker Swarm]({{ site.baseurl }}/docs/getting-started/create-swarm-cluster/).
