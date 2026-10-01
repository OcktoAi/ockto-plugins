# Ockto no ChatGPT

Dá para empacotar o plugin neste repositório. Ligar um conector avulso continua sendo configuração no produto: o ChatGPT não lê um manifest para esse fluxo.

Servidor: `https://mcp.ockto.ai/mcp`

## Pacote no repositório

Formato portátil [Agent Plugins](https://agent-plugins.org/specification), como a OpenAI descreve em [Package your plugin](https://developers.openai.com/plugins/build/plugins):

- [`plugin.json`](plugin.json) na raiz do plugin, com `$schema` `https://agent-plugins.org/schemas/1.0.0/plugin.schema.json`
- [`mcp.json`](mcp.json) com `type: streamable-http` e a URL do servidor
- `skills/` com um `SKILL.md` por pasta
- apresentação da OpenAI em `extensions.com.openai.interface`

O catálogo local do repositório está em [`.agents/plugins/marketplace.json`](../.agents/plugins/marketplace.json). `source.path` é `./chatgpt`, relativo à raiz do repositório.

Com o repositório aberto no app desktop do ChatGPT, reinicie o app e instale o plugin a partir do marketplace do repositório. Pelo Codex, o comando documentado é:

```text
codex plugin marketplace add OcktoAi/ockto-plugins
```

Autenticação é OAuth do servidor, na instalação. Não há client id, secret nem header neste pacote.

Este repositório não envia o plugin ao diretório público.

## Conector no produto

Quem só quer o MCP remoto, sem o pacote de skills, configura no ChatGPT. Passos de [Connect and test your plugin](https://developers.openai.com/plugins/deploy/connect-chatgpt):

1. Settings → Security and login → Developer mode.
2. ChatGPT Plugins → botão de adicionar.
3. Nome Ockto, descrição curta, conexão pública `https://mcp.ockto.ai/mcp`.
4. Crie a conexão e revise as ferramentas que o servidor anuncia.
5. Se o servidor usar OAuth, conclua o consentimento. Não cole token.

O developer mode depende do plano e da política do workspace. Em workspace, o admin habilita a criação de conectores MCP. Não há arquivo deste repositório nesse fluxo: o ChatGPT descobre ferramentas no endpoint.

## Skills

- `conectar` — OAuth, escopos e canais conectados
- `crm` — contatos, canais, notas e leads nas jornadas
- `jornadas` — jornadas e etapas
- `funcionarios` — funcionários de IA e cérebros
- `automacoes` — rascunho, ativação e execuções
- `conversas` — conversas e métricas
- `negocios` — marcas da organização
