---
title: Application logging
slug: appliction-logging
description: How to log applications with the Rackspace Container Service
topics:
  - docker
  - intermediate
---

### Prerequisites

A working Docker installation and container.

### Concepts

Docker allows you to log your application in a variety of ways. This tutorial will show each in turn.

### Types of logging

* `json-file`
* `syslog`
* `journald`
* `gelf`
* `fluentd`

Please note that the `docker logs` command is only available when using the `json-file` logging type.
This is enabled by default.

### Accessing logs

#### json-file log driver
By default the Docker daemon uses `json-file` logging driver, and we can access logs simply by running the `docker logs <CONTAINER_ID_OR_NAME>` command:

1. `docker run --name redis1 -d redis`
1. `docker logs redis1`

You will see the following log from the `redis1` container:

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

There is a helpful option available named `max-size` when using the `json-file` logging method that automatically rolls over the log file when it reaches a specified size:
`--log-opt max-size=[0-9+][k|m|g]` (`k`, `m`, `g` standing for kilobyte, megabyte and gigabyte respectfully.) If this option is not set the logs will no roll over.

#### syslog log driver

Docker also supports streaming its log to a remote `rsyslog` server via these options:

```
--log-opt syslog-address=[tcp|udp]://host:port
--log-opt syslog-address=unix://path
--log-opt syslog-facility=daemon
--log-opt syslog-tag="mailer"
```

Example command:
`docker run --log-driver=syslog --log-opt syslog-address=tcp://192.168.0.42:514`

The `syslog-tag` option specifies a tag that identifies the container’s syslog messages.
By default, the system uses the first 12 characters of the container id. To override this behavior, specify a `syslog-tag` option.

Setting up rsyslogd is outside the scope of this article; more information is available via the "rsyslogd" link in the *Resources* section of this article.

#### journald log driver

The journald logging driver sends container logs to a `systemd` journal. Log entries can be retrieved using the `journalctl` command or through use of the journal API.
In addition to the log message `journald` also sends the container name.

#### gelf log driver

The [Graylog Extended Log Format](https://www.graylog.org/resources/gelf/)(GELF) logging driver supports the following options:

```
--log-opt gelf-address=udp://host:port
--log-opt gelf-tag="database"
```

Currently, only `UDP` connections are allowed via the specified `port` value.


#### Fluentd log driver

[Fluentd](https://www.graylog.org/resources/gelf/) is an open source data collection application that aims to unify your logging layer.

Here is an example showing the options that Docker may use to log to a Fluentd server:
`docker run --log-driver=fluentd --log-opt fluentd-address=localhost:24224 --log-opt fluentd-tag=docker.{{.Name}}`

Note that the container using this logging method will immediately stop if it cannot connect to the Fluentd server.

### Resources

[rsyslogd](https://vexxhost.com/resources/tutorials/how-to-setup-remote-system-logging-with-rsyslog-on-ubuntu-14-04-lts/)
[systemd](http://www.freedesktop.org/software/systemd/man/systemd-journald.service.html)

### Next
