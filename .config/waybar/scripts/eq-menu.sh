#!/usr/bin/env bash
set -euo pipefail

options=$'Normal\nBass Boost\nTreble Boost\nOpen EasyEffects'

if command -v walker >/dev/null 2>&1; then
  choice=$(printf "%s" "$options" | walker -d -p "Select EQ preset" 2>/dev/null || true)
else
  choice=$(printf "%s" "$options" | head -n1)
fi

[[ -n "${choice:-}" ]] || exit 0
"$HOME/.config/waybar/scripts/eq-apply.sh" "$choice"
