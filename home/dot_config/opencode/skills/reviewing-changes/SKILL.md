---
name: reviewing-changes
description: Review changes in GitHub pull requests and GitLab merge requests
---

# Reviewing Changes

- Use pending reviews on GitHub.
- Use draft notes on GitLab.
- Be respectful and comment on the change.
    - Do not dismiss or make assumptions about the assignee's approach.
    - Do not block changes based only on personal preferences.
- When you agree with part of the approach, acknowledge it first.
- When requesting a change:
    - Explain why the change is needed.
    - Include a concrete direction for the requested change.
- Prefer actionable feedback over open-ended questions.
- If the intent is unclear:
    - Explain what is unclear and why.
    - Ask for the reason behind the implementation.
    - Avoid vague questions.
- Clearly mark low-priority or optional feedback.

## Examples

### Maintainability

> @assignee\
> 保守性を上げるため、~をする必要がありそうです\
> ~のような場合に保守しづらくなる可能性があると考えています

### Readability

> @assignee\
> 可読性を上げるため、~すると良さそうです

### Possibly Unnecessary Change

> @assignee\
> 処理が重複しているため、おそらく不要そうです\
> もし意図的に重複させている場合、その旨を教えてほしいです

### Alternative Approach

> @assignee\
> 確かにそうですね\
> 一方で~の場合は失敗してしまう可能性もありそうです\
> ~の場合も考慮して、処理を追加したいと考えてるのですが、どうでしょうか？

### Low Priority

> @assignee\
> 優先度: 低\
> 余裕があれば、~を改善すると良さそうです
