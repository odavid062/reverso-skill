# 05 · Modo CLONAR FEATURE: "vi no app X, quero no meu projeto"

É a combinação dos dois motores: o **REA** descobre como a feature funciona; o **Reversa** transforma isso
em spec e leva até o código. Você reimplementa **comportamento**, nunca copia código ou ativos proprietários.

## Pré-condições

- O usuário diz **qual app**, **qual feature** (descrita em uma frase, do ponto de vista de quem usa) e **qual projeto destino**.
- Uso legítimo: interoperabilidade, estudo, inspiração funcional. Se a "feature" for uma proteção (licença, DRM, anti-cheat, paywall, autenticação), recuse.
- Runtime só se autorizado (padrão: análise estática).

## Pipeline

```
1. Recorte       → 2. Observação (ARTEFATO) → 3. Spec da feature → 4. Encaixe no destino → 5. Forward (código)
```

### 1. Recorte
Escreva em `.reverso/plan.md` a feature como perguntas verificáveis:
- Qual é o gatilho (clique, atalho, evento, agendamento)?
- Que dados entram e de onde vêm?
- Que transformação/regra acontece?
- Que estado muda e onde persiste (memória, disco, servidor)?
- Que saída o usuário percebe? Quais erros e estados vazios?

### 2. Observação (modo ARTEFATO, `03-modo-artefato.md`)
- Ache o **ponto de entrada da feature**: strings de UI/locale com o rótulo do botão, comandos de menu, rotas, nomes de IPC, endpoints em HAR.
- Siga a entrada até o resultado (handler → serviço → persistência/rede → renderização).
- Registre tudo em `evidence-ledger.md` com IDs `EV-NNN`.
- Para web: o HAR/captura mostra o **contrato** (requests, payloads, respostas); o JS mostra a **regra**.

### 3. Spec da feature
Use o **Writer** (`02-modo-fonte.md` §5) para gerar `_reverso_sdd/features/<feature>/requirements.md`, `design.md` e `tasks.md`:
- Cada RF cita a evidência (`EV-NNN`) no lugar de `arquivo:linha`.
- Separe em duas seções do `design.md`: **Comportamento observado** (🟢/🟡 com evidência) e **Decisões de design para o destino** (escolhas suas, sem selo de observação).
- Liste o que é **propriedade do original** e não deve ser reproduzido (marca, textos, ícones, algoritmos patenteados/protegidos).

### 4. Encaixe no projeto destino
Se o projeto destino ainda não tem extração, rode só o **Scout** nele (rápido) para saber stack, módulos e convenções.
Mapeie cada componente da feature para onde ela vai morar no destino (`plan` do forward).

### 5. Implementar
Siga o ciclo FORWARD (`06-forward.md`) a partir de `requirements.md` já pronto: clarify → plan → to-do → audit → coding.
Ao final, valide o comportamento contra os critérios Gherkin da spec (testes) e marque o que foi provado.

## Entregável final

Um resumo curto: como a feature funciona no original (com evidências), o que foi implementado no destino,
as diferenças intencionais e as 🔴 lacunas que ficaram.
