#!/bin/bash

systemctl is-active --quiet nordvpnd.service
result="$?"

[[ "$result" == 1 ]] && echo '{"alt": "disconnected"}'

nordvpn status |
	grep 'Status: Connected' >/dev/null &&
	echo '{"alt": "connected"}' ||
	echo '{"alt": "disconnected"}'
