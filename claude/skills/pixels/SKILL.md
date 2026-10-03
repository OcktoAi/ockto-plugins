---
name: pixels
description: Consulta e grava pixels de integração e o vínculo com jornadas na Ockto. Pixel manual com script fica no console.
---

# Pixels

A organização é a do consentimento. Jornadas vêm da skill `jornadas`.

Se a ferramenta não aparecer, ou a chamada responder `insufficient_scope`, reconecte o MCP e consinta de novo. Os escopos são `pixels:read`, `pixels:write` e `pixels:delete`. A renovação do token não acrescenta escopo que o consentimento antigo não gravou. O passo a passo está na skill `conectar`. Escopo não substitui a permissão do membro.

Listar e obter não devolvem o identificador de rastreamento nem o código instalado.

## Leitura

- `listar_pixels` (`pixels:read`, só lê). `pagina` começa em 1. `limite` tem padrão 15 e teto 50. A resposta traz `pixels`, `total`, `pagina`, `limite` e `tem_mais`. Filtros opcionais: `busca`, `status` (`active` ou `inactive`) e `servico`. Cada pixel traz `id`, `nome`, `tipo`, `servico`, `status` e `jornadas` (quantidade).
- `obter_pixel` (`pixels:read`, só lê). Exige `pixel_id`, o id do pixel na Ockto.
- `listar_servicos_pixel` (`pixels:read`, só lê) lista o catálogo de integração, com `servico`, `nome` e `descricao`. Sem argumento. `criar_pixel` aceita `facebook`, `google-ads`, `google-analytics`, `google-tag-manager`, `tiktok` e `linkedin`.
- `obter_preview_pixel` (`pixels:read`, só lê) gera o snippet público a partir do `servico` e do `identificador` informados. Não lê um pixel salvo e não devolve credencial. A resposta traz `cabecalho`, `corpo` e `rodape`.
- `verificar_pixel` (`pixels:read`, só lê; consulta a URL). Exige `url`: uma só, até 2000 caracteres, sem espaço. A API bloqueia endereço interno. A resposta traz `instalado`, `compativel`, `tem_script` e `mensagem`. Sem id de organização.
- `listar_pixels_jornada` (`pixels:read`, só lê) lista os pixels ligados a uma jornada, sem o código. Exige `jornada_id`.
- `listar_jornadas_pixel` (`pixels:read`, só lê) lista as jornadas da organização ligadas a um pixel. Exige `pixel_id`. Cada item traz `id` e `nome`.

Nenhuma leitura pede `codigo_confirmacao`.

## Gravar

Pixel manual, com script colado, não entra pelo MCP. Crie esse no console (https://console.ockto.ai). `criar_pixel` só cria integração. A resposta não traz o código. Para ver o snippet, use `obter_preview_pixel` com o serviço e o identificador.

- `criar_pixel` (`pixels:write`; cada chamada pode criar outro). Exige `nome` (até 200), `servico` e `identificador` (id no serviço, até 80 caracteres; o servidor recusa espaço, barra, `?` e `#`). `status` opcional: `active` ou `inactive`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra nome, serviço e identificador. Mostre isso ao usuário. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `atualizar_pixel` (`pixels:write`) altera o nome ou o status. Não altera o código. Exige `pixel_id` e ao menos `nome` ou `status` (`active` ou `inactive`). Confirmação em dois passos. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
- `associar_pixel_jornadas` (`pixels:write`) liga o pixel a jornadas da organização. Exige `pixel_id` e `jornada_ids` (lista de até 50). Jornada de outra organização é recusada. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o pixel e as jornadas. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

## Excluir

- `excluir_pixel` (`pixels:delete`, destrutiva) apaga o pixel e os vínculos com jornadas. Exige `pixel_id`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o nome. A segunda repete o mesmo `pixel_id` com `codigo_confirmacao`. 120 segundos, uso único.
- `desassociar_pixel_jornada` (`pixels:delete`, destrutiva) tira uma jornada do pixel. O pixel continua. Exige `pixel_id` e `jornada_id`. Confirmação em dois passos. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.
