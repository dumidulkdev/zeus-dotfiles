#!/usr/bin/env bash
set -euo pipefail

ON_TEMP=4000
OFF_TEMP=6000
MIN_TEMP=2500
MAX_TEMP=6500
STEP=200

OMARCHY_NL="/home/zeus/.local/share/omarchy/bin/omarchy-toggle-nightlight"

get_temp() {
  hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+' | head -n1 || true
}

set_temp() {
  local t="$1"
  hyprctl hyprsunset temperature "$t" >/dev/null 2>&1 || true
}

ensure_running() {
  pgrep -x hyprsunset >/dev/null 2>&1 || setsid uwsm-app -- hyprsunset >/dev/null 2>&1 &
}

status() {
  local t cls txt tip
  t=$(get_temp)
  [[ -z "$t" ]] && t=$OFF_TEMP

  if (( t >= OFF_TEMP )); then
    cls="off"
    txt=""
    tip="Eye Comfort: OFF\nClick to toggle\nScroll: adjust intensity"
  else
    cls="on"
    txt=""
    tip="Eye Comfort: ON (${t}K)\nClick to toggle\nScroll up: warmer\nScroll down: cooler"
  fi

  jq -cn --arg text "$txt" --arg cls "$cls" --arg tooltip "$tip" '{text:$text,class:$cls,tooltip:$tooltip}'
}

toggle() {
  "$OMARCHY_NL" >/dev/null 2>&1 || true
}

warmer() {
  ensure_running
  local t
  t=$(get_temp)
  [[ -z "$t" ]] && t=$ON_TEMP
  t=$(( t - STEP ))
  (( t < MIN_TEMP )) && t=$MIN_TEMP
  set_temp "$t"
}

cooler() {
  ensure_running
  local t
  t=$(get_temp)
  [[ -z "$t" ]] && t=$ON_TEMP
  t=$(( t + STEP ))
  (( t > MAX_TEMP )) && t=$MAX_TEMP
  set_temp "$t"
}

case "${1:-status}" in
  status) status ;;
  toggle) toggle ;;
  warmer) warmer ;;
  cooler) cooler ;;
  *) status ;;
esac
