---
name: public-safe-config-repositories
description: Create and maintain public-safe repositories for portable agent/dotfile/harness configuration, including skills, MCP templates, instructions, and bootstrap scripts without leaking personal data or secrets.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [config-repos, dotfiles, harness, skills, mcp, public-safe, privacy, github]
---

# Public-Safe Config Repositories

## When to use

Use this skill when the user asks to create, structure, audit, publish, or sync a repository containing portable setup/configuration such as:

- AI harness files, agent instructions, skills, MCP templates, plugins, or bootstrap scripts.
- Dotfiles or cross-machine setup files.
- Public or potentially public copies of local agent configuration.
- Any repo that intentionally mirrors useful local setup while excluding personal data and secrets.

## Core principle

Treat these repositories as **public by default** even if the initial remote will be private. The repo should contain reusable, portable, sanitized setup artifacts — not live local state.

Never copy raw local agent/profile/config directories directly into the repo. Create reviewed templates, examples, and curated skills instead.

## Recommended repository shape

Prefer a class-level, extensible structure:

```text
repo/
├── README.md
├── SECURITY.md
├── .gitignore
├── .gitattributes
├── skills/                 # Portable SKILL.md folders only
├── mcps/
│   ├── configs/            # Sanitized .example.yaml/.example.json templates
│   └── catalog/            # One note per MCP server: purpose/install/security
├── agent-instructions/     # Generic public-safe instructions
├── profiles/               # Public-safe skeletons only, never live profiles
├── scripts/                # Bootstrap/sync/validation scripts
└── docs/templates/         # Starter templates for skills/configs
```

For skill collections, each skill should remain self-contained:

```text
skills/<skill-name>/
├── SKILL.md
├── references/
├── scripts/
└── templates/
```

## Workflow

1. **Research before scaffolding when asked.** Public dotfiles, Agent Skills, and MCP repositories commonly use a README-first structure, grouped config directories, install/bootstrap scripts, and strong secret hygiene. See `references/repo-structure-research.md` for the condensed research pattern.
2. **Choose a conventional local repo root.** On Windows, prefer `${HOME}/Sources/<repo-name>` when no stronger project-specific location exists. Use POSIX paths under git-bash tools when executing shell commands.
3. **Initialize the repo locally before creating a remote.** Use `git init -b main`, add a skeleton, run privacy checks, and make an initial commit. Only create/push a remote after review/confirmation when public exposure is possible.
4. **Add explicit privacy documentation.** Include a README statement that the repo is public-safe and a SECURITY.md with blocked content.
5. **Add defensive ignore rules.** Block `.env`, auth/token stores, session/log/cache directories, SQLite state, private keys, credential files, and local runtime artifacts.
6. **Use templates/placeholders, not live values.** MCP configs should use `.example.yaml`/`.example.json` and placeholders like `${EXAMPLE_API_KEY}`. Document required env var names, never values.
7. **Add a local scanner.** Include a simple `scripts/scan-for-secrets.sh` or equivalent; run it before committing and before publishing.
8. **Manual diff review remains mandatory.** Secret scanners are a backstop, not proof of safety. Inspect `git status`, staged files, and `git diff --cached` before pushing.

## Public-safety rules

Never commit:

- `.env`, `auth.json`, OAuth stores, API tokens, passwords, passphrases, cookies, bearer tokens, private SSH/GPG keys, or session IDs.
- Hermes `state.db`, session transcripts, logs, request dumps, caches, audio cache, or runtime databases.
- Personal emails, phone numbers, addresses, private account IDs, private usernames, private organization/customer names, or personal vault/context-engine content.
- Raw `~/.hermes/config.yaml`, live profile directories, or MCP configs copied from a machine without review.
- Database URLs, private hostnames, sensitive filesystem allowlists, or URLs containing embedded credentials.

Allowed after review:

- Reusable `SKILL.md` files containing public procedural knowledge.
- Sanitized MCP templates with placeholder environment variables.
- Generic agent instructions not tied to personal/private context.
- Bootstrap scripts that copy/install public-safe files and avoid overwriting private config without confirmation.

## Verification commands

Typical local initialization pattern:

```bash
mkdir -p "$HOME/Sources/<repo-name>"
cd "$HOME/Sources/<repo-name>"
git init -b main
mkdir -p skills mcps/configs mcps/catalog scripts docs/templates agent-instructions profiles
# create README.md, SECURITY.md, .gitignore, .gitattributes, templates
chmod +x scripts/scan-for-secrets.sh
./scripts/scan-for-secrets.sh
git add .
git diff --cached --stat
git commit -m 'chore: initialize public-safe config repo'
```

Before remote creation or push:

```bash
./scripts/scan-for-secrets.sh
git status --short
git diff --cached
git log --oneline -1
```

If using GitHub CLI after confirmation:

```bash
gh repo create <repo-name> --public --source . --push --description '<public-safe description>'
```

## Pitfalls

- **Do not mirror live config directories wholesale.** Live Hermes/profile folders can contain tokens, memory, sessions, logs, and private skills.
- **Do not rely on `.gitignore` alone.** Files already staged or committed can bypass new ignore rules.
- **Do not treat scanner success as publish approval.** Scanners miss semantic personal information; manually inspect staged content.
- **Do not create the public remote before review if the user explicitly asked to research or prepare locally first.** Build locally, verify, then ask/confirm before publishing.
- **Avoid direct personal paths in committed docs.** Use `${HOME}` or placeholders unless a path is generic and intentionally local-only in a report, not committed repo content.
