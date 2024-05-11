#!/usr/bin/env sh

if [ -e "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh" ]; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
  if [ -n "$SSH_AGENT_PID" ]; then
    export SSH_AGENT_PID=''
  fi
elif [ -z "$SSH_AUTH_SOCK" ] && command -v ssh-agent > /dev/null; then
  if ! (pgrep -u "$USER" ssh-agent > /dev/null); then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
  fi
  if [ -e "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
    . "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
  fi
fi
