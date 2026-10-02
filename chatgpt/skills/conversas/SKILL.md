---
name: conversas
description: Lê conversas da organização e as contagens operacionais do dashboard na Ockto.
---

# Conversas e métricas

A organização é a do consentimento. Estas ferramentas só leem.

Em `listar_conversas` e `listar_conversas_contato`, `pagina` começa em 1, `limite` tem teto 50 e a resposta traz `total`, `pagina`, `limite` e `tem_mais`.

## Conversas

- `listar_conversas` (`conversations:read`, só lê) lista threads: contato, canal e status. Filtros opcionais: `busca`, `canal`, `status` (`open` ou `closed`), `contato_id`, `data_inicio` e `data_fim` (ISO 8601). `pagina` e `limite` (padrão 15, teto 50).
- `listar_conversas_contato` (`conversations:read`, só lê) lista as conversas de um contato. Exige `contato_id` (de `obter_contato`). `pagina` e `limite` (padrão 20, teto 50). O histórico de uma thread continua em `obter_conversa`.
- `obter_conversa` (`conversations:read`, só lê) devolve o histórico de uma conversa. Exige `conversa_id`. Página 1 traz as mensagens mais recentes. `limite` (teto 30) e `pagina` são opcionais. A resposta traz `total`, `pagina` e `temMaisAntigas`.

Não há ferramenta para enviar mensagem.

## Métricas

- `obter_metricas` (`analytics:read`, só lê) devolve contagens da organização: conversas abertas, de hoje e no total; funcionários e cérebros; mensagens da IA; série dos últimos 7 dias; ranking de volume por funcionário. Sem argumentos.
- `obter_metricas_funcionarios` (`analytics:read`, só lê) lê métricas dos funcionários IA. Sem `funcionario_id`, o resumo da organização. Com `funcionario_id` (de `listar_funcionarios`), as métricas daquele funcionário.
- `obter_analytics_periodo` (`analytics:read`, só lê) lê analytics de páginas no período. `recorte`: `organizacao` (padrão), `diario` ou `jornada` (exige `jornada_id`). `data_inicio` e `data_fim` são ISO 8601.

Não lista nomes de jornadas, fluxos, conversas individuais nem canais. Para isso use `listar_jornadas`, `listar_automacoes`, `listar_conversas` ou `listar_integracoes`. Métricas de uma jornada: `obter_metricas_jornada` (skill `jornadas`).
