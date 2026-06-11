# GitHub MCP

Purpose: expose GitHub repository, issue, pull request, and file operations to Hermes through GitHub's remote MCP endpoint.

Endpoint:

```text
https://api.githubcopilot.com/mcp/
```

Required local environment variables:

- `GITHUB_TOKEN` — GitHub token/PAT/OAuth token with only the scopes needed locally. Do not commit the value.

Public-safe Hermes config template: `mcps/configs/hermes-mcp.example.yaml`

Security notes:

- Prefer least-privilege tokens.
- Keep write-capable GitHub tools enabled only where needed.
- Never put a bearer token directly into committed YAML; use `${GITHUB_TOKEN}` placeholders.
