#!/usr/bin/env bash

if [ -f .pre-commit-config.yaml ]; then
	# shellcheck disable=SC2016
	echo 'pre-commit configuration detected, but `pre-commit install` was never run' 1>&2
	exit 1
fi
