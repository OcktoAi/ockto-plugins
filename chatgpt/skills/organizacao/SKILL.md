---
name: organizacao
description: Lista os membros da organização e lê o plano e o uso dos limites, inclusive créditos restantes, na Ockto. O e-mail do membro é dado pessoal.
---

# Organização e plano

A organização é a do consentimento. Estas ferramentas só leem e não recebem argumento.

Se uma delas não aparecer na lista, ou a chamada disser que falta `organization:read` (`insufficient_scope`), reconecte o MCP e consinta de novo. A renovação do token não acrescenta escopo que o consentimento antigo não gravou. O passo a passo está na skill `conectar`.

- `listar_membros_organizacao` (`organization:read`, só lê) lista os membros. Cada item traz `id`, `usuario_id`, `nome`, `email`, `papel` e `status`. Não traz telefone, convite, MFA nem avatar. Para `transferir_conversa_para_humano` e para `atribuir_responsavel_conversa` com `tipo` `user` (skill `conversas`), o id é `usuario_id`. O `id` do membro não entra nessas ferramentas.

O `email` é dado pessoal. Mostre o nome, e o e-mail só para distinguir homônimos. Não copie a lista de e-mails para mensagem ao cliente, arquivo ou outra ferramenta.

- `obter_limites_plano` (`organization:read`, só lê) devolve `plano` e `recursos`, inclusive créditos restantes. Sem token e sem id da organização. Consulte quando um contato está bloqueado pelo limite do plano ou antes de uma ação que consome vaga. Pagamento, fatura e troca de plano ficam no console (https://console.ockto.ai).

Convite, mudança de papel e remoção de membro ficam no console. Não invente ferramenta para isso.
