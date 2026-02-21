#!/usr/bin/env bash
set -euo pipefail

OUT_FILE="/tmp/waybar_cava.out"
CONF_DIR="$HOME/.config/cava"
CONF_FILE="$CONF_DIR/waybar.conf"

mkdir -p "$CONF_DIR"

cat > "$CONF_FILE" <<'EOF'
[general]
framerate = 60
bars = 10
bar_width = 2
bar_spacing = 1

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
channels = mono
EOF

exec cava -p "$CONF_FILE" > "$OUT_FILE" 2>/tmp/waybar_cava.err
