#!/usr/bin/env sh

find_first() {
  while [ -n "$1" ]; do
    if command -v "$1"; then
      return 0
    fi
    shift
  done
  return 1
}

# Select the best available editor
if EDITOR="$(find_first nvim vim vi nano)"; then
  export EDITOR
fi

# Select the best available pager
if PAGER="$(find_first less more)"; then
  export PAGER
fi

# Select the best available terminal, overrides the i3-sensible-terminal selection order
if TERMINAL="$(find_first wezterm-gui wezterm st kitty urxvt ghostty alacritty xterm)"; then
  export TERMINAL
fi

# Select the best available browser
if BROWSER="$(find_first google-chrome-beta google-chrome-stable chromium-snapshot-bin chromium firefox \
  "$([ -n "${WSL_DISTRO_NAME}" ] && echo '/mnt/c/PROGRA~1/Google/Chrome/Application/chrome.exe')" \
)"; then
  export BROWSER
fi
