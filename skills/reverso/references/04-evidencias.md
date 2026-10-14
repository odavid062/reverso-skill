# 04 · Evidências e confiança (vale para todos os modos)

## Tipos de afirmação

| Tipo | Selo | Exemplo |
|------|------|---------|
| **Observação** | 🟢 | "`calcularFrete()` soma 10% quando `uf == 'AM'`" (`src/frete.ts:42`) |
| **Inferência** | 🟡 | "Provavelmente é a taxa da Zona Franca": nome da constante `TAXA_ZF`, sem comentário |
| **Desconhecido** | 🔴 | "Não sei se o desconto se aplica a frete grátis; o caminho depende do serviço externo X" |

## Regras

1. **Toda conclusão cita a fonte:** `arquivo:linha`, commit (`abc1234`), ID de evidência (`EV-007`) ou arquivo em `.reverso/evidence/`.
2. **Estático não é runtime.** Nunca escreva "o app faz X ao clicar" se só leu o código; escreva "o handler de clique chama X (estático)".
3. **Busca negativa é limitada:** "não encontrei uso de `Y` em `src/` (grep, 312 arquivos)" está correto; "Y não é usado" só se a cobertura for completa.
4. **Padrão parecido não é causa.** Correlação entre um trecho estático e um evento de runtime é hipótese 🟡 até haver mapeamento explícito.
5. **Truncou, avise.** Saída cortada, paginação incompleta e timeouts entram como limitação no ledger.
6. **Reclassifique ao revisar:** 🟡 confirmado → 🟢; 🟡 contradito → 🔴 + nota; 🔴 respondido pelo humano → 🟢 com `[Validado por <nome>, <data>]`.

## IDs de evidência

Formato `EV-NNN`, sequencial por projeto, registrados em `_reverso_sdd/evidence-ledger.md`:

```markdown
| ID | Fonte | Tipo | O que mostra | Limitações |
|----|-------|------|--------------|------------|
| EV-001 | app.asar sha256:9f2c… → main.js:120-188 | estático | IPC `sync:push` envia fila local | source map ausente para preload |
| EV-002 | captura.har registros 14-19 | runtime | POST /v2/sync com lote de 50 itens | só 1 sessão observada |
```

Com o REA, use o `evidence_id` devolvido pela ferramenta (cite os dois se quiser: `EV-003 = rea:ev_8c1…`).

## Relatório de confiança

No fim de cada pipeline, `confidence-report.md`: contagem e % de 🟢/🟡/🔴 por unit e no total, as 5 lacunas mais críticas
e a cobertura (arquivos/módulos do alvo mapeados a alguma unit). Mais de 40% de 🟡/🔴 numa unit Must merece outra passada.
