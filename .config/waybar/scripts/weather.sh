#!/usr/bin/env bash

set -u

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/waybar"
cache_file="${cache_dir}/weather.json"

mkdir -p "$cache_dir"

fetch_weather() {
  local location="$1"
  curl -fsSL --max-time 5 --connect-timeout 3 \
    -A "waybar-weather" \
    "https://wttr.in/${location}?format=%l|%C|%t"
}

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  printf '%s' "$s"
}

raw="$(fetch_weather "Nugegoda" 2>/dev/null || true)"
if [[ -z "$raw" || "$raw" == *"Unknown location"* ]]; then
  raw="$(fetch_weather "Colombo" 2>/dev/null || true)"
fi

if [[ -n "$raw" ]]; then
  IFS='|' read -r location condition temp <<<"$raw"
  short_location="${location%%,*}"

  text=" ${temp}"
  tooltip="${location}\n${condition} ${temp}\nSource: wttr.in"

  printf '{"text":"%s","tooltip":"%s"}\n' \
    "$(json_escape "$text")" \
    "$(json_escape "$tooltip")" | tee "$cache_file"
  exit 0
fi

if [[ -f "$cache_file" ]]; then
  cat "$cache_file"
  exit 0
fi

printf '{"text":" Weather N/A","tooltip":"Weather unavailable"}\n'
