---
name: contatos
description: Consulta, altera e importa contatos, canais e notas, e coloca, move e tira contatos das jornadas da organização na Ockto.
---

# Contatos

A organização é a do consentimento. Ids vêm das listagens; não invente id.

Nas listagens, `pagina` começa em 1 e `limite` tem teto 50. A resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Contatos

- `listar_contatos` (`contacts:read`, só lê) lista ou busca. Filtros opcionais: `busca`, `canal` (`whatsapp`, `instagram`, `messenger`), `etapa_id` (columnId de `obter_jornada`), `data_inicio` e `data_fim` (ISO 8601) com `campo_data` (`created_at` ou `updated_at`), `ordenar_por` (`name`, `created_at`, `last_activity`) e `ordem` (`asc` ou `desc`). `pagina` e `limite` (padrão 20, teto 50).
- `obter_contato` (`contacts:read`, só lê) lê um contato por `contato_id`: canais, atributos e vínculos. Notas, timeline, memórias e conversas têm ferramenta própria abaixo.
- `criar_contato` (`contacts:write`) cria o contato. Com `jornada_id` e `coluna_id` (de `obter_jornada`), ele já nasce nessa etapa e pode disparar as automações dela, como template de WhatsApp. `canal`, `canal_identificador`, `campos_personalizados` e `utm` só valem nesse caso. `ref` é a referência de rastreio da campanha.
- `atualizar_contato` (`contacts:write`) altera só os campos enviados. Exige `contato_id`.
- `adicionar_nota_contato` (`contacts:write`) acrescenta uma nota na linha do tempo. Exige `contato_id` e `nota`.
- `listar_notas_contato` (`contacts:read`, só lê) lista as notas de um contato. Exige `contato_id`. `pagina` e `limite` (padrão 20, teto 50). O id de cada nota é o argumento `nota_id` das escritas abaixo.
- `editar_nota_contato` (`contacts:write`) grava só os campos enviados. Exige `contato_id` e `nota_id`. Opcionais: `nota`, `visivel_para_funcionario`, `prioritaria`. Sem nenhum desses três, a chamada é recusada. O que não foi enviado permanece. Repetir o mesmo texto não acumula.
- `excluir_nota_contato` (`contacts:delete`, destrutiva) apaga a nota. Sem restauração. Exige `contato_id` e `nota_id`. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o `nota_id` e diz que não há restauração. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `obter_timeline_contato` (`contacts:read`, só lê) devolve a linha do tempo do contato e o histórico de jornada (etapa de origem e de destino). Exige `contato_id`. `pagina` e `limite` (padrão 20, teto 50).
- `listar_memorias_contato` (`contacts:read`, só lê) lista memórias de longo prazo que o funcionário IA guardou deste contato. Exige `contato_id`. `pagina` e `limite` (padrão 20, teto 50). O id de cada memória é o argumento `memoria_id`.
- `excluir_memoria_contato` (`contacts:delete`, destrutiva) apaga essa memória do contato. O funcionário deixa de usar o trecho. Exige `contato_id` e `memoria_id`. Memória presa a uma conversa continua no chat do console (https://console.ockto.ai/chat); esta ferramenta não apaga essa. Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra o `memoria_id` e diz que o funcionário deixa de usar o trecho. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

## Canais

- `adicionar_canal_contato` (`contacts:write`) adiciona WhatsApp, Instagram ou Messenger. Exige `contato_id`, `canal` e `identificador`.
- `atualizar_canal_contato` (`contacts:write`) altera identificador ou status de um canal. Exige `contato_id` e `canal_id`.
- `remover_canal_contato` (`contacts:delete`, destrutiva) tira o canal do contato. Confirmação em dois passos: a primeira chamada, sem `codigo_confirmacao`, só descreve e devolve o código; a segunda repete os mesmos argumentos (`contato_id`, `canal_id`) com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

## Contato na jornada

O id da jornada e o id da coluna vêm de `obter_jornada` (skill `jornadas`).

- `listar_contatos_da_jornada` (`contacts:read`, só lê) lista os contatos de uma jornada, com os mesmos filtros de `listar_contatos` (inclusive `etapa_id`). Exige `jornada_id`. `pagina` e `limite` (padrão 20, teto 50).
- `adicionar_contato_jornada` (`contacts:write`; pode falar com sistema fora da organização) vincula um contato que já existe. Se ele já está nesta jornada, move a coluna. Se já está na etapa pedida, a etapa não é reprocessada: não dispara webhook, mensagem nem integração, e só atualiza a última atividade. Exige `contato_id`, `jornada_id` e `coluna_id`. Entrar numa etapa diferente pode disparar as ações dela: webhook de entrada e, se veio de outra etapa, webhook de saída; mensagem de WhatsApp por template aprovado; envio a Mailchimp e ActiveCampaign quando o contato tem e-mail e a etapa tem a integração ativa. Para mover um contato que já está na jornada entre colunas, prefira `mover_contato`. Para criar o contato já numa etapa, use `criar_contato` com `jornada_id` e `coluna_id`.
- `mover_contato` (`contacts:write`, pode disparar webhook e mensagem inicial) move o contato para outra coluna da mesma jornada. Exige `contato_id`, `jornada_id` e `coluna_destino_id`. Mover para a mesma etapa não faz nada. Mover para uma etapa com `resultado` `sucesso` ou `perda` (ver `obter_jornada`) conclui ou encerra o contato nesta jornada; `motivo` e `valor` (opcionais) ficam registrados.
- `fixar_contato` (`contacts:write`) fixa ou desafixa o contato no topo da coluna. Exige `contato_id`, `jornada_id` e `fixado`.
- `remover_contato_da_jornada` (`contacts:delete`, destrutiva) tira o contato da jornada. O contato continua na base. Confirmação em dois passos com `codigo_confirmacao`, os mesmos argumentos (`contato_id`, `jornada_id`), 120 segundos, uso único.

## Importação

`importar_contatos` (`contacts:write`, destrutiva quando `estrategia` é `substituir`: sobrescreve o contato que já existe) importa até 2000 linhas em JSON. Exige `contatos` (lista não vazia de objetos; cada linha traz name, email, os canais, a origem e a referência `ref`, como a ferramenta descreve). `nome` é um rótulo opcional do lote. `estrategia` padrão é `mesclar`: preenche campo vazio e não apaga o que já existe. `substituir` só se o usuário pedir: troca o contato conflitante.

Não agenda WhatsApp nem coloca o contato em jornada. Não chama serviço externo.

Confirmação em dois passos. A primeira chamada, sem `codigo_confirmacao`, mostra quantas linhas são, quantas são novas, quantos conflitos há e a estratégia. Em `substituir`, diz quantos contatos existentes serão sobrescritos. Também avisa que os novos consomem vaga do limite de contatos do plano. Se o plano não comportar, não há código. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único. Repetir o lote pode criar contatos de novo.

Arquivo e lote acima de 2000 linhas ficam no console (https://console.ockto.ai/contatos). Exportação em massa também.

## Exclusão

`excluir_contato` (`contacts:delete`, destrutiva) apaga o contato de forma permanente, com canais, notas e vínculos de jornada. Confirmação em dois passos: sem `codigo_confirmacao` a ferramenta só descreve; com o código e o mesmo `contato_id`, executa. Não há desfazer.

Conversas deste contato: `listar_conversas_contato` (skill `conversas`).
