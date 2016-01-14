---
title: Tutorial name
author: First Last <first.last@rackspace.com>
date: yyyy-mm-dd
permalink: docs/tutorials/tutorial-name/
description: Learn to accomplish some task in Carina
docker-versions:
  - 1.8.2
topics:
  - docker
  - intermediate
  - etc
---

<!--
Limit tutorials to a single task.

Choose a title that accurately describes the task. For example:

### Create a new container
### Remove containers without deleting Swarm
-->

This tutorial describes *x* so that you can *y*.

<!--
Give a brief summary of what this tutorial describes and why it matters. For example:

"This tutorial describes Docker basics: what Docker is and how to start using it."
"This tutorial demonstrates how to remove containers without deleting system-critical containers."

You are not limited to this phrasing, but ensure that the introduction adequately describes what the article is about.
-->

### Prerequisites

<!--
List necessary prerequisites for the tutorial. Limit this section to only what the user needs to know or do to accomplish the task.

* Software installed
* State dependencies
* Links to other tutorials
* Any other required setup
-->

### Steps

<!--
Provide a descriptive heading for this section. Begin with the an imperative verb.

List steps in numbered order. Limit steps to a single action.

Include as many "steps" sections as needed to provide a complete topic to the user.
To make it easier to shuffle steps around, number each with 1. and Jekyll will handle numbering it appropriately.

1. Do this.

    Indent any descriptions or information needed between steps. If your task includes sublists, graphics, and code examples, use the spacing guidelines at https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#lists.

1. Do that.

1. Do this other thing.

1. Clean up.

    If a tutorial isn't part of a series of tutorials and the user might not need the containers that they created anymore, include an optional step at the end of the tutorial to remove only the containers created in the tutorial. Use the following text, adjusting the example as needed for your tutorial:

    *(Optional)* Remove the containers.

    ```bash
    $ docker rm --force $(docker ps --quiet -n=-2)
    47c6d35c63ec
    08d0383a775f
    ```

    The output of this `docker rm` command are the shortened IDs of the containers that you removed.

    When the container is gone, so is your data.

Conclude with a brief description of the end state.
-->

### Troubleshooting

<!--

Provide the following boilerplate. If you have a troubleshooting information that pertains only to this tutorial, you can include it in this section, before the boilerplate. However, if it might apply to more than one article, add a new section for it in the [Troubleshooting common problems]({{ site.baseurl }}/docs/troubleshooting/common-problems/) article or create a new article for it and link to that article from here as well.

-->

See [Troubleshooting common problems]({{site.baseurl}}/docs/troubleshooting/common-problems/).

For additional assistance, ask the [community](https://community.getcarina.com/) for help or join us in IRC at [#carina on Freenode](http://webchat.freenode.net/?channels=carina).

### Resources

<!--
* Links to related content
-->

### Next step

<!--
* What should your audience read next?
-->
