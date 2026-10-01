---
name: conversas
description: Lê conversas da organização e as contagens operacionais do dashboard na Ockto.
---

# Conversas e métricas

A organização é a do consentimento. Estas ferramentas só leem.

## Conversas

- `listar_conversas` (`conversations:read`) lista threads recentes: contato, canal e status. Filtros opcionais: `busca`, `canal`, `status`.
- `obter_conversa` (`conversations:read`) devolve o histórico de uma conversa. Exige `conversa_id`. `limite` e `pagina` são opcionais.

Não há ferramenta para enviar mensagem.

## Métricas

`obter_metricas` (`analytics:read`) devolve contagens da organização: conversas abertas, de hoje e no total; funcionários e cérebros; mensagens da IA; série dos últimos 7 dias; ranking de volume por funcionário. Sem argumentos.

Não lista nomes de jornadas, fluxos, conversas individuais nem canais. Para isso use `listar_jornadas`, `listar_automacoes`, `listar_conversas` ou `listar_integracoes`.
