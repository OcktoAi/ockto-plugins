---
name: conversas
description: Lê, responde, transfere, atribui, fecha e reabre conversas da organização, marca como lida, e lê as contagens do dashboard na Ockto.
---

# Conversas e métricas

A organização é a do consentimento. Ids vêm de `listar_conversas` ou `obter_conversa`. Não invente id.

Se uma escrita desta skill não aparecer na lista, ou a chamada disser que falta `conversations:write` (`insufficient_scope`), reconecte o MCP e consinta de novo. A renovação do token não acrescenta escopo que o consentimento antigo não gravou. O passo a passo está na skill `conectar`.

Em `listar_conversas` e `listar_conversas_contato`, `pagina` começa em 1, `limite` tem teto 50 e a resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Conversas

- `listar_conversas` (`conversations:read`, só lê) lista threads: contato, canal e status. Filtros opcionais: `busca`, `canal`, `status` (`open` ou `closed`), `contato_id`, `data_inicio` e `data_fim` (ISO 8601). `pagina` e `limite` (padrão 15, teto 50).
- `listar_conversas_contato` (`conversations:read`, só lê) lista as conversas de um contato. Exige `contato_id` (de `obter_contato`). `pagina` e `limite` (padrão 20, teto 50). O histórico de uma thread continua em `obter_conversa`.
- `obter_conversa` (`conversations:read`, só lê) devolve o histórico de uma conversa. Exige `conversa_id`. Página 1 traz as mensagens mais recentes. `limite` (teto 30) e `pagina` são opcionais. A resposta traz `total`, `pagina` e `temMaisAntigas`.

## Responder

`responder_conversa` (`conversations:write`; destrutiva: a mensagem chega ao cliente e não volta; cada chamada envia outra; o canal é fora da organização). Envia o texto como atendente humano, em nome da organização (`role` attendant). A conversa passa para o membro da sessão. Não consome crédito de IA. Sem anexo e sem mídia.

Exige `conversa_id` e `texto`. Os dois são string e precisam sobrar texto depois do trim. O schema não declara teto de caracteres. Qualquer outra propriedade é recusada: anexo e mídia ficam no console (https://console.ockto.ai).

Confirmação em dois passos. `codigo_confirmacao` não entra no schema declarado pela ferramenta: o servidor acrescenta. Sem esse argumento a ferramenta só descreve.

1. Chame com `conversa_id` e `texto`, sem `codigo_confirmacao`. A resposta mostra canal, contato, o texto entre aspas, o estado da janela de 24h e o aviso de que não consome crédito de IA. Devolve um código. Nada foi enviado.
2. Mostre ao usuário esse texto exato, com o canal e o contato, e espere o ok dele. A segunda chamada repete os mesmos `conversa_id` e `texto` com `codigo_confirmacao` igual ao código recebido.
3. O código expira em 120 segundos e vale uma vez. Argumento diferente invalida o código. Para outro código, chame de novo sem `codigo_confirmacao`.

A primeira chamada recusa, sem código e sem enviar, quando:

- o canal é interno (`internal`): esse caminho pode consumir crédito de IA; use o console
- o contato está bloqueado pelo limite do plano (`obter_limites_plano`, skill `organizacao`)
- a janela de 24h está fechada

A janela vale para WhatsApp, Instagram, Facebook e Messenger. Fecha com 24 horas ou mais desde a última mensagem do cliente. Sem essa data, com data vazia ou inválida, conta como fechada. Os outros canais não têm essa janela; a descrição diz isso.

Fora da janela, pare. Texto livre não sai. O caminho é um template de WhatsApp já aprovado pela Meta. Criar esse template e sincronizar o status estão na skill `conectar` (`criar_template_whatsapp`, `sincronizar_templates_whatsapp`). Enquanto a Meta não aprovar, o template não pode ser usado. O envio do template nesta conversa fica no console (https://console.ockto.ai/chat).

## Responsável, arquivo e leitura

Nenhuma destas envia mensagem ao cliente e nenhuma pede `codigo_confirmacao`.

- `transferir_conversa_para_humano` (`conversations:write`; cada chamada grava outro histórico de responsável). Use quando uma pessoa deve assumir a conversa. Exige `conversa_id`. `usuario_id` é opcional: ausente ou vazio, assume o usuário da sessão. Para outro membro, use o `usuario_id` de `listar_membros_organizacao` (skill `organizacao`). O `id` do membro não serve aqui.
- `transferir_conversa_para_ia` (`conversations:write`; cada chamada grava outro histórico). Use quando um funcionário de IA deve assumir. Exige `conversa_id`. `funcionario_id` é opcional: ausente, a API mantém o assistente já vinculado. Para trocar, passe o id de `listar_funcionarios`. Sem assistente vinculado e sem `funcionario_id`, a chamada é recusada.
- `atribuir_responsavel_conversa` (`conversations:write`; cada chamada grava outro histórico). Use quando tipo e id já estão escolhidos. Exige `conversa_id`, `tipo` (`user` ou `ia`) e `responsavel_id` (os três string; `tipo` só aceita esses dois valores). `user` leva o `usuario_id` de `listar_membros_organizacao`. `ia` leva o id do funcionário. Para assumir com a própria sessão, ou manter o assistente da conversa, use a transferência correspondente.
- `fechar_conversa` (`conversations:write`; repetir não grava de novo) arquiva (`status` `closed`). Não apaga o histórico. Exige `conversa_id`. Se já está fechada, a resposta traz `alterado` falso.
- `reabrir_conversa` (`conversations:write`; repetir não grava de novo) devolve `status` `open`. Exige `conversa_id`. Se já está aberta, `alterado` falso. Reabrir não envia texto e não abre a janela de 24h.
- `marcar_conversa_como_lida` (`conversations:write`; repetir não acumula) marca a leitura para o membro da sessão. Não muda responsável nem status. Exige `conversa_id`.

Trocar o funcionário de IA de um canal já conectado está na skill `conectar`. Conectar e desconectar o canal ficam no console (https://console.ockto.ai).

## Métricas

- `obter_metricas` (`analytics:read`, só lê) devolve contagens da organização: conversas abertas, de hoje e no total; funcionários e cérebros; mensagens da IA; série dos últimos 7 dias; ranking de volume por funcionário. Sem argumentos.
- `obter_metricas_funcionarios` (`analytics:read`, só lê) lê métricas dos funcionários IA. Sem `funcionario_id`, o resumo da organização. Com `funcionario_id` (de `listar_funcionarios`), as métricas daquele funcionário.
- `obter_analytics_periodo` (`analytics:read`, só lê) lê analytics de páginas no período. `recorte`: `organizacao` (padrão), `diario` ou `jornada` (exige `jornada_id`). `data_inicio` e `data_fim` são ISO 8601.

Não lista nomes de jornadas, fluxos, conversas individuais nem canais. Para isso use `listar_jornadas`, `listar_automacoes`, `listar_conversas` ou `listar_integracoes`. Métricas de uma jornada: `obter_metricas_jornada` (skill `jornadas`).
