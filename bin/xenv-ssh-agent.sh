#!/bin/sh

if [[ -z $TMPDIR ]]; then
	TMPDIR="/tmp"
fi

function is_agent_socket {
	SSH_AUTH_SOCK="$1" ssh-add -l 1>/dev/null 2>&1
	if [[ $? -lt 2 ]]; then
		#echo "is socket $1"
		return 0
	else
		#echo "isnot socket $1"
		return 1
	fi
}

if [[ -z $SSH_AUTH_SOCK ]] || ! is_agent_socket $SSH_AUTH_SOCK; then

	#echo "no agent found"
	found=false
	shopt -s nullglob
	for s in $TMPDIR/ssh-?*/agent.*; do
		#echo "candidate $s"
		if [[ -w $s && -S $s ]]; then
			if is_agent_socket $s; then
				export SSH_AUTH_SOCK="$s" # who knows if those two match ...
				export SSH_AGENT_PID="`pidof ssh-agent -s`"
				found=true
				#echo "found $SSH_AUTH_SOCK with pid $SSH_AGENT_PID"
				break
			fi
		fi
	done
	shopt -u nullglob

	if ! $found; then
		eval `ssh-agent -s` >/dev/null 2>&1
		#echo "started $SSH_AUTH_SOCK with pid $SSH_AGENT_PID"
	fi

fi
