#!/bin/bash

debug=${1}
debug() {
    if [[ ${debug} == "-v" ]]; then
        echo "${@}"
    fi
}

if [[ -z $TMPDIR ]]; then
	TMPDIR="/tmp"
fi

function is_agent_socket {
	SSH_AUTH_SOCK="$1" ssh-add -l 1>/dev/null 2>&1
	if [[ $? -lt 2 ]]; then
		debug "is socket $1"
		return 0
	else
		debug "isnot socket $1"
		return 1
	fi
}

if [[ -z $SSH_AUTH_SOCK ]] || ! is_agent_socket $SSH_AUTH_SOCK; then

	debug "no agent found"
	found=false
    uid=$(id -u)
    gid=$(id -g)
	shopt -s nullglob
	for s in $TMPDIR/ssh-?*/agent.*; do
		debug "candidate $s"
        if [[ ${uid} != $(stat $s -c '%u') ]]; then
            debug "owner missmatch"
            continue
        fi
        if [[ ${gid} != $(stat $s -c '%g') ]]; then
            debug "group missmatch"
            continue
        fi
        if [[ $(stat $s -c '%A') != "srw-------" ]]; then
            debug "permission missmatch"
            continue
        fi
		if is_agent_socket $s; then
			export SSH_AUTH_SOCK="$s" #TODO who knows if those two match, could not find pid of socket in bash
			export SSH_AGENT_PID="`pidof ssh-agent -s`"
			found=true
			debug "found $SSH_AUTH_SOCK with pid $SSH_AGENT_PID"
			break
		fi
	done
	shopt -u nullglob

	if ! $found; then
		eval `ssh-agent -s` >/dev/null 2>&1
		debug "started $SSH_AUTH_SOCK with pid $SSH_AGENT_PID"
	fi

fi
