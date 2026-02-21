#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="$HOME/.config/waybar/.eq-mode"
mode="normal"
[[ -f "$STATE_FILE" ]] && mode=$(cat "$STATE_FILE" 2>/dev/null || echo normal)

case "$mode" in
  bass) label="Bass" ;;
  treble) label="Treble" ;;
  *) label="Normal" ;;
esac

# Static icon only (no dynamic icon switching)
printf '{"text":"🚀","tooltip":"EQ: %s (click to change preset)"}\n' "$label"
