---
name: jornadas
description: Consulta e altera jornadas e etapas do kanban na Ockto. Leads dentro da jornada ficam na skill crm.
---

# Jornadas e etapas

A organização é a do consentimento. Para colocar, mover, fixar ou tirar um lead, use a skill `crm`.

## Jornada

- `listar_jornadas` (`journeys:read`) lista nome e status. Filtros opcionais: `busca`, `status`.
- `obter_jornada` (`journeys:read`) devolve a jornada e a contagem de contatos em cada etapa. É a fonte de `jornada_id` e do id de cada coluna.
- `criar_jornada` (`journeys:write`) exige `nome`. Descrição, categoria, plataforma de checkout e objetivo são opcionais.
- `atualizar_jornada` (`journeys:write`) altera só os campos enviados. Exige `jornada_id`.
- `excluir_jornada` (`journeys:delete`) apaga a jornada de forma permanente, com etapas, páginas, webhooks e o vínculo dos contatos. Confirmação em dois passos: a primeira chamada, sem `codigo_confirmacao`, só descreve; a segunda repete o mesmo `jornada_id` com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Etapas

- `criar_etapa_jornada` (`journeys:write`) cria uma coluna `custom`. Exige `jornada_id` e `nome`. `funcionario_padrao_id` é opcional.
- `atualizar_etapa_jornada` (`journeys:write`) muda nome e/ou funcionário padrão. Exige `jornada_id` e `etapa_id`.
- `configurar_etapa_jornada` (`journeys:write`) define o comportamento da coluna: mover automático, atraso da mensagem inicial e webhook. Exige `jornada_id` e `etapa_id`. Envie só o que muda.
- `reordenar_etapas_jornada` (`journeys:write`) define a ordem. Exige `jornada_id` e `etapa_ids` com todas as etapas da jornada.
- `excluir_etapa_jornada` (`journeys:delete`) remove a coluna. Se houver contatos, a ferramenta descreve o efeito na primeira chamada. Confirmação em dois passos com os mesmos `jornada_id` e `etapa_id` e `codigo_confirmacao`. 120 segundos, uso único.
