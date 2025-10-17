function tag2title() {
  case "$1" in
    c)
      echo "C"
    ;;
    data-structures)
      echo "Data structures"
    ;;
    lua)
      echo "Lua"
    ;;
    featured)
      echo "Featured articles"
    ;;
    beginner)
      echo "For the beginners"
    ;;
    misc)
      echo "Miscellaneous"
    ;;
    algorithms)
      echo "Algorithms"
    ;;
    love2d)
      echo "Löve2D"
    ;;
    playdate)
      echo "Playdate"
    ;;
    gamedev)
      echo "Game Development"
      ;;
    vim)
      echo "NeoVim/Vim"
    ;;
    web)
      echo "Web Development"
    ;;
   humor)
      echo "Humor"
    ;;
  design-patterns)
      echo "Design patterns"
      ;;
  zx)
      echo "ZX Spectrum"
    ;;
    *)
      echo "Timeline"
    ;;
  esac
}