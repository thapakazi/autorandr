#!/bin/sh

set -e

logger -t autorandr "ACTION: $ACTION" # "change"
logger -t autorandr "SUBSYSTEM: $SUBSYSTEM" # "drm"

# BUG: xrandr doesn't see the new device unless is polling
logger -t autorandr "Waiting for monitor configuration to change..."
watch -g xrandr > /dev/null 2>&1

EXTERNAL_MONITOR_STATUS=$( cat /sys/class/drm/card0-DP-1/status )

# Is the external monitor connected?
if [ "$EXTERNAL_MONITOR_STATUS" = "connected" ]; then
    TYPE="double"
    xrandr --output DP1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP1 --primary --mode  1368x768 --pos 0x1080 --rotate normal
else
    TYPE="single"
    /usr/bin/xrandr --output eDP1 --off --output eDP1 --mode 1368x768 --pos 0x0 --rotate normal
fi

logger -t autorandr "Switched to $TYPE monitor mode"

exit 0
