---
name: paginas
description: Consulta e altera páginas e formulários externos das jornadas, publica em domínio e lê os domínios da organização na Ockto. O HTML fica no editor.
---

# Páginas, formulários e domínios

A organização é a do consentimento. O `jornada_id` vem de `listar_jornadas` ou `obter_jornada` (skill `jornadas`). Leads na etapa ficam na skill `crm`.

Se a ferramenta não aparecer, ou a chamada responder `insufficient_scope`, reconecte o MCP e consinta de novo. Os escopos são `pages:read`, `pages:write`, `pages:publish`, `pages:delete` e `domains:read`. A renovação do token não acrescenta escopo que o consentimento antigo não gravou. O passo a passo está na skill `conectar`. Escopo não substitui a permissão do membro.

Leituras de página não devolvem HTML, CSS, JavaScript, dados do editor nem screenshot.

## Páginas

- `listar_paginas` (`pages:read`, só lê) lista as páginas de uma jornada. Exige `jornada_id`.
- `obter_pagina` (`pages:read`, só lê) lê uma página. Exige `pagina_id`. A resposta traz `id`, `jornada_id`, `nome`, `descricao`, `caminho`, `url`, `status`, `publicada`, `externa`, `dominio_id`, `etapa_id`, `no_id`, `visitas`, `leads` e `visitantes`.
- `criar_pagina` (`pages:write`; cada chamada cria outra) cria a página só com nome, caminho e descrição. Não publica e não envia HTML. Exige `jornada_id`, `nome` (até 200) e `caminho` (caminho público, por exemplo `/captura`). `descricao` é opcional (até 500). Não pede `codigo_confirmacao`.
- `atualizar_pagina` (`pages:write`) altera nome e/ou descrição. Exige `pagina_id` e ao menos `nome` ou `descricao`. Não muda caminho, status, publicação nem HTML. Não pede `codigo_confirmacao`.

O conteúdo visual fica no editor da Ockto, no console (https://console.ockto.ai). Não há ferramenta para gravar HTML.

## Publicar

Publicar põe no ar o HTML já salvo no editor. O arquivo segue para o domínio, o cache é invalidado e um screenshot é pedido. Não envia HTML novo.

1. `listar_dominios` (`domains:read`, só lê) lista `id`, `dominio`, `status`, `tipo` e `pronto_para_publicar`. Sem bucket, distribuição, ARN ou DNS. Não pede argumento.
2. Escolha um domínio com `pronto_para_publicar`. `obter_dominio` (`domains:read`, só lê) lê um, pelo `dominio_id`. Esse id é o argumento `dominio_id` de `publicar_pagina`.
3. `publicar_pagina` (`pages:publish`, destrutiva: a página vai para o ar). Exige `pagina_id` e `dominio_id`.

Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta descreve a página e o domínio. Domínio inexistente ou sem `pronto_para_publicar` recusa antes: use `listar_dominios` e escolha um pronto. Se a leitura do domínio for recusada, a confirmação segue e a publicação confere na hora se ele está ativo e configurado. Mostre página e domínio ao usuário e espere o ok. A segunda chamada repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

- `despublicar_pagina` (`pages:publish`, destrutiva) tira a página do ar e remove os arquivos publicados no domínio. Exige `pagina_id`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra o nome e a URL atual, quando houver. A segunda repete o mesmo `pagina_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Excluir página

`excluir_pagina` (`pages:delete`, destrutiva). Exige `pagina_id`. Se a página tem etapa (`etapa_id`), a etapa é apagada e os leads que estão nela saem da jornada. O contato continua existindo. Sem etapa, nenhum lead sai. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta diz qual dos dois casos é. Mostre isso ao usuário. A segunda repete o mesmo `pagina_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Formulários externos

O snippet não traz segredo: o envio vai para a rota pública de submit.

- `listar_formularios_externos` (`pages:read`, só lê) lista os da jornada. Exige `jornada_id`. Sem screenshot.
- `obter_formulario_externo` (`pages:read`, só lê) lê um. Exige `formulario_id`. Sem screenshot. A resposta traz `id`, `jornada_id`, `etapa_id`, `no_id`, `nome`, `url`, `tipo`, `texto_botao`, `redirect_url`, `incluir_email`, `ativo`, `envios` e `visitas`.
- `obter_codigo_formulario` (`pages:read`, só lê) devolve o snippet público. Exige `formulario_id`.

- `criar_formulario_externo` (`pages:write`; cria uma etapa na jornada com o nome do formulário; a URL pode pedir screenshot). Exige `jornada_id`, `nome` (até 200) e `url` (a página onde o formulário será usado). Opcionais: `node_id`, `texto_botao` (até 80), `redirect_url` e `incluir_email`. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta mostra nome, jornada e URL e avisa que uma etapa será criada. Mostre isso ao usuário. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

- `atualizar_formulario_externo` (`pages:write`; URL nova pede screenshot). Exige `formulario_id` e ao menos um campo: `nome`, `url`, `texto_botao`, `redirect_url`, `incluir_email` ou `ativo`. `ativo` falso faz o formulário deixar de aceitar envios. Confirmação em dois passos. A segunda repete os mesmos argumentos com `codigo_confirmacao`. 120 segundos, uso único.

- `excluir_formulario_externo` (`pages:delete`, destrutiva). Exige `formulario_id`. Se o formulário tem etapa, a etapa é apagada e os leads que estão nela saem da jornada. O contato continua. Sem etapa, nenhum lead sai. Confirmação em dois passos. Sem `codigo_confirmacao` a ferramenta diz qual dos dois casos é. A segunda repete o mesmo `formulario_id` com `codigo_confirmacao`. 120 segundos, uso único.

## Domínios

Só leitura. `listar_dominios` e `obter_dominio` estão na seção Publicar. Nenhuma das duas pede `codigo_confirmacao`.

Criar domínio, DNS, repetir a configuração e excluir domínio ficam no console (https://console.ockto.ai).
