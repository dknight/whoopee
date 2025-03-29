#!/bin/bash

source "./layout/util.sh"

# Break apart the LIST payload
IFS='✂︎' read -r -a array <<< "$LIST"

function index_loop {
  for (( idx=${#array[@]}-1 ; idx>=0 ; idx-- )) ; do
    [ "${array[idx]}" ] && eval "${array[idx]} list_item"
  done
}

function list_item {
  # Skip about
  if [[ $(is_skipped) = 1 ]]; then
    return
  fi
  NORM_POST_URL="${POST_URL/.\/..\//}"
  POST_CONTENTS=$(cat "./docs/$NORM_POST_URL")
  PUBDATE=$(date -Rd "$POST_DATE_RFC822")
cat << _LOOP_
<item>
  <guid>$BLOG_HOST$NORM_POST_URL</guid>
  <title>$POST_TITLE</title>
  <link>$BLOG_HOST$NORM_POST_URL</link>
  <description>$(get_description)</description>
  <pubDate>$PUBDATE</pubDate>
</item>
_LOOP_
}

cat << _EOF_
<?xml version="1.0"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
  <title>$BLOG_TITLE</title>
  <link>$BLOG_HOST</link>
  <description>$(get_default_description)</description>
  <atom:link href="https://www.whoop.ee/feed.xml" rel="self" type="application/rss+xml"/>
  $(index_loop)
</channel>
</rss>
_EOF_
