#!/bin/sh

if [ "$WSL_DISTRO_NAME" != "" ]; then
	gum log --level warn "$0: running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Enable firewall'
sudo ufw enable

gum log --level info 'Show firewall status'
sudo ufw status verbose
