# Ockto no Gemini CLI

Extensão do Gemini CLI. O manifest é [`gemini-extension.json`](gemini-extension.json).

Servidor: `https://mcp.ockto.ai/mcp`, no campo `httpUrl` de `mcpServers`. A referência de extensões diz que valem as opções de servidor MCP, exceto `trust`. `httpUrl` é o transporte HTTP streaming em [MCP servers](https://geminicli.com/docs/tools/mcp-server/). `url` seria SSE, e este servidor não é SSE.

`contextFileName` aponta para [`GEMINI.md`](GEMINI.md). As skills ficam em `skills/`, no formato que a referência chama de agent skills: [Extension reference](https://geminicli.com/docs/extensions/reference/).

Não há `settings` de API key. O CLI faz OAuth na conexão. Não grave token na extensão.

## Instalar

A [documentação de release](https://github.com/google-gemini/gemini-cli/blob/main/docs/extensions/releasing.md) instala pela URL do repositório:

```text
gemini extensions install https://github.com/OcktoAi/ockto-plugins
```

Essa página separa dois canais. Pelo Git, a URL clona o repositório e o `HEAD` da branch é a versão. Pelo GitHub Release, o CLI procura o release marcado como Latest e instala o asset anexado; `--ref` escolhe a tag. No código atual do CLI, uma URL do GitHub tenta o release primeiro e só clona se não houver release. Este monorepo não coloca `gemini-extension.json` na raiz do Git, então o clone não serve de instalação. O workflow [`.github/workflows/release-gemini.yml`](../.github/workflows/release-gemini.yml) dispara no push de uma tag `v*` e anexa um único `ockto.tar.gz`: o conteúdo de `gemini/` na raiz do arquivo, sem pasta extra. A extensão não tem binário por plataforma, então o asset é genérico — o nome não leva `darwin`, `linux` nem `win32`. Um segundo asset faria o CLI ignorar o fallback genérico. Este repositório não cria a tag.

Para a [galeria](https://geminicli.com/extensions/browse/), a mesma documentação pede o tópico `gemini-cli-extension` no About do repositório e o manifest na raiz do repositório ou do arquivo de release. O tópico não é alterado aqui; entra na hora de publicar.

O campo `name` é `ockto`. A [referência](https://github.com/google-gemini/gemini-cli/blob/main/docs/extensions/reference.md) espera que esse nome coincida com o diretório da extensão. A instalação grava em `~/.gemini/extensions/ockto`. A pasta neste monorepo continua `gemini/`.

`contextFileName` é `GEMINI.md`, lido no diretório da extensão. No `ockto.tar.gz` ele fica ao lado do manifest, e `skills/` no mesmo nível. Não há outro caminho relativo no manifest. `httpUrl` do MCP continua absoluto.

Para desenvolver a partir do clone, o manifest está em `gemini/`:

```text
git clone https://github.com/OcktoAi/ockto-plugins.git
gemini extensions install /caminho/para/ockto-plugins/gemini
```

Para desenvolver sem copiar: `gemini extensions link /caminho/para/ockto-plugins/gemini`. Reinicie o CLI depois.

Sem a extensão, o mesmo servidor entra na configuração do usuário:

```text
gemini mcp add --transport http ockto https://mcp.ockto.ai/mcp
```

## Skills

- `conectar` — OAuth, escopos, funcionário do canal e templates
- `crm` — contatos, canais, notas e leads nas jornadas
- `jornadas` — jornadas e etapas
- `funcionarios` — funcionários de IA e cérebros
- `automacoes` — rascunho, ativação e execuções
- `conversas` — ler, responder, transferir e métricas
- `organizacao` — membros, limites do plano, saldo e extrato de créditos
- `negocios` — marcas da organização
