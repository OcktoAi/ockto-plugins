# Changelog

## 2.0.0

- Breaking: o servidor MCP passa de `https://api.ockto.ai/mcp` para `https://mcp.ockto.ai/mcp`.
- Breaking: os escopos `mcp:read` e `mcp:write` saem. O consentimento usa 19 escopos granulares.
- O repositório vira monorepo: Cursor, Claude Code, ChatGPT/Codex e Gemini CLI.
- Skills de domínio em `content/skills/`, copiadas para cada cliente que carrega skills.
- Claude.ai, Cowork, Claude Desktop e o conector avulso do ChatGPT ficam como guia, sem manifest inventado.

## 1.0.0

- Initial release: Ockto remote MCP server (`https://api.ockto.ai/mcp`) with OAuth sign-in.
