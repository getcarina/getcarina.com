# Rackspace Container Service - for content contributors

This is a [Jekyll](http://jekyllrb.com/) repo housing documentation and tutorials for Rackspace Container Service

## Writing

The content is split into three separate collections: **tutorials**, **best practices**, and **references**. The individual files for these collections are in `_tutorials`, `_best-practices`, `_assets`, and `_references`, respectively.

Right now, file names are being prefixed with a number like `001-` to control their display order. This is not really maintainable and will probably change.

Create new tutorials for tasks: `/_tutorials/000-tutorial-task-template.md`

Create new tutorials for concepts: `/_tutorials/000-tutorial-concept-template.md`

There's also a template for 101-style articles: `/_tutorials/000-tutorial-101-template.md`

## Images

If a piece of content requires an image, place the image in `_assets/img/[name of article]`. Each article will have it's own folder within the `_assets/img` directory.

## Diagrams

If a piece of content requires a diagram, follow these steps.

1. Draw or sketch the diagram. You can create a hand-sketch, or create a rough diagram using [Draw.io](https://www.draw.io/). The sketch or diagram does not have to be a work of art. It must simply display the process or relationship you wish to convey. For more tips on creating diagrams, see the [Diagram standards and practices](https://one.rackspace.com/display/devdoc/Diagram+standards+and+practices) on the Rackspace wiki.

2. Save your diagram in Draw.io by clicking **File**>**Export as**>**SVG** or take a picture of you sketch. Send the saved `.svg` file or the picture to nate.archer@rackspace.com. Nate will either triage the diagram, or create a diagram based off of your sketch.

3. Afterward the diagram has undergone triage, Nate will send the edited file back. With the new diagram in your possession, go ahead an place the file into the `_assets/img/[name of article]` directory for your article. Be sure the you are saving the file as `.svg` file.

=======
## Images

If a piece of content requires an image, place the image in `_assets/img/[name of article]`. Each article will have it's own folder within the `_assets/img` directory.

## Diagrams

If a piece of content requires a diagram, follow these steps.

1. Draw or sketch the diagram. You can create a hand-sketch, or create a rough diagram using [Draw.io](https://www.draw.io/). The sketch or diagram does not have to be a work of art. It must simply display the process or relationship you wish to convey. For more tips on creating diagrams, see the [Diagram standards and practices](https://one.rackspace.com/display/devdoc/Diagram+standards+and+practices) on the Rackspace wiki.

2. Save your diagram in Draw.io by clicking **File**>**Export as**>**SVG** or take a picture of you sketch. Send the saved `.svg` file or the picture to nate.archer@rackspace.com. Nate will either triage the diagram, or create a diagram based off of your sketch.

3. Afterward the diagram has undergone triage, Nate will send the edited file back. With the new diagram in your possession, go ahead an place the file into the `_assets/img/[name of article]` directory for your article. Be sure the you are saving the file as `.svg` file.

=======
## Images

If a piece of content requires an image, place the image in `_assets/img/[name of article]`. Each article will have it's own folder within the `_assets/img` directory.

## Diagrams

If a piece of content requires a diagram, follow these steps.

1. Draw or sketch the diagram. You can create a hand-sketch, or create a rough diagram using [Draw.io](https://www.draw.io/). The sketch or diagram does not have to be a work of art. It must simply display the process or relationship you wish to convey. For more tips on creating diagrams, see the [Diagram standards and practices](https://one.rackspace.com/display/devdoc/Diagram+standards+and+practices) on the Rackspace wiki.

2. Save your diagram in Draw.io by clicking **File**>**Export as**>**SVG** or take a picture of you sketch. Send the saved `.svg` file or the picture to nate.archer@rackspace.com. Nate will either triage the diagram, or create a diagram based off of your sketch.

3. Afterward the diagram has undergone triage, Nate will send the edited file back. With the new diagram in your possession, go ahead an place the file into the `_assets/img/[name of article]` directory for your article. Be sure the you are saving the file as `.svg` file.

>>>>>>> rackerlabs/foo
## Visuals

In `assets/img/visuals/` are Rackspace created stencils that can be used in the creation of diagrams.
While there are currently no container specific stencils, the directory contains several "generic" stencils,
which can be used to represent container items.

## Github Workflow

To follow the GitHub workflow for this repo go to [GITHUBING.md](GITHUBING.md).

## The Merge Process

**The content author owns the merge process.**

We're here to chew bubble gum and merge content. And we're all out of bubble gum.

### Technical Review

After you've created a pull request, go into the #containers channel in Slack, type `@rcs-tech`, paste in the link, and hit enter. This will notify the RCS tech reviewers that content is ready for tech review.

At least 1 technical reviewer must claim the review. If it's big and/or complicated, 2 or more technical reviewers may be necessary. If nobody claims the review, ping people individually or use `@rcs-tech` again.

Work with your technical reviewers to get the content reviewed. Once everything looks good, the reviewer will put their final comment on the review as a :+1:.

### Editorial Review

After your tech reviewers are happy, go into the #containers channel in Slack, type `@rcs-edit`, paste in the link, and hit enter. This will notify the RCS editorial reviewers that content is ready for editorial review.

At least 1 editorial reviewer must claim the review. If nobody claims the review, ping people individually or use `@rcs-tech` again.

Work with your editorial reviewers to get the content reviewed. Once everything looks good, the reviewer will put their final comment on the review as a :+1:.

### Merge It

Nice work! Give yourself a pat on the back, a :shipit:, and click the Merge pull request button.
