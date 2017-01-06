1. Gather the required information:
  * Username (CARINA_USERNAME): Your Carina username from the [Carina Control Panel](https://app.getcarina.com), displayed at the top right. Often, your username is your email address.
  * API key (CARINA_APIKEY): Your Carina API key. To find it, see [Sign up for Carina](#sign-up-for-carina).

2. Set your environment variables to contain these credentials. Replace `<username>` with your Carina username and `<apiKey>` with your Carina API key.

    On Linux and Mac OS X terminals, run the following commands:

    ```bash
    $ export CARINA_USERNAME=<username>
    $ export CARINA_APIKEY=<apiKey>
    ```

    On Windows PowerShell, run the following commands:

    ```powershell
    > $env:CARINA_USERNAME="<username>"
    > $env:CARINA_APIKEY="<apiKey>"
    ```

3. Verify that you can run `carina` commands:

    ```bash
    $ carina clusters
    ID                                      Name        Status    Template                  Nodes
    9f320718-e0b6-4687-9c43-0e0c39eba9e2    k8-test     active    Kubernetes 1.4.4 on LXC   1
    e9bd88ef-7808-4877-8108-766a04e40853    swarm-test  active    Swarm 1.11.2 on LXC       1
    ```

    The output is your list of clusters, if you already have some clusters running.
