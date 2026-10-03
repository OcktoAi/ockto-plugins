---
name: automacoes
description: Cria, edita, pausa e duplica fluxos de automação por nó, consulta e cancela execuções, e só ativa ou reativa com confirmação, porque isso consome créditos.
---

# Automações

A organização é a do consentimento. Criar e editar não ligam o fluxo.

Em `listar_automacoes` e `listar_gatilhos_automacao`, `pagina` começa em 1, `limite` tem teto 50 e a resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Leitura

- `listar_automacoes` (`automations:read`, só lê) lista os fluxos. Filtros opcionais: `busca`, `status` (`draft`, `active`, `paused`). `pagina` e `limite` (padrão 20, teto 50).
- `obter_automacao` (`automations:read`, só lê) devolve status, `versao` (updatedAt) e o grafo: nós com `data` e posição, ligações e viewport. Exige `automacao_id`. `pagina_nos` e `limite_nos` (teto 50) paginam os nós quando a resposta traz `tem_mais_nos`. Token, senha, header de auth e chave vêm como `***`. Não reenvie `***` nem URL `://***@`.
- `listar_tipos_no_automacao` (`automations:read`, só lê) lista os `type` válidos. Consulte antes de `criar_automacao`, `editar_automacao` ou `atualizar_automacao`. Sem argumentos.
- `listar_gatilhos_automacao` (`automations:read`, só lê) lista gatilhos de um fluxo: tipo, caminho, modo de auth, prévia do segredo (nunca o token), cron e checkout. Exige `automacao_id`. `pagina` e `limite` (padrão 20, teto 50).
- `listar_execucoes_automacao` (`automations:read`, só lê) lista runs. Exige `automacao_id`. `status` opcional: `pending`, `running`, `completed`, `failed`, `cancelled`, `waiting`. `pagina` (padrão 1) e `limite` (teto 20). A resposta traz `total` e `pagina`.
- `obter_execucao_automacao` (`automations:read`, só lê) detalha uma run. Exige `automacao_id` e `execucao_id`.
- `previsualizar_cron` (`automations:read`, só lê) mostra as próximas execuções de uma expressão cron e não grava. Exige `expressao`. `fuso` (IANA) e `quantidade` (teto 50) são opcionais. Use antes de um nó agendado.
- `estimar_custo_automacao` (`automations:read`, só lê) estima o custo de um nó de agente e não executa o fluxo. Exige `automacao_id` e `no_id` (de `obter_automacao`). Opcionais: `modelo`, `max_tokens`, `instrucoes`, `papel`, `nome`, `formato_saida`, `entrada`.

## Edição por nó

`editar_automacao` (`automations:write`, destrutiva: `remover_no` apaga o nó e as ligações; repetir `adicionar_no` cria outro nó) é a ferramenta para mudar um nó, uma ligação ou um campo de `data`. Não reescreva o `flow_data` inteiro para uma edição pontual.

Exige `automacao_id`, `versao` (o campo `versao` de `obter_automacao`) e `operacoes` (lista não vazia, nesta ordem):

- `adicionar_no`: `{ op, no: { id, tipo, posicao: { x, y }, data? } }`
- `atualizar_no`: `{ op, no_id, data?, posicao?, rotulo? }` — `data` faz merge parcial
- `remover_no`: `{ op, no_id }`
- `ligar_nos`: `{ op, de, para, ligacao_id?, origem_handle?, destino_handle? }`
- `desligar_nos`: `{ op, ligacao_id }` ou `{ op, de, para, origem_handle? }`

Não muda status. Valor `***` em campo secreto não sobrescreve o segredo real. Se a `versao` divergir, a chamada é recusada: leia de novo com `obter_automacao`.

## Rascunho e substituição

- `criar_automacao` (`automations:write`) exige `nome` e nasce sempre `draft`. Não aceite `status` aqui. `flow_data` é opcional (`nodes`, `edges`, `viewport`). Sem `flow_data`, o fluxo fica vazio. Se houver nó `webhook` novo, o servidor gera um token e a resposta não inclui esse valor: veja ou rotacione no console da Ockto.
- `atualizar_automacao` (`automations:write`, destrutiva: `flow_data` substitui o grafo inteiro) altera nome, descrição, `flow_data` ou status. Exige `automacao_id`. `status` aqui só aceita `draft` ou `paused`. Reserve esta ferramenta para trocar o canvas inteiro. Valor mascarado (`***` ou URL `://***@`) no `flow_data` é restaurado do mesmo nó; se não houver segredo correspondente, a chamada é recusada.

## Ativar, pausar e reativar

`ativar_automacao` (`automations:activate`, destrutiva: o fluxo passa a disparar ações externas) passa o fluxo de `draft` ou `paused` para `active`. A partir daí os gatilhos disparam de verdade e nós de agente consomem créditos a cada execução. O plano também limita quantas automações podem ficar ativas.

Confirmação em dois passos:

1. Chame só com `automacao_id`, sem `codigo_confirmacao`. A resposta lista os gatilhos e a quantidade de nós de agente, e devolve o código. Se o fluxo já estiver ativo, não há código.
2. Mostre isso ao usuário. Para confirmar, chame de novo com o mesmo `automacao_id` e `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

`desativar_automacao` (`automations:write`) põe o fluxo em `paused`. Não apaga o grafo, não rotaciona segredo e não revela token de webhook. Exige `automacao_id`. Se já estiver pausado, não grava de novo. Para voltar a `active`, use `ativar_automacao`.

`reativar_automacao` (`automations:activate`, destrutiva: o fluxo volta a poder disparar e nós de agente passam a consumir crédito; o gatilho pode chamar serviço externo) tira a interdição de crédito. Não é o mesmo que `ativar_automacao` e não cria credencial. Exige `automacao_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o nome do fluxo, que a interdição de crédito é limpa e que os nós de agente voltam a consumir créditos. A segunda repete o mesmo `automacao_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Execução

- `cancelar_execucao_automacao` (`automations:write`) cancela um run em andamento e mantém o histórico. Exige `automacao_id` e `execucao_id` (de `listar_execucoes_automacao`). Repetir no mesmo run não acumula. Para apagar o registro, use `excluir_execucao_automacao`.
- `excluir_execucao_automacao` (`automations:delete`, destrutiva) apaga o registro da execução. Sem restauração. Exige `automacao_id` e `execucao_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o id e o status do run e diz que o histórico some. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

## Cópia, amostra e mapeamento

- `duplicar_automacao` (`automations:write`) cria outro fluxo `draft` copiando o grafo. Segredo (token, senha, chave) não é copiado: gere de novo no console. Exige `automacao_id`. `nome` é opcional; sem ele, o nome fica "Cópia de …". Cada chamada gera um fluxo. Sem grafo, a chamada é recusada.
- `salvar_amostra_no_automacao` (`automations:write`) grava o JSON de amostra de um nó para o mapeamento de variáveis. Exige `automacao_id`, `no_id` (de `obter_automacao`) e `saida` (objeto JSON, não lista). Repetir substitui a mesma amostra. A resposta não devolve o JSON. Não executa o nó.
- `resetar_mapeamento_no_automacao` (`automations:write`, destrutiva) apaga o schema de saída e a amostra daquele nó. As variáveis derivadas somem. Exige `automacao_id` e `no_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o `no_id` e avisa que o mapeamento e a amostra serão apagados. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

Biblioteca de agente (`salvar_agente_biblioteca`, `atualizar_agente_biblioteca`, `excluir_agente_biblioteca`): skill `funcionarios`.

## Excluir

`excluir_automacao` (`automations:delete`, destrutiva) faz exclusão lógica: o fluxo some das listagens e os gatilhos deixam de disparar. Confirmação em dois passos com o mesmo `automacao_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Fora do MCP

Credencial (token, senha, URI de banco, segredo OAuth), fluxo de autorização OAuth, teste de nó e SQL livre ficam no console da Ockto (https://console.ockto.ai). Um nó pode citar o id de uma conexão já existente (`obter_conexao`); o segredo não entra no `data`. Agente de biblioteca com visibilidade pública também fica no console.
