#!/usr/bin/env bash
set -euo pipefail

status=$(playerctl status 2>/dev/null || echo "Stopped")
if [[ "$status" == "Playing" ]]; then
  icon=""
  tip="Pause"
else
  icon=""
  tip="Play"
fi

printf '{"text":"%s","tooltip":"%s"}\n' "$icon" "$tip"
