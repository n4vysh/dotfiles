---
name: skill-creator
description: Create effective skills. Use when creating or updating skills.
license: UNLICENSE
compatibility: opencode
---

# Skill Creator

## Principles

- **Concise**: Only add context AI doesn't have.
- **Progressive disclosure**: Metadata → SKILL.md → Resources
- **Appropriate freedom**: High for flexible, low for fragile tasks.

## Structure

```txt
skill-name/
├── SKILL.md (required)
└── Optional: scripts/, references/, assets/
```

- **SKILL.md**:
    - `name`: lowercase, hyphens, max 64 chars
    - `description`: max 1024 chars, third person, what + when
    - `compatibility`: opencode
    - Body: under 500 lines
- **Naming**: Gerund form (`processing-pdfs`, `analyzing-data`)
- **Description**: `Extract PDF text. Use when working with PDFs.`

## Formatting

- **80 chars guideline**: Exceptions: URLs, code, tables
- **Paths**: Forward slashes (`scripts/file.py`)
- **Terminology**: Consistent throughout

## Patterns

**Progressive disclosure**:

```markdown
## Quick start

[Instructions]

## Advanced

See [ADVANCED.md](ADVANCED.md)
```

**Workflows with checklist**:

```markdown
- [ ] Analyze
- [ ] Validate
- [ ] Execute
```

- **Feedback loops**: Validate → fix → repeat
- **Templates**: `ALWAYS use: [template]` or `Adapt as needed: [...]`
- **Examples**: Provide input/output pairs

## Anti-Patterns

❌ Windows paths, vague descriptions, many options
❌ Time-sensitive info, nested references

## Development

1. Complete task, notice repeated context
2. Create skill with AI
3. Test, iterate

## Template

```markdown
---
name: skill-name
description: What it does. Use when [trigger].
license: UNLICENSE
compatibility: opencode
---

# Skill Name

[Instructions]
```

**Checklist**:

- [ ] Description under 80 chars, third person
- [ ] Body under 500 lines, 80 char guideline
- [ ] Consistent terminology
- [ ] References one level deep
- [ ] Tested with real usage

<!--
References:
- https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
-->
