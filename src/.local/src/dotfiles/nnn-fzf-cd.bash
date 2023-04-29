#!/usr/bin/bash

# shellcheck source=src/.config/nnn/plugins/.nnn-plugin-helper
. "$XDG_CONFIG_HOME/nnn/plugins/.nnn-plugin-helper"

dir=$(fd -t d -HI | fzf +m --preview 'exa -aF1 --icons {}')
nnn_cd "$(readlink -fn "$dir")" 0
