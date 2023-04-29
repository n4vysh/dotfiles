#!/bin/bash

nordvpn status |
	grep 'Status: Connected' >/dev/null &&
	echo '{"alt": "connected"}' ||
	echo '{"alt": "disconnected"}'
