---
title: Tips and tricks
author: Everett Toews <everett.toews@rackspace.com>
date: 2016-03-30
permalink: docs/reference/tips-and-tricks/
description: Tips and tricks for working with Carina
topics:
  - tips
tips:
  -
    title: Alias to check your Docker environment.
    body: |

      ```
      $ alias de='env | grep DOCKER | sort'
      $ de
      DOCKER_CERT_PATH=/Users/octopus/.carina/clusters/octopus/dev
      DOCKER_HOST=tcp://xxx.xxx.xxx.xxx:2376
      DOCKER_TLS_VERIFY=1
      DOCKER_VERSION=1.10.2
      ```
  -
    title: Unset all Docker environment variables.
    body: |

      ```
      $ unset ${!DOCKER_*}
      ```
---

<div class="table-of-contents">
  <h4>Contents</h4>
  <ul>
  {% for tip in page.tips %}
    <li><a href="#{{ tip.title | slugify }}">{{ tip.title }}</a></li>
  {% endfor %}
  </ul>
</div>

{% for tip in page.tips %}
  {% comment %}
    This is a terrible, awful, no-good band-aid to parse one jekyll variable that we know gets used a lot in the frontmatter.
  {% endcomment %}
  {% assign baseUrlVar = '{{ site.baseurl }}' %}
  <h4 id="{{ tip.title | slugify }}">{{ tip.title }}</h4>
  <div class="answer">
    {{ faq.body | replace: baseUrlVar, site.baseurl }}
  </div>
{% endfor %}
