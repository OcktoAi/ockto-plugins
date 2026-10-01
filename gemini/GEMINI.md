# Ockto

Servidor MCP: `https://mcp.ockto.ai/mcp` (Streamable HTTP). A autenticação é OAuth 2.1. Não peça client id, client secret nem token, e não grave credencial em arquivo.

O Authorization Server é `https://api.ockto.ai`, descoberto por `https://mcp.ockto.ai/.well-known/oauth-protected-resource/mcp`. O registro do cliente é dinâmico.

Ferramentas destrutivas e `ativar_automacao` confirmam em dois passos. A primeira chamada, sem `codigo_confirmacao`, só descreve e devolve um código. A segunda repete os mesmos argumentos com esse código. O código expira em 120 segundos e vale uma vez.

As skills em `skills/` detalham contatos, jornadas, funcionários de IA, automações, conversas e negócios.
