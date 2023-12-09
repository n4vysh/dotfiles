#!/bin/bash

name=tokyonight.tmux
dir="$XDG_DATA_HOME/tmux/plugins/tmux-tokyonight"

if [[ $1 == install ]]; then
	tmux display "Installing $name"
	mkdir -p "$dir"

	hash="8b55a47165348dd1d811f9e1f867bb17bb35a360"
	fqdn=raw.githubusercontent.com
	repo=folke/tokyonight.nvim
	path="extras/tmux/tokyonight_night.tmux"
	url="https://$fqdn/$repo/$hash/$path"

	curl -o "$dir/$name" "$url"

	sed \
		-e '/set -g status-right /s/^.*$/set -g status-right "#[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#15161E,bg=#7aa2f7,bold] #h "/' \
		-e 's///g' \
		-e 's///g' \
		-e 's///g' \
		-e 's///g' \
		"$dir/$name" \
		>"$dir/tokyonight.mod.tmux"

	echo -n "Installed $name"
fi

tmux bind-key T run-shell "$XDG_CONFIG_HOME/tmux/theme.tmux install"

tmux source-file "$dir/tokyonight.mod.tmux"
