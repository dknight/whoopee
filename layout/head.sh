#!/bin/bash

source "./layout/util.sh"

if [[ -z "$POST_TITLE" ]]; then
  title="$BLOG_TITLE" # TODO think out title like Blog about lua
else
  title="$POST_TITLE &ndash; $BLOG_TITLE"
fi

description=$(get_description)

if [[ -z "$description" ]]; then
  description=$(get_default_description)
fi

cat << __HEAD__
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<meta name="description" content="$description">
<title>$title</title>
<link rel="icon" type="image/x-icon" href="/favicon.ico">
<link rel="stylesheet" href="/assets/css/styles.min.css?$TS">
<link rel="alternate" type="application/rss+xml" title="RSS Feed" href="/feed.xml">
__HEAD__

