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
cat << _LOOP_
  <li>
    <time datetime="$(date -d "$POST_DATE" +%Y-%m-%d)">
      $(date -d "$POST_DATE" +%Y-%m-%d)
    </time>
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

function articles_title() {
  case "$TAGNAME" in
    data-structures)
      echo "Data structures"
    ;;
    lua)
      echo "Lua"
    ;;
    featured)
      echo "Featured articles"
    ;;
    *)
      echo "All articles"
    ;;
  esac
}

function taglink() {
  if [[ "$TAGNAME" = "$1" ]]; then
    echo "<strong>$2</strong>"
  else
    echo "<a href=\"/tag/$1/\">$2</a>"
  fi
}

cat << _EOF_
<!DOCTYPE html>
<html lang="en">
  <head>
    $(source ./layout/head.sh)
  </head>
    <div class="wrap">
      $(source ./layout/header.sh)
      <main>
      $(to_index)
        <nav class="tags">
          <strong>Tags:</strong>
          <ul class="list-reset">
            <li>$(taglink "lua" "Lua")</li>
            <li>$(taglink "data-structures" "Data structures")</li>
            <li>$(taglink "featured" "Featured articles")</li>
          </ul>
        </nav>
        <section class="articles">
          <h1>$(articles_title)</h1>
          <ul class="list-reset">
            $(index_loop)
          </ul>
        </section>
      </main>
      $(nav)
      $(source ./layout/footer.sh)
    </div>
  </body>
</html>
_EOF_

# Sitemaps
sitemap="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
sitemap="$sitemap<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
while tag in $TAGS; do
  echo $tag"!"
done
sitemap="$sitemap\t<url>\n"
sitemap="$sitemap\t\t<loc>${BLOG_HOST}</loc>\n"
sitemap="$sitemap\t\t<lastmod>$(date +"%Y-%m-%d")</lastmod>\n"
sitemap="$sitemap\t</url>\n"
for (( idx=${#array[@]}-1 ; idx>=0 ; idx-- )); do
  if [ "${array[idx]}" ]; then
    eval "${array[idx]}"
    sitemap="$sitemap\t<url>\n"
    sitemap="$sitemap\t\t<loc>${BLOG_HOST}${POST_URL/"./.."/}</loc>\n"
    sitemap="$sitemap\t\t<lastmod>${POST_DATE//\//-}</lastmod>\n"
    sitemap="$sitemap\t</url>\n"
  fi
done
sitemap="$sitemap</urlset>"

source "./.blogrc"
echo -e "$sitemap" > "$DIST/sitemap.xml"