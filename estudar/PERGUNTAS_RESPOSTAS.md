# Perguntas Frequentes — NeyScript

Perguntas que o professor pode fazer na apresentação.

---

**O que é um token?**
Menor unidade com significado no código. Como palavras numa frase. `camisa10` é um token (tipo), `gols` é um token (identificador), `=` é um token (operador).

---

**Por que JFlex e não escrever o lexer na mão?**
JFlex gera o lexer automaticamente a partir de expressões regulares. Escrever na mão seria propenso a erro e muito mais código. JFlex é uma ferramenta padrão da área — mesmo princípio do Lex/Flex em C.

---

**O que é LALR(1)?**
Algoritmo de parsing Bottom-Up. O `1` significa que olha 1 token à frente (lookahead) para decidir qual regra aplicar. CUP usa LALR(1) — eficiente, sem backtracking. "0 conflicts detected" significa que a gramática é não-ambígua.

---

**Qual a diferença entre erro sintático e semântico?**
- **Sintático:** estrutura errada. `drible { camisa10 }` — não segue a gramática.
- **Semântico:** estrutura correta mas sem sentido. `camisa10 x = "texto"` — sintaticamente ok, mas tipo errado.

---

**Por que `assistencia` antes de chamar função?**
Decisão de design da linguagem — espelha o futebol (precisa de uma assistência para marcar). Tecnicamente cria um token separado (`ASSISTENCIA`) que o parser espera antes de qualquer chamada, tornando chamadas explícitas e fáceis de identificar no lexer/parser.

---

**Como o lexer "passa" tokens para o parser?**
O `Main.java` cria um objeto `Lexer` e passa para o construtor do `parser`. O parser chama `next_token()` do Lexer toda vez que precisa do próximo token — é um fluxo pull (parser puxa conforme precisa).

---

**O que é a tabela de símbolos?**
Estrutura de dados (mapa de escopos aninhados) que guarda tudo que foi declarado: nome, tipo, se é função, parâmetros e linha. Usada para checar se variável existe, se tipo bate, se aridade está correta.

---

**O que é escopo aninhado?**
Pilha de mapas. Cada bloco `{ }` empilha um mapa novo. Ao fechar o bloco, o mapa é descartado. Variável declarada dentro de `partida` não existe fora — isso é escopo.

---

**Por que `camisa10 → ousadia` é permitido mas não o contrário?**
`camisa10` (int) cabe em `ousadia` (float) sem perda de informação — é promoção numérica. O contrário (float → int) perderia a parte decimal, então rejeitamos (igual ao Java).

---

**Por que a NeyScript não tem `string` mas tem `torcida`?**
Decisão temática — o trabalho propõe uma linguagem com vocabulário do Neymar. Tecnicamente `torcida` funciona igual a `String`: aceita literais entre aspas, concatena com `+`, pode ser parâmetro e variável.

---

**Como os erros aparecem com número de linha correto?**
JFlex rastreia linha/coluna automaticamente via `%line %column`. Cada `Symbol` carrega `left` (linha) e `right` (coluna). O parser lê esses valores nas ações semânticas e usa em `erroSemantico(msg, linha)`.

---

**Qual a saída quando o programa está correto?**
```
GOOOOOL!! programa aceito sem erros lex/sint/sem.
```
Tabela de símbolos global com todas as partidas e seus tipos de parâmetros.

---

**Qual a saída quando tem erro?**
```
CARTAO VERMELHO - N erro(s) encontrado(s):
   - ERRO SEMANTICO (linha X): mensagem
   - ERRO SINTATICO linha X col Y: mensagem
```
O compilador continua após erros semânticos (não aborta), permitindo reportar todos de uma vez.
