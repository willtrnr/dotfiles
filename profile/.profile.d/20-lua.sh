#! /bin/env sh

if (command -v luarocks > /dev/null); then
  export PATH="$(luarocks path --lr-bin | cut -d: -f1)${PATH:+:${PATH}}"
fi
