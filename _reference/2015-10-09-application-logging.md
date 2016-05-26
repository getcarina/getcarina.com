---
title: Application logging
author: Matt Darby <matt.darby@rackspace.com>
date: 2015-10-09
permalink: docs/reference/application-logging/
description: Learn how to log applications with Carina
docker-versions:
  - 1.8
topics:
  - docker
  - intermediate
---

When you use Carina to containerize your applications, Docker enables you to log your applications in a variety of ways. This tutorial describes each in turn.

### Prerequisites

* [Create and connect to a cluster]({{ site.baseurl }}/docs/getting-started/create-connect-cluster/)
* A container to log its output

### Types of logging

Docker provides the following types of logs:

* `json-file`
* `syslog`
* `journald`
* `gelf`
* `fluentd`

**Note:** The `docker logs` command is available when you use the `json-file` logging type.
This log type is enabled by default.

### Accessing logs

This section describes how you can use the different log types to log your applications.

#### json-file log driver
By default the Docker daemon uses the `json-file` logging driver. You can access the logs for the applications running in the containers on the daemon by using the `docker logs <containerNameOrId>` command.

1. Start a container. For example, run `$ docker run --name redis1 -d redis`.
1. View the log for the container by running `$ docker logs redis1`.

The following log from the `redis1` container is displayed:

```
1:C 02 Oct 14:43:24.708 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 3.0.3 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

1:M 02 Oct 14:43:24.709 # Server started, Redis version 3.0.3
1:M 02 Oct 14:43:24.709 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
1:M 02 Oct 14:43:24.709 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
1:M 02 Oct 14:43:24.709 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
1:M 02 Oct 14:43:24.709 * The server is now ready to accept connections on port 6379
```

The `json-file` logging method has a helpful option available named `max-size` that automatically rolls over the log file when it reaches a specified size:

`--log-opt max-size=[0-9+][k|m|g]`

`k`, `m`, and `g` stand for kilobyte, megabyte, and gigabyte. If this option is not set, the logs will not roll over.

#### syslog log driver

Docker also supports streaming its log to a remote `rsyslog` server via the following options:

```
--log-opt syslog-address=[tcp|udp]://host:port
--log-opt syslog-address=unix://path
--log-opt syslog-facility=daemon
--log-opt syslog-tag="mailer"
```

Following is an example command for sending the log for the `redis2` container to a `rsyslog` server:

`$ docker run --log-driver=syslog --log-opt syslog-address=tcp://192.168.0.42:514 --name redis2 -d redis`

Be sure to provide the correct `syslog-address` IP address for your environment.

The `syslog-tag` option specifies a tag that identifies the container’s `syslog` messages.
By default, the system uses the first 12 characters of the container ID. To override this behavior, specify a `syslog-tag` option.

Setting up `rsyslogd` is outside the scope of this article. For more information, see the *Resources* section of this article.

#### journald log driver

The `journald` logging driver sends container logs to a `systemd` journal. You can retrieve log entries by using the `journalctl` command or by using of the `journald` API.
In addition to the log message, `journald` also sends the container name.

#### gelf log driver

The [Graylog Extended Log Format](https://www.graylog.org/resources/gelf/) (GELF) logging driver supports the following options:

```
--log-opt gelf-address=udp://host:port
--log-opt gelf-tag="database"
```

Currently, only `UDP` connections are allowed via the specified `port` value.


#### Fluentd log driver

[Fluentd](http://www.fluentd.org) is an open-source, data-collection application designed to unify your logging layer.

The following example shows the options that Docker might use to log to a Fluentd server:

```
$ docker run \
  --log-driver=fluentd \
  --log-opt fluentd-address=localhost:24224 \
  --log-opt fluentd-tag=docker.{% raw %}{{.Name}}{% endraw %}
```

**Note:** A container using this logging method will immediately stop if it cannot connect to the Fluentd server.

### Troubleshooting

See [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

* [rsyslogd](https://vexxhost.com/resources/tutorials/how-to-setup-remote-system-logging-with-rsyslog-on-ubuntu-14-04-lts/)
* [systemd](http://www.freedesktop.org/software/systemd/man/systemd-journald.service.html)
