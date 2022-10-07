# Contributing to Zeffiro Interface

These instruction cover how one should proceed, should they wish to partake in developing Zeffiro Interface. Use of Git in a terminal emulator and shell of your choice has to be mastered to some extent, although the basic workflow will be covered here.

## Git practices

### Forking the project

To start off, one has to *fork* the project, as in create a copy of it on GitHub / GitLab / other VCS website. This is usually achieved by pressing a <kbd>Fork</kbd> button on the main page of the project repository and choosing one's user name or organization, under which the repository copy will be created. Once this is done, one can move onto cloning the project.

### Cloning the project

To start off, clone the copy or fork of the original repository with the shell command

    git clone <fork url>

where `<fork url>` is the address of the repository copy, which you can usually get by pressing the <kbd>Clone</kbd> or <kbd>Code</kbd> button on the main fork page. Once this is done, a folder `zeffiro_interface` will be placed in the directory where you ran the `git clone` command.

**Note:** there are usually both HTTPS- and SSH-addresses presented behind the <kbd>Clone</kbd> or <kbd>Code</kbd> buttons. SSH-should be preferred, and instructions on setting it up can be found on GitHub ([link][ssh]).

[ssh]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### Setting up a connection to the main repository

As new updates are pushed to the original repository, you might need to update your copy or fork with these changes every now and then. To this end we add the original repository as another *remote* :

    git remote add upstream git@github.com:sampsapursiainen/zeffiro_interface.git

While we're at it, we might change the name of our fork to something more descriptive:

    git remote rename origin our-fork

Now the command

    git remote -v

should print our remote repositories as follows:

    our-fork (push) <our fork url>
    our-fork (pull) <our fork url>
    upstream (push) <upstream url>
    upstream (pull) <upstream url>

Now we are ready to start contributing.

### Branching to make changes

Whenever one wishes to change or add something in or to the project, a Git *branch* has to be made for the changes. The changes can be merged to the main branch `main_development_branch` later, and while the branch is being edited the changes made to it will not bother other developers. Create a new branch by navigating to the head of the main branch with

    git checkout main_development_branch

and running

    git checkout -b <branch-name>

where `<branch-name>` should describe the feature that is being developed on it. Finally, push the new branch into the repository fork with

    git push -u my-fork <branch-name>

Subsequent pushes to the new branch are done the same way, except without the `-u` flag.

### Making pull or merge requests

Let us say that you have now worked on a new branch `feature_branch` for a while and have deemed the feature ready for merging into the main project repository. To do this, we follow the *update–rebase–copy–squash* -workflow.

This means that before making a pull request you should (1) fetch any changes to `main_development_branch` from `upstream` with

    git fetch --all
    git checkout main_development_branch
    git pull upstream main_development_branch

(2) rebase the feature branch onto `main_development_branch` with

    git rebase main_development_branch feature_branch

**fixing any conflicts that arise during the rebase**, (3) making a copy of `feature_branch` with the name `squashed_feature_branch` with

    git checkout -b squashed_feature_branch

from the head of `feature_branch` and (4) performing a

    git rebase -i main_development_branch

from the head of `squashed_feature_branch` and squashing all commits on the branch into a single commit.

Once these 4 steps are performed, especially the possible conflict fixes during step (2), the update will consist of a single commit on top of `main_development_branch`, which should be automatically mergeable to the main branch without any conflicts arising. The original commits are still available on `fearure_branch` if one performs a `git checkout` on it.

## Programming practises

TODO
