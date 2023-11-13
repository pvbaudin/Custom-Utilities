#!/bin/zsh

BRANCH=$(git branch -a | gum filter)
SELECTED_FILE=$(git ls-tree -r $(git branch --show-current) --name-only | gum filter)

if [ -n "$SELECTED_FILE" ]; then
  SELECTED_FILE=$(echo "$SELECTED_FILE" | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
  git show $(echo "$BRANCH:$SELECTED_FILE") > INCOMING
  touch temp2
  gum confirm "merging changes from $BRANCH:$SELECTED_FILE, continue?" && \
    git merge-file $(echo "$SELECTED_FILE") temp2 INCOMING

  rm INCOMING
  rm temp2
  echo "here"
else
    echo "No file selected. Exiting."
fi

