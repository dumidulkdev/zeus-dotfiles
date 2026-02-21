#!/usr/bin/env bash
set -euo pipefail

OUT_FILE="/tmp/waybar_cava.out"
PID_FILE="/tmp/waybar_cava.pid"

ensure_daemon() {
  if ! command -v cava >/dev/null 2>&1; then
    return 1
  fi

  if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE" 2>/dev/null || true)" 2>/dev/null; then
    return 0
  fi

  nohup "$HOME/.config/waybar/scripts/cava-daemon.sh" >/tmp/waybar_cava-launch.log 2>&1 &
  echo $! > "$PID_FILE"
  sleep 0.15
}

if ! ensure_daemon; then
  printf '{"text":"","tooltip":"cava not installed (sudo pacman -S cava)"}\n'
  exit 0
fi

line=""
if [[ -f "$OUT_FILE" ]]; then
  line=$(tail -n 1 "$OUT_FILE" 2>/dev/null || true)
fi

if [[ -z "$line" ]]; then
  printf '{"text":"<span foreground=\"#7dd3fc\">▁▁▁▁▁▁▁▁▁▁</span>","tooltip":"CAVA (waiting for audio)"}\n'
  exit 0
fi

# map 0..7 -> tiny bar chars
IFS=';' read -r -a vals <<< "$line"
chars=()
for v in "${vals[@]}"; do
  case "$v" in
    0) ch="▁" ;;
    1) ch="▂" ;;
    2) ch="▃" ;;
    3) ch="▄" ;;
    4) ch="▅" ;;
    5) ch="▆" ;;
    6) ch="▇" ;;
    *) ch="█" ;;
  esac
  chars+=("$ch")
done

# 10-step static gradient (cyan -> blue -> violet)
colors=("#67e8f9" "#5eead4" "#86efac" "#a3e635" "#facc15" "#fb923c" "#f97316" "#f43f5e" "#c084fc" "#818cf8")

out=""
for i in {0..9}; do
  c="${colors[$i]}"
  ch="${chars[$i]:-▁}"
  out+="<span foreground='$c'>$ch</span>"
done

printf '{"text":"%s","tooltip":"CAVA visualizer"}\n' "$out"
