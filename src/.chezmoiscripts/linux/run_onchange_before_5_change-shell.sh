#!/bin/sh

[ "$WSL_DISTRO_NAME" != "" ] && exit 0 # NOTE: skip when WSL

gum log --level info 'Change default shell'
if [ "$SHELL" != /usr/bin/zsh ]; then
	sudo homectl update --shell="$(which zsh)" "$USER"
else
	gum log --level warn 'default shell already changed -- skipping'
fi
