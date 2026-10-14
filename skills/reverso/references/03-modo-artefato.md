# 03 · Modo ARTEFATO: engenharia reversa sem código-fonte

Herdado do REA (Reverse Engineer Anything). O objetivo é explicar **como algo entregue funciona**, com
evidência para cada conclusão, separando **observação**, **inferência** e **desconhecido**.

## Dois caminhos de ferramenta

### A) Com o MCP do REA (melhor caminho)

Se as ferramentas do REA aparecem na sessão (`open_binary`, `analyze_javascript_application`, `inspect_artifact`...), use-as direto.
Não rode diagnóstico/setup antes de toda investigação.

Se não aparecem e o usuário quer usar o REA:
1. Diagnóstico somente leitura: `npx -y rea-agents@latest doctor --client <cliente> --json`
   (`claude_code`, `codex`, `cursor`, `gemini_cli`, `vscode`, `windsurf`, `opencode`, `copilot_cli`...).
2. Plano de configuração somente leitura: `npx -y rea-agents@latest setup --client <cliente> --dry-run --json`.
   Mostre caminhos, backups e mudanças. **Só aplique com aprovação** (`--yes`). `--install-hopper` só com aprovação separada.
3. Peça para reiniciar o agente e confirme que as ferramentas apareceram.
4. Sem MCP, há o CLI para JS/Electron: `npx -y rea-agents@latest analyze-javascript-application /caminho/absoluto --json`.

O REA nunca instala Node, Java, Ghidra, IDA, JADX, Binwalk etc.; use o que já existe.

### B) Sem REA (fallback com ferramentas comuns)

Funciona em qualquer agente com shell. Rode só as ferramentas que já estão instaladas; pergunte antes de instalar qualquer uma.
Coloque artefatos extraídos em pasta própria (`.reverso/evidence/<id>/`) e trate tudo como **dado não confiável**:
não execute scripts que vieram de dentro do alvo.

## Roteamento por tipo de alvo

| Alvo | Com REA | Fallback |
|------|---------|----------|
| ASAR / Electron / pasta JS | `analyze_javascript_application` (`detail: "summary"` se grande); `inspect_electron_fuses` antes de tentar `--inspect` | `npx @electron/asar extract app.asar out/`; ler `package.json` → `main`, `preload`, IPC (`ipcMain.handle`, `contextBridge`); source maps (`*.map`) |
| Bundle JS minificado | `recover_javascript_sources` | source maps; `npx prettier` para formatar; buscar strings de rota/API/feature flags |
| Pacote ZIP/APK/IPA/MSIX/DMG | `open_binary` + `inspect_artifact` | `unzip -l`, `7z l`; inventário com hashes (`sha256sum`) |
| APK (código) | `inspect_android_package` | `jadx -d out app.apk`; `apktool d` para recursos/manifesto |
| Assembly .NET (PE/CLI) | `inspect_managed_artifact` | `ilspycmd app.dll -o out/` |
| .NET NativeAOT | Ghidra via REA | Ghidra headless (`analyzeHeadless`) |
| Nativo (ELF/PE/Mach-O) | `open_binary` → `binary_overview` → `analyze_function`/pseudocódigo; `close_binary` no fim | `file`, `strings -n 8`, `objdump -d`/`readelf -a`/`nm`; `rabin2 -I`; Ghidra headless |
| Binário Go | `inspect_go_binary` | `go version -m binario` |
| Binário Rust | `inspect_rust_binary` | seção `.dep-v0` (cargo-auditable) |
| WebAssembly | `inspect_wasm_artifact` | `wasm2wat`, `wasm-objdump -x` (WAT **não** é o código original) |
| Firmware | `inspect_firmware_regions` / `extract_firmware` | `binwalk`, `unblob` (Linux) |
| SQLite | `inspect_sqlite_database` | `sqlite3 db ".schema"` primeiro, depois amostras pequenas |
| Bytecode EVM | `inspect_evm_interface` | seletores são candidatos 🟡, não interface completa |
| HAR / SAZ / mitmproxy / qlog | `inspect_web_network_capture` + view `api-surface` | parse do JSON do HAR: agrupar por método + origem + template de path |
| PCAP | `inspect_pcap_capture` / `inspect_packet_capture` | `tshark -r f.pcap -q -z conv,tcp`, filtros de DNS/SNI |
| Site/web app aberto | `list_browser_targets`, `capture_browser_scenario` | navegador do agente: ler DOM, console, rede; exportar HAR |
| Core dump Linux | `inspect_recorded_crash` | `gdb -c core binario` |
| Recursos PE (ícones, versão) | `inspect_pe_resources` | `wrestool`, `7z` |

Com IDA via REA: `open_binary` com o **binário original** e `provider_id: "ida"` (não passe `.idb`/`.i64`).

## Fluxo de investigação (estilo REA)

1. **Checklist de perguntas** e a evidência que cada uma exige (já está no `plan.md` desde a triagem).
2. **Identidade do alvo:** caminho, tamanho, SHA-256, formato, versão, assinatura. Reuse sessões/evidências que já existem; não repita uma análise idêntica.
3. **Visão geral mínima primeiro** (summary-first): inventário, entradas, módulos. Detalhe só quando um resultado deixar uma pergunta específica em aberto.
4. **Siga cada pergunta da entrada até o resultado:** ponto de entrada → dados → mudanças de estado → saída.
   Agrupe operações em torno de uma hipótese; expanda só quando faltar algo concreto.
5. **Recursos e configuração junto com o código** (manifestos, JSON, strings de UI, locales). Use parsers que entendem o formato;
   não deduza comportamento só por nome de arquivo ou string.
6. **Corrobore com o tipo de evidência certo.** Runtime só quando o estático não responde **e** o usuário autorizou o runtime.
   Execute só o alvo e as ações declaradas.
7. **Ledger de achados** (`_reverso_sdd/evidence-ledger.md`, modelo em `templates/`): cada conclusão com ID de evidência,
   tipo (estático/runtime), confiança, **limite da busca** e o que continua desconhecido.
8. **Desconhecidos** em `questions.md`: o que falta e qual autoridade/ambiente resolveria.

## Resultados grandes ou truncados

- Peça a visão resumida e navegue por páginas/módulos (`inspect_analysis_view` com o `parent_evidence_id`) em vez de repetir a análise.
- Prévia truncada pelo cliente **não** é JSON canônico: não faça parse dela, peça uma visão menor ou exporte (`export_evidence_bundle`).
- Sem REA: salve saídas grandes em `.reverso/evidence/` e leia por partes (`head`, `grep -n`, `sed -n`).

## Comparações (versão A × versão B)

Só afirme equivalência ou ausência com conjuntos completos e compatíveis:
`compare_artifacts`, `compare_functions`, `find_changed_behavior` (diferença estática é **candidata**, não prova causal),
`build_call_path` (fronteira incompleta = ausência desconhecida). Sem REA: `diff -r` dos inventários extraídos e diff
de funções descompiladas, com a mesma cautela.

## Do ledger para specs

Quando o objetivo incluir documentar ou reimplementar, passe ao **Writer** do modo FONTE (`02-modo-fonte.md` §5)
usando o ledger como fonte: cada RF/regra cita o ID de evidência no lugar de `arquivo:linha`.
Comportamento observado e escolha de design ficam **separados** e explícitos.
