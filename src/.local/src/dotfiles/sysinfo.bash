#!/bin/bash

wezterm \
	--config initial_rows=11 \
	--config initial_cols=37 \
	start \
	--class sysinfo \
	bash -c '
		neofetch
		tput civis
		sleep infinity
	'
