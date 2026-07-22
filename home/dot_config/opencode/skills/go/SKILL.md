---
name: go
description: Use when running go, gofmt, or gofumpt commands.
license: UNLICENSE
compatibility: opencode
---

# Go commands

- Run Go commands in the current working directory by default.
- For another package, set the Bash tool's `workdir`.
- Do not use `go -C`.
- Preserve requested package patterns and test arguments.

The local permission policy auto-approves these command families:

- `go fmt`
- `go list`
- `go test`
- `gofmt`
- `gofumpt`

Other Go commands remain subject to Bash permission.
