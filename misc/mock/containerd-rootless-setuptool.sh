#!/bin/bash

if [[ $1 == install ]] || [[ $1 == install-buildkit ]]; then
  true
else
  /usr/bin/containerd-rootless.sh "$@"
fi
