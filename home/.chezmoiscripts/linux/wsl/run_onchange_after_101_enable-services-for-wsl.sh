#!/bin/sh

set -eu

if ! [ -d /mnt/wsl ]; then
	gum log --level warn "$0: not running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Enable systemd services'
sudo systemctl start "user@$(id -u "$USER")" # start systemd-logind
systemctl --user daemon-reload
# NOTE: fix wslg bug of WSL
# https://github.com/microsoft/wslg/issues/1032#issuecomment-2310369848
systemctl --user enable --now wsl-wayland-symlink.service

gum log --level info 'Enable and start Docker socket'
systemctl --user enable --now docker.socket

gum log --level info 'Start LiteLLM PostgreSQL'
systemctl --user start litellm-postgres.service
