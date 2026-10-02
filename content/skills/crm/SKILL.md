---
name: crm
description: Consulta e altera contatos, canais, notas e a posição de leads nas jornadas da organização na Ockto.
---

# Contatos e leads

A organização é a do consentimento. Ids vêm das listagens; não invente id.

Nas listagens, `pagina` começa em 1 e `limite` tem teto 50. A resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Contatos

- `listar_contatos` (`leads:read`, só lê) lista ou busca. Filtros opcionais: `busca`, `status` (`lead`, `cliente`, `perdido`), `canal` (`whatsapp`, `instagram`, `messenger`), `etapa_id` (columnId de `obter_jornada`), `data_inicio` e `data_fim` (ISO 8601) com `campo_data` (`created_at` ou `updated_at`), `ordenar_por` (`name`, `created_at`, `last_activity`) e `ordem` (`asc` ou `desc`). `pagina` e `limite` (padrão 20, teto 50).
- `obter_contato` (`leads:read`, só lê) lê um contato por `contato_id`: canais, atributos e vínculos. Notas, timeline, memórias e conversas têm ferramenta própria abaixo.
- `criar_contato` (`leads:write`) cria o contato fora de qualquer jornada. Para já nascer numa coluna, use `criar_lead_jornada`.
- `atualizar_contato` (`leads:write`) altera só os campos enviados. Exige `contato_id`.
- `adicionar_nota_contato` (`leads:write`) acrescenta uma nota na linha do tempo. Exige `contato_id` e `nota`.
- `listar_notas_contato` (`leads:read`, só lê) lista as notas de um contato. Exige `contato_id`. `pagina` e `limite` (padrão 20, teto 50).
- `obter_timeline_contato` (`leads:read`, só lê) devolve a linha do tempo do contato e o histórico de jornada (etapa de origem e de destino). Exige `contato_id`. `pagina` e `limite` (padrão 20, teto 50).
- `listar_memorias_contato` (`leads:read`, só lê) lista memórias de longo prazo que o funcionário IA guardou deste contato. Exige `contato_id`. `pagina` e `limite` (padrão 20, teto 50).

## Canais

- `adicionar_canal_contato` (`leads:write`) adiciona WhatsApp, Instagram ou Messenger. Exige `contato_id`, `canal` e `identificador`.
- `atualizar_canal_contato` (`leads:write`) altera identificador ou status de um canal. Exige `contato_id` e `canal_id`.
- `remover_canal_contato` (`leads:delete`, destrutiva) tira o canal do contato. Confirmação em dois passos: a primeira chamada, sem `codigo_confirmacao`, só descreve e devolve o código; a segunda repete os mesmos argumentos (`contato_id`, `canal_id`) com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Jornada do lead

O id da jornada e o id da coluna vêm de `obter_jornada` (skill `jornadas`).

- `listar_leads_jornada` (`leads:read`, só lê) lista os leads de uma jornada, com os mesmos filtros de `listar_contatos` (inclusive `etapa_id`). Exige `jornada_id`. `pagina` e `limite` (padrão 20, teto 50).
- `adicionar_contato_jornada` (`leads:write`, pode disparar webhook e mensagem fora da organização) vincula um contato que já existe. Exige `contato_id`, `jornada_id` e `coluna_id`.
- `criar_lead_jornada` (`leads:write`, pode enviar template de WhatsApp) cria o contato já na coluna e pode disparar automações dessa coluna. Exige `jornada_id` e `coluna_id`.
- `mover_lead` (`leads:write`, pode disparar webhook e mensagem inicial) move o contato para outra coluna da mesma jornada. Exige `contato_id`, `jornada_id` e `coluna_destino_id`.
- `fixar_lead` (`leads:write`) fixa ou desafixa o contato no topo da coluna. Exige `contato_id`, `jornada_id` e `fixado`.
- `remover_lead_jornada` (`leads:delete`, destrutiva) tira o contato da jornada. O contato continua na base. Confirmação em dois passos com `codigo_confirmacao`, os mesmos argumentos (`contato_id`, `jornada_id`), 120 segundos, uso único.

## Exclusão

`excluir_contato` (`leads:delete`, destrutiva) apaga o contato de forma permanente, com canais, notas e vínculos de jornada. Confirmação em dois passos: sem `codigo_confirmacao` a ferramenta só descreve; com o código e o mesmo `contato_id`, executa. Não há desfazer.

Conversas deste contato: `listar_conversas_contato` (skill `conversas`).
