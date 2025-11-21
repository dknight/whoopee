#!/bin/bash

source "./layout/util.sh"

function logo {
  img="<picture>"
  img="$img<source srcset=\"/assets/img/dragon-static-256.gif\" media=\"(prefers-reduced-motion: reduce)\">"
  img="$img<img src=\"/assets/img/dragon-anim-256.gif\" width=\"256\" height=\"256\" alt=\"${BLOG_TITLE}\" class=\"logo\">"
  img="$img</picture>"
  if [[ $(is_index) = 0 ]]; then
    echo "<a href=\"/\">$img</a>"
  else
    echo "$img"
  fi
}

function toolbox_link {
  if [[ "$POST_URL" == *"lua-toolbox"* ]]; then
   echo '<a class="mainmenu-toolbox active">Lua Toolbox</a>'
  else
    echo '<a href="/post/lua-toolbox.html" class="mainmenu-toolbox">Lua Toolbox</a>'
  fi
}

cat << __HEADER__
  <header>
    $(logo)
    <nav class="mainmenu">
      $(toolbox_link)
      <a href="/me/" class="mainmenu-about">About</a>
      <a href="/feed.xml" class="mainmenu-rss">RSS</a>
    </nav>
  </header>
__HEADER__
