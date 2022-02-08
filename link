#! /usr/bin/env bash

function link_package() {
    local pkg="$1" src dst rel

    find "$pkg" -not -type d -print0 |
        while IFS= read -r -d '' src; do
            dst="$HOME/$(printf '%s\n' "$src" | cut -d/ -f2-)"
            mkdir -p "$(dirname "$dst")"
            rel="$(realpath --relative-to="$(dirname "$dst")" "$src")"
            ln -sf "$rel" "$dst"
            printf '%s -> %s\n' "$dst" "$rel"
        done
}

PKG="$1"
if [ -z "$PKG" ] || [ ! -d "$PKG" ]; then
    exit 1
fi

link_package "$PKG"
