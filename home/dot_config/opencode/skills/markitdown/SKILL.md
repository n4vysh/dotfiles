---
name: markitdown
description: Use when converting files, documents, or URLs to Markdown.
license: UNLICENSE
compatibility: opencode
---

# MarkItDown

Run the CLI via Bash and consume stdout by default.

Supported inputs include:

- PDF
- PowerPoint
- Word
- Excel
- Images
- Audio
- HTML
- Text formats such as CSV, JSON, and XML
- ZIP archives
- YouTube URLs
- EPUB

## Usage

Convert a file:

```bash
markitdown path-to-file.pdf
```

Save the output:

```bash
markitdown path-to-file.pdf -o document.md
```

Convert stdin with an extension hint:

```bash
markitdown -x pdf <path-to-file
```
