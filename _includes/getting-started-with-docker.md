### Install the Docker Version Manager

1. Install the Docker Version Manager (dvm)

    On Mac OS X with Homebrew, run the following commands:

    ```bash
    $ brew update
    $ brew install dvm
    ```

    On Linux and Mac OS X terminals, run the following command:

    ```bash
    $ curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh
    ```

    On Windows PowerShell, run the following command:

    ```powershell
    > iwr 'https://download.getcarina.com/dvm/latest/install.ps1' -UseBasicParsing | iex
    ```

1. Copy the commands from the output, and then paste and run them to finalize the installation.

1. Configure the Docker client.

    ```bash
    $ dvm use
    Now using Docker 1.11.2
    ```

1. Use `docker` to interact with your cluster:

    ```bash
    $ docker info
    Containers: 5
     Running: 3
     Paused: 0
     Stopped: 2
    Images: 5
    Server Version: swarm/1.2.0
    Role: primary
    Strategy: spread
    Filters: health, port, dependency, affinity, constraint
    Nodes: 1
     1dba0f72-75bc-4825-a5a0-b2993c535599-n1: 172.99.70.6:42376
      └ Status: Healthy
      └ Containers: 5
      └ Reserved CPUs: 0 / 12
      └ Reserved Memory: 0 B / 4.2 GiB
      └ Labels: com.docker.network.driver.overlay.bind_interface=eth1, executiondriver=, kernelversion=3.18.21-2-rackos, operatingsystem=Debian GNU/Linux 7 (wheezy) (containerized), storagedriver=aufs
      └ Error: (none)
      └ UpdatedAt: 2016-05-27T19:27:24Z
      └ ServerVersion: 1.11.2    
    ```

### Run your first application

Run a WordPress blog with a MySQL database on an overlay network.

1. Create a network to connect your containers.

    ```bash
    $ docker network create mynetwork
    ec98e17a760b82b5c0857e2e0d561019af67ef790170fac8413697d5ee183288
    ```

    The output of this `docker network create` command is your network ID.

1. Run a MySQL instance in a container.

    ```bash
    $ docker run --detach --name mysql --net mynetwork --env MYSQL_ROOT_PASSWORD=my-root-pw mysql:5.6
    ab8ca480c46d10143217c0ee323f8420b6ab93737033c937c2f4dbf8578435bb
    ```

    The output of this `docker run` command is your running MySQL container ID.

1. Run a WordPress instance in a container.

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
    104.130.0.124:80
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
* [Docker Version Manager]({{ site.baseurl }}/docs/reference/docker-version-manager/)
* [Carina CLI]({{ site.baseurl }}/docs/reference/carina-cli/)
* [Use overlay networks in Carina]({{ site.baseurl }}/docs/tutorials/overlay-networks/)
