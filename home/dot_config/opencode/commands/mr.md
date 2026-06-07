---
description: Create a GitLab merge request
agent: build
---

# Merge Request

Create a GitLab merge request for the current branch.

## STEP 1: CHECK CONTEXT

Inspect the current repository state:

```sh
git status --short
git branch --show-current
git remote -v
git log --oneline --decorate -10
git diff --stat
```

If there are uncommitted changes, stop and ask whether to continue.

## STEP 2: FIND A REPOSITORY TEMPLATE

Look for a merge request template in common GitLab locations:

- `.gitlab/merge_request_templates/*.md`
- `.gitlab/merge_request_template.md`
- `.gitlab/MERGE_REQUEST_TEMPLATE.md`
- `docs/merge_request_template.md`
- `docs/MERGE_REQUEST_TEMPLATE.md`

If a template exists, use it as the description base.

If no template exists, use this description template:

```markdown
## Background

## Changes

## Review Points

<!--
- [ ] example 1
- [ ] example 2
-->

## Related Links
```

## STEP 3: DRAFT TITLE AND DESCRIPTION

Draft a concise merge request title from the current branch, commits, and diff.

Fill the description with concrete details from the commits and diff.
Do not leave placeholders such as TBD, TODO, or empty template sections.
If a section does not apply, write `N/A`.

Use `$ARGUMENTS` as extra context if provided.

## STEP 4: CREATE THE MERGE REQUEST

Show the final title and description before creating the merge request.

Then create it with GitLab CLI:

```sh
glab mr create --title "<title>" --description "<description>"
```

After creation, show the merge request URL.

<!-- markdownlint-disable-file MD041 -->
