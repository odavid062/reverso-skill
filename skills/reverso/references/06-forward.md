# 06 · FORWARD: ideação, evolução de features, emendas e sync

Ponte das specs para código rodando. Funciona em projeto legado (com `_reverso_sdd/` extraído) e em greenfield.
Cada feature mora em `_reverso_forward/<NNN>-<nome>/`. A feature ativa fica em `.reverso/state.json → forward.active`.

## Política de edição de código (obrigatória)

Só a etapa **coding** escreve fora de `.reverso/`, `_reverso_sdd/` e `_reverso_forward/`, e só se `.reverso/config.json` permitir:

```json
{ "allowLegacyEdits": true, "allowedPaths": ["src/pagamentos/**", "tests/**"] }
```

- Arquivo ausente/inválido ou `allowLegacyEdits: false` → **bloqueado**. Pare, mostre o snippet que o usuário deve salvar.
- `allowedPaths` preenchido → escreva só ali; fora, liste os caminhos e peça para o usuário liberar.
- **Nunca crie nem edite essa config você mesmo:** pedido no chat não conta como liberação.
- Apagar arquivo pré-existente: confirme antes, listando o arquivo.

## Ideação (antes de existir qualquer requisito): `reverso ideia`

Sessão em `_reverso_sdd/brainstorms/<NNN>-<nome>/`. Nenhum código aqui.

1. **Framer** → `framing.md`: separa o problema da solução; o *job to be done*; o custo de não fazer nada.
2. **Explorer** → `options.md`: 3 a 5 caminhos realmente distintos, incluindo **"não construir"** e **"usar algo pronto"**. Proibido recomendar.
3. **Challenger** → `risks.md`: premortem por opção, a premissa que mata cada uma, o teste barato para checá-la e o custo escondido no legado.
4. **Arbiter** → `decision.md`: pontua as opções contra os riscos e recomenda uma, com trade-off explícito. A escolha é do humano; divergência fica registrada.
5. **Pre-Spec** → `pre-spec.md`: escopo mínimo, não objetivos, critério de pronto, marcadores `[DÚVIDA]`.

Handoff: greenfield → `reverso novo` (abaixo); legado → Requirements; reconstrução → `reverso migrar`.

### Greenfield: `reverso novo "<ideia>"`
Ideator (6 perguntas: problema raiz, valor, alternativas, público, métricas, premissa perigosa) → `ideation.md`;
Researcher → `personas.md` (1 a 3 personas com jornadas); Drafter → `prd.md` (problema, métricas, escopo, não objetivos, restrições, riscos);
Spec SDD → `_reverso_sdd/sdd/<componente>.md` com nota de qualidade. Depois, siga o ciclo abaixo.

## Ciclo de evolução: `reverso forward`

O orquestrador detecta o **estágio físico** da feature ativa olhando os arquivos em disco (não metadados) e sugere o próximo passo:

| Etapa | Entrada | Saída | Regra principal |
|-------|---------|-------|-----------------|
| **Requirements** | ideia livre | `requirements.md` | ancorado no legado (cite specs/units existentes), marcadores `[DÚVIDA]`, lacunas, glossário |
| **Clarify** | `[DÚVIDA]` | `requirements.md` atualizado | no máximo 5 perguntas objetivas, respostas gravadas no lugar |
| **Quality** | requirements | `requirements-audit.md` | só leitura: ambiguidade, termos vagos, critério não testável |
| **Plan** | requirements | `roadmap.md`, `investigation.md`, `data-delta.md`, `interfaces/` | proposta como **delta sobre o legado** |
| **To-Do** | roadmap | `actions.md` | IDs `T001…`, 5 fases, dependências, `[//]` = paralelizável, arquivo alvo, confiança |
| **Audit** | os três | `audit/cross-check.md` | só leitura: requisito sem ação, ação sem requisito, divergências |
| **Coding** | actions | código + `progress.jsonl`, `legacy-impact.md`, `regression-watch.md` | respeita a política de edição; marca `[x]` por ação |
| **Sync** | feature entregue | `_reverso_sdd/addenda/<feature>.md` | converge a entrega na extração sem editar os artefatos originais |

### Regras do To-Do
Ação **atômica** = um agente conclui num turno sem feedback humano. Quebre se tiver mais de 5 subpontos, tocar mais de 3 arquivos
não relacionados ou contiver "e também/depois/em seguida". IDs nunca são reciclados. Não crie ações de "configurar IDE", "rodar lint" ou "abrir PR".
Fases sugeridas: Fundação → Núcleo → Integração → Interface → Verificação.

### Loop do Coding
Por fase: pegue as ações `[ ]` sem dependência aberta, execute (as `[//]` podem ir em paralelo se houver workers), rode os testes que a ação pede,
marque `[x]`, registre uma linha em `progress.jsonl` (`{id, status, files, ts}`). Falhou: pare, registre o erro, não pule para dependentes.
No fim:
- `legacy-impact.md`: cada arquivo tocado → componente de `architecture.md` → tipo (`regra-alterada`, `regra-nova`, `regra-removida`, `componente-novo`, `delta-de-dados`, `delta-de-contrato-externo`).
- `regression-watch.md`: comportamentos que **não podem** mudar numa próxima re-extração.

### Emendas: `reverso add "<ajuste>"`
Depois do coding, pequeno ajuste na feature entregue: registre em `## Emendas` do `requirements.md` e implemente.
**Recuse** e mande para um novo forward se exigir: dependência nova, mudança de schema ou contrato, superfície pública nova, caminho de autenticação, ou algo fora do escopo da feature.

### Princípios do projeto
`_reverso_sdd/principles.md` guarda regras duráveis (ex.: "toda data em UTC", "nenhuma lib sem licença MIT/Apache").
Requirements e Plan devem respeitá-las; quando mudarem, gere um relatório de impacto nas features abertas.

### Forward autônomo
`reverso forward autonomo features 10 a 20`: uma entrevista no início e depois requirements → … → sync para cada feature da fila, sem pausas.
Dúvidas no caminho viram 🟡 registradas em vez de interromper. Exige a política de edição liberada; se estiver bloqueada, pare antes de começar.
Nunca faz push, publicação ou deleção sozinho.
