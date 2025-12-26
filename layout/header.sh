#!/bin/bash

source "./layout/util.sh"

function logo {
  img="<img src=\"/assets/img/dra02.gif\" alt=\"Whoopee!\" class=\"logo\">"
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

function about_link {
  if [[ "$POST_URL" == *"about"* ]]; then
   echo '<a class="mainmenu-about active">About</a>'
  else
    echo '<a href="/post/about.html" class="mainmenu-about">About</a>'
  fi
}

cat << __HEADER__
  <header>
    $(logo)
    <nav class="mainmenu">
      $(toolbox_link)
      $(about_link)
      <a href="/feed.xml" class="mainmenu-rss">RSS</a>
    </nav>
  </header>
__HEADER__
