#!/bin/bash
#
# A collection of bash functions to make
# command-line git a little easier to work
# with.
#
# @licence MIT
# @author Nick Pyett <contact@nickpyett.co.uk>
# @copyright Nick Pyett

gitishTextGreen="\033[0;32m"
gitishTextRed="\033[0;31m"
gitishTextNormal="\033[0m"
gitishTextWeightBold="$(tput bold)"
gitishTextWeightNormal="$(tput sgr0)"

#######################################
# Show git status in short format with
# numbered files for use with add_n().
#
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
#######################################
gitish::status_n() {
    echo -e "## ${gitishTextGreen}$(gitish::branch_name)${gitishTextNormal}"

    IFS=$'\r\n' GLOBIGNORE='*' gitStatusFiles=($(git status -s))

    if [ "${gitStatusFiles}" = "" ]
        then
            return
    fi

    count=1

    for line in "${gitStatusFiles[@]}"
    do
        echo -e "${gitishTextGreen}${line:0:1}${gitishTextRed}${line:1:1}${gitishTextNormal} [${count}] ${line:3}"
        ((count++))
    done
}

#######################################
# Show the current branch name with no
# other information.
#
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
#######################################
gitish::branch_name() {
    git branch --show-current;
}

#######################################
# Set the current branch to track the
# upstream branch in the origin remote.
#
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
#######################################
gitish::set_upstream() {
    echo "Running ${gitishTextWeightBold}git push --set-upstream origin $(gitish::branch_name)${gitishTextWeightNormal}..."
    git push --set-upstream origin $(gitish::branch_name)
}

#######################################
# Add the file(s) to the index identified
# by the number from status_n().
#
# Globals:
#     None
# Arguments:
#     File number(s) to add from status_n()
# Returns:
#     None
#######################################
gitish::add_n() {
    if [ $# -eq 0 ]
        then
            echo "gitish::add_n: Please pass the file path ${gitishTextRed}number(s)"
            return
    fi

    IFS=$'\r\n' GLOBIGNORE='*' gitStatusFiles=($(git status -s))

    for arg;
    do
        fileNumber=$(($arg - 1));
        fileStatus=${gitStatusFiles[${fileNumber}]}

        if [ "${fileStatus}" = "" ]
            then
                echo "gitish::add_n: File path not found with number ${arg}"
                continue
        fi

        filePath=${fileStatus:3}

        echo "Adding file ${gitishTextWeightBold}${filePath}${gitishTextWeightNormal} to index"

        git add ${filePath}
    done
}

#######################################
# Add the file(s) to the index identified
# by the number from status_n() and commit.
#
# Globals:
#     None
# Arguments:
#     File number(s) to unstage from status_n()
# Returns:
#     None
#######################################
gitish::commit_n() {
    if [ $# -eq 0 ]
        then
            echo "gitish::commit_n: Please pass the file path ${gitishTextRed}number(s)"
            return
    fi

    gitish::add_n "$@" && git commit
}

#######################################
# Remove the file(s) from the index
# identified by the number from status_n().
#
# Globals:
#     None
# Arguments:
#     File number(s) to unstage from status_n()
# Returns:
#     None
#######################################
gitish::unstage_n() {
    if [ $# -eq 0 ]
        then
            echo "gitish::unstage_n: Please pass the file path ${gitishTextRed}number(s)"
            return
    fi

    IFS=$'\r\n' GLOBIGNORE='*' gitStatusFiles=($(git status -s))

    for arg;
    do
        fileNumber=$(($arg - 1));
        fileStatus=${gitStatusFiles[${fileNumber}]}

        if [ "${fileStatus}" = "" ]
            then
                echo "gitish::unstage_n: File path not found with number ${arg}"
                return
        fi

        filePath=${fileStatus:3}

        echo "Unstaging file ${gitishTextWeightBold}${filePath}${gitishTextWeightNormal} from index"

        git reset HEAD ${filePath}
    done
}

#######################################
# Show a list of numbered branches.
#
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
#######################################
gitish::branch_n() {
    echo -e "## ${gitishTextGreen}$(gitish::branch_name)${gitishTextNormal}"

    IFS=$'\r\n' GLOBIGNORE='*' gitBranches=($(git branch))

    if [ "${gitBranches[1]}" = "" ]
        then
            echo "gitish::branch_n: Repository only contains a ${gitishTextRed}single${gitishTextNormal} branch"
            return
    fi

    count=1

    for line in "${gitBranches[@]}"
    do
        echo -e "${line:0:1}${gitishTextNormal} [${count}] ${line:2}"
        ((count++))
    done
}

#######################################
# Checkout a branch based on the number
# from branch_n().
#
# Globals:
#     None
# Arguments:
#     Branch number from branch_n()
# Returns:
#     None
#######################################
gitish::checkout_n() {
    if [ $# -eq 0 ]
        then
            echo "gitish::checkout_n: Please pass the branch ${gitishTextRed}number"
            return
    fi

    IFS=$'\r\n' GLOBIGNORE='*' gitBranches=($(git branch))

    if [ "${gitBranches[1]}" = "" ]
        then
            echo "Repository only contains a single branch"
            return
    fi

    branchNumber=$(($1));
    branchName=${gitBranches[${branchNumber}]:2}

    if [ -z "${branchName}" ]
        then
            echo "gitish::checkout_n: Branch not found with number ${gitishTextRed}${1}"
            return
    fi

    echo "Checking out branch ${gitishTextWeightBold}\"${branchName}\""

    git checkout ${branchName}
}

#######################################
# Add all the files to the index.
#
# Globals:
#     None
# Arguments:
#     None
# Returns:
#     None
#######################################
gitish::add_a() {
    git add -A
}

#######################################
# Checkout a new branch.
#
# Globals:
#     None
# Arguments:
#     New branch name
# Returns:
#     None
#######################################
gitish::branch_new() {
    if [ "$1" = "" ]
        then
            echo "gitish::branch_new: Please provide a ${gitishTextRed}branch name"
            return
    fi

    git checkout -b $1
}

#######################################
# Checkout a new feature branch.
#
# Globals:
#     None
# Arguments:
#     New feature branch name
# Returns:
#     None
#######################################
gitish::branch_new_feature() {
    if [ "$1" = "" ]
        then
            echo "gitish::branch_new_feature: Please provide a ${gitishTextRed}feature branch name"
            return
    fi

    git checkout -b feature/$1
}

#######################################
# Checkout a new hotfix branch.
#
# Globals:
#     None
# Arguments:
#     New feature branch name
# Returns:
#     None
#######################################
gitish::branch_new_hotfix() {
    if [ "$1" = "" ]
        then
            echo "gitish::branch_new_hotfix: Please provide a ${gitishTextRed}hotfix branch name"
            return
    fi

    git checkout -b hotfix/$1
}
