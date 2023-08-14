#!/bin/bash

CHANNEL_ID=UCdhWEif3MQbYy5EJDc3BfSA
VIDEOS_XML="https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
VIDEO_URLS=$(curl -s "$VIDEOS_XML" | grep -o 'https://www.youtube.com/watch?v=[^"]*')

help ()
{
  echo "Usage: $0 [-t] for title of video [-u] for id of video [-c] to create markdown"
}

title ()
{
  curl -s "$VIDEOS_XML" | grep -o '<media:title>[^<]*' | cut -d'>' -f2 | head -n 1
}

url_id () 
{
  echo "$VIDEO_URLS" | head -n 1 | cut -d'=' -f2
}

MARKDOWN_TITLE="$(title | awk '{print tolower($0)}'| tr ' ' '-').md"
FILE_PATH="$HOME/Public/myblog/_posts/$(date +%F-$MARKDOWN_TITLE).md"
create_markdown () {
  cat <<EOF > $FILE_PATH
---
layout: post 
title: $title
date: $(date +%F)
author: Simon
categories: youtube 
---

<div class="video-container">
  <iframe src="https://www.youtube-nocookie.com/embed/$(url_id)" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</div>
EOF
}

# update () 
# {
#   git add $FILE_PATH
#   git commit "Add $MARKDOWN_TITLE"
#   git push -u origin master 
# }

while getopts ":tulh" options; do
  case $options in
    t) title ;;
    u) url_id ;;
    l) create_markdown ;;
    h) help ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      echo $(help)
      exit 1
      ;;
  esac
done

if [ $OPTIND -eq 1 ]; then
  echo $(help)
fi
