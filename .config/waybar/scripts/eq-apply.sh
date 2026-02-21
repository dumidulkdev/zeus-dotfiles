#!/usr/bin/env bash
set -euo pipefail

choice="${1:-}"
STATE_FILE="$HOME/.config/waybar/.eq-mode"

# EasyEffects needs a graphical user session env
if [[ -z "${WAYLAND_DISPLAY:-}" && -z "${DISPLAY:-}" ]]; then
  notify-send "EQ" "Open from Waybar click (graphical session required)." 2>/dev/null || true
  exit 0
fi

# Start EasyEffects service mode if not running
if ! pgrep -x easyeffects >/dev/null 2>&1; then
  nohup easyeffects --service-mode --hide-window >/tmp/easyeffects-service.log 2>&1 &
  sleep 1
fi

apply_and_set() {
  local mode="$1"
  echo "$mode" > "$STATE_FILE"
  pkill -RTMIN+9 waybar 2>/dev/null || true
}

load_preset_safe() {
  local preset="$1"
  easyeffects -b 2 >/dev/null 2>&1 || return 1
  easyeffects -l "$preset" >/dev/null 2>&1 || return 1
}

case "$choice" in
  "Normal")
    # bypass on = no effects
    if easyeffects -b 1 >/dev/null 2>&1; then
      apply_and_set normal
    else
      notify-send "EQ" "Could not apply Normal preset." 2>/dev/null || true
    fi
    ;;
  "Bass Boost")
    if load_preset_safe "Bass Boost"; then
      apply_and_set bass
    else
      notify-send "EQ" "Preset 'Bass Boost' not found. Open EasyEffects and save a preset with that exact name." 2>/dev/null || true
    fi
    ;;
  "Treble Boost")
    if load_preset_safe "Treble Boost"; then
      apply_and_set treble
    else
      notify-send "EQ" "Preset 'Treble Boost' not found. Open EasyEffects and save a preset with that exact name." 2>/dev/null || true
    fi
    ;;
  "Open EasyEffects")
    nohup easyeffects >/tmp/easyeffects-ui.log 2>&1 &
    ;;
  *)
    exit 0
    ;;
esac
