# 02 · Modo FONTE: pipeline Discovery (código legado → specs)

Herdado do Reversa. Cinco fases, um agente por vez, com checkpoint entre elas:

```
Reconhecimento  Escavação       Interpretação          Geração   Revisão
   Scout     →  Archaeologist → Detective + Architect → Writer → Reviewer
```

Agentes independentes, rodáveis a qualquer momento: **Data Master** (banco), **Design System** (tokens de UI),
**Visor** (UI por screenshots), **Alma** (`soul.md`).

Saída em `_reverso_sdd/`; dados estruturados para os próximos agentes em `.reverso/context/`.
Respeite `doc_level` (essencial | completo | detalhado) em todos.

---

## 1. Scout: mapear a superfície

1. **Árvore de pastas**, excluindo `node_modules`, `.git`, `.reverso`, `_reverso_sdd`, `dist`, `build`, `target`, `coverage`, `__pycache__`, `.venv`.
2. **Tecnologias:** contagem de arquivos por extensão; frameworks e versões críticas via manifestos
   (`package.json`, `pom.xml`, `build.gradle`, `requirements.txt`/`pyproject.toml`, `go.mod`, `Cargo.toml`, `composer.json`, `Gemfile`, `*.csproj`).
3. **Entradas:** `main`/`index`/`app`/`server`/`Application.java`, rotas, configs (`.env.example`, `application.yml`),
   CI (`.github/workflows`), `Dockerfile`/`docker-compose.yml`, scripts de build/test/deploy.
4. **Banco (superficial):** só liste DDL, migrations, models de ORM.
5. **Testes:** frameworks e contagem de `*.test.*`/`*.spec.*`/`*Test.java`.
6. **Sugestão de organização das specs** (pare no primeiro sinal dominante):

| Sinal | Onde | Organização |
|-------|------|-------------|
| Roteamento centralizado | `routes.*`, `urls.py`, `@RestController`, `app.get(...)` | `endpoint` |
| Pastas top-level com nomes de domínio | `src/<dominio>/`, `internal/<dominio>/` | `module` |
| Specs Gherkin/E2E | `features/*.feature`, `cypress/e2e` | `use-case` |
| Vários sinais com peso parecido | | `hybrid` |
| Nenhum sinal claro | | `feature` (liste as features que achou) |

**Saída:** `_reverso_sdd/inventory.md`, `_reverso_sdd/dependencies.md`, `.reverso/context/surface.json`
(`modules[]`, `languages`, `entrypoints`, `integrations`, `database`, `organization_suggestion {granularity, rationale, signals[], features[]}`).

**Depois do Scout (checkpoint bloqueante):**
- Reescreva a Fase 2 do `plan.md` com **uma tarefa por módulo** (`- [ ] Archaeologist: módulo auth`).
- Mostre o resumo (N módulos, linguagem, integrações, banco) e pergunte o **nível de documentação**.
- Pergunte a **organização das specs**: 1 módulo · 2 caso de uso · 3 endpoint · 4 híbrida · 5 features · 6 customizada.
  Mostre a sugestão do Scout como padrão. Salve em `state.json → specs.granularity`.

---

## 2. Archaeologist: análise profunda, módulo a módulo

Para **cada módulo** do plano, um por vez:

1. **Fluxo de controle:** funções principais (nome, parâmetros, retorno), condicionais não triviais, loops com regra de negócio, tratamento de erro.
2. **Algoritmos:** cálculos, fórmulas, transformações, validações.
3. **Estruturas de dados:** entidades, DTOs, interfaces; dicionário de dados (campo, tipo, obrigatório, default).
4. **Metadados:** constantes, enums com nomes de domínio, feature flags, parâmetros por ambiente.
5. Checkpoint do módulo em `state.json → checkpoints.archaeologist.modules_analyzed`.
6. Depois de 3 módulos na mesma sessão, ofereça a pausa preventiva.

| Artefato | essencial | completo | detalhado |
|----------|-----------|----------|-----------|
| `code-analysis.md` | sim (com tabela de dados resumida) | sim | sim |
| `data-dictionary.md` | não | sim | sim |
| `flowcharts/<modulo>.md` (Mermaid) | não (fluxo em texto) | sim | sim + por função |
| `.reverso/context/modules.json` | sim | sim | sim |

Cada afirmação cita `arquivo:linha`.

---

## 3. Detective: o "porquê" (conhecimento implícito)

1. **Arqueologia git:** `git log --oneline --stat`, mensagens com decisões, fix/hotfix (indicam comportamento esperado),
   grandes refatorações (mudança de requisito), reverts. São a fonte dos ADRs retroativos.
2. **Regras de negócio implícitas:** condicionais de domínio, validações nos modelos, enums de negócio,
   comentários antigos, TODO/FIXME (intenções não implementadas).
3. **Máquinas de estado:** para cada campo `status`/`state`: valores, transições, gatilhos, diagrama Mermaid `stateDiagram-v2`.
4. **Permissões (RBAC/ACL):** papéis, matriz papel × funcionalidade, restrições de dados.
5. **Logs**, se houver: eventos de negócio monitorados e erros recorrentes.

**Saída:** `domain.md` (sempre: glossário + regras); `state-machines.md`, `permissions.md`, `adrs/NNN-titulo.md` (completo/detalhado;
no essencial, só se forem centrais). Seja rigoroso: a maior parte aqui será 🟡.

---

## 4. Architect: síntese

1. **C4 Contexto** (sistema, pessoas, sistemas externos) em Mermaid.
2. **C4 Containers** (apps, serviços, bancos, filas, caches + tecnologia + comunicação).
3. **C4 Componentes** dos containers relevantes.
4. **ERD** com cardinalidades, PK e FK.
5. **Integrações externas:** APIs consumidas/expostas, webhooks, filas, formatos.
6. **Dívida técnica:** duplicação, padrões inconsistentes, dependências críticas desatualizadas, módulos críticos sem teste.
7. **Spec impact matrix:** componente × componente impactado.

**Saída:** `architecture.md` + `c4-context.md` (sempre); `c4-containers.md`, `c4-components.md`, `erd-complete.md`,
`traceability/spec-impact-matrix.md` (completo+); `deployment.md` (detalhado, se houver infra declarada).

---

## 5. Writer: specs como contratos operacionais

1. Resolva a lista de **units** pela `granularity` (módulo, endpoint, caso de uso, híbrida, feature, custom).
2. Para cada unit: `requirements.md`, `design.md`, `tasks.md` (modelos em `templates/`). Opcionais:
   `contracts.md` (contrato externo, completo+), `flows.md` (2+ fluxos), `edge-cases.md` (detalhado), `decisions.md`, `questions.md` (se houver 🔴).
3. Globais (completo+): `openapi/<api>.yaml`, `user-stories/<fluxo>.md`, `traceability/code-spec-matrix.md` (por último).
4. **Mostre o plano de geração** (lista numerada de arquivos) e espere `CONTINUAR`.
5. **Gere um arquivo por vez**: anuncie `Gerando [N/total]: caminho`, gere, salve `state.json → writer_progress`, peça `CONTINUAR`.
   Nunca gere tudo de uma vez. Se a pasta da unit já existir, só acrescente o que falta.

Como preencher:
- **RNF:** só com evidência (timeout → performance; middleware de auth → segurança; cache/fila → escalabilidade; retry/circuit breaker → disponibilidade). Sem evidência, omita.
- **Critérios de aceite:** Gherkin `Dado/Quando/Então`, pelo menos um cenário feliz e um de falha por fluxo principal.
- **MoSCoW:** Must = caminho crítico/chamado por vários; Should = tem alternativa; Could = borda/raro; Won't = código comentado, flag desligada, deprecado.
- **Tasks:** cada tarefa cita o arquivo do legado de origem, tem critério de pronto e confiança.

---

## 6. Reviewer: revisão e lacunas

1. **Por unit:** os 3 canônicos existem? São consistentes entre si? Há comportamento óbvio não especificado?
   **Volte ao código** para checar cada 🟡 e reclassifique (🟡→🟢 se confirmado, 🟡→🔴 se contradito).
2. **Entre units:** contradições, dependências declaradas × reais, units faltando (compare com `surface.json`).
3. **Matrizes:** arquivos do legado sem spec (`n/a`) = candidatos a análise extra.
4. **Revisão cruzada (detalhado, ou se pedida):** se houver outro agente disponível (Codex, outro modelo, subagente), delegue uma revisão
   independente buscando: inconsistências internas, contradições entre units, lacunas críticas e 🟢 que parecem inferência.
   Incorpore com a marca `[Revisão cruzada]`.
5. **Perguntas ao humano:** junte cada 🔴 que só o usuário resolve em `questions.md` (modelo em `templates/`).
   Pergunte no chat em blocos temáticos, ou peça para preencher o arquivo e avisar com `reverso`.
6. Gere `confidence-report.md` (modelo em `templates/`).

---

## Agentes independentes

- **Data Master:** DDL, migrations, ORM, ERD completo, índices, triggers, procedures, seeds → `database.md`.
- **Design System:** cores, tipografia, espaçamento, temas, componentes → `design-system.md` (tokens em tabela/JSON).
- **Visor:** documenta telas a partir de screenshots (campos, ações, validações visíveis, navegação) → `ui/<tela>.md`. Não precisa do sistema rodando.
- **Alma (`soul.md`):** logo depois do Scout, uma página só: propósito, para quem, entidades centrais, 3 a 7 decisões fundadoras, o que **nunca** pode quebrar.
- **Reconstructor:** a partir das specs, gera um plano de reconstrução de baixo para cima e implementa uma tarefa por vez.

## Re-extração e regressão

Se já existe `_reverso_sdd/` e há features entregues pelo FORWARD sem adendo em `_reverso_sdd/addenda/`, ofereça
primeiro o **sync** (rápido) em vez de re-extrair tudo. Numa re-extração completa, compare cada item de
`_reverso_forward/<feature>/regression-watch.md` com os artefatos novos e dê o veredito 🟢/🟡/🔴. Destaque os vermelhos.
