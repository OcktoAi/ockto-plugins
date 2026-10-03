---
name: jornadas
description: Consulta e altera jornadas e etapas do kanban na Ockto. Leads dentro da jornada ficam na skill crm.
---

# Jornadas e etapas

A organização é a do consentimento. Para colocar, mover, fixar ou tirar um lead, use a skill `crm`.

Nas listagens, `pagina` começa em 1 e `limite` tem teto 50. A resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Jornada

- `listar_jornadas` (`journeys:read`, só lê) lista nome e status. Filtros opcionais: `busca`, `status` (`draft`, `published`, `archived`). `pagina` e `limite` (padrão 30, teto 50).
- `obter_jornada` (`journeys:read`, só lê) devolve a jornada e a contagem de contatos em cada etapa. É a fonte de `jornada_id` e do id de cada coluna. Leads: `listar_leads_jornada`. Config de uma etapa: `obter_etapa`. Métricas: `obter_metricas_jornada`.
- `criar_jornada` (`journeys:write`) exige `nome`. Descrição, categoria, plataforma de checkout e objetivo são opcionais.
- `atualizar_jornada` (`journeys:write`) altera só os campos enviados. Exige `jornada_id`.
- `excluir_jornada` (`journeys:delete`, destrutiva) apaga a jornada de forma permanente, com etapas, páginas, webhooks e o vínculo dos contatos. Confirmação em dois passos: a primeira chamada, sem `codigo_confirmacao`, só descreve; a segunda repete o mesmo `jornada_id` com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Etapas

- `obter_etapa` (`journeys:read`, só lê) devolve a etapa e a configuração atual (mover automático, atraso da mensagem inicial, webhook de saída, template de WhatsApp). Exige `jornada_id` e `etapa_id`. Use antes de `configurar_etapa_jornada`.
- `criar_etapa_jornada` (`journeys:write`) cria uma coluna `custom`. Exige `jornada_id` e `nome`. `funcionario_padrao_id` é opcional.
- `atualizar_etapa_jornada` (`journeys:write`) muda nome e/ou funcionário padrão. Exige `jornada_id` e `etapa_id`.
- `configurar_etapa_jornada` (`journeys:write`, pode gravar webhook de saída) define o comportamento da coluna: mover automático, atraso da mensagem inicial e webhook. Exige `jornada_id` e `etapa_id`. Envie só o que muda.
- `reordenar_etapas_jornada` (`journeys:write`) define a ordem. Exige `jornada_id` e `etapa_ids` com todas as etapas da jornada.
- `excluir_etapa_jornada` (`journeys:delete`, destrutiva) remove a coluna. Se houver contatos, a ferramenta descreve o efeito na primeira chamada. Confirmação em dois passos com os mesmos `jornada_id` e `etapa_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Métricas da jornada

`obter_metricas_jornada` (`analytics:read`, só lê) lê métricas de uma jornada. Exige `jornada_id`. `recorte`: `resumo` (padrão), `linha_do_tempo` (`periodo`: `day`, `week` ou `month`), `etapas` ou `negociacoes`. `limite` (máximo 50) vale para a série ou as negociações. O dashboard da organização continua em `obter_metricas` (skill `conversas`).
