#!/usr/bin/env sh

export PATH="${HOME}/.nodebrew/current/bin${PATH:+:${PATH}}"

if command -v yarn >/dev/null; then
  export PATH="$(yarn global bin 2> /dev/null)${PATH:+:${PATH}}"
fi
