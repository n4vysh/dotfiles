#!/bin/sh

set -eu

WSL_DISTRO_NAME="${WSL_DISTRO_NAME:=none}"

if [ "$WSL_DISTRO_NAME" != "none" ]; then
	gum log --level warn "$0: running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Change default shell'
if [ "$SHELL" != /usr/bin/zsh ]; then
	sudo homectl update --shell="$(which zsh)" "$USER"
else
	gum log --level warn 'default shell already changed -- skipping'
fi
