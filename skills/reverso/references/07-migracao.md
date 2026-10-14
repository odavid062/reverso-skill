# 07 · MIGRAÇÃO: reconstruir o legado numa stack moderna

Pré-requisito: extração do modo FONTE concluída (`_reverso_sdd/` com domain, architecture e specs por unit).
Tudo vai para `_reverso_sdd/migration/`. Pausa para revisão humana entre agentes.

```
Brief → Paradigm Advisor → Curator → Strategist → Designer → Screen Translator → Inspector → Handoff
```

## 0. Brief (`migration_brief.md`)
Entrevista curta: stack alvo (se já houver preferência), motivação, prazo, orçamento, regulação, o que está fora do escopo, dores atuais (`pain_points`).

## 1. Paradigm Advisor (`paradigm_decision.md`)
Detecte o paradigma do legado (procedural, OO clássico, MVC monolítico, event-driven, funcional...) e infira o alvo.
Force uma **decisão consciente** do usuário: mudar de paradigma muda o significado de muitas regras. Registre o gap (baixo/médio/alto) e o apetite (conservador/transformacional).

## 2. Curator (`target_business_rules.md`, `discard_log.md`, `ambiguity_log.md`)
Regra por regra, decida **MIGRAR**, **DESCARTAR** ou **DECISÃO HUMANA**, nesta ordem:
1. 🔴 ou ambígua → DECISÃO HUMANA.
2. Incompatível com o brief (escopo excluído, regulação nova) → DESCARTAR com justificativa.
3. **Artefato do paradigma, não do negócio** (ex.: `SELECT … FOR UPDATE` manual vira idempotência por event ID; 2PC vira saga; `try/catch` global vira retry/DLQ) → DESCARTAR registrando o vínculo de paradigma (a intenção de negócio continua, muda o mecanismo).
4. Citada como dor → DECISÃO HUMANA com recomendação.
5. 🟡 → MIGRAR com aviso de validação.
6. 🟢 compatível → MIGRAR.

## 3. Strategist (`migration_strategy.md`, `risk_register.md`, `cutover_plan.md`)
Avalie Strangler Fig, Big Bang, Parallel Run e Branch by Abstraction contra tamanho do legado, apetite, gap de paradigma e restrições.
Heurísticas: gap alto + apetite transformacional → Parallel Run nas regras críticas; produção + conservador → Strangler Fig + Branch by Abstraction;
sistema pequeno + transformacional → Big Bang com rollback robusto. Recomende uma estratégia; o humano confirma.

## 4. Designer
`target_architecture.md`, `target_domain_model.md`, `target_data_model.md`, `data_migration_plan.md` (mapeamento campo a campo, transformação, validação, rollback)
e `topology_decision.md` (monólito modular × serviços, com justificativa).

## 5. Screen Translator (se houver UI)
Decida o modo por tela: **literal** (paridade visual, gera golden files quando dá para executar o legado), **modernizado** (contrato de tela:
hierarquia, eventos, textos, estados idle/loading/error/success) ou **híbrido**. Saída: `target_screens.md`, `screen_modernization_decision.md`.

## 6. Inspector (`parity_specs.md`, `parity_tests/*.feature`)
Como provar que o novo se comporta igual ao legado: characterization tests, contract tests, data parity (checksums), shadow mode,
métrica primária (ex.: divergência funcional < 0,01% em 30 dias), janela de observação e critério que **bloqueia** o cutover.
Um `.feature` Gherkin por fluxo crítico.

## 7. Handoff (`handoff.md`)
Checklist: decisões humanas pendentes = 0 (ou aceitas como risco), estratégia confirmada, arquitetura aprovada, paridade definida.
Próximo passo: `reverso forward` no projeto novo, feature por feature, usando `target_business_rules.md` como requisito.
