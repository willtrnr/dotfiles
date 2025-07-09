if [ -n "${WSL_DISTRO_NAME}" ]; then
  if [ -z "${DISPLAY}" ]; then
    export DISPLAY=:0
  fi
fi
