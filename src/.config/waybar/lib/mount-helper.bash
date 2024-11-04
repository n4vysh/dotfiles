#!/bin/bash

udiskie-info -a | grep . >/dev/null
result="$?"

[[ "$result" == 0 ]] && echo "󱊞"
