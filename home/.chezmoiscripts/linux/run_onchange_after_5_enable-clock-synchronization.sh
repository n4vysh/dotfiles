#!/bin/sh

set -eu

gum log --level info 'Enable ntp'
sudo timedatectl set-ntp true

gum log --level info 'Show time settings'
sudo timedatectl status
