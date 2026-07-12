---
description: Create a GitHub pull request
agent: build
---

# Pull Request

Create a GitHub pull request for the current branch.

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

Look for a pull request template in common GitHub locations:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/pull_request_template/*.md`
- `.github/PULL_REQUEST_TEMPLATE/*.md`
- `docs/pull_request_template.md`
- `docs/PULL_REQUEST_TEMPLATE.md`

If a template exists, use it as the body base.

If no template exists, use this body template:

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

## STEP 3: DRAFT TITLE AND BODY

Draft a concise pull request title from the current branch, commits, and diff.

Fill the body with concrete details from the commits and diff.
Do not leave placeholders such as TBD, TODO, or empty template sections.
If a section does not apply, write `N/A`.

Use `$ARGUMENTS` as extra context if provided.

## STEP 4: CREATE THE PULL REQUEST

Show the final title and body before creating the pull request.

Then create it with GitHub CLI:

```sh
gh pr create --title "<title>" --body "<body>"
```

After creation, show the pull request URL.

<!-- rumdl-disable-file MD041 -->
