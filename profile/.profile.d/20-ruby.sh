#! /bin/env sh

if (command -v ruby > /dev/null); then
  export PATH="$(ruby -e 'print Gem.user_dir')/bin${PATH:+:${PATH}}"
fi
