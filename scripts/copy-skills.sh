#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"

for dest in claude cursor chatgpt gemini; do
  rm -rf "$root/$dest/skills"
  mkdir -p "$root/$dest/skills"
  cp -R "$root/content/skills/." "$root/$dest/skills/"
done
