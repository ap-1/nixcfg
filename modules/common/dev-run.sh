#!/usr/bin/env bash
# dev's tmux orchestrator, runs on mocha
#
#   dev-run <query|cwd|pick> [zoxide query...]
#
# Anchor holds the windows, siblings are throwaway views
set -u

mode=${1:?dev-run: missing mode}
shift
dir=""
name=""

case "$mode" in
query)
  dir=$(zoxide query -- "$@") || {
    printf 'dev: no project matches: %s\n' "$*" >&2
    exit 1
  }
  ;;
cwd)
  dir=$PWD
  ;;
pick)
  sel=$(sesh list -t -z -d 2>/dev/null | grep -vE '~[0-9]+$' | fzf --prompt='dev> ' --height=40% --reverse) || exit 0
  [ -n "$sel" ] || exit 0
  if tmux has-session -t "=$sel" 2>/dev/null; then
    name=$sel
  else
    dir=$(zoxide query -- "$sel" 2>/dev/null || printf '%s' "$sel")
  fi
  ;;
*)
  echo "dev-run: unknown mode: $mode" >&2
  exit 1
  ;;
esac

if [ -z "$name" ]; then
  name=$(basename "$dir")
  name=$(printf '%s' "$name" | tr -c 'A-Za-z0-9_-' '_')
fi
[ -n "$name" ] || {
  echo 'dev: no project' >&2
  exit 1
}

# Detached anchor keeps the windows alive
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "${dir:-$HOME}"

# Most recently active window
last=$(tmux list-windows -t "=$name" -F '#{window_activity} #{window_id}' | sort -n | tail -1 | cut -d' ' -f2)

# Attach before destroy-unattached or it self-kills while detached
exec tmux new-session -t "$name" -s "${name}~$$" \; set-option destroy-unattached on \; select-window -t "$last"
