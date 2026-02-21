#!/usr/bin/env bash
set -euo pipefail

SSID_TARGET="OUSL_AIR_STUDENT"
SERVICE="sing-box@campus.service"
FORCE_FILE="$HOME/.config/sing-box/force-on"

current_ssid() {
  iw dev wlan0 link 2>/dev/null | sed -n 's/^\s*SSID: //p' | head -n1 || true
}

is_running() {
  systemctl is-active --quiet "$SERVICE"
}

svc_start() {
  sudo -n systemctl start "$SERVICE"
}

svc_stop() {
  sudo -n systemctl stop "$SERVICE"
}

status_json() {
  local txt cls tip
  if is_running; then
    txt=""
    cls="on"
    tip="Campus VPN ON\nSSID: $(current_ssid)\nClick to stop"
  else
    txt=""
    cls="off"
    tip="Campus VPN OFF\nTarget SSID: ${SSID_TARGET}\nClick to start immediately"
  fi
  jq -cn --arg text "$txt" --arg cls "$cls" --arg tooltip "$tip" '{text:$text,class:$cls,tooltip:$tooltip}'
}

toggle_manual() {
  mkdir -p "$(dirname "$FORCE_FILE")"
  if is_running; then
    rm -f "$FORCE_FILE"
    svc_stop || notify-send "Campus VPN" "Failed to stop (sudoers not ready)" 2>/dev/null || true
  else
    touch "$FORCE_FILE"
    svc_start || notify-send "Campus VPN" "Failed to start (sudoers not ready)" 2>/dev/null || true
  fi
}

auto_tick() {
  mkdir -p "$(dirname "$FORCE_FILE")"
  if [[ -f "$FORCE_FILE" ]]; then
    svc_start || true
    exit 0
  fi

  local ssid
  ssid=$(current_ssid)
  if [[ "$ssid" == "$SSID_TARGET" ]]; then
    svc_start || true
  else
    svc_stop || true
  fi
}

case "${1:-status}" in
  status) status_json ;;
  toggle) toggle_manual ;;
  auto) auto_tick ;;
  start) svc_start ;;
  stop) svc_stop ;;
  *) status_json ;;
esac
