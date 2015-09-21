# Rackspace Container Service - for content contributors

This is a [Jekyll](http://jekyllrb.com/) repo housing documentation and tutorials for Rackspace Container Service

## Writing

The content is split into three separate collections: **tutorials**, **best practices**, and **references**. The individual files for these collections are in `_tutorials`, `_best-practices`, `_assets`, and `_references`, respectively.

Right now, file names are being prefixed with a number like `001-` to control their display order. This is not really maintainable and will probably change.

Create new tutorials for tasks: (`/_tutorials/000-tutorial-task-template.md`).

Create new tutorials for concepts: (`/_tutorials/000-tutorial-concept-template.md`).

## Github workflow

1. Fork from rackerlabs/docs-container-service.
2. Clone the repo by typing

    `git clone (*url for your fork*)`

3. CD to your repo and type:

    `git remote add --track master upstream git@github.com:rackerlabs/docs-container-service.git`

4. To bring your master branch up-to-date with upstream type:

	 `git pull --rebase upstream master`

**Note** Make sure to create a separate branch for each separate pull request by typing `git checkout -b <new branch>`

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
