#!/bin/sh
# Started as root by `clam`. Turns clamshell mode off when the Mac is unplugged
# at or below the battery threshold, and exits once clamshell mode is off.

threshold=20

while pmset -g | grep -q 'SleepDisabled[[:space:]]*1'; do
  batt=$(pmset -g batt)
  percent=$(printf '%s\n' "$batt" | grep -Eo '[0-9]+%' | head -n 1 | tr -d %)

  if printf '%s\n' "$batt" | grep -q "'Battery Power'" &&
    [ -n "$percent" ] && [ "$percent" -le "$threshold" ]; then
    pmset -a disablesleep 0
    exit 0
  fi

  sleep 60
done
