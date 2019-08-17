#!/bin/bash

set -eu

if [ ! -r "$1" ]; then
    echo "could not read file: $1"
    exit 1
fi

cat "$1" | jq -r '.step_log[].payload' | while read line; do
    echo "$line" | base64 -d
done