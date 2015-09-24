# Rackspace Container Service - for content contributors

This is a [Jekyll](http://jekyllrb.com/) repo housing documentation and tutorials for Rackspace Container Service


## Writing

The content is split into three separate collections: **tutorials**, **best practices**, and **references**. The individual files for these collections are in `_tutorials`, `_best-practices`, `_assets`, and `_references`, respectively.

Right now, file names are being prefixed with a number like `001-` to control their display order. This is not really maintainable and will probably change.

## Images

If a piece of content requires an image, place the image in `_assets/img/[name of article]`.
Each article will have it's own folder within the `_assets/img` directory.

## Diagrams

If a piece of content requires a diagram, follow these steps.

1. Draw or sketch the diagram. You can create a hand-sketch, or create a rough diagram
   using ![Draw.io](https://www.draw.io/). The sketch or diagram does not have to be a work of art. It must simply
   display the process or relationship you wish to convey. For more tips on creating diagrams,
   see the ![Diagram standards and practices](https://one.rackspace.com/display/devdoc/Diagram+standards+and+practices) on the
   Rackspace wiki.

2. Save your diagram or sketch, and email the file to nate.archer@rackspace.com.
   Nate will triage the diagram and ensure that diagram meets visual standards.

3. Afterward the diagram has undergone triage, Nate will send the edited file
   back. With the new diagram in your possession, go ahead an place the file into the
   `_assets/img{name of article]` directory for your article. Be sure to save two versions 
   of the file in the directory, one `.svg` file, and one `.xml` file. This will allow any future 
   contributors to edit the file.

## Visuals

In `assets/img/visuals/` are Rackspace created stencils that can be used in the creation of diagrams. 
While there are currently no container specific stencils, the directory contains several "generic" stencils,
which can be used to represent container items. 

## Github workflow

1. Fork from rackerlabs/docs-container-service.
2. Clone the repo by typing

    `git clone (*url for your fork*)`

3. CD to your repo and type:

    `git remote add --track master upstream git@github.com:rackerlabs/docs-container-service.git`

4. To bring your master branch up-to-date with upstream type:

	 `git pull --rebase upstream master`


**Note** Make sure to create a separate branch for each separate pull request by typing `git checkout -b <new branch>`

## Technical Review

After pushing your content to GitHub, do not merge it by yourself. Your content will be merged after it has been edited and undergone a techical review.

After committing your changes and pushing them to GitHub, the content will be reviewed by @rackerlabs/rcs-technical-review.

For technical edits, contact Kelly.Holcomb@rackspace.com.
