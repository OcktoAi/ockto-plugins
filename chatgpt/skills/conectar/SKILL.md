---
name: conectar
description: Liga o cliente ao MCP da Ockto em https://mcp.ockto.ai/mcp, com OAuth 2.1 e escopos granulares, sem gravar token.
---

# Conectar a Ockto

Servidor: `https://mcp.ockto.ai/mcp`. Transporte Streamable HTTP, stateless.

Não peça client id, client secret nem access token. Não grave credencial em arquivo, header de `mcp.json` ou variável do plugin. O cliente descobre o Authorization Server e registra o próprio cliente.

## Descoberta

1. Protected Resource Metadata: `https://mcp.ockto.ai/.well-known/oauth-protected-resource/mcp`.
2. O documento aponta `authorization_servers` para `https://api.ockto.ai`.
3. Metadata do Authorization Server: `https://api.ockto.ai/.well-known/oauth-authorization-server`, com registro dinâmico de cliente (DCR).
4. Na tela de consentimento o membro escolhe a organização. O papel dele na organização limita os escopos que podem ser concedidos.

Deixe client id e client secret em branco.

## Onde informar a URL

- Cursor: Customize, servidor MCP com essa URL, ou o plugin `ockto`.
- Claude Code: `claude mcp add --transport http ockto https://mcp.ockto.ai/mcp`, ou o plugin.
- Claude.ai, Cowork e Claude Desktop: Customize → Connectors → Add custom connector. Em plano Team ou Enterprise, um Owner adiciona antes em Organization settings → Connectors → Add → Custom → Web.
- ChatGPT: Settings → Apps → Create, com developer mode, endpoint `https://mcp.ockto.ai/mcp` e autenticação OAuth.
- Gemini CLI: a extensão usa `httpUrl`. O CLI faz o OAuth na conexão. Não declare API key em `settings`.

## Escopos

`leads:read` `leads:write` `leads:delete`
`journeys:read` `journeys:write` `journeys:delete`
`assistants:read` `assistants:write` `assistants:delete`
`businesses:read` `businesses:write` `businesses:delete`
`automations:read` `automations:write` `automations:activate` `automations:delete`
`conversations:read` `integrations:read` `analytics:read`

Cada ferramenta exige o escopo dela. Sem esse escopo a chamada é recusada. Escopo não substitui a permissão do membro.

`listar_integracoes` (`integrations:read`) lista canais (WhatsApp, Instagram, Messenger) e conexões de automação: nome, provedor, status e identificador. Não devolve credencial. `recorte` opcional: `canais` ou `conexoes`.

## Confirmação em dois passos

`ativar_automacao` e as ferramentas de exclusão, remoção e desvínculo não executam na primeira chamada. O argumento `codigo_confirmacao` não entra no schema da ferramenta: o servidor acrescenta.

1. Chame sem `codigo_confirmacao`. A resposta descreve o efeito e devolve um código.
2. Mostre esse efeito ao usuário. Só então chame de novo com os mesmos argumentos e `codigo_confirmacao` igual ao código recebido.
3. O código expira em 120 segundos e vale uma vez. Qualquer argumento diferente invalida o código. Para obter outro, chame de novo sem `codigo_confirmacao`.

Não invente o código e não reutilize código de outra ferramenta.
