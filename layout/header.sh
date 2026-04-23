#!/bin/bash

source "./layout/util.sh"

function logo {
  img="<div class="logo-wrapper"><span lang="ja-Kana">やったー!</span></div>"
  if [[ $(is_index) = 0 ]]; then
    echo "<a href=\"/\" class=\"logo-link\">$img</a>"
  else
    echo "$img"
  fi
}

function lua_toolbox_link {
  if [[ "$POST_URL" == *"lua-toolbox"* ]]; then
   echo '<a class="lua-mainmenu-toolbox active">Lua Toolbox</a>'
  else
    echo '<a href="/post/lua-toolbox.html" class="lua-mainmenu-toolbox">Lua Toolbox</a>'
  fi
}

function nes_toolbox_link {
  if [[ "$POST_URL" == *"nes-toolbox"* ]]; then
   echo '<a class="nes-mainmenu-toolbox active">NES Toolbox</a>'
  else
    echo '<a href="/post/nes-toolbox.html" class="nes-mainmenu-toolbox">NES Toolbox</a>'
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
      $(nes_toolbox_link)
      $(lua_toolbox_link)
      $(about_link)
      <a href="/feed.xml" class="mainmenu-rss">RSS</a>
    </nav>
  </header>
  <hr>
__HEADER__
