#!/bin/bash

source "./layout/util.sh"

function logo {
  if [[ $(is_index) = 0 ]]; then
    echo "<a href=\"/\" class=\"logo\">${BLOG_TITLE}</a>"
  else
    echo "<span class=\"logo\">${BLOG_TITLE}</span>"
  fi
}

cat << __HEADER__
  <header>
    $(logo)
    <nav class="mainmenu">
      <ul class="list-reset">
        <li><a href="/about.html">About</a>
        <li><a href="/feed.xml">RSS</a>
      </ul>
    </nav>
  </header>
__HEADER__
