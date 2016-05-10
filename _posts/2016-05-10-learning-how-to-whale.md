---
title: Learning How to Whale
date: 2016-05-10
comments: true
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
published: true
excerpt: >
  Learn How to Whale with JupyterHub, and use Carina to provide a Bring Your Own Compute experience to users that encourages interactivity, play, and sharing.
categories:
  - Docker
  - Swarm
  - Carina
  - Rackspace
authorIsRacker: true
---

{{ page.excerpt }}

## Learning How to Whale
[How to Whale][howtowhale] is an online platform that I created to teach Docker. Just log in with your Carina account and in minutes you have an interactive scripting notebook in your web browser. From there you can run Docker commands without having to install a thing.

<p style="color: gray; font-style: italic; text-align: center; margin-left: 4em; margin-right: 4em;">Want to do the Dockers? Not sure what it's all about, other than some epic whales? How to Whale has got you covered! Learn Docker in your web browser, no setup or installation required.</p>

![Docker Docker Docker MUSHROOM!]({% asset_path learning-howtowhale/howtowhale.png %})

How to Whale is an amusing concept all on its own: learning Docker with Docker before you know how to Docker is deliciously recursive and surprisingly effective. Even more interesting, though, is the idea behind it: BYOC (Bring You Own Compute). How to Whale demonstrates how to integrate with Carina and offload a user's workload to Carina. As its user base increases, the associated costs to run the site do not increase linearly with it because when a user first signs up, a cluster is created on the user's Carina account. Every command that the user runs is executed on that user's cluster, not on How to Whale's infrastructure.

![Screenshot of the Try Docker tutorial]({% asset_path learning-howtowhale/try-docker.png %})

How to Whale combines JupyterHub and Carina, with some configuration tweaks to connect the user's Jupyter notebook shell session to the underlying Docker Swarm cluster.

With [Jupyter][jupyter] notebooks you can execute code live in your web browser and immediately see the output. It is a bit of an online REPL with superpowers. [JupyterHub][jupyterhub] is a server that gives multiple users access to Jupyter notebooks, running an independent Jupyter notebook server for each user. How to Whale is essentially a customized installation of JupyterHub that deploys a Jupyter server on the user's own Carina cluster.

JupyterHub employs a simple proxy so that users don't need to understand that the site they are seeing, for example https://howtowhale.com/jupyter/user/sally, isn't actually served from howtowhale.com. Instead the user is interacting with the Jupyter server running on their Carina cluster.

The result is that each user has an isolated, preconfigured sandbox in which to try out Docker.
The technology behind it all—Carina, Docker and Docker Swarm—are mostly transparent. The following
flow diagram and steps show how the simple `docker run hello-world` command is routed and run.

![How to Whale Topology]({% asset_path learning-howtowhale/howtowhale-topology.png %})

1. The user runs `docker run hello-world` from their web browser.
1. The web request is sent to JupyterHub.
1. Based on the URL suffix, the JupyterHub proxy directs the request to the
    user's Jupyter server.
1. Jupyter sends the command to a Bash shell session for the user. The shell
    has Docker environment variables defined so that the Docker client is configured
    to connect to the Docker Swarm running in the user's Carina account.
1. Docker connects to the user's cluster and starts the hello-world container.
1. The hello-world container starts and its output is relayed back to the web browser.

## Running JupyterHub on Carina
<img class="right" src="{% asset_path learning-howtowhale/docker-jupyter.png %}" alt="Running JupyterHub on Carina"/>
How to Whale uses this setup to teach Docker, but it can be used for a variety of other
applications. The code that supports integrating JupyterHub with Carina has been contributed back to the Jupyter Project. So, you can use it to create your own Carina backed JupyterHub instance, or read the code to see how to integrate with Carina for your own evil purposes.

Here are the steps to run your own JupyterHub instance:

1. [Create a Carina account](https://getcarina.com).
1. [Register with Carina OAuth]({{site.baseurl}}/docs/reference/oauth-integration/#register-your-application).
    Use `https://<jupyterhub_domain>/hub/oauth_callback` for the Redirect URI, replacing
    `<jupyterhub_domain>` with the IP address or domain name where you will host JupyterHub.

    **Note**: If you configure a base_url for your JupyterHub instance, then this URL
    should be updated to reflect the path to JupyterHub.
1. [Install JupyterHub](https://github.com/jupyterhub/jupyterhub/blob/master/README.md).
    You can either run JupyterHub on Carina by using the `jupyter/jupyterhub` as the base
    Docker image for your Dockerfile or host JupyterHub on a traditional server.
1. Install the jupyterhub-carina plug-in by running `pip install jupyterhub-carina`.
1. Edit your JupyterHub configuration file, **jupyterhub-config.py**, so that
    it uses the jupyterhub-carina plug-in. Replace `<carina_username>` with your
    Carina username and `<jupyterhub_domain>` with the domain name or IP address
    where JupyterHub is accessible.

    ```python
    c = get_config()

    # Required: Configure JupyterHub to authenticate against Carina
    c.JupyterHub.authenticator_class = "jupyterhub_carina.CarinaAuthenticator"
    c.CarinaAuthenticator.admin_users = ["<carina_username>"]
    c.CarinaAuthenticator.oauth_callback_url = "https://<jupyterhub_domain>/hub/oauth_callback"

    # Required: Configure JupyterHub to spawn user servers on Carina
    c.JupyterHub.hub_ip = "0.0.0.0"
    c.JupyterHub.spawner_class = "jupyterhub_carina.CarinaSpawner"
    c.CarinaSpawner.hub_ip_connect = "<jupyterhub_domain>"
    ```

    **Note**: See the [jupyterhub-carina plug-in documentation][jupyterhub-carina] for optional
    settings and detailed configuration instructions.
1. On the JupyterHub server, set the following environment variables:
    * `OAUTH_CLIENT_ID`: The ID assigned to your Carina OAuth application.
    * `OAUTH_CLIENT_SECRET`: The secret assigned to your Carina OAuth application.
1. Start the JupyterHub service by running the `jupyterhub` command.
1. Open your web browser and navigate to the URL of your JupyterHub instance.

When you log in to JupyterHub, click the the **Sign in with Carina** button.
After you first start a Jupyter server for your user, a progress page is displayed
while your Carina cluster is created and configured.

Even if you don't have big data or research to play with, running your own JupyterHub instance
gives you a personal online REPL and live code snippet repository. So give it a try,
and send us your feedback!

[howtowhale]: https://howtowhale.com
[jupyter]: http://jupyter.org
[jupyterhub]: http://jupyterhub.readthedocs.io/en/latest/
[jupyterhub-carina]: https://github.com/jupyterhub/jupyterhub-carina/
