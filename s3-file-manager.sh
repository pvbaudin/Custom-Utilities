#!/bin/sh
#
# This script allows you to navigate an s3 object store and select a single file to download

# (tr -s ' ') replaces whitespace with single space then (sed -e 's/^[ \t]*//') removes leading whitespace and finally (cut -d " " -f2) separates the line by spaces and selects the second field 

if [[ -z "$1" ]]; then
    PROFILE="default"
else
    PROFILE=$1
fi

if [[ -z "$2" ]]; then
    BUCKET=$(gum input --placeholder "Enter bucket name with trailing slash")
else
    BUCKET=$2
fi

# while file not selected
while [ -z "$FILE" ]; do

    SELECT=$(gum spin --title="Loading file list..." --show-output -- aws --profile $PROFILE --endpoint https://s3-west.nrp-nautilus.io s3 ls s3://$BUCKET | gum filter)

    if [[ $SELECT == *"PRE"* ]]; then
        #append word after PRE to BUCKET
        BUCKET="$BUCKET$(echo $SELECT | tr -s ' ' | sed -e 's/^[ \t]*//' | cut -d " " -f2)"
        echo "bucket is now:"
        echo $BUCKET
    else
        FILE=$BUCKET$(echo $SELECT | tr -s ' ' | sed -e 's/^[ \t]*//' | cut -d " " -f4)
        gum spin -s line --title="Downloading $FILE" --show-output -- aws --profile $PROFILE --endpoint https://s3-west.nrp-nautilus.io s3 cp s3://$FILE . 

    fi
done