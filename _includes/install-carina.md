### Install the Carina CLI
To download and install the Carina client, use the appropriate instructions for your operating system.

#### Mac OS X with Homebrew

If you're using [Homebrew](http://brew.sh/), open a terminal, and then run the following commands:

```bash
$ brew update
$ brew install carina
```

#### Linux and Mac OS X without Homebrew

Open a terminal and run the following command:

```bash
$ curl -L https://download.getcarina.com/carina/latest/$(uname -s)/$(uname -m)/carina -o carina
$ mv carina ~/bin/carina
$ chmod u+x ~/bin/carina
```

#### Windows with Chocolatey

If you're using [Chocolatey](http://chocolatey.org/), open PowerShell, and then run the following command:

```powershell
> choco install carina
```

#### Windows without Chocolatey

PowerShell performs the initial installation; you can use the `carina` CLI with PowerShell
or CMD after it is installed.

Open PowerShell and run the following command (for 64-bit systems):

```powershell
> iwr 'https://download.getcarina.com/carina/latest/Windows/x86_64/carina.exe' -OutFile carina.exe
```

**Note**: The download URL for 32-bit systems is `https://download.getcarina.com/carina/latest/Windows/i686/carina.exe`.

Then, move `carina.exe` to a directory on your `%PATH%`.

### Upgrade
If you installed the `carina` CLI with a package manager, use the appropriate upgrade command.
Otherwise, repeat the manual installation instructions in the preceding section.
