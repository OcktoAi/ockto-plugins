---
name: funcionarios
description: Configura funcionários de IA, cérebros e fontes de conhecimento na Ockto, e busca no conteúdo de um cérebro.
---

# Funcionários de IA e cérebros

A organização é a do consentimento. `negocio_id`, quando usado, vem de `listar_negocios` (skill `negocios`).

## Funcionário

- `listar_funcionarios` (`assistants:read`) lista os agentes de atendimento.
- `obter_funcionario` (`assistants:read`) devolve instruções, regras e cérebros vinculados. Exige `funcionario_id`.
- `criar_funcionario` (`assistants:write`) exige `perfil`. O schema da ferramenta descreve regras, atributos e notificação humana. Não invente campo fora desse schema.
- `atualizar_funcionario` (`assistants:write`) altera o funcionário existente. Exige `funcionario_id`.
- `excluir_funcionario` (`assistants:delete`) apaga o funcionário de forma permanente. Confirmação em dois passos: sem `codigo_confirmacao` a chamada só descreve; a segunda repete o mesmo `funcionario_id` com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Cérebro

- `listar_cerebros` (`assistants:read`) lista as bases de conhecimento.
- `obter_cerebro` (`assistants:read`) devolve o cérebro e as fontes. Exige `cerebro_id`.
- `criar_cerebro` (`assistants:write`) exige `nome`.
- `atualizar_cerebro` (`assistants:write`) altera nome, descrição, status ou `negocio_id`. Exige `cerebro_id`.
- `buscar_conhecimento` (`assistants:read`) faz busca semântica dentro de um cérebro. Exige `cerebro_id` e `consulta`.
- `excluir_cerebro` (`assistants:delete`) apaga o cérebro e o conteúdo indexado das fontes. Confirmação em dois passos com o mesmo `cerebro_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Fontes

`adicionar_fonte_cerebro` (`assistants:write`) exige `cerebro_id`, `tipo` e `nome`. Tipos aceitos: `text`, `qa`, `json`, `youtube`, `vimeo`, `website`, `api`. Não envia arquivo: `document` e `audio` ficam de fora desta ferramenta.

`remover_fonte_cerebro` (`assistants:delete`) remove a fonte e o que já foi indexado dela. Confirmação em dois passos com os mesmos `cerebro_id` e `fonte_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Vínculo

- `vincular_cerebro_funcionario` (`assistants:write`) liga um cérebro a um funcionário. Exige `funcionario_id` e `cerebro_id`. `escopo`: `all` (atendimento e chat interno; é o padrão) ou `internal_only`. Cérebro exclusivo de um negócio só vincula a funcionário do mesmo negócio. Chamar de novo com o mesmo par só atualiza o escopo.
- `desvincular_cerebro_funcionario` (`assistants:delete`) tira o vínculo. Não apaga o cérebro nem o funcionário. Confirmação em dois passos com os mesmos `funcionario_id` e `cerebro_id` e `codigo_confirmacao`. 120 segundos, uso único.
