# Ockto plugins

Plugins da [Ockto](https://ockto.ai) para agentes. Todos apontam para o MCP de produção `https://mcp.ockto.ai/mcp` (Streamable HTTP, stateless). A autenticação é OAuth 2.1: o cliente descobre o Authorization Server em `https://api.ockto.ai` pelo Protected Resource Metadata (`https://mcp.ockto.ai/.well-known/oauth-protected-resource/mcp`) e registra o próprio cliente (DCR). Não há client id, secret nem token neste repositório.

A fonte das skills é [`content/skills/`](content/skills/). [`scripts/copy-skills.sh`](scripts/copy-skills.sh) copia esse texto para `cursor/skills`, `claude/skills`, `chatgpt/skills` e `gemini/skills`.

Submeter a um diretório público é passo humano. Este repositório não publica em marketplace.

## Instalação

| Cliente | O que o repositório entrega | Como instalar |
| --- | --- | --- |
| Cursor | Plugin em [`cursor/`](cursor/) | Copie `cursor/` para `~/.cursor/plugins/local/ockto` e recarregue. Em Team/Enterprise, um admin importa o repo em Dashboard → Plugins & MCPs. |
| Claude Code | Plugin em [`claude/`](claude/) | `/plugin marketplace add OcktoAi/ockto-plugins` e `/plugin install ockto@ockto`. |
| Claude.ai, Cowork, Desktop | Guia, sem manifest | Customize → Connectors → Add custom connector, URL `https://mcp.ockto.ai/mcp`. |
| ChatGPT e Codex | Pacote em [`chatgpt/`](chatgpt/) | Marketplace do repo em [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json). Conector avulso: Settings → Apps → Create. |
| Gemini CLI | Extensão em [`gemini/`](gemini/) | `gemini extensions install https://github.com/OcktoAi/ockto-plugins` depois da release `v*`. Sem release, o caminho local de `gemini/`. |

O detalhe de cada um está no README da pasta. Na primeira conexão, o membro escolhe a organização e os escopos. Deixe client id e client secret em branco.

## Escopos

`leads:read` `leads:write` `leads:delete`
`journeys:read` `journeys:write` `journeys:delete`
`assistants:read` `assistants:write` `assistants:delete`
`businesses:read` `businesses:write` `businesses:delete`
`automations:read` `automations:write` `automations:activate` `automations:delete`
`conversations:read` `integrations:read` `analytics:read`

O escopo é um limite a mais sobre o papel do membro na organização. Não substitui esse papel.

## Segurança

- OAuth 2.1 com PKCE no cliente. O access token fica no cliente, não em arquivo do plugin.
- Não coloque `Authorization`, client secret nem bearer em `mcp.json`, `.mcp.json` ou `gemini-extension.json`.
- Ativar e reativar automação, importar contatos, sincronizar fonte, resetar mapeamento e as ferramentas de exclusão, remoção e desvínculo confirmam em dois passos quando a skill diz isso. O argumento é `codigo_confirmacao`: a primeira chamada só descreve e devolve um código; a segunda repete os mesmos argumentos com esse código. O código expira em 120 segundos e vale uma vez.
- A conexão pode ser revogada na Ockto.

## Suporte

- Produto: https://ockto.ai
- Servidor: https://mcp.ockto.ai/mcp
- Issues: https://github.com/OcktoAi/ockto-plugins/issues

## Documentação dos formatos

- Cursor: https://cursor.com/docs/plugins e https://cursor.com/docs/plugins/building
- Claude Code: https://code.claude.com/docs/en/plugins-reference, https://code.claude.com/docs/en/plugin-marketplaces e https://code.claude.com/docs/en/mcp
- Conector do Claude.ai: https://claude.com/docs/connectors/custom/remote-mcp e https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp
- ChatGPT/Codex: https://developers.openai.com/plugins/build/plugins, https://developers.openai.com/plugins/deploy/connect-chatgpt e https://agent-plugins.org/specification
- Gemini CLI: https://geminicli.com/docs/extensions/reference/ e https://geminicli.com/docs/tools/mcp-server/

## Licença

MIT
