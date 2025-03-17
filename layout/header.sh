#!/bin/bash

source "./layout/util.sh"

function logo {
  img="<img src=\"/assets/img/dragon-logo.gif\" width=\"200\" height=\"172\" alt=\"${BLOG_TITLE}\" class=\"logo\">"
  if [[ $(is_index) = 0 ]]; then
    echo "<a href=\"/\">$img</a>"
  else
    echo "$img"
  fi
}

cat << __HEADER__
  <header>
    $(logo)
    <nav class="mainmenu">
      <a href="/me/">About</a>
      <a href="/feed.xml">RSS</a>
    </nav>
  </header>
__HEADER__
