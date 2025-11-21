#!/bin/bash

source "./layout/util.sh"

if [[ -n "$TAGNAME" ]]; then
  title="$(tag2title $TAGNAME) &mdash; $BLOG_TITLE"
elif [[ -z "$POST_TITLE" ]]; then
  title="$BLOG_TITLE &mdash; $BLOG_SUBTITLE"
else
  title="$POST_TITLE &mdash; $BLOG_TITLE"
fi

description=$(get_description)

if [[ -z "$description" ]]; then
  description=$(get_default_description)
fi

canonical="$BLOG_HOST$POST_URL"
if [[ -n "$TAGNAME" ]]; then
  canonical="$BLOG_HOST/tag/$TAGNAME/"
fi

if [[ "$canonical" = "$BLOG_HOST" ]]; then
  canonical="$canonical/"
fi

cat << __HEAD__
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="$description">
<meta name="keywords" content="lua, programming, algorithms, data-structures, gamedev, game development, blog, personal">
<meta name="author" content="Dmitri Smirnov">
<meta property="og:type" content="website">
<meta property="og:url" content="$canonical">
<meta property="og:image" content="$BLOG_HOST/assets/img/whoopee-logo-black.png">
<meta http-equiv="Content-Security-Policy" content="script-src 'self'">
<meta http-equiv="Content-Security-Policy" content="object-src 'none'">
<title>$title</title>
<link rel="preload" href="/assets/fonts/zx-spectrum.woff2" as="font" type="font/woff2" crossorigin>
<link rel="icon" type="image/x-icon" href="/favicon.ico">
<link rel="alternate" type="application/rss+xml" title="RSS Feed" href="/feed.xml">
<link rel="canonical" href="$canonical">

<style>$(lightningcss --minify --bundle "./assets/css/styles.css")</style>
</head>
__HEAD__

