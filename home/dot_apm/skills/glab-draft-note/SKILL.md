---
name: glab-draft-note
description: Create draft notes on GitLab with glab
---

# GitLab Draft Note

Use the Draft Notes API to create an unpublished comment

```sh
glab api \
  --method POST \
  "projects/:id/merge_requests/$MR/draft_notes" \
  --field "note=$COMMENT"
```

For inline comments, include the appropriate `position` fields

Use `jq` when building complex JSON payloads such as inline positions
