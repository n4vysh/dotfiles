#!/bin/bash

buffer=$(tmux show-buffer)
window=1
if grep : <<<"$buffer" >/dev/null; then
	file=$(awk -F : '{print $1}' <<<"$buffer")
	line=$(awk -F : '{print $2}' <<<"$buffer")
else
	file="$buffer"
fi

if [[ -f $file ]]; then
	sock="/run/user/$(id -u)/nvim-$(tmux display-message -p '#S')-${window}.sock"
	if [[ -z $line ]]; then
		nvim --server "$sock" --remote "$file"
		tmux select-window -t ":=$window"
	else
		nvim --server "$sock" --remote-send ":e $file | $line <cr><c-l>"
		tmux select-window -t ":=$window"
	fi
else
	tmux display-message "No such file"
fi
