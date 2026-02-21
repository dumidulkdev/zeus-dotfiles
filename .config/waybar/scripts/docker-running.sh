#!/usr/bin/env bash

set -u

if ! command -v docker >/dev/null 2>&1; then
  printf '{"text":" 0","tooltip":"Docker not installed"}\n'
  exit 0
fi

if ! output="$(timeout 3s docker ps --filter status=running --format '{{.Names}}' 2>/dev/null)"; then
  printf '{"text":" 0","tooltip":"Docker unavailable"}\n'
  exit 0
fi

count=0
tooltip="No running containers"
if [[ -n "$output" ]]; then
  count="$(printf '%s\n' "$output" | wc -l | tr -d ' ')"
  tooltip="$output"
fi

printf '{"text":" %s","tooltip":"%s"}\n' "$count" "${tooltip//$'\n'/\\n}"
