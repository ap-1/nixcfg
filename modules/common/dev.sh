#!/usr/bin/env bash
# dev - attach an independent terminal to a project's tmux session on mocha
#
#   dev           picker of projects (cortado) / the cwd's project (mocha)
#   dev <query>   the project whose directory zoxide resolves <query> to
#
# Runs over mosh unless already on mocha
set -u

if [ "$(hostname -s 2>/dev/null || uname -n)" = mocha ]; then
  if [ "$#" -gt 0 ]; then exec dev-run query "$@"; else exec dev-run cwd; fi
else
  if [ "$#" -gt 0 ]; then set -- query "$@"; else set -- pick; fi
  exec env LC_ALL=en_US.UTF-8 mosh \
    --ssh='ssh -o StrictHostKeyChecking=accept-new' \
    mocha.ts.anish.land -- dev-run "$@"
fi
