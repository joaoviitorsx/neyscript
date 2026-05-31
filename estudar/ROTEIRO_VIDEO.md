# Roteiro do Vídeo — NeyScript

> Objetivo: curto, direto, mostra o que foi feito e como funciona.
> Tempo estimado: 5 a 8 minutos.
> Ferramentas: tela compartilhada (terminal + editor de código).

---

## [0:00 – 0:30] Apresentação

Falar:
> "Olá professor. Vou apresentar o Trabalho 3 — Compilador Front-end.
> Criei a linguagem **NeyScript**, 100% tematizada no Neymar Jr.
> O front-end é composto por analisador léxico feito com JFlex,
> analisador sintático e semântico feito com CUP, e um driver de
> integração em Java."

---

## [0:30 – 2:00] Mostrar os arquivos do projeto

Abrir o terminal, mostrar a estrutura:
```bash
ls -la
```

Destacar em voz:
- `src/lexer.flex` → especificação do léxico
- `src/parser.cup` → especificação do sintático + semântico
- `src/Main.java` → integração
- `gen/` → Lexer.java, parser.java, sym.java gerados pelas ferramentas
- `input.txt` → código-fonte de entrada
- `README.md` e `RELATORIO.pdf` → documentação

---

## [2:00 – 3:30] Explicar o lexer.flex (abrir o arquivo)

Abrir `src/lexer.flex` no editor. Mostrar e comentar:

> "Aqui defino os padrões usando expressões regulares.
> Cada palavra-chave da NeyScript tem um token equivalente ao
> da linguagem convencional:"

Apontar no arquivo:
- `"neymar"` → `NEYMAR` (main)
- `"camisa10"` → `CAMISA10` (int)
- `"drible"` → `DRIBLE` (if)
- `"prorrogacao"` → `PRORROGACAO` (while)
- `"gol"` → `GOL` (return)
- `"assistencia"` → `ASSISTENCIA` (chamada de função)
- padrão `{Identifier}` → `ID`
- `{FloatLiteral}` e `{IntegerLiteral}` → `NUM_FLOAT`, `NUM_INT`
- `{StringLiteral}` → `LIT_TEXTO`
- comentários descartados

> "O JFlex leu esse arquivo e gerou automaticamente `gen/Lexer.java`."

---

## [3:30 – 5:00] Explicar o parser.cup (abrir o arquivo, mostrar trechos)

Abrir `src/parser.cup`. Mostrar e comentar:

> "Aqui defino a gramática da linguagem e as checagens semânticas.
> Por exemplo, uma partida (função) é declarada assim:"

Mostrar a regra:
```
decl_func ::= PARTIDA tipo ID ( params ) bloco
```

Mostrar a tabela de símbolos e destacar:
> "A tabela de símbolos guarda cada variável e função declarada
> com nome, tipo e lista de parâmetros. Isso permite checar
> declaração antes do uso, tipos incompatíveis e aridade de argumentos."

Mostrar `checarArgs`:
> "Quando o código chama uma partida com `assistencia`,
> verifico se a quantidade e o tipo dos argumentos batem."

---

## [5:00 – 6:30] Demonstrar rodando o input.txt

No terminal:
```bash
./run.sh
```

Mostrar a saída e comentar ao vivo:

**Etapa 1 (léxico):**
> "Aqui estão os 237 tokens gerados. Cada linha mostra
> a linha no código, a coluna, a classe do token e o lexema."

Apontar alguns:
- `PARTIDA`, `CAMISA10`, `ID(somarGols)`, `LIT_TEXTO("Neymar Jr")`

**Etapa 2 (sintático + semântico):**
> "Nenhum erro. O programa está gramaticalmente correto."

**Etapa 3 (tabela de símbolos):**
> "Aqui a tabela de símbolos. Vemos as 4 partidas declaradas
> com seus tipos de retorno e as assinaturas de parâmetros."

**Resultado:**
> "`GOOOOOL!!` — programa aceito sem erros léxicos, sintáticos ou semânticos."

---

## [6:30 – 7:30] Demonstrar detecção de erros (input_erros.txt)

```bash
./run.sh input_erros.txt
```

Mostrar os erros e comentar:
> "Aqui um programa com erros intencionais.
> O compilador detecta 11 erros semânticos sem parar na primeira ocorrência:"

Destacar os mais interessantes:
- Redeclaração de partida
- Tipo incompatível (`camisa10 = ousadia`)
- Aridade errada: `espera 1 argumento, recebeu 3`
- Tipo de argumento errado: `esperado camisa10, recebeu torcida`
- Variável não declarada

> "Esse é o painel CARTAO VERMELHO — listando todos os erros com linha exata."

---

## [7:30 – 8:00] Encerramento

> "Em resumo: implementei um front-end completo com JFlex e CUP,
> integrados pelo driver Main.java. A linguagem NeyScript cobre
> todos os requisitos — keywords, identificadores, constantes,
> operadores, delimitadores, comentários, estruturas de controle,
> funções, expressões e checagens semânticas com tabela de símbolos.
> Obrigado."

---

## Dicas antes de gravar

- **Terminal limpo** antes de começar (`clear`)
- **Fonte grande** no terminal e no editor (professor vê melhor)
- **Falar devagar** ao mostrar a saída — é muita informação na tela
- Não precisa ler o código linha por linha — aponta e explica o conceito
- Se travar, foca na saída do `./run.sh` — ela fala sozinha
- Resolução recomendada: 1080p, sem barra de notificações visível
