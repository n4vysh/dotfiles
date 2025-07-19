#!/bin/bash

if ! pgrep fcitx5 >/dev/null; then
	# NOTE: exit if not running fcitx5
	exit 0
fi

[[ $(fcitx5-remote) != 2 ]] && echo en || echo jp
