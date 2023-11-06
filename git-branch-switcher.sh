#!/bin/zsh

# Check if the .git directory exists in the current directory
if [ -d .git ]; then
  git switch $(git branch -a | fzf)
else
  echo "Oops, not a Git repository."
fi
