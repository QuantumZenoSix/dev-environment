#!/bin/bash

# Get monitor names (adjust based on your setup from `niri msg outputs`)
# INTERNAL="eDP-1"
# EXTERNAL="HDMI-A-1"  # or whatever yours is

INTERNAL="$(niri msg outputs | grep -E '^Output' | sed -n '1{p;q}' | sed -r 's:Output\s+\".*\"::' | tr -d '()' | xargs)"
EXTERNAL="$(niri msg outputs | grep -E '^Output' | sed -n '2{p;q}' | sed -r 's:Output\s+\".*\"::' | tr -d '()' | xargs)"

# Simple states: Laptop only, External only, Both (extend)
STATE_FILE="/tmp/niri-display-state"

if [ ! -f "$STATE_FILE" ]; then
    echo "laptop" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

case $STATE in
    laptop)
        niri msg output "$INTERNAL" on
        niri msg output "$EXTERNAL" on
        echo "both" > "$STATE_FILE"
        notify-send "Displays: Extend"
        ;;
    both)
        niri msg output "$INTERNAL" off
        niri msg output "$EXTERNAL" on
        echo "external" > "$STATE_FILE"
        notify-send "Displays: External only"
        ;;
    external)
        niri msg output "$INTERNAL" on
        niri msg output "$EXTERNAL" off
        echo "laptop" > "$STATE_FILE"
        notify-send "Displays: Laptop only"
        ;;
esac
