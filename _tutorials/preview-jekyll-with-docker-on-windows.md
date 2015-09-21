---
title: Preview a Jekyll Site with Docker on Windows
permalink: docs/tutorials/preview-jekyll-with-docker-on-windows/
topics:
  - docker
  - intermediate
  - windows
---

*Note: This tutorial is for Windows users. If you are using Mac OS X or Linux, follow
[this tutorial]({{ site.baseurl }}/docs/tutorials/preview-jekyll-with-docker) instead.*

[Jekyll][jekyll] is a popular static site generator, most commonly used for blogging on GitHub Pages.
It is written in ruby and sometimes getting your local machine setup properly to preview your
changes before publishing can be difficult, especially on Windows.

This tutorial describes how to preview a Jekyll site in a Docker container, so that
you do not need to install ruby or Jekyll on your local machine.

[jekyll]: https://jekyllrb.com/

## <a name="prerequisites"></a> Prerequisites
* [Docker Toolbox][docker-toolbox]
* An existing Jekyll site on your local file system. If you do not have
  an existing site, a good way to get jump started is download the
  [Jekyll Example Project][jekyll-example] or a [Jekyll theme][jekyll-themes].

_You must place your site in a sub-directory of `C:\Users`,
  though it can be more deeply nested, e.g. `C:\Users\myuser\repos\my-site`.
  That is the only directory exposed from your local machine
  to the Docker host via VirtualBox. If you want to use a different directory, you will
  need to manually share the directory using VirtualBox._

[docker-toolbox]: https://www.docker.com/toolbox
[jekyll-example]: https://github.com/jekyll/example
[jekyll-themes]: https://github.com/jekyll/jekyll/wiki/Themes

## <a name="steps"></a> Steps

1. Open a command terminal and change to your Jekyll site directory.

2. Create a new file named `Dockerfile` with the content below.
    *If you are using GitHub Pages or are not using any Jekyll plugins,
    you do not need to a custom Docker image and should skip to the next step.*

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

3. Create a script from the options below with your preferred scripting language.
    You may want to customize the `DOCKER_MACHINE_NAME` and `DOCKER_IMAGE_NAME`
    variables defined at the top of the file.

    **PowerShell**

    Create a file named `preview.ps1` with the content below.

    ```powershell
    # Set to the name of the docker machine you would like to use
    $DOCKER_MACHINE_NAME='default'

    # Set to the name of the docker image you would like to use
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
      # Build a custom Docker image which has custom Jekyll plugins installed
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

    # Translate our current directory into the file share mounted in the docker host
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

    Create a file named `preview.sh` with the context below. Then mark it as executable by running `chmod +x preview.sh`.

    ```bash
    #!/usr/bin/env bash

    # Set to the name of the docker machine you would like to use
    DOCKER_MACHINE_NAME=default

    # Set to the name of the docker image you would like to use
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

    # Load our docker host's environment variables
    eval $(docker-machine env $DOCKER_MACHINE_NAME)

    if [ -e Dockerfile ]; then
      # Build a custom Docker image which has custom Jekyll plugins installed
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

4. Execute the preview script to start Jekyll. You can also double-click on the
    script from Windows Explorer.

    **CMD**

    ```batch
    powershell.exe -f preview.ps1
    ```

    **PowerShell**

    ```powershell
    .\preview.ps1
    ```

    **Bash**

    ```bash
    ./preview.sh
    ```

6. In a web browser, navigate to the URL specified in the output (example below).

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

You are now ready to modify your site and preview the changes.
After saving a file, it will be automatically regenerated by Jekyll.
Refresh the page in your web browser to see your changes.

[jekyll-image]: https://hub.docker.com/r/grahamc/jekyll/

## <a name="troubleshooting"></a>Troubleshooting

### <a name="troubleshooting-stop-jekyll"></a>CTRL+C does not stop Jekyll

PowerShell sometimes doesn't catch `CTRL` + `C` the first time. However pressing that key combination in quick succession usually works.

### <a name="troubleshooting-missing-config"></a> \_config.yml file is not picked up by Jekyll
If you see output like that below with `Configuration file: none`,
the most likely cause is that the [Docker data volume][docker-volume], which exposes the Jekyll site on your local file
system to the Docker container, is configured incorrectly.

```text
Configuration file: none
            Source: /src
       Destination: /src/_site
      Generating...
```

Verify that the Jekyll site is located in a directory which is exposed via VirtualBox shared folders, e.g. `C:\Users`.
See the [Prerequisites](#prerequisites) for additional information.

[docker-volume]: https://docs.docker.com/userguide/dockervolumes/

## <a name="resources"></a>Resources

* [Jekyll Documentation](https://jekyllrb.com/docs/home/)
* [Using Jekyll with GitHub Pages](https://jekyllrb.com/docs/github-pages/)
