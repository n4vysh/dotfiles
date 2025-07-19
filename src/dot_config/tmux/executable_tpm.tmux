#!/bin/bash

if [[ $1 == install ]]; then
	tmux display 'Installing tpm'
	git clone https://github.com/tmux-plugins/tpm \
		~/.tmux/plugins/tpm
	echo -n 'Installed tpm'
fi

tmux bind-key P run-shell "$XDG_CONFIG_HOME/tmux/tpm.tmux install"
