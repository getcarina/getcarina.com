# GitHub Workflow :octocat:

This is the GitHub workflow we use to contribute content to this repo. To follow the entire contributing process for this repo go to [CONTRIBUTING.md](CONTRIBUTING.md).

## Prerequisites

1. [Generating SSH keys](https://help.github.com/articles/generating-ssh-keys/)

## Workflow

1. Fork from https://github.com/getcarina/getcarina.com

2. Clone your fork of the repo using the SSH clone URL
    ```bash
    git clone git@github.com:my-github-username/getcarina.com.git
    ```

3. Track the upstream repo
    ```bash
    cd getcarina.com
    git remote add --track master upstream git@github.com:getcarina/getcarina.com.git
    ```

4. :sunrise: Start new changes here.

    Bring your branch up-to-date with upstream
    ```bash
    git checkout master
    git pull --rebase upstream master
    ```

5. Create a branch to make a change. If you'd like to see some lovely graphics, this step is the start of the [Understanding the GitHub Flow](https://guides.github.com/introduction/flow/index.html) guide.
    ```bash
    git checkout -b <name-of-branch>
    ```

6. Add all files relevant to the change
    ```bash
    git add .
    ```

7. Commit the changed files
    ```bash
    git commit -m "The reason for my change"
    ```

8. Push your branch to your fork
    ```bash
    git push -u origin <name-of-branch>
    ```

9. Create a pull request (PR) to the upstream repo for your branch

    1. Go to https://github.com/my-github-username/getcarina.com
    2. Click on the Create pull request button
    3. If this PR is related to an [issue](https://github.com/getcarina/getcarina.com/issues), include a link to that GitHub issue in the comment

10. Notify rcs-tech a PR is ready for [Tech Review](CONTRIBUTING.md#technical-review)

11. Make updates to your PR by adding more commits
    ```bash
    git add .
    git commit -m "The reason for my update"
    git push
    ```

12. When the tech review is complete, it's time for the [Editorial Review](CONTRIBUTING.md#editorial-review)

13. Deal with conflicts

    During your review process, someone may have already updated and merged a file that you are in the process of changing. This can result in a conflict and you won't be able to merge your PR. First you need to bring your branch up-to-date with upstream. While on your `<name-of-branch>` do
    ```
    git fetch upstream
    git rebase upstream/master
    ```
    Then go ahead and [Resolve a merge conflict from the command line](https://help.github.com/articles/resolving-a-merge-conflict-from-the-command-line/).

14. When the Editorial Review is complete and the button is green, [Merge It](CONTRIBUTING.md#merge-it)!

15. Update your repo
    ```bash
    git checkout master
    git pull --rebase upstream master
    git push
    ```

## Tips and Tricks

### Git prompt and completion

1. Download [git-prompt.sh](https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh) and save it in your home directory as .git-prompt.sh
1. Download [git-completion.bash](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash) and save it in your home directory as .git-completion.bash
1. Add the following to your .bash_profile in your home directory

```bash
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM=1
source ~/.git-prompt.sh
source ~/.git-completion.bash
```

## Help

* [Understanding the GitHub Flow](https://guides.github.com/introduction/flow/index.html)
* [Mastering GitHub Issues](https://guides.github.com/features/issues/)
* [GitHub Help](https://help.github.com/)
* GitHub help in Slack channel #git-support-group
* deconst help in Slack channel #deconst
