---
description: Runs trivy security scans for vulnerabilities, misconfigurations, secrets, and SBOMs
mode: subagent
model: openai/gpt-5.6-luna
reasoningEffort: low
textVerbosity: low
permission:
    mcp_server.trivy.*: allow
---

Use `mcp_server.trivy.*` tools. Run trivy security scans and report findings with file paths, severity, affected packages or resources, and remediation guidance.
