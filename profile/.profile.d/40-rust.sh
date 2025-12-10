#!/usr/bin/env sh

export RUSTUP_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/rustup"

export PATH="${HOME}/.cargo/bin${PATH:+:${PATH}}"

if RUSTC_WRAPPER="$(command -v sccache)"; then
  export RUSTC_WRAPPER
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
  export CARGO_TARGET_I686_PC_WINDOWS_GNU_RUNNER=/usr/bin/env
  export CARGO_TARGET_I686_PC_WINDOWS_MSVC_RUNNER=/usr/bin/env
  export CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUNNER=/usr/bin/env
  export CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_RUNNER=/usr/bin/env
fi
