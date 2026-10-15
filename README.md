# Reverso: super skill de engenharia reversa para IA

**Engenharia reversa de qualquer coisa, do código legado ao binário, até virar uma spec que outro agente de IA consegue executar.**

O Reverso une, numa única skill, dois projetos open source:

| | [Reversa](https://github.com/sandeco/reversa) (sandeco) | [REA: Reverse Engineer Anything](https://github.com/morluto/rea) (morluto) |
|---|---|---|
| Entrada | código-fonte legado | o que foi entregue: binário, APK, Electron/JS, .NET, WASM, firmware, site, HAR/PCAP, SQLite |
| Ponto forte | time de agentes que gera specs SDD rastreáveis (Scout → Archaeologist → Detective → Architect → Writer → Reviewer) e leva até o código | evidência rigorosa: observação × inferência × desconhecido, roteamento por tipo de alvo |
| No Reverso vira | **Modo FONTE**, + Forward, Migração, Debug, Refatoração | **Modo ARTEFATO**, com fallback para ferramentas comuns quando o MCP do REA não está instalado |

E um modo novo que só existe com os dois juntos: **CLONAR FEATURE**. Viu uma feature num app e quer no seu projeto?
O Reverso observa como ela funciona (sem código-fonte), escreve a spec e implementa no seu projeto, **sem copiar código proprietário**.

---

## 🤖 Instalar: só diga "aprenda essa skill"

Abra o Claude Code, o Codex (ou Cursor, Gemini CLI...) e cole:

```
aprenda essa skill: https://github.com/odavid062/reverso-skill
```

A IA lê o [AGENTS.md](AGENTS.md), instala a skill nas pastas certas e já passa a usá-la na mesma sessão.
Depois de reiniciar o agente, o comando `/reverso` fica disponível em qualquer projeto.

<details>
<summary>Instalação manual (se preferir)</summary>

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/odavid062/reverso-skill/main/install.ps1 | iex
```

Linux / macOS / Git Bash:

```bash
curl -fsSL https://raw.githubusercontent.com/odavid062/reverso-skill/main/install.sh | bash
```

Ou clone e rode `install.sh` / `install.ps1`. Use `--project` (bash) ou `-Project` (PowerShell) para instalar só no projeto atual.

Destinos: `~/.claude/skills/reverso` (Claude Code), `~/.codex/skills/reverso` (Codex), `~/.agents/skills/reverso` (padrão Agent Skills).
Uma versão anterior vira backup `reverso.bak.<data>`.
</details>

---

## Como usar

No Claude Code use `/reverso ...`; no Codex e em agentes sem slash command, escreva só `reverso ...`.

| Você quer... | Diga |
|---|---|
| Documentar o sistema legado aberto agora (gera specs) | `reverso` |
| Entender um app/binário sem código-fonte | `reverso artefato C:\caminho\app.exe` |
| Trazer uma feature de outro app para o seu projeto | `reverso clonar "exportar PDF" de <app>` |
| Rodar tudo sem pausas (uma entrevista e pronto) | `reverso autonomo` |
| Amadurecer uma ideia antes de codar | `reverso ideia "app de controle de estoque"` |
| Implementar uma feature nova a partir das specs | `reverso forward` |
| Reescrever o legado em outra stack | `reverso migrar` |
| Corrigir bug com rastreabilidade | `reverso debug` |
| Refatorar sem mudar comportamento | `reverso refatorar` |
| Gerar spec executiva única (`soul.md`: propósito, decisões) | `reverso alma` |
| Ver o progresso / retomar | `reverso status` · `reverso` |

O Reverso **pausa entre etapas** e espera você digitar `CONTINUAR`. O progresso fica salvo em `.reverso/state.json`:
se a sessão cair, digite `reverso` de novo e ele continua de onde parou.

### O que ele gera

```
.reverso/            estado, plano, contexto, evidências
_reverso_sdd/
├── inventory.md         stack, entradas, dependências
├── code-analysis.md     (fonte) · evidence-ledger.md (artefato)
├── domain.md            glossário + regras de negócio
├── architecture.md      C4, integrações, dívida técnica
├── <unit>/requirements.md · design.md · tasks.md
├── questions.md         lacunas para você responder
└── confidence-report.md
```

Toda afirmação vem com um selo:
🟢 **CONFIRMADO** (com `arquivo:linha` ou ID de evidência) · 🟡 **INFERIDO** (com justificativa) · 🔴 **LACUNA** (precisa de você).

---

## Garantias

- **Não destrutivo:** durante a análise só escreve em `.reverso/` e `_reverso_sdd/`. Código só é editado no ciclo forward,
  e só nos caminhos que você liberar em `.reverso/config.json`.
- **Nada externo sem permissão:** push, publicar, instalar ou apagar exigem seu "sim".
- **Uso responsável:** só para software próprio ou autorizado, interoperabilidade, segurança defensiva, estudo e preservação.
  A skill recusa contornar DRM, licença, anti-cheat ou autenticação, e não copia código ou ativos proprietários.
- **Faça commit antes de começar.** Agentes erram; com git você volta com `git restore .`.

## Turbinar o modo ARTEFATO (opcional)

O modo ARTEFATO funciona com ferramentas comuns (`strings`, `jadx`, `@electron/asar`, `ilspycmd`, Ghidra...).
Para análises profundas de binários, instale o MCP do REA (a própria skill guia o passo a passo e pede aprovação):

```bash
npx rea-agents setup
```

## Estrutura do repositório

```
.
├── AGENTS.md                    instruções para agentes instalarem a skill
├── CREDITS.md                   créditos e atribuições (Reversa e REA)
├── LICENSE                      licença MIT
├── README.md                    documentação principal
├── install.sh                   script de instalação para Linux/macOS
├── install.ps1                  script de instalação para Windows PowerShell
└── skills/reverso/
    ├── SKILL.md                 roteador: regras, modos, comandos
    ├── references/
    │   ├── 01-triagem.md        qual modo usar
    │   ├── 02-modo-fonte.md     Scout → Archaeologist → Detective → Architect → Writer → Reviewer
    │   ├── 03-modo-artefato.md  roteamento por tipo de alvo (REA + fallback)
    │   ├── 04-evidencias.md     escala de confiança e ledger
    │   ├── 05-clonar-feature.md observar → especificar → implementar
    │   ├── 06-forward.md        ideação, evolução, emendas, sync
    │   ├── 07-migracao.md       paradigma, curadoria, estratégia, paridade
    │   ├── 08-debug-e-qualidade.md bugs rastreáveis e refatoração por ROI
    │   └── 09-estado-e-checkpoints.md
    └── templates/               requirements, design, tasks, evidence-ledger, questions, confidence-report, state.json, plan
```

## Créditos

Baseado em [sandeco/reversa](https://github.com/sandeco/reversa) (MIT, © 2026 Sandeco), com o paper
[Reversa (arXiv 2605.18684)](https://arxiv.org/abs/2605.18684), e em [morluto/rea](https://github.com/morluto/rea) (MIT, © 2026 morluto).
Esta skill é uma síntese independente, não oficial, dos métodos dos dois projetos. Veja [CREDITS.md](CREDITS.md).

Licença: [MIT](LICENSE).
