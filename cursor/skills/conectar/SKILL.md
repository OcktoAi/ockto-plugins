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
`conversations:read` `conversations:write` `integrations:read` `analytics:read` `organization:read`

Cada ferramenta exige o escopo dela. Sem esse escopo a chamada é recusada. Escopo não substitui a permissão do membro.

`conversations:write` e `organization:read` só entram num consentimento novo. Quem já conectou não os recebe na renovação do token. Se a ferramenta não estiver na lista do cliente, ou a chamada responder `insufficient_scope` (a ferramenta exige o escopo), reconecte o MCP e aceite esses escopos na tela de consentimento.

## Canais e conexões

Estas ferramentas só leem e não devolvem credencial. `pagina` começa em 1, `limite` tem padrão 20 e teto 50. A resposta traz `total`, `pagina`, `limite` e `tem_mais`.

- `listar_integracoes` (`integrations:read`) é a visão geral: canais (WhatsApp, Instagram, Messenger) e conexões de automação, com nome, provedor, status e identificador. `busca` opcional. `recorte` opcional: `canais` ou `conexoes`.
- `listar_canais` (`integrations:read`; com status ao vivo, consulta a Meta) lista só canais de atendimento. `provedor`: `whatsapp`, `instagram`, `facebook`, `meta` (instagram e facebook), `canais` ou `todos` (padrão). O registro traz funcionário e, no WhatsApp, a jornada padrão. Com `conexao_id` e `provedor` `whatsapp` ou `todos`, o status ao vivo sai para a Graph API da Meta.
- `obter_saude_canais` (`integrations:read`) lê o status monitorado. `conexao_id` opcional restringe a uma conexão. Não força checagem externa.
- `listar_templates_whatsapp` (`integrations:read`) lista templates armazenados de uma conexão WhatsApp. Exige `conexao_id` (de `listar_canais`). Não sincroniza com a Meta.
- `listar_provedores_conexao` (`integrations:read`) lista o catálogo de provedores (Slack, Jira, HTTP, banco). Não devolve id de conexão já criada.
- `obter_conexao` (`integrations:read`) detalha uma conexão de automação, sem credencial. Exige `conexao_id` de `listar_integracoes` com `recorte` `conexoes`.

Valor mascarado `***` (ou URL `://***@`) não é o segredo. Não o reenvie para gravar por cima.

## Confirmação em dois passos

A skill de cada ferramenta diz quando a primeira chamada só descreve. Entram aí `responder_conversa`, ativar e reativar automação, importar contatos, sincronizar fonte de cérebro, resetar mapeamento de nó e as ferramentas de exclusão, remoção e desvínculo. O argumento `codigo_confirmacao` não entra no schema da ferramenta: o servidor acrescenta.

1. Chame sem `codigo_confirmacao`. A resposta descreve o efeito e devolve um código.
2. Mostre esse efeito ao usuário. Só então chame de novo com os mesmos argumentos e `codigo_confirmacao` igual ao código recebido.
3. O código expira em 120 segundos e vale uma vez. Qualquer argumento diferente invalida o código. Para obter outro, chame de novo sem `codigo_confirmacao`.

Não invente o código e não reutilize código de outra ferramenta.

## Fora do MCP

Não há ferramenta para isto. Mande o usuário ao console (https://console.ockto.ai):

- credencial, token, senha e fluxo de autorização OAuth
- upload de documento ou áudio para um cérebro
- teste de nó de automação
- SQL livre
- exportação em massa
- domínios
- convite, papel, remoção de membro, conta, MFA e senha
- pagamento, fatura e troca de plano
- agente de biblioteca com visibilidade pública
- eventos de agenda
- super-admin
- ligar funcionário de IA a um canal de atendimento
- páginas
- template de WhatsApp com a janela de 24h fechada
- anexo e mídia na conversa

Responder, transferir, atribuir, fechar, reabrir e marcar conversa como lida estão na skill `conversas`. Membros e limites do plano, inclusive créditos restantes, estão na skill `organizacao`.
