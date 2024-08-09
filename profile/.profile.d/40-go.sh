#!/usr/bin/env sh

# Make go a little less horrible
export GOPATH="${HOME}/.go"

export GOBIN="${GOPATH}/bin"
export GOMODCACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/go/mod"

export PATH="${GOBIN}${PATH:+:${PATH}}"
