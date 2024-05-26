#!/bin/bash

source "./layout/util.sh"

# Break apart the LIST payload
IFS='✂︎' read -r -a array <<< "$LIST"

function index_loop() {
  for (( idx=${#array[@]}-1 ; idx>=0 ; idx-- )) ; do
    [ "${array[idx]}" ] && eval "${array[idx]} list_item $1"
  done
}

function list_item() {
  if [[ -n "$1" ]] && [[ "$TAGS" != *"$1"* ]]; then
    return
  fi
  if [ -z "$BREAK" ]; then
    # Skip $SKIP
    if [[ $(is_skipped) = 1 ]]; then
        return
    fi
  date=$(date -d "$POST_DATE" +%Y-%m-%d)
cat << _LOOP_
  <li>
    <time datetime="$date">$date</time>
    <a href="$URL_PREFIX$POST_URL">$POST_TITLE</a>
  </li>
_LOOP_
  else
cat << _LOOP_
  <li><a href="./page/$BREAK.html">In page $BREAK</a></li>
_LOOP_
  fi
}

function nav() {
  # if [ "$PAGE_OLD" ] || [ "$PAGE_NEW" ]; then
# cat << _NAV_
  #  <nav>
  #   $([ "$PAGE_NEW" ] && echo "<a href=\"$PAGE_NEW\">← NEWER</a>")
  #   $([ "$PAGE_OLD" ] && echo "<a href=\"$PAGE_OLD\">OLDER →</a>")
  #  </nav>
# _NAV_
  # fi
  return
}

function tag2title() {
  case "$1" in
    data-structures)
      echo "Data structures and Algorithms"
    ;;
    lua)
      echo "Lua common"
    ;;
    featured)
      echo "Featured articles"
    ;;
    beginner)
      echo "For the beginners"
    ;;
    *)
      echo "All articles"
    ;;
  esac
}

function taglink() {
  title=$(tag2title "$1")
  if [[ "$TAGNAME" = "$1" ]]; then
    echo "<strong>$title</strong>"
  else
    echo "<a href=\"/tag/$1/\">$title</a>"
  fi
}

cat << _EOF_
<!DOCTYPE html>
<html lang="en">
  $(source ./layout/head.sh)
  <body>
    $(source ./layout/header.sh)
    <main>
    $(to_index)
      <nav class="tags">
        <strong>Tags:</strong>
        $(taglink "lua")
        $(taglink "beginner")
        $(taglink "data-structures")
        <!-- $(taglink "featured") -->
      </nav>
      <section class="articles">
        <h1>$(tag2title "$TAGNAME")</h1>
        <ul class="list-reset">
          $(index_loop)
        </ul>
      </section>
    </main>
    $nav
    $(source ./layout/footer.sh)
  </body>
</html>
_EOF_

# Sitemaps
tags=""
if [[ -z "$TAGNAME" ]]; then
  sitemap="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
  sitemap="$sitemap<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"

  # Index
  sitemap="$sitemap\t<url>\n"
  sitemap="$sitemap\t\t<loc>${BLOG_HOST}</loc>\n"
  sitemap="$sitemap\t\t<lastmod>$DATE_NOW</lastmod>\n"
  sitemap="$sitemap\t</url>\n"

  # Posts
  for (( idx=${#array[@]}-1 ; idx>=0 ; idx-- )); do
    if [ "${array[idx]}" ]; then
      eval "${array[idx]}"
      tags="$tags $TAGS"
      sitemap="$sitemap\t<url>\n"
      sitemap="$sitemap\t\t<loc>${BLOG_HOST}${POST_URL/"./.."/}</loc>\n"
      sitemap="$sitemap\t\t<lastmod>${POST_DATE//\//-}</lastmod>\n"
      sitemap="$sitemap\t</url>\n"
    fi
  done

  # Tags
  tags=$(echo $tags | tr " " "\n" | sort -u)
  for tag in $tags; do
    sitemap="$sitemap\t<url>\n"
    sitemap="$sitemap\t\t<loc>${BLOG_HOST}/tag/$tag/</loc>\n"
    sitemap="$sitemap\t\t<lastmod>$DATE_NOW</lastmod>\n"
    sitemap="$sitemap\t</url>\n"
  done
  sitemap="$sitemap</urlset>"

  source "./.blogrc"
  echo -e "$sitemap" > "$DIST/sitemap.xml"
fi