#!/usr/bin/env sh

# This will be already set by pam_systemd on systemd systems
# It will probably fix some issues on WSL and Termux
if [ -z "${XDG_RUNTIME_DIR}" ]; then
  export XDG_RUNTIME_DIR="${TMPDIR:-/tmp}/user/${UID}"
  mkdir -p -m0700 "${XDG_RUNTIME_DIR}"
fi

# Explicitly set to the defaults for misbehaved programs
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/share"
