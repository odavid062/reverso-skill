# 08 · DEBUG com rastreabilidade e QUALIDADE de código

## Debug: `reverso debug`

Registro em `_reverso_bugs/<contexto>/` (`intake/`, `bugs/BUG-NNN/bug.md`).

### Rota expressa (avalie primeiro)
Se o usuário **pediu conserto** ("corrige", "resolve"), é **um** defeito localizado, sem suspeita de segurança e sem sinal de regressão de bug já fechado:
grave o relato em `intake/`, registre `BUG-NNN` (identidade, classificação e rastreabilidade completas, `express: true`) e vá direto ao conserto.

### Rota completa
1. **Contexto:** em que área/módulo/feature? (case com pastas existentes, depois com units de `_reverso_sdd/`). Se não estiver claro, pergunte com um menu.
2. **Intake:** anote cada problema com as palavras do usuário; salve prints/logs em `intake/`. Pergunte só o que falta (esperado × observado, passos, frequência).
   Severidade (`critical/high/medium/low`) e prioridade (`P0..P3`) numa única mensagem para todos.
3. **Registro:** dedupe (grep nos bugs existentes), depois `bug.md` com: sintoma, passos, esperado × observado, **unit/spec afetada**,
   regra violada (link para o `requirements.md`), confiança e evidências.
4. **Diagnóstico** (para bugs difíceis, debate): proponha 2 ou 3 hipóteses concorrentes, a evidência que confirmaria ou derrubaria cada uma, rode a
   verificação mais barata primeiro. Opcional: grafo causal sintoma → causa provável → componente.
5. **Conserto:** respeita a política de edição (`06-forward.md`). Escreva primeiro um **teste que reproduz** o bug, depois corrija, depois rode a suíte.
   Feche com `DONE.md` (causa raiz, mudança, teste que prova). Se a correção mudou uma regra, atualize a spec por **adendo**, não editando o original.

## Qualidade: `reverso refatorar`

Melhorar o código **sem mudar comportamento**. Nada é aplicado sem aprovação.

1. Leia `soul.md` e as specs da área: elas definem o comportamento que **não pode** mudar.
2. **Inventário de oportunidades** em `_reverso_refactor/<contexto>/opportunities/`, cada uma com um verbo:
   `simplify` (complexidade), `optimize` (performance), `standardize` (padrões inconsistentes), `prune` (código morto),
   `modularize`/`decouple`/`restructure` (fronteiras e acoplamento).
3. **Priorize por ROI** = impacto × custo × risco. Hotpath primeiro: alto acoplamento, alta frequência de execução ou alta taxa de mudança no `git log`.
   "200 linhas que rodam 10 milhões de vezes por dia antes de 2000 linhas que ninguém chama."
4. **Confiança condiciona a rede de segurança:** 🟢 coberto por testes; 🟡 parcial (escreva testes de caracterização antes); 🔴 sem prova de comportamento (não mexa antes de criar a prova).
5. Aplique uma transformação por vez, com testes antes e depois, e registre em `transformations/`.

**Prune** (código morto): só remova com evidência de não uso (grep completo + rotas + reflexão/injeção dinâmica + configs). Na dúvida, marque 🟡 e pergunte.
