# Export notes

This repo contains a curated, sanitized export of portable harness setup.

Included:

- Modified/custom public-safe skills under `skills/`.
- Sanitized MCP templates for Obsidian Intelligence Layer and GitHub MCP.
- Catalog notes documenting required environment variable names only.
- Attribution links in `NOTICE.md` and the relevant MCP catalog/config files for third-party tools such as Obsidian Intelligence Layer MCP, GitHub MCP, MCP, and Hermes Agent.

Deliberately excluded:

- Private context-engine skills/instructions that directly encode personal context.
- Live Hermes `config.yaml`, `.env`, `auth.json`, sessions, memory, logs, and databases.
- Real vault paths, OAuth tokens, API keys, account IDs, email addresses, or private local paths.

Before each push, run:

```bash
scripts/scan-for-secrets.sh
git status --short
git diff --cached
```
