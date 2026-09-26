---
name: glab-mr
description: Use when you need to inspect GitLab merge requests from CLI, including MR details, diffs, comments/system logs, and commit history context.
---

# glab mr

Use this skill to inspect GitLab merge requests from the CLI.

## Examples

<!-- rumdl-disable MD013 -->

```sh
# show current branch MR details
glab mr view

# show MR comments and system logs
glab mr view --comments --system-logs

# show MR details in JSON
glab mr view -F json

# show MR diff
glab mr diff

# list MR notes (includes system notes)
glab api \
    "/projects/$project_id/merge_requests/$mr_id/notes?per_page=100" \
    --paginate

# list MR discussions with review comments
glab api \
    "/projects/$project_id/merge_requests/$mr_id/discussions?per_page=100" \
    --paginate

# list commits in an MR
glab api \
    "/projects/$project_id/merge_requests/$mr_id/commits?per_page=100" \
    --paginate

# extract only human notes (exclude system notes)
glab api \
    "/projects/$project_id/merge_requests/$mr_id/notes?per_page=100" \
    --paginate |
    jq -r '.[] | select(.system == false) | "\(.created_at)\t\(.author.username)\t\(.body)"'

# extract unresolved discussion notes
glab api \
    "/projects/$project_id/merge_requests/$mr_id/discussions?per_page=100" \
    --paginate |
    jq -r '.[] | .notes[] | select(.system == false and .resolvable == true and .resolved == false) | "\(.created_at)\t\(.author.username)\t\(.body)"'

# count unresolved discussion notes by author
glab api \
    "/projects/$project_id/merge_requests/$mr_id/discussions?per_page=100" \
    --paginate |
    jq -r '.[] | .notes[] | select(.system == false and .resolvable == true and .resolved == false) | .author.username' |
    sort |
    uniq -c |
    sort -nr
```

<!-- rumdl-enable MD013 -->

## Unix command extraction tips

- Prefer `glab api ... --paginate | jq ...` for stable extraction.
- Use `select(.system == false)` to skip system notes.
- Use `select(.resolvable == true and .resolved == false)` for unresolved comments.
- Summarize with standard Unix commands such as `sort`, `uniq`, and `wc`.
