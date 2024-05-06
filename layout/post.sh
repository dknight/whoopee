#!/bin/bash

cat << _EOF_
<!DOCTYPE html>
<html lang="en">
  <head>
    $( . ./layout/head.sh )
  </head>
  <body>
    <div class="wrap">
    $( . ./layout/header.sh )
    <main class="post">
      <article>
        <a href="/"><em>&larr; Back to index page</em></a>
        <h1>$POST_TITLE</h1>
        <time datetime="$(date -d "$POST_DATE" +%Y-%m-%d)">
          $(date -d "$POST_DATE" +"%B %d, %Y")
        </time>
        $(echo "$POST_CONTENTS")

        <!-- <div class="tags">$(for i in $TAGS; do echo "<a href=\"../tag/$i\">$i</a>"; done;)</div> -->

        </article>
    </main>
    $( . ./layout/footer.sh )
    </div>
  </body>
</html>
_EOF_

