---
name: helmfile
description: Use when running helmfile commands.
license: UNLICENSE
compatibility: opencode
---

# Helmfile

Place `--kube-context`, `--namespace`, and `-n` after the subcommand.

Use:

```sh
helmfile template --kube-context <context> -n <namespace>
```

Avoid:

```sh
helmfile --kube-context <context> -n <namespace> template
```

The local permission policy auto-approves `template`.
Other commands remain subject to Bash permission.
