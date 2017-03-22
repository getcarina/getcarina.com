---
title: Memory limits in Carina
author: Zack Shoylev <zack.shoylev@rackspace.com>
date: 2015-02-01
permalink: docs/reference/memory-limits/
description: Learn how memory works in Carina
docker-versions:
  - 1.9.0
topics:
  - docker
  - memory
---

Carina containers can be used to run memory-intensive applications such as databases, caching, or game servers. However, the maximum memory that can be allocated by all containers on a segment is limited.

### Determining memory limits

As of the writing of this guide, each Carina segment has a total memory capacity of 4 GB. The way to determine your current usage and  limit is by running:

```
$ docker stats mycontainer

CONTAINER           CPU %               MEM USAGE / LIMIT     MEM %               NET I/O               BLOCK I/O
2f1f41a82841        0.00%               11.08 MB / 4.295 GB   0.26%               23.04 MB / 418.3 kB   2.472 GB / 304.1 kB
```

This command will monitor your current resource usage in real time until you press `Ctrl-C`. You can specify multiple containers to monitor.

### Application behavior when exceeding memory limits

When any application attempts to exceeds the maximum available memory with a memory allocation system call (malloc), the Operating System will terminate that application with a 9 (SIGKILL) signal. This is standard behavior.

A quick way to demonstrate this behavior would be by running `stress` in a container:

```
$ stress --vm-bytes 10G --vm 200 --verbose --vm-keep

stress: info: [242] dispatching hogs: 0 cpu, 0 io, 200 vm, 0 hdd
stress: dbug: [242] using backoff sleep of 600000us
stress: dbug: [242] --> hogvm worker 200 [243] forked
stress: dbug: [242] using backoff sleep of 597000us
stress: dbug: [242] --> hogvm worker 199 [244] forked
stress: dbug: [242] using backoff sleep of 594000us
...
stress: dbug: [442] allocating 10737418240 bytes ...
stress: dbug: [442] touching bytes in strides of 4096 bytes ...
stress: dbug: [441] allocating 10737418240 bytes ...
stress: dbug: [441] touching bytes in strides of 4096 bytes ...
...
stress: dbug: [317] touching bytes in strides of 4096 bytes ...
stress: FAIL: [242] (415) <-- worker 440 got signal 9
...
stress: FAIL: [242] (451) failed run completed in 239s
```

This will attempt to allocate 10 GB using multiple processes, eventually resulting in failure. 

To work around this limitation, Carina allows segments to autoscale when applications are close to reaching resource limits. Please see [Autoscaling Carina]({{ site.baseurl }}/docs/reference/autoscaling-carina/) for details. 