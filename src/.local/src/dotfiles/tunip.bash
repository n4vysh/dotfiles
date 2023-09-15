#!/bin/bash

name=$(
	basename -a /sys/class/net/* |
		grep tun |
		fzf +m
)

if [[ -n $name ]]; then
	ip -4 addr show "$name" |
		grep -oP '(?<=inet\s)\d+(\.\d+){3}' |
		tr -d '\n'
fi
