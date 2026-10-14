#!/usr/bin/env bash
# Instala a skill "reverso" para Claude Code, Codex e agentes compatíveis com Agent Skills.
# Uso:
#   ./install.sh               # instalação global (pasta do usuário)
#   ./install.sh --project     # instala só no projeto atual (.claude/skills e .agents/skills)
#   curl -fsSL https://raw.githubusercontent.com/odavid062/reverso-skill/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/odavid062/reverso-skill.git"
SKILL="reverso"
MODE="global"
[ "${1:-}" = "--project" ] && MODE="project"

# Descobre a pasta da skill: no clone local ou baixando o repositório.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/skills/$SKILL/SKILL.md" ]; then
  SRC="$SCRIPT_DIR/skills/$SKILL"
else
  TMP="$(mktemp -d)"
  git clone --depth 1 "$REPO_URL" "$TMP/repo" >/dev/null 2>&1
  SRC="$TMP/repo/skills/$SKILL"
fi

if [ "$MODE" = "project" ]; then
  TARGETS=("$PWD/.claude/skills" "$PWD/.agents/skills")
else
  TARGETS=("$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills")
fi

for dir in "${TARGETS[@]}"; do
  mkdir -p "$dir"
  if [ -d "$dir/$SKILL" ]; then
    mv "$dir/$SKILL" "$dir/$SKILL.bak.$(date +%Y%m%d%H%M%S)"
  fi
  cp -R "$SRC" "$dir/$SKILL"
  echo "✔ instalado em $dir/$SKILL"
done

echo
echo "Pronto. Reinicie o agente e digite: /reverso  (ou só: reverso)"
