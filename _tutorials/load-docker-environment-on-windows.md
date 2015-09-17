---
title: Load a Docker environment from the command line on Windows
permalink: docs/tutorials/load-docker-environment-on-windows/
topics:
  - docker
  - windows
  - beginner
---

This tutorial describes how to load a Docker environment on Windows, so that you can work
with Docker with the terminal and shell of your choice. For the purpose of this
tutorial, the term **shell** refers to a command line interpreter which executes
text commands and **terminal** is the graphical window which hosts a shell.

* [Shells](#shells)
  * [CMD](#cmd)
  * [PowerShell](#powershell)
  * [Bash](#bash)
* [Terminals](#terminals)
  * [Windows Command Prompt](#cmd-prompt)
  * [MinTTY](#mintty)
  * [Alternatives](#alternatives)

## <a name="shells"></a> Shells
After installing Docker Toolbox on Windows, you have three shells available for
interacting with Docker: CMD, PowerShell, and Bash. Although each shell provides
different commands and syntax, all are capable of interacting with Docker.

* [CMD](#cmd)
* [PowerShell](#powershell)
* [Bash](#bash)

### <a name="cmd"></a> CMD
[CMD][cmd-doc] is the standard Windows shell.

<!-- TODO: Include instructions for using Ansicon to support the colors that docker and linux may emit -->

1. Run `cmd.exe`.
2. Load your docker host environment variables
  * If you are using the Rackspace Container Service, follow the instructions on [Working with Your Cluster Credentials][get-cluster-creds]
    to download your credentials. Then run the `docker.cmd` script.
  * Otherwise, run `docker-machine env default --shell cmd`, replacing `default`
    with the name of your Docker environment. Copy the command output, then paste it into the command line.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[cmd-doc]: http://ss64.com/nt/syntax.html
<!-- TODO: REPLACE WITH REAL URL -->
[get-cluster-creds]: http://todo

### <a name="powershell"></a> PowerShell
[PowerShell][powershell-doc] is built on top Microsoft .NET and was designed to
work with .NET objects instead of raw text. It is distributed with all versions of Windows supported by Docker.

1. Run `powershell.exe`.
2. Load your docker host environment variables
  * If you are using the Rackspace Container Service, follow the instructions on [Working with Your Cluster Credentials][get-cluster-creds]
    to download your credentials. Then run the `docker.ps1` script.
  * Otherwise, run `docker-machine env default --shell powershell | Invoke-Expression`,
    replacing `default` with the name of your Docker environment.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[powershell-doc]: https://technet.microsoft.com/en-us/library/ms714469.aspx

### <a name="bash"></a> Bash
[Bash][bash-doc] is a Unix shell, installed with [Git for Windows][git-for-windows],
which is included with Docker Toolbox.

_NOTE: Even when running on Windows, Bash uses Unix paths instead of Windows paths,
e.g. `/C/Users/Bob` vs. `C:\Users\Bob`, and is case-sensitive._

1. Open the Git Bash application either from the Start Screen, or by right clicking
    in a directory from Windows Explorer and selecting **Git Bash Here**. The underlying
    shell executable is located at `C:\Program Files\Git\bin\bash.exe` and is called
    with the `--login -i` arguments.
2. Load your docker host environment variables
  * If you are using the Rackspace Container Service, follow the instructions on [Working with Your Cluster Credentials][get-cluster-creds]
    to download your credentials. Then run `source docker.env`.
  * Otherwise, run `eval $(docker-machine env default --shell bash)`,
    replacing `default` with the name of your Docker environment.
3. Verify that your Docker environment was initialized properly by running `docker version`.

[git-for-windows]: https://git-for-windows.github.io
[bash-doc]: http://www.gnu.org/software/bash/manual/bash.html

## <a name="terminals"></a> Terminals
After installing Docker Toolbox on Windows, you have two terminals available:
Windows Command Prompt and MinTTY.

* [Windows Command Prompt](#cmd-prompt)
* [MinTTY](#mintty)
* [Alternatives](#alternatives)

### <a name="cmd-prompt"></a> Windows Command Prompt
This is the standard Windows terminal. By default all console applications, including cmd.exe,
are hosted in the Windows Command Prompt. It isn't very customizable and
features that should simply work out of the box, such as copy/paste, are awkward to use.

![Windows Command Prompt Screenshot]({% asset_path load-docker-environment-on-windows/cmd.png %})

### <a name="mintty"></a> MinTTY
[MinTTY][mintty] the terminal used by the Git Bash application, installed with [Git for Windows][git-for-windows],
which is included with Docker Toolbox. It is simple to configure, though it lacks
the advanced settings that other terminals provide, and with it you can:

* Resize or maximize the window.
* Copy text by highlighting it with your mouse.
* Paste text by pressing the `SHIFT` + `INSERT` keys. You may optionally
  configure it to paste when you perform a right mouse click.<br/>
  ![Options &rarr; Mouse &rarr; Right click action &rarr; Paste]({% asset_path load-docker-environment-on-windows/gitbash-paste-on-right-click.png %})

The initial shell used when running Git Bash is [Bash](#bash), which will be familiar
to Linux or Mac OS X users. To take advantage of the MinTTY terminal and also continue using CMD or PowerShell,
open Git Bash and then run `cmd.exe` or `powershell.exe` and follow the steps
in the corresponding sections above to setup your Docker environment.

![Git Bash Screenshot]({% asset_path load-docker-environment-on-windows/gitbash.png %})

[mintty]: https://mintty.github.io
## <a name="alternatives"></a>Alternatives
There are alternative terminals which provide useful features such as improved copy/paste,
window resizing and tabs. Overall they are much more customizable than the standard
Windows terminal used by CMD and PowerShell.

* [ConsoleZ][consolez]
* [ConEmu][conemu]

## <a name="consolez"></a> ConsoleZ
[ConsoleZ][consolez] is a terminal emulator which can be used with any shell.

1. Download ConsoleZ.
2. There is no installer, so unzip the files to any location such as `C:\Program Files\ConsoleZ`.
3. Open `console.exe`.

[consolez]: https://github.com/cbucher/console/wiki

## <a name="conemu"></a> ConEmu
[ConEmu][conemu], short for Console Emulator, is a terminal emulator which can be used with any shell.

[conemu]: https://conemu.github.io/

### A Note on Git
<!-- TODO: Not sure where this should live, it seems like good information but perhaps it belongs in Docker for Windows or somewhere else -->
The default installation of [Git for Windows][git-for-windows], which is included with Docker Toolbox,
does not add git commands to your PATH as they are not strictly needed for Docker.
In order to use git, you must either:

* Use the Git Bash terminal.
* Specify the full path to the git executable, e.g. `"C:\Program Files\Git\bin\git.exe"`.
* Add `C:\Program Files\Git\cmd` to your PATH.

## <a name="references"></a> References
* [CMD Syntax][cmd-doc]
