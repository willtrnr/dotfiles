#!/usr/bin/env sh

export PATH="${HOME}/.local/perl5/bin${PATH:+:${PATH}}"
export PERL5LIB="${HOME}/.local/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="${HOME}/.local/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base '${HOME}/.local/perl5'"
export PERL_MM_OPT="INSTALL_BASE=${HOME}/.local/perl5"
