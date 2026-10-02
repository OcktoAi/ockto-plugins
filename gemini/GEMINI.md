# Ockto

Servidor MCP: `https://mcp.ockto.ai/mcp` (Streamable HTTP). A autenticação é OAuth 2.1. Não peça client id, client secret nem token, e não grave credencial em arquivo.

O Authorization Server é `https://api.ockto.ai`, descoberto por `https://mcp.ockto.ai/.well-known/oauth-protected-resource/mcp`. O registro do cliente é dinâmico.

Quando a skill pede confirmação (ativar ou reativar automação, importar contatos, sincronizar fonte, resetar mapeamento, exclusão, remoção e desvínculo), a primeira chamada, sem `codigo_confirmacao`, só descreve e devolve um código. A segunda repete os mesmos argumentos com esse código. O código expira em 120 segundos e vale uma vez. Nem toda escrita destrutiva pede esse código: a skill diz qual pede.

As skills em `skills/` detalham contatos, jornadas, funcionários de IA, automações, conversas e negócios.
