# AI Harness

Portable, public-safe setup for AI agent harness configuration: skills, MCP server templates, agent instructions, and bootstrap scripts.

This repository is intended to be safe to make public. It must not contain personal data, emails, API tokens, passwords, OAuth files, database URLs, private hostnames, or machine-specific secrets.

## Layout

```text
.
├── skills/                 # Portable SKILL.md folders only; no private context or secrets
├── mcps/
│   ├── configs/            # Sanitized MCP config examples/templates
│   └── catalog/            # Notes about MCP servers used and install commands
├── agent-instructions/     # Public-safe generic agent instruction files
├── profiles/               # Public-safe profile skeletons only
├── scripts/                # Bootstrap/sync/validation scripts
└── docs/templates/         # Templates for adding new skills/MCP definitions
```

## Credits and upstream attribution

This repo contains public-safe setup files plus sanitized templates for third-party tools. Anything not authored here should link back to its upstream project or official documentation. See [`NOTICE.md`](NOTICE.md) for current credits, including Obsidian Intelligence Layer MCP, GitHub MCP, MCP itself, and Hermes Agent.

## Privacy rules

Never commit:

- `.env`, `auth.json`, OAuth/token stores, API keys, passwords, secrets, private keys, cookies, or session files.
- Personal emails, phone numbers, addresses, usernames tied to private accounts, private notes, vault content, or personal context.
- Real local absolute paths that expose private names or sync locations, except generic examples using placeholders.
- Raw Hermes config copied from `~/.hermes/config.yaml` without review.
- MCP configs containing live credentials, account IDs, database URLs, private filesystem paths, or sensitive allowlists.

Use placeholders instead:

```yaml
api_key_env: EXAMPLE_API_KEY
allowed_path: "${HOME}/Projects/example"
```

## Suggested workflow

1. Add or update portable skills under `skills/<skill-name>/SKILL.md`.
2. Add sanitized MCP templates under `mcps/configs/<server>.example.yaml` or `.example.json`.
3. Run `scripts/scan-for-secrets.sh` before every commit.
4. Review `git diff --staged` manually before pushing.

## Install/sync approach

This repo should eventually provide scripts that copy selected public-safe files into the local harness locations, e.g. Hermes skills or MCP config snippets. Scripts should be explicit, dry-run by default where possible, and should never overwrite private local config without confirmation.
