---
name: kubectl
description: Use when running kubectl commands.
license: UNLICENSE
compatibility: opencode
---

# kubectl

Place `--context`, `--namespace`, and `-n` after the subcommand.

Use:

```sh
kubectl get pods --context <context> -n <namespace>
```

Avoid:

```sh
kubectl --context <context> -n <namespace> get pods
```

The local permission policy auto-approves these read command patterns:

- `auth whoami *`
- `auth can-i *`
- `config current-context`
- `logs *`
- `explain *`
- `get *`
- `describe *`
- `rollout history *`

Mutating commands remain subject to Bash permission.
