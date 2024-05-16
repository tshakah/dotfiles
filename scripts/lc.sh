#!/usr/bin/env bash

## lc.sh
## Artium Nihamkin
## August 2013
##
## This script will to run "lsd" or "bat" depending the type of the input.
##
## Examples where "lsd" is invoked:
##    ./lc.sh file.txt
##    ./lc.sh
## Examples where "bat" is invoked
##    ./lc.sh ~/directory.name
##    ./lc.sh does.not.exist
##    echo "xxx" | ./lc.sh
##

# If stdin present, assume user meant bat
#
if [ ! -t 0 ]
then
    bat -p "$@"
    exit
fi

# Find the argument that is file/directory name and test it
# to find out if it is an existing directory. Other arguments are
# options and thus will begin with an "-".
#
for v in "$@"
do
    if [ '-' != `echo "$v" | cut -c1 ` ]
    then
        if [ -d "$v" ]
        then
            # A directory, use "lsd".
            #
            lsd --color=auto "$@"
            exit
         else
            # Not a directory, use 'bat'.
            # If this is not a file or a directory then bat will
            # print an error message:
            # bat: xxx: No such file or directory
            #
            bat -p "${@: -1}"
            exit
        fi
    fi
done

# No file name provided, assume the user is trying to ls
# the working directory
#
lsd --color=auto "$@"
