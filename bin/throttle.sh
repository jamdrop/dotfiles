#!/bin/bash

set -eu

ipt() {
    iptables -t mangle $@
}

flush() {
    # clean input/output mangel
    ipt -F INPUT
    ipt -F OUTPUT
}

mark() {
    # add mark
    ipt -A INPUT -s "${1}" -j MARK --set-mark 10
    ipt -A OUTPUT -d "${1}" -j MARK --set-mark 11
}

rate() {
    tc class replace dev eth0 parent 1: classid 1:11 htb rate "${1}"
}

setup() {
    tc qdisc add dev eth0 root handle 1: htb default 1
    tc class add dev eth0 parent 1: classid 1:11 htb rate 10mbit
    tc filter add dev eth0 parent 1: handle 11 fw classid 1:11
}

usage() {
    echo "$(basename "${0}") ( IP MBIT | clear | setup)"
}

if [[ $# -eq 1 ]]; then
  if [[ "${1}" == "clear" ]]; then
    flush
  elif [[ "${1}" == "setup" ]]; then
    setup
  else
    usage
    exit 1
  fi
elif [[ $# -eq 2 ]]; then
    flush
    mark "${1}"
    rate "${2}"
else
    usage
    exit 1
fi
