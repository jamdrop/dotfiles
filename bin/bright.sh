#!/bin/bash

if [[ $# -gt 1 ]]; then
    echo "$(basename ${0}) [0..1]"
    echo "0..1 brightness - e.g. 0.5 (defaults to 1)"
    exit 1
fi

brightness=1
if [[ -n ${1} ]]; then
    brightness=${1}
fi

currentOutput=$(i3-msg -t get_workspaces | jq -r 'map(select(.focused==true))[0].output' 2>/dev/null)
if [[ $! -ne 0 ]]; then
    echo "could not read current output from i3" >&2
    exit 1
fi

echo "setting brightness on ${currentOutput} to ${brightness}"
xrandr --output ${currentOutput} --brightness ${brightness}
if [[ $! -ne 0 ]]; then
    echo "could not set brightness" >&2
    exit 1
fi
