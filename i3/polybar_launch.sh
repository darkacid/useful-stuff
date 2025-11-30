#!/usr/bin/env bash

# Kill existing bars
killall -q polybar

# Wait for them to die
while pgrep -x polybar >/dev/null; do sleep 0.5; done

# Launch one bar per monitor
for m in $(polybar --list-monitors | cut -d: -f1); do
  MONITOR="$m" polybar mainbar &
done
