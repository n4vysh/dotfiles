#!/bin/sh

set -eu

if ! [ -f /usr/bin/wslinfo ]; then
	gum log --level warn "$0: not running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Link command wrappers for WSL'
for name in firefox wl-paste xdg-open nmap notify-send; do
	ln -sfn "wsl-$name" "$HOME/.local/bin/$name"
done
