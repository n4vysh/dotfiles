#!/bin/bash

OPENAI_KEY="$(gopass show -o n4vysh/openai/aicommits)"
export OPENAI_KEY

exec /usr/bin/aicommits "$@"
