# Ockto Plugins: instruções para agentes

Plugins da Ockto para Claude, ChatGPT, Cursor e Gemini. Cada plugin aponta para o servidor MCP da Ockto (`ockto-mcp`) e traz skills que ensinam a IA a usar as ferramentas.

Tudo aqui é produto publicado nas lojas, não documentação interna: os `SKILL.md`, os manifests, os `README.md` de cada plataforma (o do Claude é a `documentationUrl` do plugin) e o `gemini/GEMINI.md` (contexto carregado pela extensão).

## Onde editar

- Skills: edite só em `content/skills/` e rode `bash scripts/copy-skills.sh`, que copia para `chatgpt/`, `claude/`, `cursor/` e `gemini/`. O `validate.sh` falha se as cópias divergirem.
- Cada plataforma é empacotada da sua própria pasta. Arquivos na raiz não entram em nenhum plugin.

## Produto

A Ockto é uma plataforma de **automação, atendimento com IA, gestão de contatos (CRM) e gestão de jornadas**, agnóstica de mercado, negócio e área. O mesmo cliente a usa para vendas, atendimento, suporte, agendamento, onboarding, pós-venda, cobrança ou qualquer outro processo.

## Fonte da verdade

O código é a única fonte da verdade. Os nomes de ferramentas e escopos citados nas skills vêm do `ockto-mcp`: confira lá antes de escrever.

## Vocabulário

**Vendas pode aparecer como um caso de uso entre outros; nunca como o modelo padrão.** Nenhuma skill, descrição ou exemplo pressupõe que o cliente vende algo.

| Use | Evite |
|---|---|
| contato | lead |
| contatos | leads |
| concluiu a jornada (etapa de sucesso) / perdido (etapa de perda) | status `lead` / `cliente` / `perdido` |
| concluídos, taxa de conclusão | vendas, conversão em cliente |
| jornada, progresso | funil |
| valor | valor do negócio |
| movimentações | negociações |
| valor movimentado | receita |
| Contatos, Jornadas (nomes de tela, permissão e código) | CRM como nome de tela ou de permissão, como em "Leads (CRM)" |

"Cliente" só se usa para a empresa que contrata a Ockto. A pessoa que conversa com a organização é sempre "contato".

## Validação

```bash
bash scripts/validate.sh
```
