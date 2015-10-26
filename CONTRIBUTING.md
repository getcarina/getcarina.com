# Carina by Rackspace - for content contributors

This [Jekyll](http://jekyllrb.com/) repo houses documentation and tutorials for Carina by Rackspace.

## Writing

The content is split into three separate collections: **tutorials**, **best practices**, and **getting started**. The individual files for these collections are in `_tutorials`, `_best-practices`, and `_getting-started`. The `_assets` directory contains images for the content.

Right now, file names are being prefixed with a number like `001-` to control their display order. This is not really maintainable and will probably change.

Templates for content are available in each of the directories:

- Create new tutorials for tasks: `/_tutorials/_000-tutorial-task-template.md`
- Create new tutorials for concepts: `/_tutorials/_000-tutorial-concept-template.md`
- Create 101-style articles: `/_tutorials/_000-tutorial-101-template.md`
- Create getting started topics: `/_references/_000-getting-started-template.md`
- Create best practices topics: `/_best-practices/_000-best-practices-template.md`

Follow the style guidelines defined at in the [Writing style guide](https://one.rackspace.com/display/devdoc/Writing+style+guide). Following are some specific guidelines you might review:

- Use [sentence-style capitalization for titles and headings](https://one.rackspace.com/display/devdoc/Titles+and+headings#Titlesandheadings-Capitalizationoftitlesandheadings)
- Use [consistent text formatting](https://one.rackspace.com/display/devdoc/Text+formatting)
- Write [clear and consistent code examples](https://one.rackspace.com/display/devdoc/Code+examples)
- Use [active voice](https://one.rackspace.com/display/devdoc/Basic+writing+guidelines#Basicwritingguidelines-Useactivevoice)
- Use [present tense](https://one.rackspace.com/display/devdoc/Basic+writing+guidelines#Basicwritingguidelines-Usepresenttense)
- Write to the user [by using second person and imperative mood](https://one.rackspace.com/display/devdoc/Basic+writing+guidelines#Basicwritingguidelines-Writetoyou(thecustomer))
- Write [clear and consistent step text](https://one.rackspace.com/display/devdoc/Tasks+and+procedures)

A few specific guidelines for container content:

- For the first-level headings in an article, use the H3 level (designated by ###). Avoid using more than three levels of heading in an article (H3, H4, and H5) . If you need more than three levels, you should consider breaking your article into two or more articles.

- When code includes placeholders, show them in camelCase and enclose them in angle brackets. For example, `<hostName>`. For more information, see [Placeholder text](https://one.rackspace.com/display/devdoc/Placeholder+%28variable%29+text).

- Show the long forms of command flags on first use in tutorials intended for beginners. For example, `--interactive` and `--tty`. You can then introduce the short version (for example, `-i`, `-t`, or `-it`) and use it consistently throughout the article. Long versions are preceded by a double hyphen; short versions are preceded by a single hyphen.   

For terminology usage related to container content, see `<termsFileComingSoon>`.

## Metadata

When populating the frontmatter metadata of your article, use the guidelines in [frontmatter-metadata-guidelines.md](frontmatter-metadata-guidelines.md).

## Legal

Do not use the name Docker in any public facing repositories. Docker is a trademark and should be used only when referring to the tools produced by Docker. Do *not* include the name Docker in the name of anything that you create.

For an example how Docker responds when someone uses their name in an unauthorized way, see [Legal request - Change domain name to drop Docker](https://github.com/j-bennet/wharfee/issues/89).  

## Images

If a piece of content requires an image, place the image in `_assets/img/<articleName>`. Each article will have it's own folder within the `_assets/img` directory.

## Diagrams

If a piece of content requires a diagram, follow these steps.

1. Draw or sketch the diagram. You can create a hand-sketch, or create a rough diagram using [Draw.io](https://www.draw.io/). The sketch or diagram does not have to be a work of art. It must simply display the process or relationship you wish to convey. For more tips on creating diagrams, see the [Diagram standards and practices](https://one.rackspace.com/display/devdoc/Diagram+standards+and+practices) on the Rackspace wiki.

2. Save your diagram in Draw.io by clicking **File**>**Export as**>**SVG** or take a picture of you sketch. Send the saved `.svg` file or the picture to nate.archer@rackspace.com. Nate will either triage the diagram, or create a diagram based off of your sketch.

3. Afterward the diagram has undergone triage, Nate will send the edited file back. With the new diagram in your possession, go ahead an place the file into the `_assets/img/<articleName>` directory for your article. Be sure the you are saving the file as `.svg` file.

4. In your content file, add your diagram by using this syntax: `![<titleOfDiagram>]({% asset_path
<articleName>/<nameOfDiagramFile> %})`. `asset_path` is relative to the `_assets/img` directory.

    e.g. `![Carina overview]({% asset_path overview-of-carina/carina-cluster.svg %})`

## Visuals

In `assets/img/visuals/` are Rackspace created stencils that can be used in the creation of diagrams.
While there are currently no container specific stencils, the directory contains several "generic" stencils,
which can be used to represent container items.

## Github workflow

To follow the GitHub workflow for this repo go to [GITHUBING.md](GITHUBING.md).

## The merge process

**The content author owns the merge process.**

We're here to chew bubble gum and merge content. And we're all out of bubble gum.

### Technical review

After you've created a pull request, go into the #containers channel in Slack, type `@rcs-tech`, paste in the link, and hit enter. This will notify the RCS tech reviewers that content is ready for tech review.

At least 1 technical reviewer must claim the review. If it's big and/or complicated, 2 or more technical reviewers may be necessary. If nobody claims the review, ping people individually or use `@rcs-tech` again.

Work with your technical reviewers to get the content reviewed. Once everything looks good, the reviewer will put their final comment on the review as a :+1:.

### Editorial review

After your tech reviewers are happy, go into the #containers channel in Slack, type `@rcs-edit`, paste in the link, and hit enter. This will notify the RCS editorial reviewers that content is ready for editorial review.

At least 1 editorial reviewer must claim the review. If nobody claims the review, ping people individually or use `@rcs-tech` again.

Work with your editorial reviewers to get the content reviewed. Once everything looks good, the reviewer will put their final comment on the review as a :+1:.

### Merge it

Nice work! Give yourself a pat on the back, a :shipit:, and click the Merge pull request button.
