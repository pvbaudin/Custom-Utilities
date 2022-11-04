#!/bin/sh
#
# This script allows you to search running processes and kill the selected process
# alias kill-task= "/path/to/search-and-kill-task.sh"

PROC=$(ps ax | gum filter)

# (tr -s ' ') replaces whitespace with single space then (sed -e 's/^[ \t]*//') removes leading whitespace and finally (cut -d " " -f2) separates the line by spaces and selects the second field 

gum confirm "Kill Process: $PROC ?" && kill -9 $(echo  "$PROC" | tr -s ' ' | sed -e 's/^[ \t]*//' | cut -d " " -f1)
