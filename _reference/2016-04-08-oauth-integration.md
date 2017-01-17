---
title: OAuth integration
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2017-01-17
permalink: docs/reference/oauth-integration/
description: Learn how to integrate your application with Carina using OAuth
---

Carina supports OAuth v2 for integration with external applications.
OAuth is an authentication protocol that allows users to grant limited access
to their account without sharing their password. With Carina OAuth, you can
authenticate users, download their cluster credentials, and create clusters on
their behalf.

* [OAuth dance](#oauth-dance)
* [Register your application](#register-your-application)
* [Configure your application](#configure-your-application)
* [Interact with Carina](#interact-with-carina)

### OAuth dance
The flow that a user experiences when authorizing an application
is sometimes called the "OAuth dance" because of the back-and-forth communication between
the external application and OAuth provider. The following process describes
that dance with Carina.

1. The external application requests permission to access the user's Carina account.
    Usually this request happens when a user clicks a login or authorize button
    on the application's website.

    ![OAuth prompt]({% asset_path oauth-integration/signin-prompt.png %})

1. The user is redirected to the Carina OAuth website. If the user is not logged in,
    the user is prompted for Rackspace credentials. These credentials are used to authenticate
    the user against Carina and are not shared with the external application.

    ![Carina OAuth log in form]({% asset_path oauth-integration/oauth-signin.png %})

1. The user is presented with an authorization form that lists the permissions
    requested by the application.

    ![Carina OAuth Request]({% asset_path oauth-integration/authorize-app.png %})

1. After the application is authorized, the user is redirected back to the application.

Authorized applications can act on behalf of the user until that authorization is revoked.
You can view a list of authorized applications on the Carina OAuth website
and revoke an application's access.

![Manage Authorized Applications]({% asset_path oauth-integration/authorized-apps.png %})

### Register your application
Before your application can integrate with Carina, you must first register the application.

1. Log in to the [Carina OAuth][carina-oauth] website.

1. Click the **Developer Applications** link and log in with your Carina credentials.

1. On the Developer Applications page, click **New Application**.

    ![Manage Developer Applications]({% asset_path oauth-integration/developer-apps.png %})

1. Complete the registration form. The **Redirect URI** specifies the URL to which
    users are directed after they authorize your application. It must be a secure
    web page, starting with `https`.

    ![Register Developer Application]({% asset_path oauth-integration/register-app.png %})

On the confirmation page, the application ID and secret are displayed. Do not share
the secret publicly, and do not check it in to source control.

![Register Developer Application]({% asset_path oauth-integration/app-secrets.png %})

### Configure your application
Select an [OAuth2 library][oauth-libs] for the programming language used by your application.
Depending on the library, some or all of the following configuration is handled
by the library. The following guidelines are generic; see the documentation
for your particular library for additional details.

1. In your application, configure the library to use the application ID, secret
   and redirect URI for your registered application in the Carina OAuth
   Control Panel.

1. Add a link to your application that requests access to the user's Carina account.
    Replace `<applicationId>`, and `<redirectURI>` with the values from your application
    registration.

    `https://oauth.getcarina.com/oauth/authorize?client_id=<applicationId>&redirect_uri=<redirectURI>&response_type=code`

    The `scope` query string parameter is optional and should be a space separated
    list of the requested scopes.

    `&scope=identity+cluster_credentials+create_cluster`

1. Add a webpage to your application that handles requests to your Redirect URI.

    After the user authorizes your application, the user is redirected to this page
    with the authorization `code` included in the query string.

    `https://example.com/carina-oauth-callback?code=abc123`

    The callback web page should use the authorization code to request a token,
    and then store the returned tokens. The `access_token` value has an expiration date,
    after which the `refresh_token` value can be used to request a new token.

    **Example request**

    `POST https://oauth.getcarina.com/oauth/token`

    ```json
    {
      "client_id": "<applicationId>",
      "client_secret": "<secret>",
      "redirect_uri": "<redirectURI>",
      "code": "<authorizationCode>",
      "grant_type": "authorization_code"
    }
    ```

    **Example response**

    ```json
    {
      "access_token": "09ba487fc3df...",
      "token_type": "bearer",
      "expires_in": 7200,
      "refresh_token": "8c488ab5f75d61..."
    }
    ```


### Interact with Carina
The following OAuth scopes are available, granting your application varying
levels of access to a user's account.

* [Identity](#identity)
* [Read](#read)
* [Write](#write)
* [Execute](#execute)

All requests must include an authorization header, `Authorization: bearer <access_token>`,
replacing `<access_token>` with the OAuth token returned from the `/oauth/token` endpoint.

#### Identity
The `identity` scope enables an application to read a user's profile. Because the
amount of information in a user's profile is limited, this scope is mainly useful
for delegating your application's authentication to Carina.

**Get current user**

`GET https://oauth.getcarina.com/users/current`

```json
{
  "id": 1,
  "username": "carolynvs",
  "email": "carolynvs",
  "full_name": "carolynvs"
}
```

#### Read
The `read` scope enable an application to query for information about the clusters
on the user's Carina account.

**List clusters**

`GET https://oauth.getcarina.com/proxy/clusters`

```json
{
  "clusters": [
    {
      "status": "active",
      "name": "mycluster",
      "cluster_type": {
        "active": true,
        "coe": "kubernetes",
        "host_type": "lxc",
        "name": "Kubernetes 1.4.4 on LXC",
        "id": 17
      },
      "created_at": "2017-01-11T21:56:34.327946+00:00",
      "updated_at": "2017-01-11T21:56:31.799278+00:00",
      "node_count": 1,
      "id": "d09da2f3-1d31-4521-b856-54256fb0c52f"
    }
  ]
}
```

**Get cluster**

`GET https://oauth.getcarina.com/proxy/clusters/<clusterId>`

```json
{
  "status": "active",
  "name": "mycluster",
  "cluster_type": {
    "active": true,
    "coe": "kubernetes",
    "host_type": "lxc",
    "name": "Kubernetes 1.4.4 on LXC",
    "id": 17
  },
  "created_at": "2017-01-11T21:56:34.327946+00:00",
  "updated_at": "2017-01-11T21:56:31.799278+00:00",
  "node_count": 1,
  "id": "d09da2f3-1d31-4521-b856-54256fb0c52f"
}
```

**List cluster templates**

`GET https://oauth.getcarina.com/proxy/cluster_types`

```json
{
  "cluster_types": [
    {
      "active": true,
      "coe": "swarm",
      "host_type": "lxc",
      "name": "Swarm 1.11.2 on LXC",
      "id": 16
    },
    {
      "active": true,
      "coe": "kubernetes",
      "host_type": "lxc",
      "name": "Kubernetes 1.4.4 on LXC",
      "id": 17
    }
  ]
}
```
#### Write
The `write` scope enables an application to create and delete clusters on the user's
Carina account.

**Create cluster**

```
POST https://oauth.getcarina.com/proxy/clusters
{
  "cluster_type_id": "17",
  "node_count": 1,
  "name": "<clusterName>"
}
```

```json
{
  "status": "creating",
  "name": "mycluster",
  "cluster_type": {
    "active": true,
    "coe": "kubernetes",
    "host_type": "lxc",
    "name": "Kubernetes 1.4.4 on LXC",
    "id": 17
  },
  "created_at": "2017-01-16T17:47:58.023553+00:00",
  "updated_at": "2017-01-16T17:47:58.023553+00:00",
  "node_count": 1,
  "id": "f6589883-3ab5-4c9e-b06e-9d6f70af1e80"
}
```

**Delete cluster**

`DELETE https://oauth.getcarina.com/proxy/clusters/<clusterId>`

```json
{
  "status": "deleting",
  "name": "mycluster",
  "cluster_type": {
    "active": true,
    "coe": "kubernetes",
    "host_type": "lxc",
    "name": "Kubernetes 1.4.4 on LXC",
    "id": 17
  },
  "created_at": "2017-01-16T17:47:58.023553+00:00",
  "updated_at": "2017-01-16T17:47:58.023553+00:00",
  "node_count": 1,
  "id": "f6589883-3ab5-4c9e-b06e-9d6f70af1e80"
}
```

#### Execute
The `execute` scope enables an application to download the credentials
zip file for a user's Carina cluster. Replace `<clusterId>` with id of the cluster.

**Download cluster credentials**

`GET https://oauth.getcarina.com/proxy/clusters/<clusterId>/credentials/zip`

The body of the response is the user's cluster credentials zip file, provided as
an `application/zip` encoded binary attachment.

If the cluster is not yet active, a `404 NOT FOUND` response is returned.
After a new cluster is created, it can take a few minutes for the cluster to become active.
Poll the cluster endpoint at a reasonable interval, such as every 30 seconds,
until the cluster is active.


### Resources
* [OAuth2 libraries][oauth-libs]
* [OAuth2 authorization code grant workflow](https://tools.ietf.org/html/rfc6749#section-4.1)

[carina-oauth]: https://oauth.getcarina.com/
[oauth-libs]: http://oauth.net/2/
[carina-community]: https://community.getcarina.com/
[carina-community-source]: https://github.com/getcarina/
