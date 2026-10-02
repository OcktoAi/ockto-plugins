---
name: funcionarios
description: Configura funcionários de IA, cérebros e fontes de conhecimento na Ockto, e busca no conteúdo de um cérebro.
---

# Funcionários de IA e cérebros

A organização é a do consentimento. `negocio_id`, quando usado, vem de `listar_negocios` (skill `negocios`).

Nas listagens, `pagina` começa em 1 e `limite` tem teto 50. A resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Funcionário

- `listar_funcionarios` (`assistants:read`, só lê) lista os agentes de atendimento. `busca` opcional. `pagina` e `limite` (padrão 20, teto 50).
- `obter_funcionario` (`assistants:read`, só lê) devolve o mesmo recorte que `atualizar_funcionario` grava: perfil, regras, instruções, atributos, informações adicionais, dados da organização e notificação humana. Sem `system_prompt` e sem segredo. Exige `funcionario_id`. Leia antes de atualizar, para não reescrever listas às cegas.
- `obter_agenda_funcionario` (`assistants:read`, só lê) diz se a agenda Google está conectada, com o id da conexão e o e-mail. Sem token. Exige `funcionario_id`.
- `listar_capacidades_conexao_funcionario` (`assistants:read`, só lê) lista conexões e capacidades disponíveis para um funcionário, inclusive o que já está habilitado na conversa. Sem credencial. Exige `funcionario_id`. `pagina` e `limite` (padrão 20, teto 50).
- `listar_modelos_funcionario` (`assistants:read`, só lê) lista a biblioteca de modelos de agente (nome, papel, visibilidade). `busca` opcional. `pagina` e `limite` (padrão 20, teto 50).
- `obter_modelo_funcionario` (`assistants:read`, só lê) detalha um modelo, inclusive instruções e formato de saída. Sem segredo. Exige `modelo_id`.
- `criar_funcionario` (`assistants:write`) exige `perfil`. O schema da ferramenta descreve regras, atributos e notificação humana. Não invente campo fora desse schema.
- `atualizar_funcionario` (`assistants:write`, destrutiva: listas enviadas substituem as atuais) altera o funcionário existente. Exige `funcionario_id`.
- `excluir_funcionario` (`assistants:delete`, destrutiva) apaga o funcionário de forma permanente. Confirmação em dois passos: sem `codigo_confirmacao` a chamada só descreve; a segunda repete o mesmo `funcionario_id` com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

Métricas de volume: `obter_metricas_funcionarios` (skill `conversas`).

## Cérebro

- `listar_cerebros` (`assistants:read`, só lê) lista as bases de conhecimento. `busca` opcional. `pagina` e `limite` (padrão 20, teto 50).
- `obter_cerebro` (`assistants:read`, só lê) devolve o cérebro e as fontes. Exige `cerebro_id`.
- `criar_cerebro` (`assistants:write`) exige `nome`.
- `atualizar_cerebro` (`assistants:write`) altera nome, descrição, status ou `negocio_id`. Exige `cerebro_id`.
- `buscar_conhecimento` (`assistants:read`, só lê) faz busca semântica dentro de um cérebro. Exige `cerebro_id` e `consulta`. `limite` opcional, teto 8.
- `excluir_cerebro` (`assistants:delete`, destrutiva) apaga o cérebro e o conteúdo indexado das fontes. Confirmação em dois passos com o mesmo `cerebro_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Fontes

`adicionar_fonte_cerebro` (`assistants:write`; website, YouTube ou API rastreiam URL externa) exige `cerebro_id`, `tipo` e `nome`. Tipos aceitos: `text`, `qa`, `json`, `youtube`, `vimeo`, `website`, `api`. Não envia arquivo: `document` e `audio` ficam de fora desta ferramenta.

`remover_fonte_cerebro` (`assistants:delete`, destrutiva) remove a fonte e o que já foi indexado dela. Confirmação em dois passos com os mesmos `cerebro_id` e `fonte_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Vínculo

- `vincular_cerebro_funcionario` (`assistants:write`) liga um cérebro a um funcionário. Exige `funcionario_id` e `cerebro_id`. `escopo`: `all` (atendimento e chat interno; é o padrão) ou `internal_only`. Cérebro exclusivo de um negócio só vincula a funcionário do mesmo negócio. Chamar de novo com o mesmo par só atualiza o escopo.
- `desvincular_cerebro_funcionario` (`assistants:delete`, destrutiva) tira o vínculo. Não apaga o cérebro nem o funcionário. Confirmação em dois passos com os mesmos `funcionario_id` e `cerebro_id` e `codigo_confirmacao`. 120 segundos, uso único.
