#!/usr/bin/env bash
set -euo pipefail

DEFAULT_PROJECT="$HOME/Documents/projects/nest-js/todo-app-2"
LAST_NVIM_FILE="$HOME/.config/waybar/.last-nvim-project"
LEGACY_FILE="$HOME/.config/waybar/.git-repo-path"

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

# Resolve git root if inside a repo
repo_root=""
if repo_root=$(git -C "$project" rev-parse --show-toplevel 2>/dev/null); then
  :
else
  repo_root=""
fi

status_json() {
  if [[ -z "$repo_root" ]]; then
    txt="<span foreground='#ffd166'>git init?</span>"
    tip="No git repo in: $project\nClick to initialize git here"
    jq -cn --arg text "$txt" --arg tooltip "$tip" '{text:$text, tooltip:$tooltip}'
    return 0
  fi

  branch=$(git -C "$repo_root" symbolic-ref --short -q HEAD 2>/dev/null || echo "main")
  porcelain=$(git -C "$repo_root" status --porcelain 2>/dev/null || true)
  dirty=0
  [[ -n "$porcelain" ]] && dirty=$(printf '%s\n' "$porcelain" | wc -l | tr -d ' ')

  ahead=0
  behind=0
  if git -C "$repo_root" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    read -r behind ahead < <(git -C "$repo_root" rev-list --left-right --count HEAD...@{u} 2>/dev/null || echo "0 0")
  fi

  sync=""
  (( ahead > 0 )) && sync+=" ↑$ahead"
  (( behind > 0 )) && sync+=" ↓$behind"

  if (( dirty > 0 )); then
    txt="git ${branch} • ${dirty}${sync}"
  else
    txt="git ${branch}${sync}"
  fi

  tip="Project: $project\nRepo: $repo_root\nBranch: $branch\nChanged files: $dirty"
  jq -cn --arg text "$txt" --arg tooltip "$tip" '{text:$text, tooltip:$tooltip}'
}

click_action() {
  if [[ -z "$repo_root" ]]; then
    git -C "$project" init >/dev/null 2>&1 || true
    notify-send "Waybar Git" "Initialized git repo in: $project" 2>/dev/null || true
    exit 0
  fi

  if command -v lazygit >/dev/null 2>&1; then
    alacritty -e bash -lc "cd \"$repo_root\" && lazygit"
  else
    alacritty -e bash -lc "cd \"$repo_root\" && git status; exec bash"
  fi
}

right_click_action() {
  local dir="$project"
  [[ -n "$repo_root" ]] && dir="$repo_root"
  alacritty -e bash -lc "cd \"$dir\" && git status; exec bash"
}

case "${1:-status}" in
  status) status_json ;;
  click) click_action ;;
  right-click) right_click_action ;;
  *) status_json ;;
esac
