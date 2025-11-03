#!/usr/bin/env sh

if [ -n "${WSL_DISTRO_NAME}" ] && [ -z "${DISPLAY}" ]; then
  export DISPLAY=:0
fi
