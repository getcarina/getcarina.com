---
title: Troubleshooting the Docker Toolbox setup on Windows 7, 8.1, and 10
seo:
  description: Docker Toolbox, Windows troubleshooting
---

 
Issues with existing applications 
===

The toolbox comes with its own VirtualBox and Git Bash versions. As such, existing installations of either git or VirtualBox on Windows (especially if the system PATH was modified for them) can potentially cause issues.

Solution: Remove your own bash versions (such as cygwin, mingw, git for windows, babun) from PATH. Uninstall VirtualBox. Restart Windows. Re-install the Docker Toolbox, which will install VirtualBox.

Before starting the Docker Quickstart Terminal, ensure files with sh extensions are associated to the newly installed git-bash, as the terminal will open start.sh with the default application associated with .sh

![Script Association Menu]({% asset_path 002-troubleshooting-windos-docker-vm-startup/StartScriptAssociationMenu.png %})

![Script Association]({% asset_path 002-troubleshooting-windos-docker-vm-startup/StartScriptAssociation.png %})

Issues with the Docker Toolbox install
===

In some cases, the Docker Quickstart Terminal will fail and hang while "Starting VM" for the first time after setup.

![Stuck Starting VM]({% asset_path 002-troubleshooting-windos-docker-vm-startup/StuckStartingVM.png %})

This either succeeds or eventually turns into

![VM Timing Out]({% asset_path 002-troubleshooting-windos-docker-vm-startup/DockerVMTimeout.png %})

Open VirtualBox and make sure the virtual machine is running. You can "Show" the virtual machine output to make sure there are no errors. If the machine is running properly (it displays the bash command prompt), there was a problem with the Docker Toolbox setup.

![Docker VM Output]({% asset_path 002-troubleshooting-windos-docker-vm-startup/DockerVMSuccessfullyStarted.png %})

Stop and delete the VirtualBox Docker "default" virtual machine, then delete you .docker folder in your user folder (c:\Users\[username]\.docker).

Restart your machine, then start the Docker Quickstart Terminal. Everything should be re-downloaded and setup properly.

Issues with nested virtualization
===

The Docker Toolbox is running a virtual machine. You cannot install and run the Docker Toolbox on a virtual machine that does not pass the VT-X extensions. 

If that is the case, when running docker-machine commands, you will see a message similar to:

```
Post http://127.0.0.1:2375/v1.20/containers/create: dial tcp 127.0.0.1:2375: ConnectEx tcp: No connection could be made because the target machine actively refused it..
* Are you trying to connect to a TLS-enabled daemon without TLS?
* Is your docker daemon up and running?
```

This only indicates that your VirtualBox virtual machine has not been able to start properly. It may also indicate an issue with not setting the environment properly (see below). You can start the VirtualBox UI and check the machine status. Even if it displays as running, you can open the VM (Show) to see if there are any error messages. In this case, you would see that the virtualization extensions have not been passed by VirtualBox to the Docker VM.

![Docker VM Output]({% asset_path 002-troubleshooting-windos-docker-vm-startup/MissingVTX.png %})

Issues with not setting the environment
===

When opening a fresh command prompt different from the Docker Quickstart Terminal, it will not be initialized properly. Run docker-machine env {environment} --shell {shell name} and executing the output. For more information, see [this article](/docs/references/troubleshooting-cannot-enable-tty-mode-on-windows).