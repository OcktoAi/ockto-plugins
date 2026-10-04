# Changelog

## 2.5.1

- O caminho do conector avulso no ChatGPT passou a ser Developer mode em Settings → Security and login, depois ChatGPT Plugins → + (README e skill `conectar`).

## 2.5.0

- Skills acompanham as 150 ferramentas do MCP: páginas e formulários externos, pixels de integração, chat bubble, link direto e leitura de domínios.
- Escopos `pages:read`, `pages:write`, `pages:publish`, `pages:delete`, `pixels:read`, `pixels:write`, `pixels:delete` e `domains:read`. Conexão antiga precisa reconectar e consentir de novo. Chat bubble e link direto usam `integrations:read` e `integrations:write`.
- Publicar página exige domínio com `pronto_para_publicar`. Excluir página ou formulário com etapa tira os leads da jornada. Criar formulário cria etapa. HTML, pixel manual, avatar e criar domínio continuam no console.
- A etapa WhatsApp de vincular e desvincular funcionário é tentativa. O extrato aceita a carteira `PENDING`. Contato já na etapa não reprocessa; mover para a mesma etapa não faz nada.

## 2.4.0

- Skills acompanham as 113 ferramentas do MCP: vincular e desvincular funcionário de canal com confirmação, sincronizar e criar template de WhatsApp, saldo e extrato de créditos.
- Escopos `integrations:write` e `billing:read`. Conexão antiga precisa reconectar e consentir de novo.
- `adicionar_contato_jornada` avisa as ações da etapa: webhook de entrada e de saída, template de WhatsApp aprovado, Mailchimp e ActiveCampaign.
- Conectar e desconectar canal, token, excluir template, enviar template na conversa e compra de créditos continuam no console.

## 2.3.0

- Skills acompanham as 107 ferramentas do MCP: responder conversa com confirmação (atendente humano, sem crédito de IA, janela de 24h), transferir para humano ou IA, atribuir responsável, fechar, reabrir, marcar como lida, listar membros e limites do plano.
- Escopos `conversations:write` e `organization:read`. Conexão antiga precisa reconectar e consentir de novo.
- Template fora da janela, anexo, canal do funcionário, páginas, convite e pagamento continuam no console.

## 2.2.0

- Skills acompanham as 98 ferramentas do MCP: pausa e reativação, execução, amostra, biblioteca de agente, agenda, capacidades, sincronização de fonte, exclusão forçada de cérebro, notas, memória e importação de contatos.
- Importação padrão mescla; substituir só se o usuário pedir. Arquivo, volume acima de 2000, upload de documento ou áudio, teste de nó, agente público, evento de agenda, credencial, SQL, exportação, domínio, equipe e billing ficam no console. Responder conversa, transferir, ligar funcionário a canal, páginas, saldo de créditos e membros não têm ferramenta.

## 2.1.0

- Skills acompanham as 79 ferramentas do MCP: edição de automação por nó, leituras novas e `pagina`/`limite` (teto 50, com os tetos menores de cada ferramenta).
- Segredo mascarado `***` não deve ser reenviado. Credencial, OAuth, SQL livre, equipe, billing, domínio, exportação e super-admin ficam no console.

## 2.0.1

- Metadados de listagem. O MCP permanece em `https://mcp.ockto.ai/mcp` e as skills não mudam.
- ChatGPT: subtítulo de até 30 caracteres e URLs de site, suporte, privacidade e termos.
- Claude: política, termos, documentação, suporte e ícone do diretório.
- Gemini: workflow que empacota `gemini/` num `ockto.tar.gz` na release de uma tag `v*`.

## 2.0.0

- Breaking: o servidor MCP passa de `https://api.ockto.ai/mcp` para `https://mcp.ockto.ai/mcp`.
- Breaking: os escopos `mcp:read` e `mcp:write` saem. O consentimento usa 19 escopos granulares.
- O repositório vira monorepo: Cursor, Claude Code, ChatGPT/Codex e Gemini CLI.
- Skills de domínio em `content/skills/`, copiadas para cada cliente que carrega skills.
- Claude.ai, Cowork, Claude Desktop e o conector avulso do ChatGPT ficam como guia, sem manifest inventado.

## 1.0.0

- Initial release: Ockto remote MCP server (`https://api.ockto.ai/mcp`) with OAuth sign-in.
