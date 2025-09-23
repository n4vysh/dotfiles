#!/bin/sh

set -eu

WSL_DISTRO_NAME="${WSL_DISTRO_NAME:=none}"

if [ "$WSL_DISTRO_NAME" = "none" ]; then
	gum log --level warn "$0: not running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Enable systemd services'
sudo systemctl start "user@$(id -u "$USER")" # start systemd-logind
systemctl --user daemon-reload
# NOTE: fix wslg bug of WSL
# https://github.com/microsoft/wslg/issues/1032#issuecomment-2310369848
systemctl --user enable --now wsl-wayland-symlink.service
