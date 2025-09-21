#!/bin/bash

systemctl is-active --quiet openvpn-client@nordvpn
result="$?"

[[ "$result" == 0 ]] &&
	echo '{"alt": "connected"}' ||
	echo '{"alt": "disconnected"}'
