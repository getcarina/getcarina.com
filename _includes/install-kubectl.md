To download and install the Kubernetes client (`kubectl`), use the appropriate instructions for your operating system.

#### Mac OS X with Homebrew

Open a terminal, and then run the following commands:

```bash
$ brew update
$ brew install kubectl
```

#### Mac OS X without Homebrew

Open a terminal, and then run the following commands:

```bash
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/darwin/amd64/kubectl
$ chmod u+x kubectl
$ mv kubectl ~/bin/kubectl
```

#### Linux

Open a terminal, and then run the following commands:

```bash
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/linux/amd64/kubectl
$ chmod u+x kubectl
$ mv kubectl ~/bin/kubectl
```

#### Windows
Open PowerShell, and then run the following commands:

```powershell
> (New-Object System.Net.WebClient).DownloadFile("https://storage.googleapis.com/kubernetes-release/release/v1.4.5/bin/windows/amd64/kubectl.exe", "$pwd\kubectl.exe")
> mkdir  ~\.kube
```

Then move `kubectl.exe` to a directory on your `%PATH%`.
