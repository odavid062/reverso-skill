# Instruções para agentes de IA (Codex, Claude Code, Cursor, Gemini CLI...)

Este repositório **é uma skill**, não um projeto para modificar. Se o usuário disse algo como
**"aprenda essa skill"**, **"instale essa skill"** ou só colou o link deste repositório, faça o seguinte:

## 1. Instalar (global, para valer em qualquer projeto)

Copie a pasta `skills/reverso/` inteira (com `references/` e `templates/`) para as pastas de skills do usuário,
fazendo backup de uma versão anterior se existir (`reverso.bak.<data>`):

| Agente | Destino |
|--------|---------|
| Claude Code | `~/.claude/skills/reverso/` |
| Codex | `~/.codex/skills/reverso/` |
| Outros (padrão Agent Skills: Cursor, Gemini CLI, OpenCode...) | `~/.agents/skills/reverso/` |

Atalhos prontos (o usuário já autorizou ao pedir a instalação):

- Linux/macOS/Git Bash: `bash install.sh` (ou `bash install.sh --project` para instalar só no projeto atual)
- Windows PowerShell: `powershell -ExecutionPolicy Bypass -File install.ps1` (ou `-Project`)

Se você não puder escrever fora do diretório atual, instale no projeto: `.claude/skills/reverso/` e `.agents/skills/reverso/`.

## 2. Aprender agora, nesta mesma sessão

A sessão atual normalmente só enxerga skills novas depois de reiniciar. Para usar **já**:
leia `skills/reverso/SKILL.md` na íntegra e siga as instruções dela quando o usuário pedir
`reverso`/`/reverso`. Leia os arquivos de `references/` só quando a etapa precisar.

## 3. Confirmar ao usuário

Responda em português, em poucas linhas:
- onde instalou;
- que deve reiniciar o agente para o comando `/reverso` aparecer;
- 3 exemplos de uso: `reverso` (analisar o projeto atual), `reverso artefato caminho/do/app`, `reverso clonar <feature> de <app>`.

## Ao trabalhar *neste* repositório (manutenção da skill)

- A fonte da verdade é `skills/reverso/`. O README é para humanos.
- Mantenha o `SKILL.md` enxuto (roteador); detalhe vai para `references/`.
- Escreva em português do Brasil.
