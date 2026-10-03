# Ockto

Servidor MCP: `https://mcp.ockto.ai/mcp` (Streamable HTTP). A autenticação é OAuth 2.1. Não peça client id, client secret nem token, e não grave credencial em arquivo.

O Authorization Server é `https://api.ockto.ai`, descoberto por `https://mcp.ockto.ai/.well-known/oauth-protected-resource/mcp`. O registro do cliente é dinâmico.

Quando a skill pede confirmação (responder conversa, vincular ou desvincular funcionário de canal, criar template de WhatsApp, publicar ou despublicar página, criar ou atualizar formulário externo, criar, atualizar ou associar pixel, criar ou atualizar chat bubble e link direto, ativar ou reativar automação, importar contatos, sincronizar fonte, resetar mapeamento, exclusão, remoção e desvínculo), a primeira chamada, sem `codigo_confirmacao`, só descreve e devolve um código. A segunda repete os mesmos argumentos com esse código. O código expira em 120 segundos e vale uma vez. Sincronizar template, criar página e atualizar página não pedem código. Nem toda escrita destrutiva pede esse código: a skill diz qual pede.

Conexão antiga não recebe `pages:read`, `pages:write`, `pages:publish`, `pages:delete`, `pixels:read`, `pixels:write`, `pixels:delete` nem `domains:read` na renovação do token, como já ocorre com `integrations:write`, `billing:read`, `conversations:write` e `organization:read`. Chat bubble e link direto usam `integrations:read` e `integrations:write`. Se a ferramenta faltar ou a chamada disser que o escopo falta, reconecte o MCP e consinta de novo.

As skills em `skills/` detalham contatos, jornadas, páginas, pixels, funcionários de IA, automações, conversas, organização, negócios, chat bubble e link direto.
