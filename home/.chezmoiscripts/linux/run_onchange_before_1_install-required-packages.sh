#!/bin/sh

set -eu

# NOTE: logger function with the same format as gum command
# https://github.com/charmbracelet/log/blob/v0.4.2/styles.go#L62
info() {
	level=INFO
	color="86" # aqua (8-bit color)
	message="$1"
	printf "%b%s%b %s\n" "\033[1;38;5;${color}m" "$level" "\033[0m" "$message"
}

info 'Install logging command'
sudo pacman -S --noconfirm --needed --disable-download-timeout gum
