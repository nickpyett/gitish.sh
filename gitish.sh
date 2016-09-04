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
    IFS=$'\r\n' GLOBIGNORE='*' command eval 'gitStatusFiles=($(git status -s))'

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
    git rev-parse --abbrev-ref HEAD;
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
    if [ "$#" == "0" ]
        then
            echo 'gitish::add_n: Please pass the file path number(s)'
            return
    fi

    IFS=$'\r\n' GLOBIGNORE='*' command eval 'gitStatusFiles=($(git status -s))'

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
    if [ "$#" == "0" ]
        then
            echo 'gitish::commit_n: Please pass the file path number(s)'
            return
    fi

    gitish::add_n $arg && git commit
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
    if [ "$#" == "0" ]
        then
            echo 'gitish::unstage_n: Please pass the file path number(s)'
            return
    fi

    IFS=$'\r\n' GLOBIGNORE='*' command eval 'gitStatusFiles=($(git status -s))'

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
    git checkout -b $1
}
