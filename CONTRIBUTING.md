# Rackspace Container Service - for content contributors

This is a [Jekyll](http://jekyllrb.com/) repo housing documentation and tutorials for Rackspace Container Service


## Writing

The content is split into three separate collections: **tutorials**, **best practices**, and **references**. The individual files for these collections are in `_tutorials`, `_best-practices`, `_assets`, and `_references`, respectively.

Right now, file names are being prefixed with a number like `001-` to control their display order. This is not really maintainable and will probably change.

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
