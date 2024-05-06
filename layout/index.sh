#!/bin/bash

# space-separated skip pages in index
SKIP="about.html"

# Break apart the LIST payload
IFS='✂︎' read -r -a array <<< "$LIST"

function index_loop {
  for (( idx=${#array[@]}-1 ; idx>=0 ; idx-- )) ; do
    [ "${array[idx]}" ] && eval "${array[idx]} list_item $1"
  done
}

function list_item {
  if [[ -n "$1" ]] && [[ "$TAGS" != *"$1"* ]]; then
    return
  fi
  if [ -z "$BREAK" ]; then
    # Skip about
    if [[ "$POST_URL" =~ "$SKIP" ]]; then
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

function nav {
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

cat << _EOF_
<!DOCTYPE html>
<html lang="en">
  <head>
    $(source ./layout/head.sh)
  </head>
  <body>
    <div class="wrap">
      $(source ./layout/header.sh)
      <main>
        <section class="articles">
          <h2>Articles</h2>
          <ul class="list-reset">
            $(index_loop)
          </ul>
        </section>
        <section class="articles">
          <h2>Featured articles <span class="featured">&#9733;</span></h2>
          <ul class="list-reset">
            $(index_loop "feature")
          </ul>
        </section>
      </main>
      $(nav)
      $(source ./layout/footer.sh)
    </div>
  </body>
</html>
_EOF_
