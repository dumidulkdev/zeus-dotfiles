#!/usr/bin/env bash
set -euo pipefail

LAST_NVIM_FILE="$HOME/.config/waybar/.last-nvim-project"
LEGACY_FILE="$HOME/.config/waybar/.git-repo-path"
DEFAULT_PROJECT="$HOME/Documents/projects/nest-js/todo-app-2"

get_project_dir() {
  local p=""
  if [[ -f "$LAST_NVIM_FILE" ]]; then
    p=$(head -n1 "$LAST_NVIM_FILE" 2>/dev/null || true)
  fi
  if [[ -z "$p" && -f "$LEGACY_FILE" ]]; then
    p=$(head -n1 "$LEGACY_FILE" 2>/dev/null || true)
  fi
  [[ -z "$p" ]] && p="$DEFAULT_PROJECT"
  [[ -d "$p" ]] || p="$HOME"
  printf '%s\n' "$p"
}

project=$(get_project_dir)
name=$(basename "$project")

status_json() {
  local txt tip
  txt="📁 $name"
  tip="Current project: $project\nClick to open in Neovim"
  jq -cn --arg text "$txt" --arg tooltip "$tip" '{text:$text,tooltip:$tooltip}'
}

open_nvim() {
  alacritty -e bash -lc "cd \"$project\" && nvim ."
}

case "${1:-status}" in
  status) status_json ;;
  click) open_nvim ;;
  *) status_json ;;
esac
