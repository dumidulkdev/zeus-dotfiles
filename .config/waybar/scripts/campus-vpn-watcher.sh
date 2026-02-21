#!/usr/bin/env bash
set -euo pipefail

while true; do
  "$HOME/.config/waybar/scripts/campus-vpn.sh" auto || true
  sleep 5
done
