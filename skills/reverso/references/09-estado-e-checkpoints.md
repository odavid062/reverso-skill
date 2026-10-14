# 09 · Estado, checkpoints, retomada e modo autônomo

## `.reverso/state.json`

Modelo em `templates/state.json`. Campos principais:

```json
{
  "version": "1.0.0",
  "user_name": "",
  "chat_language": "pt-BR",
  "doc_language": "pt-BR",
  "mode": "fonte | artefato | clonar | forward | migrar | debug",
  "phase": null,
  "doc_level": "essencial",
  "output_folder": "_reverso_sdd",
  "triage": { "target": "", "goal": "", "runtime_allowed": false, "authorization": "" },
  "specs": { "granularity": "", "custom_folders": [] },
  "completed": [],
  "pending": [],
  "checkpoints": {},
  "writer_progress": { "total": 0, "done": [] },
  "evidence_counter": 0,
  "forward": { "active": null, "queue": [], "paused": [] },
  "autonomous": false,
  "updated_at": ""
}
```

## Checkpoint (ao fim de cada agente/etapa)

1. Acrescente o agente em `completed`, tire de `pending`, atualize `phase`.
2. Em `checkpoints.<agente>`, guarde: arquivos gerados, contagens (módulos, regras, 🔴) e a hora.
3. Marque ✅ no `plan.md`.
4. Atualize `updated_at`.
5. Grave o JSON inteiro (escrita atômica: grave em `state.json.tmp` e renomeie).

## Retomada (`reverso` numa sessão nova)

1. Leia `state.json` e `plan.md`.
2. Diga em 2 linhas onde parou: "Última etapa: Detective ✅. Próxima: Architect."
3. Se `writer_progress` estiver incompleto, retome no próximo arquivo do plano de geração.
4. Peça `CONTINUAR`. Não ofereça pausa logo depois de retomar.

## Estouro de contexto

Se o contexto estiver acabando: salve o checkpoint **na hora** e diga
"Vou pausar aqui. Tudo está salvo. Digite `reverso` numa nova sessão para continuar."

## Modo autônomo: `reverso autonomo`

Para rodar sem ninguém olhando (ex.: Claude Code com permissões liberadas, Codex em modo full-auto).

1. **Uma entrevista única no começo**, com todas as decisões: alvo, objetivo, nível de documentação, organização das specs,
   runtime permitido (padrão não), revisão cruzada (sim/não), modo de perguntas ao humano (padrão: arquivo `questions.md`).
2. Mostre o resumo e espere `INICIAR`.
3. Rode o pipeline inteiro sem pausas. Dúvidas viram 🟡/🔴 registradas, não perguntas.
4. Mesmo no autônomo: nada destrutivo, nada externo (push, publicar, instalar, apagar), escrita só em `.reverso/` e `_reverso_sdd/`.
5. No fim: relatório com o que foi gerado, `confidence-report.md` e a lista de `questions.md` para o humano.

## Ajuda: `reverso ajuda`

Explique os modos e agentes com analogias simples (Scout = topógrafo, Archaeologist = arqueólogo, Detective = detetive que lê o diário do projeto
no `git log`, Architect = quem desenha a planta, Writer = quem redige o contrato, Reviewer = auditor) e sugira por onde começar.
