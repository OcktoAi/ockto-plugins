---
name: automacoes
description: Cria e edita fluxos de automação como rascunho, consulta execuções e só ativa com confirmação, porque a ativação consome créditos.
---

# Automações

A organização é a do consentimento. Criar e editar não ligam o fluxo.

## Leitura

- `listar_automacoes` (`automations:read`) lista os fluxos. Filtros opcionais: `busca`, `status`.
- `obter_automacao` (`automations:read`) devolve status, webhooks e o canvas em forma legível. Use um fluxo existente como exemplo do `data` de cada nó antes de montar outro.
- `listar_tipos_no_automacao` (`automations:read`) lista os `type` válidos. Consulte antes de `criar_automacao` ou `atualizar_automacao`. Sem argumentos.
- `listar_execucoes_automacao` (`automations:read`) lista runs de um fluxo. Exige `automacao_id`.
- `obter_execucao_automacao` (`automations:read`) detalha uma run. Exige `automacao_id` e `execucao_id`.

## Rascunho

- `criar_automacao` (`automations:write`) exige `nome` e nasce sempre `draft`. Não aceite `status` aqui. `flow_data` é opcional (`nodes`, `edges`, `viewport`). Sem `flow_data`, o fluxo fica vazio. Se houver nó `webhook` novo, o servidor gera um token e a resposta não inclui esse valor: veja ou rotacione no editor web.
- `atualizar_automacao` (`automations:write`) altera nome, descrição, `flow_data` ou status. Exige `automacao_id`. `status` aqui só aceita `draft` ou `paused`. `flow_data` substitui o grafo inteiro.

## Ativar

`ativar_automacao` (`automations:activate`) passa o fluxo de `draft` ou `paused` para `active`. A partir daí os gatilhos disparam de verdade e nós de agente consomem créditos a cada execução. O plano também limita quantas automações podem ficar ativas.

Confirmação em dois passos:

1. Chame só com `automacao_id`, sem `codigo_confirmacao`. A resposta lista os gatilhos e a quantidade de nós de agente, e devolve o código. Se o fluxo já estiver ativo, não há código.
2. Mostre isso ao usuário. Para confirmar, chame de novo com o mesmo `automacao_id` e `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Excluir

`excluir_automacao` (`automations:delete`) faz exclusão lógica: o fluxo some das listagens e os gatilhos deixam de disparar. Confirmação em dois passos com o mesmo `automacao_id` e `codigo_confirmacao`. 120 segundos, uso único.
