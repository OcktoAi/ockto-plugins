#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

python3 - "$root" << 'PY'
import json
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

root = Path(sys.argv[1])
mcp_url = "https://mcp.ockto.ai/mcp"
errors = []

def load(rel):
    path = root / rel
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        errors.append(f"{rel}: JSON inválido ({exc})")
        return None

cursor_mcp = load("cursor/mcp.json")
claude_mcp = load("claude/.mcp.json")
chatgpt_mcp = load("chatgpt/mcp.json")
chatgpt_plugin = load("chatgpt/plugin.json")
gemini = load("gemini/gemini-extension.json")
cursor_plugin = load("cursor/.cursor-plugin/plugin.json")
claude_plugin = load("claude/.claude-plugin/plugin.json")
load(".cursor-plugin/marketplace.json")
load(".claude-plugin/marketplace.json")
load(".agents/plugins/marketplace.json")

def expect(label, got):
    if got != mcp_url:
        errors.append(f"{label}: URL do MCP é {got!r}, esperado {mcp_url}")

if cursor_mcp:
    expect("cursor/mcp.json", cursor_mcp.get("mcpServers", {}).get("ockto", {}).get("url"))
if claude_mcp:
    server = claude_mcp.get("mcpServers", {}).get("ockto", {})
    expect("claude/.mcp.json", server.get("url"))
    if server.get("type") != "http":
        errors.append("claude/.mcp.json: type precisa ser http")
if chatgpt_mcp:
    server = chatgpt_mcp.get("mcpServers", {}).get("ockto", {})
    expect("chatgpt/mcp.json", server.get("url"))
    if server.get("type") != "streamable-http":
        errors.append("chatgpt/mcp.json: type precisa ser streamable-http")
    if chatgpt_mcp.get("$schema") != "https://agent-plugins.org/schemas/1.0.0/mcp.schema.json":
        errors.append("chatgpt/mcp.json: $schema divergente do Agent Plugins 1.0.0")
if gemini:
    expect("gemini/gemini-extension.json", gemini.get("mcpServers", {}).get("ockto", {}).get("httpUrl"))
    if gemini.get("contextFileName") != "GEMINI.md":
        errors.append("gemini/gemini-extension.json: contextFileName precisa ser GEMINI.md")

versioned = (
    ("cursor/.cursor-plugin/plugin.json", cursor_plugin, "version"),
    ("claude/.claude-plugin/plugin.json", claude_plugin, "version"),
    ("chatgpt/plugin.json", chatgpt_plugin, "version"),
    ("gemini/gemini-extension.json", gemini, "version"),
)
seen = {}
for rel, doc, key in versioned:
    if doc and doc.get("name") != "ockto":
        errors.append(f"{rel}: name precisa ser ockto")
    if doc:
        seen[rel] = doc.get(key)
versions = {value for value in seen.values()}
if len(seen) != 4 or len(versions) != 1 or None in versions or "" in versions:
    detail = ", ".join(f"{rel}={value!r}" for rel, value in seen.items())
    errors.append(f"versões divergem: {detail}")

if chatgpt_plugin:
    interface = chatgpt_plugin.get("extensions", {}).get("com.openai", {}).get("interface", {})
    short = interface.get("shortDescription")
    if not isinstance(short, str) or len(short) > 30:
        errors.append(
            f"chatgpt/plugin.json: shortDescription tem {len(short) if isinstance(short, str) else 'tipo inválido'} caracteres; o máximo é 30"
        )
    for field in ("websiteURL", "supportURL", "privacyPolicyURL", "termsOfServiceURL"):
        if not interface.get(field):
            errors.append(f"chatgpt/plugin.json: falta {field}")

if claude_plugin:
    for field in ("privacyPolicyUrl", "termsOfServiceUrl", "icon"):
        if not claude_plugin.get(field):
            errors.append(f"claude/.claude-plugin/plugin.json: falta {field}")
    icon = claude_plugin.get("icon")
    if isinstance(icon, str) and icon:
        icon_rel = icon[2:] if icon.startswith("./") else icon
        icon_path = root / "claude" / icon_rel
        if not icon_path.is_file():
            errors.append(f"claude/.claude-plugin/plugin.json: ícone não existe em {icon_path.relative_to(root)}")
        else:
            suffix = icon_path.suffix.lower()
            if suffix == ".png":
                if not icon_path.read_bytes().startswith(b"\x89PNG\r\n\x1a\n"):
                    errors.append(f"{icon_path.relative_to(root)}: PNG inválido")
            elif suffix == ".svg":
                svg = icon_path.read_text(encoding="utf-8")
                try:
                    ET.fromstring(svg)
                except ET.ParseError as exc:
                    errors.append(f"{icon_path.relative_to(root)}: SVG inválido ({exc})")
                lowered = svg.lower()
                if any(token in lowered for token in ("<style", "class=", "<script", "href=", "url(")):
                    errors.append(f"{icon_path.relative_to(root)}: SVG tem <style>, class=, <script> ou referência externa")
            else:
                errors.append(f"{icon_path.relative_to(root)}: ícone precisa ser PNG ou SVG")

if chatgpt_plugin and chatgpt_plugin.get("$schema") != "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json":
    errors.append("chatgpt/plugin.json: $schema divergente do Agent Plugins 1.0.0")

forbidden = "https://api.ockto.ai/mcp"
skip_scan = {Path("scripts/validate.sh"), Path("CHANGELOG.md")}
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts:
        continue
    rel = path.relative_to(root)
    if path.suffix == ".png" or rel in skip_scan:
        continue
    text = path.read_text(encoding="utf-8", errors="replace")
    if forbidden in text:
        errors.append(f"{rel}: ainda aponta para {forbidden}")
    for needle in ("client_secret", "clientSecret", '"Authorization"', "Bearer "):
        if needle in text:
            errors.append(f"{rel}: contém {needle}")

catalog = (root / "scripts/ferramentas.txt").read_text(encoding="utf-8").split()
skills_root = root / "content/skills"
blob_by_file = {p: p.read_text(encoding="utf-8") for p in skills_root.rglob("SKILL.md")}
blob = "\n".join(blob_by_file.values())
for name in catalog:
    if f"`{name}`" not in blob:
        errors.append(f"skill não cita `{name}`")

confirm = (root / "scripts/confirmacao.txt").read_text(encoding="utf-8").split()
for name in confirm:
    owners = [p for p, text in blob_by_file.items() if f"`{name}`" in text]
    if not owners:
        errors.append(f"ferramenta com confirmação sem skill: {name}")
        continue
    for path in owners:
        if "codigo_confirmacao" not in blob_by_file[path]:
            errors.append(f"{path.relative_to(root)} cita `{name}` sem explicar codigo_confirmacao")

if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
print("JSON, URL do MCP e ferramentas conferidos")
PY

for dest in claude cursor chatgpt gemini; do
  if ! diff -rq "$root/content/skills" "$root/$dest/skills" >/dev/null; then
    echo "skills de $dest divergem de content/skills" >&2
    diff -rq "$root/content/skills" "$root/$dest/skills" >&2 || true
    exit 1
  fi
done

echo "skills sincronizadas"
