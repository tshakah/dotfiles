#!/usr/bin/env bash

set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

# This is intended to be used as an alias for git (e.g. `alias git '~/source/dotfiles/scripts/git.sh'`), and checks some
# of the git commands to avoid common mistakes in everyday use. It has to be an alias as git doesn't have hooks to check
# these commands.

# Check parent branch is used when creating a branch, to remind the user that other branches might be more appropriate.
# This tries to prevent branch creation with the wrong parent, e.g. off a feature branch.
function check_parent_branch {
    # If the requested branch exists, just check it out
    git show-ref --verify --quiet refs/heads/"$1"

    if [[ "$?" == 0 ]]; then
        git checkout "$1"
        exit 0
    fi

    # Otherwise shift off the requested branch (storing it for later) and continue
    local newbranch="$1"
    shift

    # Get the current branch
    local branch="$(git rev-parse --abbrev-ref HEAD)"

    # Make sure we actually want to use this branch as the parent of the new one
    #(if we aren't branching off main/master).
    if [[ "$branch" != "master" ]] && [[ "$branch" != "main" ]]; then
        while read -p "`echo -e '\e[1m'`You are branching off `echo -e '\e[33m'`$branch`echo -e '\e[0m'`.
Are there any earlier branches that you could use (y/n)?
`echo -e '\e[0m';`" yn; do
            case ${yn:0:1} in
                Y|y )
                    echo -e '\n\e[31m\e[1mCANCELLING\e[0m\n';
                    exit 1
                ;;
                N|n )
                    echo -e '';
                    command git "$@";

                    # Now ask about tracking origin
                    ask_about_origin_tracking "$newbranch"

                    break
                ;;
                * )
                    echo -e '\n\e[33m\e[1mPlease answer y (yes) or n (no):\e[0m';
                    continue
                ;;
            esac
        done
    else
        command git "$@"

        # Also ask about tracking origin
        ask_about_origin_tracking "$newbranch"
    fi
}

# When creating a branch we should also ask if the user wants to create/track the origin branch, as it's annoying that
# git doesn't already do this
function ask_about_origin_tracking {
    while read -p "`echo -e '\e[1m'`
Do you want to set up and track `echo -e '\e[33m'`$1`echo -e '\e[0m\e[1m'` on origin as well (y/n)?
`echo -e '\e[0m'`" yn; do
        case ${yn:0:1} in
            Y|y )
                echo -e ''
                command git push -u origin $1;

                if [[ $? == 0 ]]; then
                    echo -e '\n\e[35m\e[1mDone ♥\e[0m\n';
                    exit 0
                else
                    echo -e "\n\e[31m\e[1mI couldn't set up origin tracking!\e[0m\e[1m\n"
                    echo -e 'Please run `\e[33mgit push -u origin HEAD\e[0m\e[1m` manually.\n';
                    exit 1
                fi
            ;;
            N|n )
                echo -e '\n\e[34m\e[1mOkay! You can `\e[33mgit push -u origin HEAD\e[0m\e[34m\e[1m` when you are ready c[_]\e[0m\n';
                exit 0
            ;;
            * )
                echo -e '\n\e[33m\e[1mPlease answer y (yes) or n (no):\e[0m';
                continue
            ;;
        esac
    done
}

if [[ "$1" == "psuh" ]]; then
    # I frequently mistype `git push` as `git psuh`
    shift # remove the "psuh"
    # Call the correct command with the rest of the arguments
    "$0" push "$@"
elif [[ $1 == 'push' ]]; then
    # If force pushing, make sure it's with a lease
    command git $(echo $@ | sed -E 's/\s(-f|--force)/ --force-with-lease/g')
elif [[ "$1" == "exdif" || "$1" == "exdiff" ]]; then
    # Show the exclusive diff for a commit - i.e. only what that commit changed. Uses the supplied (or current) commit.
    commit="${2-$(git rev-parse HEAD)}"
    command git diff $commit~ $commit
elif [[ "$1" == "cleanup" ]]; then
    command git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D "$branch"; done
elif [[ "$1" == "children" ]]; then
    # Find immediate children of the supplied (or current) commit
    parent="${2-$(git rev-parse HEAD)}"
    for commit in $(git rev-parse "$parent"^0); do
        for child in $(git log --format='%H %P' --all | grep -F " $commit" | cut -f1 -d' '); do
            git show -s $child
        done
    done
elif [[ "$1" == "branch" && "$2" == "list" ]]; then
    # I mistype `git branch --list` as `git branch list` all the time - I think because other git commands (like stash)
    # use `list`. This makes sure I don't keep creating new branches called `list`
    command git branch --list
elif [[ "$1" == "branch" && ${2::1} != '-' ]]; then
    # If we aren't passing an argument beginning with `-`, then we are creating a new branch, so check the parent
    check_parent_branch "$2" "$@"
elif [[ "$1" == "tag" && "$2" == "list" ]]; then
    # I also mistype `git tag --list` as `git tag list`, so like the `branch --list` make it do the right thing
    command git tag --list
elif [[ "$1" == "checkout" && "$2" == "-b" ]]; then
    # Checkout with `-b` creates a new branch, so check the parent
    check_parent_branch "$3" "$@"
else
    # Otherwise just run the command
    command git "$@"
fi
