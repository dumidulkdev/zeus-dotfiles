#!/usr/bin/env bash
set -euo pipefail

# Try lm-sensors first
get_temp_c() {
  if command -v sensors >/dev/null 2>&1; then
    local t
    t=$(sensors 2>/dev/null | awk '
      /Package id 0:/ {gsub(/[^0-9.+-]/, "", $4); if ($4!="") print $4; exit}
      /Tctl:/ {gsub(/[^0-9.+-]/, "", $2); if ($2!="") print $2; exit}
      /Tdie:/ {gsub(/[^0-9.+-]/, "", $2); if ($2!="") print $2; exit}
      /temp1:/ {gsub(/[^0-9.+-]/, "", $2); if ($2!="") print $2; exit}
    ')
    if [[ -n "${t:-}" ]]; then
      printf '%.0f\n' "$t"
      return 0
    fi
  fi

  # fallback: sysfs thermal zone
  local z
  for z in /sys/class/thermal/thermal_zone*/temp; do
    [[ -r "$z" ]] || continue
    local raw
    raw=$(cat "$z" 2>/dev/null || echo "")
    if [[ "$raw" =~ ^[0-9]+$ ]] && (( raw > 1000 )); then
      echo $(( raw / 1000 ))
      return 0
    fi
  done

  return 1
}

if ! temp=$(get_temp_c); then
  echo '{"text":"<span foreground='"'"'#ffffff'"'"'> --°C</span>","tooltip":"Temperature sensor unavailable"}'
  exit 0
fi

# color ranges
# <65 normal (white), 65-80 warm (yellow), >80 hot (red)
if (( temp > 80 )); then
  color="#ff4d4d"
elif (( temp >= 65 )); then
  color="#ffd166"
else
  color="#ffffff"
fi

text="<span foreground='$color'> ${temp}°C</span>"
tip="Laptop Temperature\nCurrent: ${temp}°C\nRanges: <65 normal, 65-80 warm, >80 hot"

printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tip"
