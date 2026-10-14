# 01 · Triagem: qual modo usar

Decida o modo pelo **alvo que o usuário forneceu**, não pelo que seria mais interessante analisar.

## Árvore de decisão

```
O usuário tem o código-fonte legível do que quer entender?
├── Sim, e quer specs/documentação do sistema ─────────────► MODO FONTE (02-modo-fonte.md)
├── Sim, mas parte crítica é binária/minificada/terceiros ─► MODO FONTE + ARTEFATO só na parte opaca
└── Não, só tenho o produto entregue
    ├── Quero entender/explicar/comparar versões ─────────► MODO ARTEFATO (03-modo-artefato.md)
    └── Quero a mesma feature no MEU projeto ─────────────► MODO CLONAR FEATURE (05-clonar-feature.md)

Já existe _reverso_sdd/ com extração concluída?
├── Quero mudar/adicionar algo ───────► FORWARD (06-forward.md)
├── Quero reescrever em outra stack ──► MIGRAÇÃO (07-migracao.md)
├── Tem um bug ───────────────────────► DEBUG (08-debug-e-qualidade.md)
└── Entreguei feature e quero atualizar a extração ► SYNC (06-forward.md), não re-extraia tudo
```

**Regra do REA:** para um repositório de código-fonte completo, **não** use ferramentas de binário/MCP
de engenharia reversa; use leitura de arquivos, grep e git. Binário só entra quando a afirmação depende
de algo que o código disponível não estabelece.

## Sinais rápidos por tipo de alvo

| Você vê | Modo | Primeira ação |
|---------|------|---------------|
| `package.json`, `pom.xml`, `go.mod`, `requirements.txt`, `.git/` com código legível | FONTE | Scout |
| Workflow n8n exportado (`.json` com `nodes`/`connections`) | FONTE (tradutor) | ler nodes como se fossem módulos |
| `.exe`, `.dll`, `.so`, `.dylib`, ELF/Mach-O | ARTEFATO, nativo | identificar formato e linguagem |
| `.asar`, `app.asar`, pasta `resources/app` | ARTEFATO, Electron/JS | extrair e analisar o grafo JS |
| `.apk`, `.aab` | ARTEFATO, Android | manifesto + classes |
| `.ipa`, `.app`, `.dmg`, `.msix`, `.zip` | ARTEFATO, pacote | inventário de membros |
| Assembly .NET (PE com CLI header) | ARTEFATO, gerenciado | descompilar IL |
| `.wasm` | ARTEFATO, WASM | WAT + glue JS |
| `.bin`/`.img` de dispositivo | ARTEFATO, firmware | regiões/extração |
| `.har`, `.saz`, `.pcap`, `.pcapng`, qlog | ARTEFATO, captura | resumo de API/protocolos |
| `.sqlite`, `.db` | ARTEFATO, dados | schema primeiro |
| URL de site/web app | ARTEFATO, runtime web | observar com navegador, HAR, source maps |

## Perguntas mínimas (só o que não dá para deduzir)

Antes de perguntar, procure a resposta na conversa e no workspace. Pergunte no máximo:

1. **Qual é o alvo exato?** (caminho, nome do app instalado ou URL). Se houver vários candidatos, liste e peça escolha.
2. **Qual é o objetivo?** Entender, documentar (specs), clonar uma feature, migrar ou corrigir bug.
3. **Autorização** (só no modo ARTEFATO, com software de terceiros): confirme que o uso é legítimo
   (próprio, autorizado, interoperabilidade, segurança, estudo). Se o pedido for contornar proteção, recuse.
4. **Runtime permitido?** Posso executar o alvo, abrir o app, navegar, capturar tráfego? Padrão: **não**, só estático.

Salve as respostas em `.reverso/state.json → triage`.

## Plano inicial (`.reverso/plan.md`)

Monte a lista de **perguntas a responder** e a **evidência que cada uma exige**, depois a lista de agentes/etapas.
Exemplo (modo ARTEFATO):

```markdown
## Perguntas
- [ ] Q1. Como o app sincroniza dados offline? → evidência: código do módulo de storage + tráfego
- [ ] Q2. Qual formato de arquivo ele exporta? → evidência: função de export + amostra de saída

## Etapas
- [ ] Inventário (identidade, hashes, stack)
- [ ] Mapa de entradas
- [ ] Rastreio Q1
- [ ] Rastreio Q2
- [ ] Writer: specs das features observadas
- [ ] Reviewer
```
