#!/bin/sh
#
# This script allows you to enter a docker container shell within a running container
# alias enter-container= "/path/to/enter-docker-shell.sh"
echo "Choose desired shell (bash is most common, for containers without bash try sh)..."
SHELL=$(gum choose "bash" "sh" "zsh") &&
CONTAINER=$(docker container list | gum choose | sed -e 's/^[ \t]*//' | cut -d " " -f1)

# (tr -s ' ') replaces whitespace with single space then (sed -e 's/^[ \t]*//') removes leading whitespace and finally (cut -d " " -f2) separates the line by spaces and selects the second field 

docker exec -it $CONTAINER /bin/$SHELL
