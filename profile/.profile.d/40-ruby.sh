#!/usr/bin/env sh

if command -v ruby >/dev/null; then
  # shellcheck disable=SC2155
  export PATH="$(ruby -e 'print Gem.user_dir')/bin${PATH:+:${PATH}}"
fi
