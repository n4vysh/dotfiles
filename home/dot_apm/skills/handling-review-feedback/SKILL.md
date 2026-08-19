---
name: handling-review-feedback
description: Handle review feedback on GitHub and GitLab.
---

# Handling Review Feedback

- Use pending reviews on GitHub.
- Use draft notes on GitLab.
- Commit changes before replying to review thread.
- Reply to review thread after committing.
    - Mention reviewer in reply.
    - Include commit short hash in reply.
    - Ask reviewer to confirm changes.
    - Use `\` for line breaks in reply.
    - Keep commit IDs unquoted so that they are automatically linked.
- Do not resolve to conversation before reviewer confirmation.

## Examples

### Japanese

Feedback:

> `user` がnilの処理も追加お願いしたいです

Reply:

> @reviewer\
> 承知しました\
> a1b2c3d にて対応しました\
> 確認いただけると幸いです

### English

Feedback:

> Please handle the case where `user` is nil.

Reply:

> @reviewer\
> Thanks for pointing this out.\
> Addressed in a1b2c3d.\
> Could you take another look?
