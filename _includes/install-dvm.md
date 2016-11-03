To download and install the Docker Version Manager (dvm), use the appropriate instructions for your operating system. Copy the command to load `dvm` from the output, and then paste and run them to finalize the installation.

#### Mac OS X with Homebrew

Open a terminal, and then run the following commands:

```bash
$ brew update
$ brew install dvm
```

#### Linux and Mac OS X without Homebrew

Open a terminal, and then run the following command:

```bash
$ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
```

#### Windows

PowerShell performs the initial installation; you can use dvm with PowerShell or
CMD after it is installed. Open a PowerShell command prompt and execute the following command:

```powershell
> iwr 'https://download.getcarina.com/dvm/latest/install.ps1' -UseBasicParsing | iex
```
