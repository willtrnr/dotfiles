#!/usr/bin/env sh

# Setup the runtime dir if not already set by pam_systemd or something else
if [ -z "${XDG_RUNTIME_DIR}" ] || [ ! -w "${XDG_RUNTIME_DIR}" ]; then
  XDG_RUNTIME_DIR="${TMPDIR:-/run}/user/$(id -u)"
  mkdir -p "${XDG_RUNTIME_DIR}"
  chmod 0700 "${XDG_RUNTIME_DIR}"
  export XDG_RUNTIME_DIR
fi

# Explicitly set to the defaults to help with misbehaved programs
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
