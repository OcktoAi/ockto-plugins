---
name: automacoes
description: Cria e edita fluxos de automação por nó, em rascunho, consulta execuções e só ativa com confirmação, porque a ativação consome créditos.
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

## Ativar

`ativar_automacao` (`automations:activate`, destrutiva: o fluxo passa a disparar ações externas) passa o fluxo de `draft` ou `paused` para `active`. A partir daí os gatilhos disparam de verdade e nós de agente consomem créditos a cada execução. O plano também limita quantas automações podem ficar ativas.

Confirmação em dois passos:

1. Chame só com `automacao_id`, sem `codigo_confirmacao`. A resposta lista os gatilhos e a quantidade de nós de agente, e devolve o código. Se o fluxo já estiver ativo, não há código.
2. Mostre isso ao usuário. Para confirmar, chame de novo com o mesmo `automacao_id` e `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Excluir

`excluir_automacao` (`automations:delete`, destrutiva) faz exclusão lógica: o fluxo some das listagens e os gatilhos deixam de disparar. Confirmação em dois passos com o mesmo `automacao_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Fora do MCP

Credencial (token, senha, URI de banco, segredo OAuth), fluxo de autorização OAuth e SQL livre ficam no console da Ockto. Um nó pode citar o id de uma conexão já existente (`obter_conexao`); o segredo não entra no `data`.
