# Obsidian Intelligence Layer MCP

Purpose: expose a local Obsidian vault or Markdown knowledge base to Hermes through token-efficient search, metadata reads, section reads, and controlled writes.

Upstream package: `@jinlee794/obsidian-intelligence-layer`

Install/run command:

```bash
npx -y @jinlee794/obsidian-intelligence-layer mcp
```

Required local environment variables:

- `OBSIDIAN_VAULT_PATH` — absolute path to the local vault/knowledge-base folder. Do not commit the actual value.

Public-safe Hermes config template: `mcps/configs/hermes-mcp.example.yaml`

Security notes:

- Treat the vault path as private unless it points to a deliberately public example vault.
- Review write-capable tools before enabling this MCP in unattended workflows.
- Keep private notes and personal context outside this repository.
