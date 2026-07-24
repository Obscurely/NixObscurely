#!/usr/bin/env bash

# directories to search for projects
selected=$(find ~/Code -mindepth 2 -maxdepth 2 -type d | fzf)

if [[ -z $selected ]]; then
  exit 0
fi

session_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t="$session_name" 2>/dev/null; then
  if [[ -f "$selected/flake.nix" ]]; then
    tmux new-session -ds "$session_name" -c "$selected" "nix develop -c nvim"
  else
    tmux new-session -ds "$session_name" -c "$selected" "nvim"
  fi
fi

tmux switch-client -t "$session_name"
