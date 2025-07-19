#!/bin/bash

systemctl is-active --quiet nordvpnd.service
result="$?"

[[ "$result" == 1 ]] && echo '{"alt": "disconnected"}'

# NOTE: `nordvpn status` print control character, so use backward match
nordvpn status |
	grep -E 'Status: Connected$' >/dev/null &&
	echo '{"alt": "connected"}' ||
	echo '{"alt": "disconnected"}'
