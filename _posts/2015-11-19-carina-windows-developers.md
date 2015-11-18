---
title: "Carina for .NET developers"
date: 2015-11-18 23:59
comments: true
author: Don Schenck <don.schenck@rackspace.com>
authorIsRacker: true
authorAvatar: https://secure.gravatar.com/avatar/f54aa14aef60a23e27147afdedf0501d
published: true
categories:
    - Carina
    - Docker
    - Windows
---
# Introducing Carina for .NET developers
I remember hearing about containers, and Docker in particular, in mid-2014. As a veteran .NET developer with little exposure outside of my Microsoft-centric world, I was curious: Would this technology affect me? How can I learn about it? How can I play around with it?

Then, last November, Microsoft announced that the full server-side .NET stack was being released as open source software. Overnight, a new world opened up to me, including -- and I never thought I'd say this -- .NET code running on Linux.

Containers and Docker suddenly became a Real Thing to me. When Rackspace announced Carina in late October, the journey to the gate of Containerland was complete; now all I needed to do was find the key that unlocked the door and walk through.

<!-- more -->

## Understanding containers

A container is like a Virtual Machine (VM) minus the operating system/kernel. It uses the host instead of packaging and running its own, so there's much less overhead. It's like a tiny, preconfigured server that runs in it's own space.

## Get Carina

Carina by Rackspace is the master key that allows you to quickly get up to speed with Docker, see what containers are all about, and begin *now* to expand your experience. Trends such as *The 12-Factor App* and *microservices* can be explored and implemented without wasting time with minutiae.

Containers need a place to run. If you're running Docker -- a specific implementation of the containers concept -- on your local machine, you use Virtual Box as your Docker Host.

With Carina, you don't need to run Virtual Box on your local machine. Instead of using your CPU cycles, Carina runs on Rackspace bare metal, meaning it's fast to start and run. You can use your Carina clusters (your Docker hosts in Carina) from any client; Mac, Linux or Windows. Let's look at a Windows setup.

## Carina in four steps
There are only four steps to get rolling:  

1. Create a Carina cluster.
2. Prepare you local machine's environment.
3. Get the Docker client on your local machine.
4. Start one or more containers in your cluster.

### Create a Carina cluster
To create a cluster, simply log in to [GetCarina.com](https://getcarina.com)</a> (if you don't have an account, creating one is a cinch -- an email address and password and you're in), click the 'Add Cluster...'' link, give the cluster a name, and click the 'Create Cluster' button. It is literally that easy.

![Create Cluster]({% asset_path 2015-11-19-carina-windows-developers/create_cluster_loop.gif %})

### Prepare you local machine's environment

Download the zip file associated with the cluster and unzip it. Inside, you'll find both a command-line script (docker.cmd) and a PowerShell script (docker.ps1). A peek inside the PowerShell script reveals code that will set your system's environment variables to use your Carina cluster to host your Docker containers rather than your local machine:

![docker.ps1 contents]({% asset_path 2015-11-19-carina-windows-developers/docker_ps1_content.png %})

The `DOCKER_HOST` line tells your Docker client to use your Carina cluster instead of your local machine to run your containers.

### Get the Docker client for your local machine

When Microsoft announced support for Docker, arguably the biggest part was a Docker client that runs in Windows. The Docker client must match the version expected by the Docker host, in our case that's Carina. Viewing the contents of the docker.ps1 file, above, we can see that our cluster expects a client version of 1.9.0.

Rackspace developed the Docker Version Manager (dvm) to facilitate this requirement, make it easy to avoid mismatches, and easily switch between clients. One simple command, `dvm use`, makes sure you're ready to go.

Download and install dvm using a one-line PowerShell command, then follow the instructions displayed.

```
iex (wget https://download.getcarina.com/dvm/latest/install.ps1)

```
For example:

![Install dvm on Windows]({% asset_path 2015-11-19-carina-windows-developers/windows_dvm_install.png %})

The following PowerShell script will check to see if you have a profile and will create one if you don't have one:

```
If (!(Test-Path $profile)) {
    New-Item $profile -ItemType File -Force
}
```

Then, open another PowerShell window to edit your profile and add the `. C:\Users\<<username>>\.dvm\dvm.ps1` command:

```
powershell_ise.exe $profile
```

### Setup is finished

From this moment forward, when you want to use Carina, you simply open PowerShell, navigate to the folder containing your Carina credentials, and run the `dvm use` command. Here's an example:

![dvm in action]({% asset_path 2015-11-19-carina-windows-developers/windows_dvm_use_in_action.png %})

## What Next?

### Running MySQL and Wordpress

Get something running ... now. Right now. The Carina documentation has instructions for running <a href="https://getcarina.com/docs/tutorials/wordpress-apache-mysql/">MySQL and Wordpress in Docker containers</a>.

### ASP.NET in a container

Microsoft will soon be delivering the final version of the ASP.NET Docker container, allowing you to run your ASP.NET web sites inside a Docker container, running on top of the Linux kernel. It's a brave new world. If you're anxious to get started (remember, it's a beta and may change), consider the ramifications of the following:

```
docker run -d -t microsoft/aspnet
```

Carina allows you to get started today, *now*, with container technology. It works with Windows as well as Mac and Linux; get signed up and start your journey to the future today.
