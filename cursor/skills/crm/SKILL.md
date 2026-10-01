---
name: crm
description: Consulta e altera contatos, canais, notas e a posição de leads nas jornadas da organização na Ockto.
---

# Contatos e leads

A organização é a do consentimento. Ids vêm das listagens; não invente id.

## Contatos

- `listar_contatos` (`leads:read`) lista ou busca por `busca` e `status`.
- `obter_contato` (`leads:read`) lê um contato por `contato_id`: canais, atributos e vínculos.
- `criar_contato` (`leads:write`) cria o contato fora de qualquer jornada. Para já nascer numa coluna, use `criar_lead_jornada`.
- `atualizar_contato` (`leads:write`) altera só os campos enviados. Exige `contato_id`.
- `adicionar_nota_contato` (`leads:write`) acrescenta uma nota na linha do tempo. Exige `contato_id` e `nota`.

## Canais

- `adicionar_canal_contato` (`leads:write`) adiciona WhatsApp, Instagram ou Messenger. Exige `contato_id`, `canal` e `identificador`.
- `atualizar_canal_contato` (`leads:write`) altera identificador ou status de um canal. Exige `contato_id` e `canal_id`.
- `remover_canal_contato` (`leads:delete`) tira o canal do contato. Confirmação em dois passos: a primeira chamada, sem `codigo_confirmacao`, só descreve e devolve o código; a segunda repete os mesmos argumentos (`contato_id`, `canal_id`) com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Jornada do lead

O id da jornada e o id da coluna vêm de `obter_jornada` (skill `jornadas`).

- `adicionar_contato_jornada` (`leads:write`) vincula um contato que já existe. Exige `contato_id`, `jornada_id` e `coluna_id`.
- `criar_lead_jornada` (`leads:write`) cria o contato já na coluna e pode disparar automações dessa coluna. Exige `jornada_id` e `coluna_id`.
- `mover_lead` (`leads:write`) move o contato para outra coluna da mesma jornada. Exige `contato_id`, `jornada_id` e `coluna_destino_id`. Pode disparar automações da coluna de destino.
- `fixar_lead` (`leads:write`) fixa ou desafixa o contato no topo da coluna. Exige `contato_id`, `jornada_id` e `fixado`.
- `remover_lead_jornada` (`leads:delete`) tira o contato da jornada. O contato continua na base. Confirmação em dois passos com `codigo_confirmacao`, os mesmos argumentos (`contato_id`, `jornada_id`), 120 segundos, uso único.

## Exclusão

`excluir_contato` (`leads:delete`) apaga o contato de forma permanente, com canais, notas e vínculos de jornada. Confirmação em dois passos: sem `codigo_confirmacao` a ferramenta só descreve; com o código e o mesmo `contato_id`, executa. Não há desfazer.
