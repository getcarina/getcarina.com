### Install the Docker Version Manager (dvm).

On Linux and Mac OS X terminals, run the following command:

```bash
$ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
Downloading dvm.sh...
######################################################################## 100.0%
Downloading bash_completion
######################################################################## 100.0%
Downloading dvm-helper...
######################################################################## 100.0%

Docker Version Manager (dvm) has been installed to ~/.dvm
Run the following command to start using dvm. Then add it to your bash profile (e.g. ~/.bashrc or ~/.bash_profile) to complete the installation.

  source ~/.dvm/dvm.sh
```

On Windows PowerShell, run the following command:

```
> iex (wget https://download.getcarina.com/dvm/latest/install.ps1)
Downloading dvm.ps1...
Downloading dvm.cmd...
Downloading dvm-helper.exe...

Docker Version Manager (dvm) has been installed to $env:USERPROFILE\.dvm

PowerShell Users: Run the following command to start using dvm. Then add it to your PowerShell profile to complete the installation.
        . $env:USERPROFILE\.dvm\dvm.ps1

CMD Users: Run the first command to start using dvm. Then run the second command to add dvm to your PATH to complete the installation.
        1. PATH=%PATH%;%USERPROFILE%\.dvm
        2. setx PATH "%PATH%;%USERPROFILE%\.dvm"
```

1. Copy the commands from the output, and then paste and run them to finalize the installation.

1. Configure the Docker client.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ dvm use
    Now using Docker 1.11.1
    ```

    On Windows PowerShell, run the following commands:

    ```
    > dvm use
    Now using Docker 1.11.1
    ```

1. Use your credentials to interact with your cluster:

    ```bash
    $ docker info

    Containers: 6
    Images: 4
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 2
    1ca87d26-0d26-48cb-8a34-1b68ce124e6e-n1: 104.120.0.18:42376
     └ Containers: 3
     └ Reserved CPUs: 0 / 12
     └ Reserved Memory: 0 B / 4.2 GiB
     └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy)     (containerized), storagedriver=aufs
    4ca87d27-0d27-48cb-9a64-2b68ce124e6e-n2: 103.140.0.22:42376
     └ Containers: 3
     └ Reserved CPUs: 0 / 12
     └ Reserved Memory: 0 B / 4.2 GiB
     └ Labels: executiondriver=native-0.2, kernelversion=3.18.21-1-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
    CPUs: 24
    Total Memory: 8.4 GiB
    Name: a1bc2d3456e7
    ```

### Run your first application

Run a WordPress blog with a MySQL database on an overlay network.

1. Create a network to connect your containers.

    ```bash
    $ docker network create mynetwork
    ec98e17a760b82b5c0857e2e0d561019af67ef790170fac8413697d5ee183288
    ```

    The output of this `docker network create` command is your network ID.

1. Run a MySQL instance in a container. Give it a name and use **my-root-pw** as a password.

    ```bash
    $ docker run --detach --name mysql --net mynetwork --env MYSQL_ROOT_PASSWORD=my-root-pw mysql:5.6
    ab8ca480c46d10143217c0ee323f8420b6ab93737033c937c2f4dbf8578435bb
    ```

    The output of this `docker run` command is your running MySQL container ID.

1. Run a WordPress instance in a container. Give it a name, link it to the MySQL instance, and publish the internal port 80 to the external port 8080.

    ```bash
    $ docker run --detach --name wordpress --net mynetwork --publish 80:80 --env WORDPRESS_DB_HOST=mysql --env WORDPRESS_DB_PASSWORD=my-root-pw wordpress:4.4
    6770c91929409196976f5ad30631b0f2836cd3d888c39bb3e322e0f60ca7eb18
    ```

    The output of this `docker run` command is your running WordPress container ID.

1. Verify that your run was successful by viewing your running containers.

    ```bash
    $ docker ps -n=2
    CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                        NAMES
    6770c9192940        wordpress:4.4       "/entrypoint.sh apach"   About a minute ago   Up About a minute   104.130.0.124:80->80/tcp   57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress
    ab8ca480c46d        mysql:5.6           "/entrypoint.sh mysql"   6 minutes ago        Up 6 minutes        3306/tcp                     57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/mysql,57d513b9-ed36-487d-8415-4ac65b6d41a8-n1/wordpress/mysql
    ```

    The output of this `docker ps` command is your running containers.

1. View your WordPress site by running the following command and pasting the result into the address bar of a browser.

    ```bash
    $ docker port wordpress 80
    ```

    The output of this `docker port` command is the IP address and port that WordPress is using.

1. *(Optional)* Remove your WordPress site.

    If you aren't going to use your WordPress site, we recommend that you remove it. Doing so removes both your WordPress and MySQL containers. This will delete any data and any posts you've made in the WordPress site.

    ```bash
    $ docker rm --force --volumes wordpress mysql
    wordpress
    mysql
    ```

    The output of this `docker rm` command are the names of the WordPress and MySQL containers that you removed.

### Congratulations!

You've successfully run your first containerized application.

Carina has many more features and there is more to learn. Review the [Resources](#resources) and [Next step](#next-step) sections for more information.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [Docker 101]({{ site.baseurl }}/docs/concepts/docker-101/)
* [Docker Version Manager]({{ site.baseurl }}/docs/tutorials/docker-version-manager/)
* [Carina documentation]({{ site.baseurl }}/docs/)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)
