---
title: Getting started with ASP.NET on Carina with Visual Studio
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-02-12
permalink: docs/getting-started/aspnet-on-carina-with-visual-studio/
description: Learn how to publish an ASP.NET website to Carina with Visual Studio
docker-versions:
  - 1.10.1
topics:
  - docker
  - windows
---

The upcoming version of ASP.NET is a major evolution of the .NET platform.
The name churn alone hints at its complete redesign: first ASP.NET vNext, then ASP.NET 5,
and now ASP.NET Core 1.0. One very welcome feature is official cross-platform
support, enabling you to develop on Windows with Visual Studio and deploy
to Linux. If you are most familiar with the Microsoft stack, a great way to get started
is to develop your website just as you do today and publish directly to Carina
with Visual Studio, where deploying to Docker containers is just a wizard away.

This tutorial describes how to publish an ASP.NET website to Carina with Visual Studio.

![Carina and Visual Studio]({% asset_path publish-aspnet-to-carina-with-visual-studio/carina-and-visual-studio.png %})

### Prerequisites

1. [Create and connect to a cluster](/docs/getting-started/create-connect-cluster/)
1. [Install Visual Studio 2015](https://www.visualstudio.com/downloads/download-visual-studio-vs)
1. [Install Microsoft ASP.NET and Web Tools 2015 Release Candidate](https://www.microsoft.com/en-us/download/details.aspx?id=49959)
1. [Install Visual Studio Tools for Docker Preview](https://visualstudiogallery.msdn.microsoft.com/0f5b2caa-ea00-41c8-b8a2-058c7da0b3e4)

**Note**: The upcoming version of ASP.NET is still under development and has not
been officially released. The preceding links are for the current prerelease installers,
which will change when the final release is available. If you have earlier
versions installed, uninstall them in reverse order, and then install the latest
versions in the order listed. If you install them out of order, run the
repair mode for each installer in the order listed.

### Create an ASP.NET website

1. Open Visual Studio, and then select **File > New > Project**.

1. In the New Project dialog box, select **Templates > Visual C# > Web** from the
    navigation pane, and then select **ASP.NET Web Application**.

    ![New Project dialog]({% asset_path publish-aspnet-to-carina-with-visual-studio/new-project.png %})

1. In the New ASP.NET Project dialog box, under **ASP.NET 5 Templates**, select
    **Web Application**. Then, click **OK**.

    ![New Web Application dialog]({% asset_path publish-aspnet-to-carina-with-visual-studio/new-webapp.png %})

1. To preview the site, select **Debug > Start Debugging** from the menu bar.
    A new browser window should open, and you should see a website with the ASP.NET banner.

    ![ASP.NET Banner]({% asset_path publish-aspnet-to-carina-with-visual-studio/aspnet-screenshot.png %})

    You now have an ASP.NET website, which is currently hosted by IIS Express.
    When the site is published to a Docker container on Carina, it can't be hosted with
    IIS because the container operating system is Linux. Instead, the site is hosted
    with a new cross-platform web server, Kestrel.

1. To preview the website with Kestrel, click the **Debug** drop down and change the command from
    IIS Express to web.

    ![Debug with web command]({% asset_path publish-aspnet-to-carina-with-visual-studio/debug-host.png %})

    Now when you preview the site, a terminal opens and displays a message from
    Kestrel with the website URL.

1. Open [http://localhost:5000](http://localhost:5000) in a web browser to view the site.

    ```
    Now listening on: http://localhost:5000
    Application started. Press Ctrl+C to shut down.
    ```

### Publish your ASP.NET website with Visual Studio
Now that you have an ASP.NET website working locally, use Visual Studio's
publish functionality to deploy the website to a Docker container on Carina.

1. If you have not done so already, [create and connect to a cluster](/docs/getting-started/create-connect-cluster/).

1. Locate your credentials on the file system, and then open **docker.cmd**.

1. Copy the value of the `DOCKER_HOST` variable and save it for later. In the following example,
    the value to save is `tcp://172.99.73.31:2376`. The `DOCKER_HOST` value
    is unique to each cluster.

    ```
    set DOCKER_HOST=tcp://172.99.73.31:2376
    set DOCKER_TLS_VERIFY=1
    set DOCKER_CERT_PATH=%~dp0

    set DOCKER_VERSION=1.10.1
    ```

1. From the Solution Explorer, right-click on the project and select **Publish**.

1. In the Publish Web dialog box, click on **Docker Containers**.

    ![Publish to Docker container]({% asset_path publish-aspnet-to-carina-with-visual-studio/publish-to-docker.png %})

1. In the Select Docker Virtual Machine pop-up dialog box, select the
    **Custom Docker Host** check box, and then click **OK**.

    ![Custom Docker Host]({% asset_path publish-aspnet-to-carina-with-visual-studio/publish-to-custom-docker-host.png %})

1. In the Publish Web dialog box, enter your Carina cluster connection information:
    * Set **Server Url** to the `DOCKER_HOST` value that you saved in step 3.
    * Set **Image Name** to `aspnet-demo`.
    * Set **Host Port** to `80` and **Container Port** to `5000`.
    * Expand the **Docker Advanced Options** section, and then set **Auth Options** to
      the following value, replacing `<credentialsPath>` with the file path to
      your cluster credentials that you located in step 2.

      ```
      --tls --tlscert=<credentialsPath>\cert.pem --tlskey=<credentialsPath>\key.pem
      ```

      ![Docker Settings]({% asset_path publish-aspnet-to-carina-with-visual-studio/publish-settings.png %})

1. Click **Validate Connection** to test that the credentials were entered
    correctly, and then click the Publish button.

The first time that the website is published takes a few minutes. When the website
is successfully deployed, a web browser opens and you should see the
same site published to Carina that you previewed locally.

### Publish your ASP.NET website from the command line
After publishing your website with Visual Studio, the following configuration files and scripts
are generated:

  * Dockerfile: Specifies the instructions that Docker should use to build a container for
    the website.
  * Properties\PublishProfiles:
    * CustomDockerProfile.pubxml: Defines the publish settings, such as the `DOCKER_HOST`.
    * CustomDockerProfile-publish.ps1: A PowerShell script that publishes the website.
    * CustomDockerProfile-publish.sh: A Bash script that publishes the website.

You can use them as a starting point to customize your deployment and trigger it programmatically.

1. Open PowerShell and change to your project directory.

1. Update the `PATH` to include the tools used when publishing the website, such as grunt, bower, and gulp,
    by running the following command:

    ```powershell
    $env:PATH+=";$pwd\node_modules\.bin;$env:VS140COMNTOOLS\..\IDE\Extensions\Microsoft\Web Tools\External"
    ```

1. Prepare the website for publishing by running the following commands:

    ```powershell
    $outDir = "$env:TEMP\PublishTemp\demo"
    if(test-path $outDir) { rm -r $outDir }
    dnu publish --out $outDir
    ```

1. Publish the website to Carina using the script generated by Visual Studio by
    running the following command:

    ```
    .\Properties\PublishProfiles\CustomDockerProfile-publish.ps1 -packOutput $outDir -pubxmlFile .\Properties\PublishProfiles\CustomDockerProfile.pubxml
    ```

### Troubleshooting

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

You might encounter the following issues when publishing:

* The generated website fails to build because of missing dependencies or because a Dockerfile is not generated.

    This issue can be caused by developing on a non-local drive, such as a file share
    or drive mount. Create a new project and save it to the local system drive.

* `AspnetPublishHandler with name "Custom" was not found`
    1. Run the ASP.NET installer and repair the installation.
    1. Delete the PublishingProfile directory in the project.
    1. Run the Publish wizard again.

* `The specified path, file name,
  or both are too long` or `Unable to prepare context: unable to evaluate symlinks
  in Dockerfile path: GetFileAttributesEx`

    Ensure that the `--out` parameter is specified. It must be a relatively
    short path to work around Windows file path limits, and cannot be a subdirectory
    of the project directory.

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Next step
Now that you have a next generation ASP.NET website published to Carina
using Visual Studio, the next tutorial [Publish an ASP.NET website to Carina][publish-aspnet-to-carina]
shows you how to build and publish an ASP.NET website to Carina without Visual Studio, or even Windows.

### Resources

[Learn more about ASP.NET](https://get.asp.net/)

[publish-aspnet-to-carina]: {{site.baseurl}}/docs/tutorials/publish-aspnet-to-carina/
