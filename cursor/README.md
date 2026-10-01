# Ockto no Cursor

Plugin do Cursor. Aponta para o MCP de produção e traz as skills de uso.

Servidor: `https://mcp.ockto.ai/mcp`

Formato: [Cursor Plugin](https://cursor.com/docs/plugins/building) (`.cursor-plugin/plugin.json`, `mcp.json`, `skills/`). O marketplace da raiz está em [`.cursor-plugin/marketplace.json`](../.cursor-plugin/marketplace.json). Este repositório não envia o plugin ao marketplace público.

## Instalar

Teste local, antes de qualquer publicação ([Test plugins locally](https://cursor.com/docs/plugins)):

1. Copie esta pasta para `~/.cursor/plugins/local/ockto` (o conteúdo, com `.cursor-plugin/`, `mcp.json`, `skills/` e `assets/`).
2. Recarregue a janela.
3. Em Customize, confira o plugin `ockto` e conclua o login.

Em plano Team ou Enterprise, um admin importa o repositório em Dashboard → Plugins & MCPs → Add Marketplace → Import from Repo. Isso não publica no diretório público.

Sem o plugin, o mesmo servidor entra em Customize como MCP remoto, com a URL acima. Na primeira conexão o Cursor abre o consentimento da Ockto. Deixe client id e client secret em branco. Não há token neste repositório.

## Skills

- `conectar` — OAuth, escopos e canais conectados
- `crm` — contatos, canais, notas e leads nas jornadas
- `jornadas` — jornadas e etapas
- `funcionarios` — funcionários de IA e cérebros
- `automacoes` — rascunho, ativação e execuções
- `conversas` — conversas e métricas
- `negocios` — marcas da organização

O plugin não substitui o app da Ockto.
