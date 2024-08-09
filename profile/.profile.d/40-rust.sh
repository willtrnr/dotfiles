#!/usr/bin/env sh

export RUSTUP_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/rustup"

export PATH="${HOME}/.cargo/bin${PATH:+:${PATH}}"
