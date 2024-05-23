#!/bin/bash

source "./layout/util.sh"

cat << _EOF_
<!DOCTYPE html>
<html lang="en">
  $(source ./layout/head.sh)
  <body>
    $(source ./layout/header.sh)
    <main>
      $(to_index)
      <article>
        <h1>$POST_TITLE</h1>
        <time datetime="$(date -d "$POST_DATE" +%Y-%m-%d)">
          $(date -d "$POST_DATE" +"%B %d, %Y")
        </time>
        $$POST_CONTENTS
        $(feedback)
      </article>
      $(to_index)
    </main>
    $(source ./layout/footer.sh)
  </body>
</html>
_EOF_

# <!-- <div class="tags">$(for i in $TAGS; do echo "<a href=\"../tag/$i\">$i</a>"; done;)</div> -->

