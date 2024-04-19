#!/usr/bin/env sh

if (command -v pyenv > /dev/null); then
  export PYENV_ROOT="$(pyenv root)"
  export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin${PATH:+:${PATH}}"
fi
