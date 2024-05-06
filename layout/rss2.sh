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
  if [[ "$POST_URL" =~ "/post/about" ]]; then
    return
  fi
cat << _LOOP_
<item>
  <title>$(echo $POST_TITLE)</title>
  <link>$(echo $BLOG_HOST)$(echo $POST_URL)</link>
  <description></description>
  <pubDate>$(echo $POST_DATE_RFC822)</pubDate>
</item>
_LOOP_
}

cat << _EOF_
<?xml version="1.0" ?>
<rss version="2.0">
<channel>
  <title>$(echo $BLOG_TITLE)</title>
  <link>$(echo $BLOG_HOST)</link>
  <description>$(get_default_description)</description>

  $(index_loop)

</channel>
</rss>
_EOF_

