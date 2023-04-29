#!/usr/bin/bash

xargs -0 diff -su <"${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection" |
	delta --max-line-length 10000 --wrap-max-lines 10000 --paging always
