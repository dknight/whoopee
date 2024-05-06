#!/bin/bash

function get_description() {
  local descr_line=$(echo "$POST_CONTENTS" | grep -m 1 "^<!-- [Dd]escription: ")
  echo $descr_line | sed -e 's/<!-- [Dd]escription\:\ *\(.*\)\ *-->/\1/'
}

TS=$(date +%s)

if [[ -z "$POST_TITLE" ]]; then
  title="$BLOG_TITLE" # TODO think out title like Blog about lua
else
  title="$POST_TITLE &ndash; $BLOG_TITLE"
fi

description=$(get_description)

if [[ -z "$description" ]]; then
  description="Website about Lua. Tutorials, best practices, development, and everything else related to small amazing Lua language."
fi

cat << __HEAD__
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<meta name="description" content="$description">
<title>$title</title>
<link rel="icon" type="image/x-icon" href="/assets/favicon.ico">
<link rel="stylesheet" href="/assets/css/styles.min.css?$TS">
<link rel="alternate" type="application/rss+xml" title="RSS Feed" href="/feed.xml">
__HEAD__

