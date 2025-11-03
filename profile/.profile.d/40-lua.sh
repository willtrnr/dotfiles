#!/usr/bin/env sh

if command -v luarocks >/dev/null; then
  # shellcheck disable=SC2155
  export PATH="$(luarocks path --lr-bin | cut -d: -f1)${PATH:+:${PATH}}"
fi
