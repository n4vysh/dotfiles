#!/bin/bash

count="$(arch-audit --upgradable | wc -l)"

[[ "$count" != 0 ]] && echo " arch-audit"
