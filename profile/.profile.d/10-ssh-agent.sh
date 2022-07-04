#! /bin/env sh

if (command -v ssh-agent > /dev/null); then
  if ! (pgrep -u "$USER" ssh-agent > /dev/null); then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
  fi
  if [ -z "$SSH_AUTH_SOCK" ]; then
    . "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
  fi
fi
