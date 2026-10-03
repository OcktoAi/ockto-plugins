---
name: conectar
description: Liga o cliente ao MCP da Ockto em https://mcp.ockto.ai/mcp, com OAuth 2.1 e escopos granulares, sem gravar token, e cobre canais, templates, chat bubble e link direto.
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
`conversations:read` `conversations:write` `integrations:read` `integrations:write` `analytics:read` `billing:read` `organization:read`
`pages:read` `pages:write` `pages:publish` `pages:delete`
`pixels:read` `pixels:write` `pixels:delete` `domains:read`

Cada ferramenta exige o escopo dela. Sem esse escopo a chamada é recusada. Escopo não substitui a permissão do membro.

`pages:read`, `pages:write`, `pages:publish`, `pages:delete`, `pixels:read`, `pixels:write`, `pixels:delete` e `domains:read` só entram num consentimento novo, como `integrations:write`, `billing:read`, `conversations:write` e `organization:read`. Chat bubble e link direto usam `integrations:read` e `integrations:write`. Quem já conectou não recebe escopo novo na renovação do token. Se a ferramenta não estiver na lista do cliente, ou a chamada responder `insufficient_scope`, reconecte o MCP e aceite esses escopos na tela de consentimento.

## Canais e conexões

Estas ferramentas só leem e não devolvem credencial. `pagina` começa em 1, `limite` tem padrão 20 e teto 50. A resposta traz `total`, `pagina`, `limite` e `tem_mais`.

- `listar_integracoes` (`integrations:read`) é a visão geral: canais (WhatsApp, Instagram, Messenger) e conexões de automação, com nome, provedor, status e identificador. `busca` opcional. `recorte` opcional: `canais` ou `conexoes`.
- `listar_canais` (`integrations:read`; com status ao vivo, consulta a Meta) lista só canais de atendimento. `provedor`: `whatsapp`, `instagram`, `facebook`, `meta` (instagram e facebook), `canais` ou `todos` (padrão). O registro traz funcionário e, no WhatsApp, a jornada padrão. Com `conexao_id` e `provedor` `whatsapp` ou `todos`, o status ao vivo sai para a Graph API da Meta.
- `obter_saude_canais` (`integrations:read`) lê o status monitorado. `conexao_id` opcional restringe a uma conexão. Não força checagem externa.
- `listar_templates_whatsapp` (`integrations:read`) lista templates armazenados de uma conexão WhatsApp. Exige `conexao_id` (de `listar_canais`). Não sincroniza com a Meta. Para buscar na Meta, use `sincronizar_templates_whatsapp`.
- `listar_provedores_conexao` (`integrations:read`) lista o catálogo de provedores (Slack, Jira, HTTP, banco). Não devolve id de conexão já criada.
- `obter_conexao` (`integrations:read`) detalha uma conexão de automação, sem credencial. Exige `conexao_id` de `listar_integracoes` com `recorte` `conexoes`.

Valor mascarado `***` (ou URL `://***@`) não é o segredo. Não o reenvie para gravar por cima.

## Confirmação em dois passos

A skill de cada ferramenta diz quando a primeira chamada só descreve. Entram aí `responder_conversa`, `vincular_funcionario_canal`, `desvincular_funcionario_canal`, `criar_template_whatsapp`, `publicar_pagina`, `despublicar_pagina`, `criar_formulario_externo`, `atualizar_formulario_externo`, `criar_pixel`, `atualizar_pixel`, `associar_pixel_jornadas`, `criar_chat_bubble`, `atualizar_chat_bubble`, `criar_link_direto`, `atualizar_link_direto`, ativar e reativar automação, importar contatos, sincronizar fonte de cérebro, resetar mapeamento de nó e as ferramentas de exclusão, remoção e desvínculo. `sincronizar_templates_whatsapp`, `criar_pagina` e `atualizar_pagina` não pedem código. O argumento `codigo_confirmacao` não entra no schema da ferramenta: o servidor acrescenta.

1. Chame sem `codigo_confirmacao`. A resposta descreve o efeito e devolve um código.
2. Mostre esse efeito ao usuário. Só então chame de novo com os mesmos argumentos e `codigo_confirmacao` igual ao código recebido.
3. O código expira em 120 segundos e vale uma vez. Qualquer argumento diferente invalida o código. Para obter outro, chame de novo sem `codigo_confirmacao`.

Não invente o código e não reutilize código de outra ferramenta.

## Funcionário do canal

Estas ferramentas trocam quem atende um canal já conectado. Conectar o canal, desconectar e token ficam no console (https://console.ockto.ai).

`canal` aceita `whatsapp`, `instagram`, `facebook` ou `messenger`. `messenger` é tratado como Facebook. `canal_id` é o id da conexão em `listar_integracoes` (no WhatsApp, o id da instância ou o connectionId). O `funcionario_id` sai de `listar_funcionarios`, da mesma organização. Id de outra organização, ou que a API responda 404 ou 403, recusa antes de gravar e devolve o aviso para usar `listar_funcionarios`.

- `vincular_funcionario_canal` (`integrations:write`; repetir o mesmo funcionário não acumula). Exige `canal`, `canal_id` e `funcionario_id`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta só descreve: canal (nome, identificador e id), funcionário atual e funcionário novo, e o efeito na jornada. Mostre canal, atual e novo ao usuário e espere o ok. A segunda chamada repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

No WhatsApp com jornada padrão, a troca da etapa WhatsApp é tentativa. Se a sincronização der certo, a etapa passa a ter o funcionário novo como responsável e é criada se não existir. Se falhar, o vínculo do canal permanece e a etapa fica para o webhook. Sem jornada padrão, nenhuma etapa muda. No Instagram e no Facebook, só muda o funcionário vinculado ao canal.

- `desvincular_funcionario_canal` (`integrations:write`, destrutiva; repetir não acumula). Tira o funcionário de IA. Exige `canal` e `canal_id`. Não desconecta o canal. Confirmação em dois passos, no mesmo formato: a primeira chamada mostra canal, funcionário atual e o estado novo (nenhum funcionário de IA). Mostre canal, atual e novo ao usuário antes da segunda chamada, com os mesmos argumentos e `codigo_confirmacao`. 120 segundos, uso único.

No WhatsApp, nas mensagens novas da instância o dono da conta fica responsável e a IA não responde. Com jornada padrão, a etapa WhatsApp deixa de ter responsável de IA só se a sincronização der certo; se falhar, a etapa fica para o webhook. Sem jornada padrão, nenhuma etapa muda. No Instagram e no Facebook, nenhum funcionário de IA responde o canal e conversas novas ficam com o dono da organização.

## Templates de WhatsApp

- `sincronizar_templates_whatsapp` (`integrations:write`; fala com a Meta; repetir converge). Busca os templates na Meta e atualiza a cópia local. Não cria nem apaga template na Meta e não pede `codigo_confirmacao`. Exige `canal_id` do WhatsApp em `listar_integracoes` (id da instância ou connectionId). A resposta traz `id`, `nome`, `idioma`, `categoria` e `status`. Sem corpo, componente nem e-mail. WhatsApp sem id de conexão para templates é recusado.

- `criar_template_whatsapp` (`integrations:write`; cada chamada pode criar outro; fala com a Meta). Cria o template e envia para revisão da Meta. Enquanto não for aprovado, não pode ser usado. Não exclui template e não envia o template a um contato.

Exige `canal_id`, `nome`, `idioma` (por exemplo `pt_BR`), `categoria` e `corpo`. `categoria` só aceita `MARKETING` ou `UTILITY`. Opcionais: `cabecalho`, `rodape`, `exemplos` (lista de textos das variáveis `{{1}}`, `{{2}}` do corpo) e `botoes`.

Botões: no máximo 3. Cada item tem `tipo` (`QUICK_REPLY` ou `URL`) e `texto`. `URL` exige `url`. Botão de URL não combina com outro botão. A API recusa nome acima de 40 caracteres, corpo acima de 1024, cabeçalho ou rodapé acima de 60, texto de botão acima de 25, URL acima de 2000 e mais de 20 exemplos. A confirmação mostra o nome enviado. A API grava minúsculas, sem acento, com espaço virando `_`.

Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra canal, nome, idioma, categoria e o corpo entre aspas, mais cabeçalho, rodapé e botões quando houver, e avisa que o template vai para revisão da Meta. Mostre o corpo exato ao usuário e espere o ok. A segunda chamada repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

Template aprovado é o caminho para falar com o cliente fora da janela de 24h. O envio do template na conversa fica no console (https://console.ockto.ai/chat). Excluir template também.

## Chat bubble e link direto

Widgets de atendimento. Usam `integrations:read` e `integrations:write`, os mesmos escopos de canal e template. Não devolvem URL de mídia assinada. A resposta não traz o código para embutir nem o endereço público: copie no console (https://console.ockto.ai). O avatar do chat bubble também fica no console.

O `funcionario_id` vem de `listar_funcionarios` (skill `funcionarios`).

### Chat bubble

- `listar_chat_bubbles` (`integrations:read`, só lê). Sem argumento. Cada item traz `id`, `nome`, `ativo`, `funcionario_id`, `nome_exibicao`, `tema`, `posicao`, `salvar_contato` e `dominios_permitidos`.
- `obter_chat_bubble` (`integrations:read`, só lê). Exige `bubble_id`.
- `criar_chat_bubble` (`integrations:write`; cada chamada cria outro). Exige `nome` (até 200), `funcionario_id` e `nome_exibicao` (até 200). Opcionais: `mensagem_boas_vindas` (até 1000; ao enviar, a boas-vindas fica ligada), `tema` (`light` ou `dark`), `posicao` (`left` ou `right`), `salvar_contato` e `dominios_permitidos` (lista de textos dos sites em que o widget pode aparecer; não é a lista de `listar_dominios`). Sem avatar. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o nome e o funcionário e avisa que o widget passa a poder ser embutido. Mostre isso ao usuário. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `atualizar_chat_bubble` (`integrations:write`). Exige `bubble_id` e ao menos um campo entre os de criar e `ativo`. Sem URL de mídia. Confirmação em dois passos. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `excluir_chat_bubble` (`integrations:write`, destrutiva). O widget deixa de responder. Exige `bubble_id`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o nome e avisa que o widget deixa de responder. A segunda repete o mesmo `bubble_id` com `codigo_confirmacao`. 120 segundos, uso único.

### Link direto

- `listar_links_diretos` (`integrations:read`, só lê). Sem argumento. Cada item traz `id`, `nome`, `ativo`, `funcionario_id`, `salvar_contato`, `coletar_nome`, `coletar_whatsapp` e `coletar_email`.
- `obter_link_direto` (`integrations:read`, só lê). Exige `link_id`.
- `criar_link_direto` (`integrations:write`; cada chamada cria outro). Exige `nome` (até 200) e `funcionario_id`. Opcionais: `salvar_contato`, `coletar_nome`, `coletar_whatsapp` e `coletar_email`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o nome e o funcionário. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `atualizar_link_direto` (`integrations:write`). Exige `link_id` e ao menos um campo, inclusive `ativo`. Confirmação em dois passos. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `excluir_link_direto` (`integrations:write`, destrutiva). O endereço deixa de abrir o chat. Exige `link_id`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o nome e esse efeito. A segunda repete o mesmo `link_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Fora do MCP

Não há ferramenta para isto. Mande o usuário ao console (https://console.ockto.ai):

- credencial, token, senha e fluxo de autorização OAuth
- upload de documento ou áudio para um cérebro
- teste de nó de automação
- SQL livre
- exportação em massa
- criar domínio, DNS, repetir a configuração e excluir domínio
- convite, papel, remoção de membro, conta, MFA e senha
- pagamento, fatura e troca de plano
- agente de biblioteca com visibilidade pública
- eventos de agenda
- super-admin
- conectar e desconectar canal, e o token desse canal
- excluir template de WhatsApp
- enviar template de WhatsApp na conversa (janela de 24h fechada)
- conteúdo HTML, CSS e JavaScript da página (o editor da Ockto)
- pixel manual com script
- avatar do chat bubble, o código para embutir e o endereço público do link direto
- anexo e mídia na conversa

Responder, transferir, atribuir, fechar, reabrir e marcar conversa como lida estão na skill `conversas`. Membros, limites do plano, saldo e extrato de créditos estão na skill `organizacao`. Páginas, formulários externos e leitura de domínios estão na skill `paginas`. Pixels de integração estão na skill `pixels`.
