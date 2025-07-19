#!/bin/bash

systemctl is-failed --quiet rkhunter.service
result="$?"

[[ "$result" == 0 ]] && echo " rkhunter"
