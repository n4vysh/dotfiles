---
name: gh-pending-review
description: Create pending reviews on GitHub with gh
---

# GitHub Pending Review

Use the Pull Request Reviews API without an `event` to create a pending
review

Use `jq` to safely build the JSON payload

```sh
jq -n \
  --arg path "$PATH" \
  --arg body "$COMMENT" \
  --argjson line "$LINE" \
  '{
    comments: [{
      path: $path,
      line: $line,
      side: "RIGHT",
      body: $body
    }]
  }' |
gh api \
  --method POST \
  "repos/{owner}/{repo}/pulls/$PR/reviews" \
  --input -
```

Do not set `event` when creating the review
