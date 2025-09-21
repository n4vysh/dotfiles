#!/bin/sh

[ "$WSL_DISTRO_NAME" != "" ] && exit 0 # NOTE: skip when WSL

gum log --level info 'Enable firewall'
sudo ufw enable

gum log --level info 'Show firewall status'
sudo ufw status verbose
