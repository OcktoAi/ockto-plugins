# Ockto no Claude

Dois jeitos, de propósito. O Claude Code instala um plugin. Claude.ai, Cowork e o Claude Desktop entram por conector customizado: a Anthropic não descreve um manifest de repositório para esse conector.

Servidor: `https://mcp.ockto.ai/mcp`

## Claude Code

Plugin em [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json), MCP em [`.mcp.json`](.mcp.json) (`type: http`) e skills em `skills/`. O catálogo do repositório está em [`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json).

Referências: [plugins](https://code.claude.com/docs/en/plugins-reference), [marketplaces](https://code.claude.com/docs/en/plugin-marketplaces), [MCP](https://code.claude.com/docs/en/mcp).

```text
/plugin marketplace add OcktoAi/ockto-plugins
/plugin install ockto@ockto
```

Sem o plugin, no Claude Code:

```text
claude mcp add --transport http ockto https://mcp.ockto.ai/mcp
```

Na primeira conexão, autorize no navegador. Deixe client id e client secret em branco. O registro do cliente é dinâmico.

## Claude.ai, Cowork e Claude Desktop

Conector customizado por URL. Não há `plugin.json` para esses clientes.

- Plano individual: Customize → Connectors → Add custom connector. URL `https://mcp.ockto.ai/mcp`. Advanced settings fica vazio.
- Team ou Enterprise: um Owner adiciona em Organization settings → Connectors → Add → Custom → Web. Depois cada membro conecta em Customize → Connectors.

Atalho com nome e URL preenchidos, documentado em [directory vs custom](https://claude.com/docs/connectors/building/directory-vs-custom):

```text
https://claude.ai/customize/connectors?modal=add-custom-connector&connectorName=Ockto&connectorUrl=https%3A%2F%2Fmcp.ockto.ai%2Fmcp
```

O usuário ainda confirma antes de adicionar. Guias: [conector remoto](https://claude.com/docs/connectors/custom/remote-mcp) e [primeiros passos](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp).

Não coloque client id, secret nem header. A descoberta OAuth parte de `https://mcp.ockto.ai/.well-known/oauth-protected-resource/mcp`.

## Skills

- `conectar` — OAuth, escopos e canais conectados
- `crm` — contatos, canais, notas e leads nas jornadas
- `jornadas` — jornadas e etapas
- `funcionarios` — funcionários de IA e cérebros
- `automacoes` — rascunho, ativação e execuções
- `conversas` — ler, responder, transferir e métricas
- `organizacao` — membros e limites do plano
- `negocios` — marcas da organização

O plugin não substitui o app da Ockto. Este repositório não envia o plugin a marketplace da Anthropic.
