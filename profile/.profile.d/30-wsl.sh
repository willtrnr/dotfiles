#!/usr/bin/env sh

if [ -z "${WSL_DISTRO_NAME}" ] && command -v wslpath >/dev/null; then
  case "$(uname -r)" in
    *WSL2)
      if WSL_DISTRO_NAME="$(wslpath -a -m / 2>/dev/null | cut -d/ -f4)"; then
        export WSL_DISTRO_NAME
      fi
      ;;
  esac
fi

if [ -n "${WSL_DISTRO_NAME}" ] && [ -z "${DISPLAY}" ]; then
  export DISPLAY=:0
fi
