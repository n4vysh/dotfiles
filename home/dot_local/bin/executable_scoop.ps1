#!/bin/sh

# shellcheck disable=SC2016
exec powershell.exe -c '& "$env:USERPROFILE\scoop\shims\scoop.ps1"' "$@"
