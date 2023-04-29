#!/bin/bash

# HACK: Set invalid value of $PASSWORD_STORE_DIR to disable pass helper
#       pass command require PIN numbers of GPG security key,
#       so it stop protonmail-bridge without this method
# https://github.com/ProtonMail/proton-bridge/blob/v2.3.0/pkg/keychain/helper_linux.go#L55
PASSWORD_STORE_DIR=/dev/null /usr/bin/protonmail-bridge "$@"
