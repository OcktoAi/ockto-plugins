---
name: organizacao
description: Lista os membros da organização, lê o plano e os limites, e consulta saldo e extrato de créditos na Ockto. O e-mail do membro é dado pessoal.
---

# Organização e plano

A organização é a do consentimento. Membros e limites só leem e não recebem argumento. Saldo e extrato também só leem; o período e a página são opcionais.

Se uma delas não aparecer na lista, ou a chamada disser que falta `organization:read` ou `billing:read` (`insufficient_scope`), reconecte o MCP e consinta de novo. A renovação do token não acrescenta escopo que o consentimento antigo não gravou. O passo a passo está na skill `conectar`.

- `listar_membros_organizacao` (`organization:read`, só lê) lista os membros. Cada item traz `id`, `usuario_id`, `nome`, `email`, `papel` e `status`. Não traz telefone, convite, MFA nem avatar. Para `transferir_conversa_para_humano` e para `atribuir_responsavel_conversa` com `tipo` `user` (skill `conversas`), o id é `usuario_id`. O `id` do membro não entra nessas ferramentas.

O `email` é dado pessoal. Mostre o nome, e o e-mail só para distinguir homônimos. Não copie a lista de e-mails para mensagem ao cliente, arquivo ou outra ferramenta.

- `obter_limites_plano` (`organization:read`, só lê) devolve `plano` e `recursos`, inclusive créditos restantes do plano. Sem token e sem id da organização. Consulte quando um contato está bloqueado pelo limite do plano ou antes de uma ação que consome vaga. Esse número não é o extrato.

## Créditos

Saldo, resumo do período e extrato. Sem cartão, fatura, id de gateway, e-mail ou id de pagamento. Compra, checkout, pacote e troca de plano ficam no console (https://console.ockto.ai).

- `obter_saldo_creditos` (`billing:read`, só lê) devolve `saldo` e `resumo`. O saldo traz `creditos_mensais`, `limite_mensal`, `creditos_adicionais`, `adicionais_usados`, `limite_adicionais`, `total` e `ultimo_reset`. O resumo traz `creditados`, `debitados`, `resets`, `por_motivo` (`quantidade` e `total` de cada motivo) e `periodo` (`de`, `ate`). `de` e `ate` são ISO 8601, opcionais, e valem só para o resumo. O saldo é o atual, com ou sem período.

- `listar_transacoes_creditos` (`billing:read`, só lê) lista o extrato. `pagina` começa em 1. `limite` tem padrão 10 e teto 50. A resposta traz `transacoes`, `total`, `pagina`, `limite` e `tem_mais`. Cada item traz `id`, `tipo`, `carteira`, `valor`, `saldo_depois`, `motivo` e `criado_em`. Filtros opcionais: `de` e `ate` (ISO 8601), `carteira` (`MONTHLY` ou `ADDITIONAL`), `tipo` (entryType, por exemplo `DEBIT` ou `CREDIT`) e `motivo` (reasonCode). Sem descrição livre, metadata, e-mail, sourceId ou id de pagamento.

Nenhuma das duas pede `codigo_confirmacao`.

Convite, mudança de papel e remoção de membro ficam no console. Não invente ferramenta para isso.
