#!/bin/bash

tmuxp ls |
	fzf -m \
		--header "load tmuxp workspace" \
		--preview "bat --color always $XDG_CONFIG_HOME/tmuxp/{}.yaml" |
	xargs tmuxp load -y
