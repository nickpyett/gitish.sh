gitish.sh
=========

Bash script to add aliases to your command line for git.

&copy; Nick Pyett 2024

## Installation with Bash Aliases

Clone the repo and add support for the gitish.sh commands and aliases to your terminal. This will add source commands to your `~/.bashrc` file; amend the command to add to a different bash profile file.

    # git clone https://github.com/nickpyett/gitish.sh.git
    # echo -en "\n# gitish\nsource $(pwd)/gitish.sh/gitish.sh\nsource $(pwd)/gitish.sh/bash-aliases.sh\n" >> ~/.bashrc

## Alliases and Commands

# adda

Equivalent of `git add -A`.

Add all files in the working tree to the index.

# addn

Usage: addn <n>

Equivalent of `git add filename-of-updated-file.example`.

Adds a file to the index by number from `stsn`.

## Arguments

### n

The number of the file that has differences to git head as shown in the `stsn` command.



