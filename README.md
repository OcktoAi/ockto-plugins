# Ockto

Cursor plugin that connects agents to [Ockto](https://ockto.ai) through Ockto's official remote [Model Context Protocol](https://modelcontextprotocol.io/) server.

Ockto is a multi-tenant platform for AI-driven sales funnels and lead management, with WhatsApp and Instagram channels. With this plugin, agents work on the signed-in member's organization: they can query the CRM, build journeys and automations, and set up AI employees and their knowledge brains.

## Install

1. Open **Cursor Settings → Plugins**.
2. Search for **Ockto**.
3. Click **Install**, then complete the Ockto sign-in and consent prompt.

## MCP

```json
{
  "mcpServers": {
    "ockto": {
      "type": "http",
      "url": "https://api.ockto.ai/mcp"
    }
  }
}
```

Auth is OAuth 2.1 with PKCE. Cursor opens the Ockto sign-in when the plugin connects; the member picks the organization and approves the requested access. Leave any OAuth client ID and secret blank.

## Before you connect

You need an Ockto account and membership in an organization. Every tool call runs with the permissions of that member's role — the plugin can never do more than the member can do in the Ockto web app.

## What agents can do

| Category | Capabilities |
| --- | --- |
| CRM | Contacts, contact channels, notes, and deals |
| Journeys | Journeys, kanban stages, and leads (create, move, pin, remove) |
| Automations | Automation flows (created as drafts), node types, runs, and activation |
| AI employees | AI employees and the knowledge brains linked to them |
| Knowledge | Brain sources and semantic search over brain content |
| Insights | Conversations, dashboard metrics, and connected integrations |

The hosted server is the source of truth for tool names and schemas. Tool names and descriptions are in Portuguese.

## Notes

- **Scopes:** `mcp:read` and `mcp:write`. They are an extra limit on top of the member's permissions, never a replacement for them.
- **Confirmation:** destructive actions (delete, remove, unlink, activate automation) run only after a second call carrying a single-use confirmation code valid for 120 seconds.
- **Revoking access:** connected apps can be reviewed and revoked in the Ockto web app at any time.

## Docs

- Ockto: https://ockto.ai
- Server URL: https://api.ockto.ai/mcp

Logo is Ockto's official mark.

## License

MIT
