# GitHub Workflow

This is the GitHub workflow we use to contribute content to this repo. To follow the entire contributing process for this repo go to [CONTRIBUTING.md](CONTRIBUTING.md).

## Prerequisites

1. [Generating SSH keys](https://help.github.com/articles/generating-ssh-keys/)

## Workflow

1. Fork from https://github.com/rackerlabs/docs-container-service

2. Clone your fork of the repo using the SSH clone URL

    git clone git@github.com:my-github-username/docs-container-service.git

3. Track the upstream repo

    cd docs-container-service
    git remote add --track master upstream git@github.com:rackerlabs/docs-container-service.git

4. To bring your master branch up-to-date with upstream type

	  git pull --rebase upstream master

5. Create a branch to make a change

    git checkout -b <new branch>

6. Add all files relevant to the change

    git add .

7. Commit the changed files

    git commit -m "The reason for my change"
