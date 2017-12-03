#!/bin/bash

usage() {
    echo "$(basename ${0}) [+....|-....]"
}

sink=$(pacmd list-sinks | awk '/* index/ { print $3}')
if [[ -z ${sink} ]]; then
    echo "no sink for you ...."
    exit 1
fi

if [[ ${#} == 0 ]]; then
    pactl set-sink-volume ${sink} 75%
elif [[ $# == 1 ]]; then
    cmd=${1:0:1}
    if [[ ${cmd} != "-" && ${cmd} != "+" ]]; then
        usage
        exit 3
    fi
    len=${#1}
    let vol=5*len
    pactl set-sink-volume ${sink} ${cmd}${vol}%
else
    usage
    exit 2
fi
