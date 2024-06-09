gitish.sh
=========

Bash script to add aliases to your command line for git.

&copy; Nick Pyett 2024

## Installation with Bash Aliases

Clone the repo and add support for the gitish.sh commands and aliases to your terminal. This will add source commands to your `~/.bashrc` file; ammend the command to add to a different bash profile file.

    # git clone https://github.com/nickpyett/gitish.sh.git
    # echo -en "\n# gitish\nsource $(pwd)/gitish.sh/gitish.sh\nsource $(pwd)/gitish.sh/bash-aliases.sh\n" >> ~/.bashrc
