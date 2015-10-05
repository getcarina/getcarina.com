---
title: Troubleshooting: My Docker command hangs
seo: docker hangs
---
This article provides a solution for when a `docker` command hangs when using RCS.
### Docker command hangs
When using RCS, you may experience a "hang" condition when running the `docker` command. That is, you run a command and nothing happens. For example:

`docker ps -a`

To fix this issue, perform the following steps:
1. Press Ctrl-C to kill the `docker` command.
2. Log in to your RCS account to view the cluster you are currently using.
3. Click the icon to rebuild your cluster.

![Example clusters]({% asset_path troubleshoot-docker-hangs/clusters.png %})
4. When the rebuild is complete (you may need to click the "Refresh" button to update your screen), you can resume using the cluster.
