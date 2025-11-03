#!/usr/bin/env sh

if [ "$(stat -f -c %T "$HOME" 2>/dev/null)" = btrfs ]; then
  # hardlink fails across subvols, but btrfs will reflink with copy
  export UV_LINK_MODE=copy
fi

if command -v pyenv >/dev/null && PYENV_ROOT="$(pyenv root)"; then
  export PYENV_ROOT
  export PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin${PATH:+:${PATH}}"
fi
