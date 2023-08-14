#!/bin/bash

CHANNEL_ID=UCdhWEif3MQbYy5EJDc3BfSA
VIDEOS_XML="https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
VIDEO_URLS=$(curl -s "$VIDEOS_XML" | grep -o 'https://www.youtube.com/watch?v=[^"]*')
GIT_REPO_DIR="$HOME/Public/myblog"

title ()
{
  curl -s "$VIDEOS_XML" | grep -o '<media:title>[^<]*' | cut -d'>' -f2 | head -n 1
}

url_id () 
{
  echo "$VIDEO_URLS" | head -n 1 | cut -d'=' -f2
}


create_markdown () {
  MARKDOWN_TITLE="$(title | awk '{print tolower($0)}'| tr ' ' '-')"
  FILE_PATH="$GIT_REPO_DIR/_posts/$(date +%F-$MARKDOWN_TITLE).md"
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

update () 
{
  cd "$GIT_REPO_DIR"
  git add "$FILE_PATH"
  git commit "Add $MARKDOWN_TITLE"
  git push -u origin master 
}

create_markdown
update
