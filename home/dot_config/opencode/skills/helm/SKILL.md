---
name: helm
description: Use when running helm commands.
license: UNLICENSE
compatibility: opencode
---

# Helm

Place `--kube-context`, `--namespace`, and `-n` after the subcommand.

Use:

```sh
helm template <release> <chart> --kube-context <context> -n <namespace>
```

Avoid:

```sh
helm --kube-context <context> -n <namespace> template <release> <chart>
```

The local permission policy auto-approves these command patterns:

- `list *`
- `show *`
- `template *`

Mutating commands remain subject to Bash permission.
