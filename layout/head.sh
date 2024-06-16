#!/bin/bash

source "./layout/util.sh"

if [[ -z "$POST_TITLE" ]]; then
  title="$BLOG_TITLE &mdash; Blog about Lua, web-development, etc."
else
  title="$POST_TITLE &mdash; $BLOG_TITLE"
fi

description=$(get_description)

if [[ -z "$description" ]]; then
  description=$(get_default_description)
fi

cat << __HEAD__
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="$description">
<meta name="keywords" content="lua, programming, algorithms, data-structures, gamedev, game development, blog, personal">
<meta name="author" content="Dmitri Smirnov">
<meta property="og:type" content="website">
<meta property="og:url" content="$BLOG_HOST$URL_PREFIX$POST_URL">
<meta property="og:image" content="$BLOG_HOST/assets/img/lua-language.gif">
<meta http-equiv="Content-Security-Policy" content="script-src 'self'">
<meta http-equiv="Content-Security-Policy" content="object-src 'none'">
<title>$title</title>
<link rel="icon" type="image/x-icon" href="/favicon.ico">
<link rel="stylesheet" href="/assets/css/styles.min.css">
<link rel="alternate" type="application/rss+xml" title="RSS Feed" href="/feed.xml">
</head>
__HEAD__
