#!/bin/bash

cat << __FOOTER__
  <footer>
    <hr>
    <p>
      This website <strong>does not</strong> use cookies and
      any tracking techniques either. Also this page is fully
      accessible, responsive, readable on any device without any
      single line of <abbr title="Tool of evil">JavaScript</abbr>.
    </p>
    <p>
      &copy; 2022&mdash;$(date +%Y) <a href="/about.html">xdknight</a>
      <a href="https://github.com/dknight/whoopee">Source code</a>.
      Powered by <a href="https://github.com/hmngwy/jenny">Jenny</a> shell
      blog engine.
    </p>
  </footer>
__FOOTER__
