#!/bin/bash

if ! (networkctl status | grep -q "State: routable"); then
	# NOTE: exit if network not working
	exit 0
fi

count="$(arch-audit --upgradable | wc -l)"

[[ "$count" != 0 ]] && echo " arch-audit"
