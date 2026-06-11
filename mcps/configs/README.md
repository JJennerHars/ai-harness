# MCP configs

Store sanitized MCP examples/templates here.

Rules:

- Prefer `.example.yaml` or `.example.json` suffixes.
- Use placeholders for env vars, URLs, account IDs, headers, and filesystem paths.
- Do not commit copied live config from `~/.hermes/config.yaml` or any other agent config.
- Do not include tokens in `env`, `headers`, `args`, or command strings.

Example shape for Hermes:

```yaml
mcp_servers:
  example:
    command: uvx
    args: ["example-mcp-server"]
    env:
      EXAMPLE_API_KEY: "${EXAMPLE_API_KEY}"
    tools:
      include: ["safe_read_only_tool"]
```
