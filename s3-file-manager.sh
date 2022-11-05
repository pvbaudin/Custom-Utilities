#!/bin/sh
#
# This script allows you to navigate an s3 object store and select a single file to download
# todo, go back one directory

# Transform long options to short ones

for arg in "$@"; do
  shift
  case "$arg" in
    '--endpoint')   set -- "$@" '-e'   ;;
    '--profile') set -- "$@" '-p'   ;;
    '--bucket')   set -- "$@" '-b'   ;;
    *)          set -- "$@" "$arg" ;;
  esac
done

while getopts 'b:p:e:' OPTION; do
  case "$OPTION" in
    b)
    #   echo "bucket should be set to $OPTARG"
      avalue="$OPTARG" 
      BUCKET=$OPTARG
      ;;
    p)
    #   echo "profile should be set to $OPTARG"
      avalue="$OPTARG"
      PROFILE=$OPTARG
      ;;
    e)
    #   echo "endpoint should be set to $OPTARG"
      avalue="$OPTARG"
      ENDPOINT=$OPTARG
      ;;
    ?)
      echo "script usage: $(basename \$0) [-e --endpoint url] [-b --bucket] [-p --profile aws-credentials profile (optional)]" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
    PROFILE="default"
fi
if [[ -z "$ENDPOINT" ]]; then
    ENDPOINT=$(gum input --placeholder "No endpoint url provided, Enter endpoint url")
fi

if [[ -z "$BUCKET" ]]; then
    BUCKET=$(gum input --placeholder "No bucket provided, Enter bucket name")
fi

#add trailing slash to BUCKET if not present
if [[ $BUCKET != */ ]]; then
    BUCKET="$BUCKET/"
fi


gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Explore an S3 Object Store' "Endpoint: $ENDPOINT" "Bucket: $BUCKET" "Profile: $PROFILE" 'Download a single file'
# while file not selected
while [ -z "$FILE" ]; do

    SELECT=$(gum spin --title="Loading file list..." --show-output -- aws --profile $PROFILE --endpoint $ENDPOINT s3 ls s3://$BUCKET)
    echo "$SELECT"
    #exit program if no file selected
    if [ -z "$SELECT" ]; then
        exit 0
    fi

    SELECT=$(echo "back\n$SELECT" | gum filter)

    #if select is back, remove last directory from BUCKET
    if [[ $SELECT == "back" ]]; then
        # remove last directory from BUCKET
        BUCKET=$(echo $BUCKET | sed 's/[^/]*[/]$//')
        echo "back"
        echo "bucket is now:"
        echo $BUCKET
    elif [[ $SELECT == *"PRE"* ]]; then
        #append word after PRE to BUCKET
        BUCKET="$BUCKET$(echo $SELECT | tr -s ' ' | sed -e 's/^[ \t]*//' | cut -d " " -f2)"
        echo "bucket is now:"
        echo $BUCKET
        ACTION=$(gum choose "list contents" "download bucket")
        if [[ $ACTION == "download bucket" ]]; then
            gum confirm "Download $BUCKET to current directory?" && gum spin -s line --title="Downloading $FILE" --show-output -- aws --profile $PROFILE --endpoint $ENDPOINT s3 cp --recursive s3://$BUCKET . 
            exit 0
        fi
    else
        FILE=$BUCKET$(echo $SELECT | tr -s ' ' | sed -e 's/^[ \t]*//' | cut -d " " -f4)
        gum confirm "Download $FILE to current directory?" && gum spin -s line --title="Downloading $FILE" --show-output -- aws --profile $PROFILE --endpoint $ENDPOINT s3 cp s3://$FILE . 
        exit 0
    fi
done
echo "no file selected exiting"