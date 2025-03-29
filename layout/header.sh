#!/bin/bash

source "./layout/util.sh"

function logo {
  img="<img src=\"/assets/img/whoopee-logo.png\" width=\"200\" height=\"172\" alt=\"${BLOG_TITLE}\" class=\"logo\">"
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
