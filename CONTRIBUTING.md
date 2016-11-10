# Carina by Rackspace&mdash;Guidelines for content contributors

This [Jekyll](http://jekyllrb.com/) repo houses documentation and tutorials for Carina by Rackspace. This file provides guidelines for the documentation process, from creating an article, to getting it reviewed, to publishing it.

### Writing

The content is split into three separate collections: **tutorials**, **best practices**, and **getting started**. The individual files for these collections are in `_tutorials`, `_best-practices`, and `_getting-started`. The `_assets` directory contains images for the content.

File names are prefixed with an ISO8601 date (YYYY-MM-DD) in order to reasonably sort them when listing source files. This prefix does not affect the sorting of files when they are displayed on the website.

#### Templates

Templates for content are available in each of the directories:

- Create new tutorial articles for tasks: `/_M2/_000-tutorial-task-template.md`
- Create new tutorial articles for concepts: `/_M2/_000-tutorial-concept-template.md`
- Create 101-style articles: `/_M2/_000-tutorial-101-template.md`
- Create reference articles: `/_M2/_000-getting-started-template.md`
- Create best practices articles: `/_M2/_000-best-practices-template.md`
- Create getting started articles by using any preceding template that fits the content.

#### General style guidelines

Use the following guidelines, which are described in detail in [style-guidelines.md](style-guidelines.md):

- Use sentence-style capitalization for titles and headings
- Use consistent text formatting
- Write clear and consistent code examples
- Use active voice
- Use present tense
- Write to the user by using second person and imperative mood
- Write clear and consistent step text
- Clarify pronouns such as *it*, *this*, *there*, and *that*
- Clarify gerunds and participles
- Use consistent terminology

#### Carina-specific style guidelines

Following are some specific guidelines for Carina content:

- For the first-level headings in an article, use the H3 level (designated by ###). Avoid using more than three levels of heading in an article (H3, H4, and H5). If you need more than three levels, you should consider breaking your article into two or more articles.

- If a title contains a special character, such as a colon, enclose the title with single quotation marks.

- When code includes placeholders, show them in camelCase and enclose them in angle brackets. For example, `<hostName>`.

- Show the long forms of command flags on first use in tutorials intended for beginners. For example, `--interactive` and `--tty`. You can then introduce the short version (for example, `-i`, `-t`, or `-it`) and use it consistently throughout the article. Long versions are preceded by a double hyphen; short versions are preceded by a single hyphen.   

- To link to another article, use the permalink for that article, preceded by `{{site.baseurl}}`. The permalink is defined in the frontmatter metadata of the article. Format the link as follows: `({{site.baseurl}}/docs/<directoryName>/<articleName>/)`. For example, `({{site.baseurl}}/docs/concepts/introduction-docker-swarm/)`. Note the use of both leading and trailing slashes.

- To create a link to a heading in the same article or a different article, you do not need to create a customized anchor. For the link, use the following format: `#heading-text`. For example, the link to the heading "GitHub workflow" in this topic would be formatted as `(#github-workflow)`.

    To link to a heading in another article, append `#heading-text`to the permalink. For example, `(/docs/concepts/introduction-docker-swarm#strategies-for-distributing-containers-to-nodes)`.

    If the heading is long or contains special characters, you can create a custom anchor.

- When creating complex lists, such as procedures with sublists, graphics, and code examples, use the spacing guidelines at https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#lists.

- In articles, you can refer to the service simply as Carina. You do not need to include the TM symbol or the phrase "by Rackspace."

- Use the following capitalization when referring to the control panel: Carina Control Panel

For more terminology related to container content, see the [Carina glossary](_getting-started/008-glossary.md).

### Metadata

When populating the frontmatter metadata of your article, use the guidelines in [frontmatter-metadata-guidelines.md](frontmatter-metadata-guidelines.md).

### Legal

All documentation and blog posts in this repository are covered by the Creative Commons Attribution-ShareAlike license. The intent with this license is that you can redistribute the material any way you like as long as you give appropriate credit and link to the license at http://creativecommons.org/licenses/by-sa/4.0/. If you reuse the material, you must also reuse the same license.

Do not use the name Docker in any public facing repositories. Docker is a trademark and should be used only when referring to the tools produced by Docker. Do *not* include the name Docker in the name of anything that you create.

For an example how Docker responds when someone uses their name in an unauthorized way, see [Legal request - Change domain name to drop Docker](https://github.com/j-bennet/wharfee/issues/89).

### Images

If an article or post requires an image, place the image in `_assets/img/<articleName>`. Each article will have its own folder within the `_assets/img` directory.

### Diagrams

If an article or post requires a diagram, follow these steps:

1. Draw or sketch the diagram. You can create a hand sketch, or create a rough diagram using [Draw.io](https://www.draw.io/). The sketch or diagram does not have to be a work of art. It must simply display the process or relationship you want to convey. For more tips on creating diagrams, see the [Diagram standards and practices](https://one.rackspace.com/display/devdoc/Diagram+standards+and+practices) on the Rackspace wiki.

2. Save your diagram in Draw.io by clicking **File > Export as > SVG** or take a picture of your sketch. Send the saved `.svg` file or the picture to <nate.archer@rackspace.com>. Nate will either triage the diagram or create a diagram based off of your sketch.

3. After the diagram has undergone triage, Nate will send the edited file back. With the new diagram in your possession, place the file into the `_assets/img/<articleName>` directory for your article. Be sure the you are saving the file as a `.svg` file.

4. In your content file, add your diagram by using this syntax: `![<titleOfDiagram>]({% asset_path
<articleName>/<nameOfDiagramFile> %})`. `asset_path` is relative to the `_assets/img` directory.

    Example: `![Carina overview]({% asset_path overview-of-carina/swarm-cluster.svg %})`

### Visuals

In `assets/img/visuals/` are Rackspace created stencils that you can use to create diagrams. Although there are currently no Carina specific stencils, the directory contains several "generic" stencils, which you can use to represent container items.

### GitHub workflow

To follow the GitHub workflow for this repo go to [GITHUBING.md](GITHUBING.md).

### The merge process

**The content author owns the merge process.**

We're here to chew bubble gum and merge content. And we're all out of bubble gum.

#### Technical review

After you've created a pull request, go into the #containers channel in Slack, type `@rcs-tech`, paste in the link, and hit enter. This will notify the RCS tech reviewers that content is ready for tech review.

At least 1 technical reviewer must claim the review. If it's big and/or complicated, 2 or more technical reviewers may be necessary. If nobody claims the review, ping people individually or use `@rcs-tech` again.

Work with your technical reviewers to get the content reviewed. Once everything looks good, the reviewer will put their final comment on the review as a :+1:.

#### Editorial review

After your tech reviewers are happy, go into the #containers channel in Slack, type `@rcs-edit`, paste in the link, and hit enter. This will notify the RCS editorial reviewers that content is ready for editorial review.

At least 1 editorial reviewer must claim the review. If nobody claims the review, ping people individually or use `@rcs-edit` again.

Work with your editorial reviewers to get the content reviewed. Once everything looks good, the reviewer will put their final comment on the review as a :+1:.

#### Merge it

Nice work! Give yourself a pat on the back, a :shipit:, and click the Merge pull request button.
