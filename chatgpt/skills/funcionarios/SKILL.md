---
name: funcionarios
description: Configura funcionários de IA, agenda, capacidades, cérebros, fontes e a biblioteca de agentes na Ockto.
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

## Biblioteca de agentes

A leitura é `listar_modelos_funcionario` e `obter_modelo_funcionario`. A escrita usa escopo de automação.

- `salvar_agente_biblioteca` (`automations:write`) cria um agente privado na mesma biblioteca. Exige `nome` e `dados_agente` (objeto). Opcionais: `descricao`, `provedores`, `visibilidade` (só `private`). Segredo dentro de `dados_agente` é descartado. Cada chamada cria outro agente. `visibilidade` `public` é recusada: agente público fica no console (https://console.ockto.ai/automacoes).
- `atualizar_agente_biblioteca` (`automations:write`) altera um agente privado. Exige `agente_id` (o id de `listar_modelos_funcionario`, o mesmo valor de `modelo_id`). `dados_agente`, se enviado, faz merge: o que não vier permanece. `provedores`, se enviado, substitui só essa lista. `visibilidade` `public` é recusada. Repetir os mesmos campos não acumula.
- `excluir_agente_biblioteca` (`automations:delete`, destrutiva) apaga o agente. Só o autor consegue. Exige `agente_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o nome do agente e diz que não há restauração. A segunda repete o mesmo `agente_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Agenda e capacidades

- `definir_capacidades_conexao_funcionario` (`assistants:write`, destrutiva: `desabilitar` tira a capacidade) liga ou desliga capacidades de uma conexão que já existe. Não cria credencial e não pede `codigo_confirmacao`. Exige `funcionario_id` e `conexao_id` (de `listar_capacidades_conexao_funcionario`). `habilitar` é lista de `{ nome, escopo? }`; `escopo` é `all` (padrão) ou `internal_only`. `desabilitar` é lista de nomes. O servidor parte do que já está ligado, aplica só o pedido e grava. `nome` é o da capacidade nessa listagem. Capacidade que não entra na conversa é recusada (console de automações). Conexão de agenda não aceita este conjunto: use `vincular_agenda_funcionario`.
- `vincular_agenda_funcionario` (`assistants:write`) aponta a agenda para uma conexão Google Calendar que já existe. Exige `funcionario_id` e `conexao_id`. Não inicia OAuth. Repetir o mesmo `conexao_id` não cria outra conexão. Conexão nova fica no console (https://console.ockto.ai/funcionarios).
- `desvincular_agenda_funcionario` (`assistants:write`, destrutiva) tira o vínculo da agenda. A conexão continua na organização. Exige `funcionario_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o `funcionario_id` e diz que a conexão não é apagada. A segunda repete o mesmo `funcionario_id` com `codigo_confirmacao`. 120 segundos, uso único.

Evento de agenda (criar ou apagar) fica no console. Trocar ou tirar o funcionário de um canal de atendimento está na skill `conectar` (`vincular_funcionario_canal`, `desvincular_funcionario_canal`). O `funcionario_id` sai de `listar_funcionarios`.

Métricas de volume: `obter_metricas_funcionarios` (skill `conversas`).

## Cérebro

- `listar_cerebros` (`assistants:read`, só lê) lista as bases de conhecimento. `busca` opcional. `pagina` e `limite` (padrão 20, teto 50).
- `obter_cerebro` (`assistants:read`, só lê) devolve o cérebro e as fontes. Exige `cerebro_id`.
- `criar_cerebro` (`assistants:write`) exige `nome`.
- `atualizar_cerebro` (`assistants:write`) altera nome, descrição, status ou `negocio_id`. Exige `cerebro_id`.
- `buscar_conhecimento` (`assistants:read`, só lê) faz busca semântica dentro de um cérebro. Exige `cerebro_id` e `consulta`. `limite` opcional, teto 8.
- `excluir_cerebro` (`assistants:delete`, destrutiva) apaga o cérebro e o conteúdo indexado das fontes. Só segue se não houver funcionário vinculado: a primeira chamada recusa e manda desvincular com `desvincular_cerebro_funcionario`. Prefira este caminho. Confirmação em dois passos com o mesmo `cerebro_id` e `codigo_confirmacao`. 120 segundos, uso único. A confirmação mostra o nome do cérebro e diz que não há desfazer.
- `excluir_cerebro_forcado` (`assistants:delete`, destrutiva) desvincula o cérebro de todos os funcionários e apaga. Use só quando `excluir_cerebro` recusar por ainda estar vinculado e o usuário quiser apagar mesmo assim. Exige `cerebro_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o nome do cérebro e diz que a exclusão vale mesmo com funcionários vinculados, sem restauração. A segunda repete o mesmo `cerebro_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Fontes

`adicionar_fonte_cerebro` (`assistants:write`; website, YouTube ou API rastreiam URL externa) exige `cerebro_id`, `tipo` e `nome`. Tipos aceitos: `text`, `qa`, `json`, `youtube`, `vimeo`, `website`, `api`. Não envia arquivo. `document` e `audio` devolvem erro pedindo o upload no console (https://console.ockto.ai/cerebros).

`sincronizar_fonte_cerebro` (`assistants:write`; rebusca a fonte fora da organização e consome crédito de indexação) reprocessa fonte de URL, site ou API. Não é idempotente: cada chamada dispara outra execução. Arquivo e áudio continuam no console. Exige `cerebro_id` e `fonte_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra a `fonte_id` e avisa que a rebusca consome créditos de indexação. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

`remover_fonte_cerebro` (`assistants:delete`, destrutiva) remove a fonte e o que já foi indexado dela. Confirmação em dois passos com os mesmos `cerebro_id` e `fonte_id` e `codigo_confirmacao`. 120 segundos, uso único.

## Vínculo

- `vincular_cerebro_funcionario` (`assistants:write`) liga um cérebro a um funcionário. Exige `funcionario_id` e `cerebro_id`. `escopo`: `all` (atendimento e chat interno; é o padrão) ou `internal_only`. Cérebro exclusivo de um negócio só vincula a funcionário do mesmo negócio. Chamar de novo com o mesmo par só atualiza o escopo.
- `desvincular_cerebro_funcionario` (`assistants:delete`, destrutiva) tira o vínculo. Não apaga o cérebro nem o funcionário. Confirmação em dois passos com os mesmos `funcionario_id` e `cerebro_id` e `codigo_confirmacao`. 120 segundos, uso único.
