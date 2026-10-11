#!/bin/sh

set -eu

if ! [ -d /mnt/wsl ]; then
	gum log --level warn "$0: not running on WSL -- skipping"
	exit 0
fi

gum log --level info 'Enable and start Docker socket'
systemctl --user enable --now docker.socket

gum log --level info 'Start LiteLLM PostgreSQL'
systemctl --user start litellm-postgres.service
