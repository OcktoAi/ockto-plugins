---
name: negocios
description: Consulta e altera negócios (marcas) da organização na Ockto. Cérebro e funcionário podem ficar restritos a um negócio.
---

# Negócios

Negócio aqui é a marca da organização, não o valor de um contato.

- `listar_negocios` (`businesses:read`, só lê) lista nome, segmento e status. `busca` opcional. `pagina` (começa em 1) e `limite` (padrão 20, teto 50). A resposta traz `total`, `pagina`, `limite` e `tem_mais`.
- `obter_negocio` (`businesses:read`, só lê) detalha um negócio. Exige `negocio_id`.
- `criar_negocio` (`businesses:write`) exige `nome`. Segmento, descrição, site, ano de fundação, contato e status são opcionais.
- `atualizar_negocio` (`businesses:write`) altera só os campos enviados. Exige `negocio_id`.
- `excluir_negocio` (`businesses:delete`, destrutiva) apaga a marca de forma permanente. A exclusão é recusada se ainda houver cérebro ou funcionário vinculado: desvincule antes (skill `funcionarios`). Confirmação em dois passos: sem `codigo_confirmacao` a chamada só descreve; a segunda repete o mesmo `negocio_id` com `codigo_confirmacao`. O código expira em 120 segundos e vale uma vez.

`negocio_id` deste catálogo é o que `criar_cerebro`, `atualizar_cerebro`, `criar_funcionario` e `atualizar_funcionario` aceitam para restringir a marca.
