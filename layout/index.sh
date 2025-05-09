#!/bin/bash

source "./layout/util.sh"

# Break apart the LIST payload
IFS='✂︎' read -r -a posts <<< "$LIST"

function count_posts_by_year() {
  count=0
  for (( idx=${#posts[@]}-1 ; idx>=0 ; idx-- )); do
    eval "${posts[idx]}"
    year=$(date +%Y --date "$POST_DATE_RFC822")
    if [ "$year" == "$1" ]; then
      count=$(( count + 1 ))
    fi
  done
  echo $count
}

function index_loop() {
  for (( idx=${#posts[@]}-1 ; idx>=0 ; idx-- )) ; do
    if [ "${posts[idx]}" ]; then
      eval "${posts[idx]}"
      if [ "$YEAR" = "$(date +%Y --date="$POST_DATE_RFC822")" ]; then
         list_item "$1"
      fi
    fi
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
  DATE=$(date -d "$POST_DATE_RFC822" +%Y-%m-%d)
cat << _LOOP_
  <li>
    <time datetime="$DATE">$DATE</time>
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
    c)
      echo "C"
    ;;
    data-structures)
      echo "Data structures"
    ;;
    lua)
      echo "Lua"
    ;;
    featured)
      echo "Featured articles"
    ;;
    beginner)
      echo "For the beginners"
    ;;
    misc)
      echo "Miscellaneous"
    ;;
    algorithms)
      echo "Algorithms"
    ;;
    love2d)
      echo "Löve2D"
    ;;
    playdate)
      echo "Playdate"
    ;;
    gamedev)
      echo "Game Development"
      ;;
    vim)
      echo "NeoVim/Vim"
    ;;
    web)
      echo "Web Development"
    ;;
   humor)
      echo "Humor"
    ;;
  design-patterns)
      echo "Design patterns"
    ;;
    *)
      echo "Timeline"
    ;;
  esac
}

function taglink() {
  title=$(tag2title "$1")
  url="$2"
  if [[ "$TAGNAME" = "$1" ]]; then
    echo "<strong aria-current=\"true\">$title</strong>"
  else
    if [[ -z "$url" ]]; then
      echo "<a href=\"/tag/$1/\">$title</a>"
    else
      echo "<a href=\"$2\">$title</a>"
    fi
  fi
}

function by_year() {
  for y in $(eval echo "{$(date +%Y)..2022}"); do
    if [ "$(count_posts_by_year "$y")" != 0 ]; then
cat << _LOOP_
  <h2>$y</h2>
  <ul class="list-reset">
    $(YEAR="$y" index_loop "$1")
  </ul>
_LOOP_
    fi
  done
}

cat << _EOF_
<!DOCTYPE html>
<html lang="en">
  $(source ./layout/head.sh)
  <body>
    $(source ./layout/header.sh)
    <main>
      $(to_index)
      <nav class="tags" aria-labelledby="tags-title">
        <strong id="tags-title">Tags:</strong>
        $(taglink "lua")
        $(taglink "c")
        $(taglink "beginner")
        $(taglink "algorithms")
        $(taglink "data-structures")
        $(taglink "design-patterns" "/post/design-patterns-in-lua.html")
        $(taglink "web")
        $(taglink "vim")
        $(taglink "gamedev")
        $(taglink "love2d")
        $(taglink "playdate")
        $(taglink "humor")
        $(taglink "misc")
      </nav>
      <section class="articles">
        <h1>$(tag2title "$TAGNAME")</h1>
        <ul class="list-reset">
          $(by_year "$1")
        </ul>
      </section>
    </main>
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

  # About
  sitemap="$sitemap\t<url>\n"
  sitemap="$sitemap\t\t<loc>${BLOG_HOST}/me/</loc>\n"
  sitemap="$sitemap\t\t<lastmod>2024-06-17</lastmod>\n"
  sitemap="$sitemap\t</url>\n"

  # Puff
  sitemap="$sitemap\t<url>\n"
  sitemap="$sitemap\t\t<loc>${BLOG_HOST}/puff/</loc>\n"
  sitemap="$sitemap\t\t<lastmod>2024-06-17</lastmod>\n"
  sitemap="$sitemap\t</url>\n"

  # Posts
  for (( idx=${#posts[@]}-1 ; idx>=0 ; idx-- )); do
    if [ "${posts[idx]}" ]; then
      eval "${posts[idx]}"
      tags="$tags $TAGS"
      sitemap="$sitemap\t<url>\n"
      sitemap="$sitemap\t\t<loc>${BLOG_HOST}${POST_URL/"./.."/}</loc>\n"
      sitemap="$sitemap\t\t<lastmod>$(date -d "${POST_DATE_RFC822//\//-}" +%Y-%m-%d)</lastmod>\n"
      sitemap="$sitemap\t</url>\n"
    fi
  done

  # FIXME tags are received, the most probably jenny's bug.
  # Tags
  tags="lua c beginner data-structures algorithms web gamedev love2d humor misc"
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
