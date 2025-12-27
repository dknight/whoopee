#!/bin/bash

source "./layout/util.sh"

post_time=""
if [[ $(is_skipped) = 0 ]]; then
  post_time="<time datetime="$(date -d "$POST_DATE" +%Y-%m-%d)">$(date -d "$POST_DATE" +"%B %d, %Y")</time>"
fi

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
        $post_time
        $POST_CONTENTS
      </article>
      $(to_index)
    </main>
    $(source ./layout/footer.sh)
  </body>
</html>
_EOF_

# <!-- <div class="tags">$(for i in $TAGS; do echo "<a href=\"../tag/$i\">$i</a>"; done;)</div> -->
