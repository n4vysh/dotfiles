#!/bin/bash

OPENAI_API_KEY="$(gopass show -o n4vysh/openai/elia)"
export OPENAI_API_KEY

exec ~/.local/bin/elia "$@"
