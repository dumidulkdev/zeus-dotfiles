#!/usr/bin/env bash

# Waybar custom media controller for Firefox/YouTube + Spotify via MPRIS/playerctl

player=$(playerctl -l 2>/dev/null | head -n1)

if [[ -z "$player" ]]; then
  echo '{"text":"󰝛","tooltip":"No media player\nLeft click: play/pause | Right click: next | Middle: previous"}'
  exit 0
fi

status=$(playerctl -p "$player" status 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
title=$(playerctl -p "$player" metadata title 2>/dev/null)

if [[ -z "$title" ]]; then
  title="Unknown"
fi

short_title="$title"
if [[ ${#short_title} -gt 28 ]]; then
  short_title="${short_title:0:28}…"
fi

if [[ "$status" == "Playing" ]]; then
  icon="󰏤"
else
  icon="󰐊"
fi

if [[ -n "$artist" ]]; then
  now_playing="$artist — $title"
else
  now_playing="$title"
fi

tooltip="Player: $player\n$now_playing\n\nLeft click: play/pause\nRight click / wheel up: next\nMiddle click / wheel down: previous"

printf '{"text":"󰒮 %s %s","tooltip":"%s"}\n' "$icon" "$short_title" "$tooltip"
