#!/bin/bash

if ! type tmux >/dev/null 2>&1; then
	echo "${0##*/}: command not found: tmux"
	exit 1
fi

if [[ -n $TMUX ]]; then
	echo "${0##*/}: try from outside tmux session"
	exit 1
fi

exec >/dev/null 2>&1

if tmux has-session; then
	exec tmux attach-session -d
else
	exec tmux new-session
fi
