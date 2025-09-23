#!/bin/sh

set -eu

WSL_DISTRO_NAME="${WSL_DISTRO_NAME:=none}"

if [ "$WSL_DISTRO_NAME" != "none" ]; then
	gum log --level warn "$0: running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Make link of resolv.conf'
# NOTE: stub-resolv.conf does not exist unless systemd-resolved starts
if ! [ -f /etc/resolv.conf ]; then
	sudo ln -rsfv /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
else
	gum log --level warn '/etc/resolv.conf already exists -- skipping'
fi
