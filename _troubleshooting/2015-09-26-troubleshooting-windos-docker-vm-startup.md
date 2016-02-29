---
title: Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2015-09-26
permalink: docs/troubleshooting/troubleshooting-windows-docker-vm-startup/
description: Solve issues that can occur when you download and set up Docker Toolbox on Windows versions 7, 8.1, and 10
docker-versions:
  -1.8.1
  -1.8.2
  -1.9.0
  -1.10.2
topics:
  -docker
  -troubleshooting
  -tutorial
---

This article provides solutions for some of the issues that can occur when you download and set up Docker Toolbox on Windows versions 7, 8.1, and 10.

### Conflicts with existing applications

The toolbox comes with its own VirtualBox and Git Bash versions. As such, existing installations of Git for Windows, other Bash versions, or VirtualBox (especially if the system PATH was modified for them) can potentially cause issues.

To resolve these issues, perform the following steps:

1. Remove your own Bash versions (such as Cygwin, MinGW, GitHub for Windows, or babun) from the system PATH.
2. Uninstall VirtualBox.
3. Restart Windows.
4. Reinstall Docker Toolbox, which reinstalls VirtualBox and Git for Windows with Git Bash.
5. Before starting the Docker Quickstart Terminal, ensure that files with **.sh** extensions are associated with the newly installed Git for Windows.

![Script Association Menu]({% asset_path 002-troubleshooting-windos-docker-vm-startup/StartScriptAssociationMenu.png %})

![Script Association]({% asset_path 002-troubleshooting-windos-docker-vm-startup/StartScriptAssociation.png %})

### Issues with the Docker Toolbox setup

The first time that you run the Docker Quickstart Terminal after installation, the process of creating the first Docker virtual machine (called `default`) might stop responding at `Starting VM`.

```
Creating VirtualBox VM...
Creating SSH key...
Starting VirtualBox VM...
Starting VM...
```

The process either eventually succeeds or returns an error, as follows:

```
Starting VM...
Error creating machine: Maximum number of retries (6) exceeded
You will want to check the provider to make sure the machine and associated resources were properly removed.
Looks like something went wrong... Press any key to continue...
```

To troubleshoot this error, open the VirtualBox Manager. The left navigation pane displays the name of the VM and its state. Verify that the VM state is **Running**. You can right-click the VM name and select **Show** to see the VM output and ensure that there are no errors. If the VM is running properly, the Bash command prompt is displayed, as shown in the following screenshot:

![Docker VM Output]({% asset_path 002-troubleshooting-windos-docker-vm-startup/DockerVMSuccessfullyStarted.png %})

If the machine is running properly, then there was a problem with the Docker Toolbox setup. To resolve that problem, follow these steps:

1. In VirtualBox, stop and delete the Docker default VM.
2. Delete the **.docker** folder in your user folder (at **c:\\Users\\*username*\\.docker**).
3. Restart your computer.
4. Open the Docker Quickstart Terminal.

Everything should be downloaded and set up properly.

### Issue with nested virtualization

The Docker Toolbox is running a virtual machine (VM). You cannot install and run the Docker Toolbox on a VM that does not pass the VT-X extensions.

If the VM does not pass the VT-X extensions, when you run `docker-machine` commands, you will see a message similar to the following one:

```
Post http://127.0.0.1:2375/v1.20/containers/create: dial tcp 127.0.0.1:2375: ConnectEx tcp: No connection could be made because the target machine actively refused it..
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

This message indicates that your Docker VM was not able to start properly. It might also indicate  an issue with the environment not being set properly (see the next section).

You can open the VirtualBox Manager and check the VM status. Even if it displays as **Running**, you can open the VM (right-click the name and select **Show**) to see if there are any error messages. In this case, you would see that the virtualization extensions have not been passed by VirtualBox to the Docker VM.

![Docker VM Output]({% asset_path 002-troubleshooting-windos-docker-vm-startup/MissingVTX.png %})

### Environment not set up properly

When you open a fresh command prompt different from the Docker Quickstart Terminal, it might not initialize properly.

Run the following command:

`$ docker-machine env <environment> --shell <shellName>`

Then, execute the output.

For more information, see [Error running interactive Docker shell on Windows]({{ site.baseurl }}/docs/troubleshooting/troubleshooting-cannot-enable-tty-mode-on-windows/).
