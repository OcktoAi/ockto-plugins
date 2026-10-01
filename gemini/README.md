# Ockto no Gemini CLI

Extensão do Gemini CLI. O manifest é [`gemini-extension.json`](gemini-extension.json).

Servidor: `https://mcp.ockto.ai/mcp`, no campo `httpUrl` de `mcpServers`. A referência de extensões diz que valem as opções de servidor MCP, exceto `trust`. `httpUrl` é o transporte HTTP streaming em [MCP servers](https://geminicli.com/docs/tools/mcp-server/). `url` seria SSE, e este servidor não é SSE.

`contextFileName` aponta para [`GEMINI.md`](GEMINI.md). As skills ficam em `skills/`, no formato que a referência chama de agent skills: [Extension reference](https://geminicli.com/docs/extensions/reference/).

Não há `settings` de API key. O CLI faz OAuth na conexão. Não grave token na extensão.

## Instalar

A documentação atual instala pela URL do GitHub ou por um caminho local, e procura `gemini-extension.json` na raiz dessa fonte. Neste monorepo o manifest está em `gemini/`, não na raiz do Git. Use o caminho local:

```text
git clone https://github.com/OcktoAi/ockto-plugins.git
gemini extensions install /caminho/para/ockto-plugins/gemini
```

Para desenvolver sem copiar: `gemini extensions link /caminho/para/ockto-plugins/gemini`. Reinicie o CLI depois.

O campo `name` é `ockto`. A referência espera que esse nome coincida com o diretório da extensão.

Sem a extensão, o mesmo servidor entra na configuração do usuário:

```text
gemini mcp add --transport http ockto https://mcp.ockto.ai/mcp
```

## Skills

- `conectar` — OAuth, escopos e canais conectados
- `crm` — contatos, canais, notas e leads nas jornadas
- `jornadas` — jornadas e etapas
- `funcionarios` — funcionários de IA e cérebros
- `automacoes` — rascunho, ativação e execuções
- `conversas` — conversas e métricas
- `negocios` — marcas da organização
