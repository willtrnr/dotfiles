export NNN_TMPFILE="$HOME/.nnncd"

function n() {
  nnn "$@"
  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm "$NNN_TMPFILE"
  fi
}

alias ncp='cat "$HOME/.nnncp"'
