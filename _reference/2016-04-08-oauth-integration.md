---
title: OAuth Integration
author: Carolyn Van Slyck <carolyn.vanslyck@rackspace.com>
date: 2016-04-08
permalink: docs/reference/oauth-integration/
description: Learn how to integrate your application with Carina using OAuth
---

Carina supports OAuth v2 for integration with external applications.
OAuth is an authentication protocol that allows users to grant limited access
to their account without sharing their password. With Carina OAuth you can
authenticate a user, download their cluster credentials or create a cluster on
their behalf.

* [OAuth Dance](#oauth-dance)
* [Register your application](#register-your-application)
* [Configure your application](#configure-your-application)
* [Interact with Carina](#interact-with-carina)

## OAuth Dance
The flow that a user experiences when authorizing an application
is sometimes called the "OAuth dance", due to the back and forth communication between
the external application and OAuth provider.

1. The external application requests permission to access the user's Carina account.
    Usually this will be a log in or authorize button on their website.

    ![OAuth prompt]({% asset_path oauth-integration/signin-prompt.png %})

1. The user is redirected to the Carina OAuth website where, if the user is not logged in,
    they are prompted for their Rackspace credentials. These are used to authenticate
    the user against Carina, and are not shared with the external application.

    ![Carina OAuth log in form]({% asset_path oauth-integration/oauth-signin.png %})

1. The user is presented with an authorization form, listing the permissions
    requested by the application.

    ![Carina OAuth Request]({% asset_path oauth-integration/authorize-app.png %})

1. After the application is authorized, the user is redirected back to the application.

Authorized applications can act on behalf of the user until that authorization is revoked.
You can view a list of authorized applications on the Carina OAuth website
and revoke an application's access.

![Manage Authorized Applications]({% asset_path oauth-integration/authorized-apps.png %})

## Register your application
Before you can integrate with Carina, you must first register your application.

1. Log in to the [Carina OAuth][carina-oauth] website.

1. On the Developer Applications page, click **New Application**.

    ![Manage Developer Applications]({% asset_path oauth-integration/developer-apps.png %})

1. Complete the registration form. The **Redirect URI** specifies the URL to which
    the user is directed after they authorize your application. It must be a secure
    webpage, starting with `https`.

    ![Register Developer Application]({% asset_path oauth-integration/register-app.png %})

1. On the confirmation page, your **Application Id** and **Secret** are displayed.
    The secret must not be shared publicly and should not be checked into source control.

    ![Register Developer Application]({% asset_path oauth-integration/app-secrets.png %})

## Configure your application
Select an [OAuth2 library][oauth-libs] for the programming language used by your application.
Depending on the library, some or all of the following configuration is handled
by the library. The following guidelines are generic, see the documentation
for your particular library for additional details.

1. In your application, configure the library to use your **Application Id**, **Secret** and **Callback URL**.

1. Add a link to your application which requests access to the user's Carina account.
    Replace `<applicationId>`, and `<redirectURI>` with the values from your application
    registration.

    `https://oauth.getcarina.com/oauth/authorize?client_id=<applicationId>&redirect_uri=<redirectURI>&response_type=code`

    The `scope` query string parameter is optional and should be a space separated
    list of the requested scopes.

    `&scope=identity+cluster_credentials+create_cluster`

1. Add a webpage to your application that handles requests to your Redirect URI.
    After the user authorizes your application, the user is redirected to this webpage
    with the authorization `code` included in the query string.

    `https://example.com/carina-oauth-callback?code=abc123`

1. The callback webpage should use the authorization code to request a token,
    and then store the returned tokens. The `access_token` has an expiration date,
    after which the `refresh_token` can be used to request a new token.

    **Example Request**

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

    **Example Response**

    ```json
    {
      "access_token": "09ba487fc3df...",
      "token_type": "bearer",
      "expires_in": 7200,
      "refresh_token": "8c488ab5f75d61..."
    }
    ```


## Interact with Carina
The following OAuth scopes are available, granting your application varying
levels of access to a user's account.

* [Identity](#identity-scope)
* [Cluster Credentials](#cluster-credentials-scope)
* [Create Cluster](#create-cluster-scope)

All requests must include an authorization header, `Authorization: bearer <access_token>`,
replacing `<access_token>`, with the OAuth token returned from the `/oauth/token` endpoint.

### Identity Scope
The `identity` scope enables an application to read a user's profile. Due to the
limited amount of information in a users' profile, this is mainly useful for delegating your
application's authentication to Carina.

**Example Request**

`GET https://oauth.getcarina.com/me`

**Example Response**

```json
{
  "id": 1,
  "username": "carolynvs",
  "email": "carolyn.vanslyck@rackspace.com",
  "full_name": "carolynvs"
}
```

### Cluster Credentials Scope
The `cluster_credentials` scope enables an application to download the credentials
zip file for a users's Carina cluster. Replace `<clusterName>` with name of the cluster.

**Example Request**

`GET https://oauth.getcarina.com/clusters/<clusterName>`

**Example Responses**

The body of the response is the user's cluster credentials zip file, provided as
an `application/zip` encoded binary attachment.

If the cluster is not yet active, a `404 NOT FOUND` response is returned.
After creating a new cluster, it can take 2-3 minutes for the cluster to become active.
Poll the cluster credentials endpoint at a reasonable interval, such as every 30 seconds,
until the cluster is active.

```json
{
  "message": "The cluster is not yet active. Retry this request later."
}
```

### Create Cluster Scope
The `create_cluster` scope enables an application to create a cluster on the users'
Carina account. If the cluster already exists, the request succeeds and the cluster
information is returned. Replace `<clusterName>` with the name of the cluster to create.

**Example Request**

`PUT https://oauth.getcarina.com/clusters/<clusterName>`

**Example Response**

```json
{
  "cluster_name": "<clusterName>",
  "status": "building",
  "autoscale": false,
  "flavor": "container1-4G",
  "nodes": 1
}
```

### Resources
* [OAuth2 libraries][oauth-libs]
* [OAuth2 authorization code grant workflow](https://tools.ietf.org/html/rfc6749#section-4.1)

[carina-oauth]: https://oauth.getcarina.com/
[oauth-libs]: http://oauth.net/2/
[carina-community]: https://community.getcarina.com/
[carina-community-source]: https://github.com/getcarina/
