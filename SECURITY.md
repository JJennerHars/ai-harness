# Secrets and privacy policy

This repository is designed to be public-safe.

## Blocked content

Do not commit any of the following:

- API tokens, OAuth refresh/access tokens, passwords, passphrases, private SSH/GPG keys, cookies, session IDs, or bearer tokens.
- `.env`, `auth.json`, `state.db`, session transcripts, logs, request dumps, or local cache directories.
- Personal email addresses, phone numbers, mailing addresses, account IDs, private usernames, or private organization/customer names.
- Personal Obsidian/vault notes or any context-engine content about Josh, relationships, finances, work details, private projects, or messages.
- Unreviewed copies of local agent config files.
- MCP configs with real `env`, `headers`, `authorization`, URLs with credentials, database URLs, or sensitive local paths.

## Allowed content

Allowed if reviewed and sanitized:

- Reusable `SKILL.md` files that contain public, procedural knowledge only.
- MCP server templates with placeholders and documentation links.
- Generic agent instructions that do not reveal private context.
- Bootstrap scripts that install or copy public-safe files.

## Required review before publishing

Before the remote repository is created or pushed:

1. Run `scripts/scan-for-secrets.sh`.
2. Run `git status --short` and inspect every file.
3. Run `git diff --cached` before commit.
4. Manually confirm no secrets or direct personal information are present.
