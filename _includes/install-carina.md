To download and install the Carina client, use the appropriate instructions for your operating system.

#### Linux and Mac OS X

Open a terminal, and then run the following commands:

```bash
$ curl -L https://download.getcarina.com/carina/beta/$(uname -s)/$(uname -m)/carina -o carina
$ mv carina ~/bin/carina
$ chmod u+x ~/bin/carina
```

#### Windows

PowerShell performs the initial installation; you can use the `carina` CLI with PowerShell
or CMD after it is installed.

Open PowerShell, and then run the following command (for 64-bit systems):

```powershell
> iwr 'https://download.getcarina.com/carina/beta/Windows/x86_64/carina.exe' -OutFile carina.exe
```

Then, move `carina.exe` to a directory on your `%PATH%`.

**Note**: The download URL for 32-bit systems is `https://download.getcarina.com/carina/beta/Windows/i686/carina.exe`.

<!-- Uncomment when out of beta
#### Mac OS X with Homebrew

Open a terminal, and then run the following commands:

```bash
$ brew update
$ brew install carina
```

#### Linux and Mac OS X without Homebrew

Open a terminal, and then run the following commands:

```bash
$ curl -L https://download.getcarina.com/carina/latest/$(uname -s)/$(uname -m)/carina -o carina
$ mv carina ~/bin/carina
$ chmod u+x ~/bin/carina
```

#### Windows with Chocolatey

Open PowerShell, and then run the following command:

```powershell
> choco install carina
```

#### Windows without Chocolatey

PowerShell performs the initial installation; you can use the `carina` CLI with PowerShell
or CMD after it is installed.

Open PowerShell, and then run the following command (for 64-bit systems):

```powershell
> iwr 'https://download.getcarina.com/carina/latest/Windows/x86_64/carina.exe' -OutFile carina.exe
```

Then, move `carina.exe` to a directory on your `%PATH%`.

**Note**: The download URL for 32-bit systems is `https://download.getcarina.com/carina/latest/Windows/i686/carina.exe`.
-->
