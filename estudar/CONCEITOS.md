# Conceitos do Projeto — NeyScript Compiler Front-end

## 1. O que é um compilador?

Compilador transforma código-fonte (texto) em outra representação (bytecode, assembly, etc.).
O **front-end** é a parte que lê e entende o código. Tem 3 fases em sequência:

```
código-fonte (texto)
        ↓
   [LÉXICO]     → tokens (palavras reconhecidas)
        ↓
   [SINTÁTICO]  → árvore/estrutura (gramática)
        ↓
   [SEMÂNTICO]  → verificação de sentido (tipos, declarações)
        ↓
   representação intermediária (IR) — não implementamos esta parte
```

---

## 2. Analisador Léxico (Scanner)

### O que faz?
Lê o código caractere por caractere e agrupa em **tokens** (unidades mínimas com significado).

### Exemplo
Código: `camisa10 gols = 118;`

Tokens gerados:
| Token | Classe |
|---|---|
| `camisa10` | CAMISA10 (tipo int) |
| `gols` | ID (identificador) |
| `=` | ASSIGN |
| `118` | NUM_INT |
| `;` | SEMI |

### O que descarta?
Espaços, tabulações, quebras de linha, comentários — nada disso vira token.

### Como implementamos? — JFlex
JFlex lê o arquivo `lexer.flex` e **gera automaticamente** `Lexer.java`.

O `.flex` define padrões usando **expressões regulares**:
```
"camisa10"   → token CAMISA10
[a-zA-Z_]+   → token ID
[0-9]+       → token NUM_INT
"//" .*      → descarta (comentário)
```

A ordem importa: palavras-chave vêm ANTES do padrão de ID, senão `camisa10` seria lido como identificador comum.

### Classe gerada: Lexer.java
Método principal: `next_token()` — retorna o próximo token toda vez que é chamado.

---

## 3. Analisador Sintático (Parser)

### O que faz?
Recebe tokens do lexer e verifica se estão na ordem correta segundo a **gramática** da linguagem.

### Exemplo
```
partida camisa10 soma(camisa10 a, camisa10 b) { gol a + b; }
```
O parser verifica:
- `partida` → espera um tipo → espera um ID → espera `(` → parâmetros → `)` → bloco `{...}` ✅

Se a ordem for diferente, é erro sintático.

### Gramática formal (BNF simplificada)
```
decl_func   ::= partida tipo ID ( params ) bloco
bloco       ::= { lista_stmt }
stmt        ::= tipo ID = expr ;
             |  drible ( expr ) bloco
             |  prorrogacao ( expr ) bloco
             |  gol expr ;
             |  assistencia ID ( args ) ;
expr        ::= expr + expr | expr * expr | ID | NUM_INT | NUM_FLOAT | LIT_TEXTO
```

### Como implementamos? — CUP (LALR)
CUP usa o algoritmo **LALR(1)** — lê tokens e decide qual regra gramatical aplicar usando uma tabela de estados. Gera:
- `parser.java` — o analisador sintático
- `sym.java` — constantes numéricas para cada token

**0 conflitos** = gramática sem ambiguidade.

---

## 4. Analisador Semântico

### O que faz?
Verifica o **sentido** do código. Sintaxe correta não garante semântica correta.

Exemplo sintaticamente correto mas semanticamente errado:
```
camisa10 x = "texto";   // tipo errado
y = 10;                 // y não declarada
```

### O que verificamos no NeyScript
| Checagem | Exemplo de erro |
|---|---|
| Declaração antes do uso | `y = 5;` sem declarar `y` |
| Redeclaração no mesmo escopo | `camisa10 x = 1; camisa10 x = 2;` |
| Compatibilidade de tipos | `camisa10 x = 3.14;` |
| Aridade de argumentos | `soma(1, 2, 3)` quando soma espera 2 args |
| Tipo dos argumentos | `soma("texto", 1)` quando soma espera camisa10 |
| Retorno compatível | `partida camisa10 f() { gol "oi"; }` |
| semGol em expressão | `camisa10 x = assistencia nada();` |
| Variável do tipo semGol | `semGol x;` |

### Tabela de Símbolos
Estrutura central da semântica. Guarda tudo que foi declarado:

```
NOME          TIPO       CATEGORIA   LINHA   PARAMS
somarGols     camisa10   partida     14      [camisa10, camisa10]
mediaGols     ousadia    partida     20      [camisa10, camisa10]
anunciar      semGol     partida     31      [torcida]
neymar        camisa10   partida     38      []
```

Usa **pilha de escopos** — quando entra num bloco `{` abre escopo, quando sai `}` fecha. Variável declarada dentro de função não existe fora.

---

## 5. Integração — Main.java

`Main.java` conecta as 3 etapas:

```
arquivo .txt
     ↓
   Lexer (JFlex)    →   imprime tabela de tokens (Etapa 1)
     ↓
   parser (CUP)     →   constrói gramática + checa semântica (Etapa 2)
     ↓
   Relatório        →   GOOOOOL!! ou CARTAO VERMELHO (Etapa 3)
```

O Lexer é passado como parâmetro para o parser — é assim que os tokens viram input do parser.

---

## 6. Ferramentas usadas

| Ferramenta | Papel | Arquivo de entrada | Arquivo gerado |
|---|---|---|---|
| **JFlex 1.9.1** | gerador de lexer | `lexer.flex` | `Lexer.java` |
| **CUP 11b** | gerador de parser LALR | `parser.cup` | `parser.java`, `sym.java` |
| **javac** | compilador Java | todos os `.java` | `.class` |

### Por que JFlex e CUP?
- JFlex: padrão acadêmico para léxico em Java, baseado em expressões regulares
- CUP: equivalente Java do YACC/Bison, gera parsers LALR(1) sem ambiguidade

---

## 7. Os tokens do NeyScript

| Token | Lexema | Equivalente | Por quê esse nome |
|---|---|---|---|
| `NEYMAR` | `neymar` | main | personagem central |
| `CAMISA10` | `camisa10` | int | número do craque |
| `OUSADIA` | `ousadia` | float | precisão, habilidade |
| `TORCIDA` | `torcida` | string | torcida "grita" frases |
| `SEM_GOL` | `semGol` | void | sem resultado produzido |
| `PARTIDA` | `partida` | function | função = uma partida |
| `DRIBLE` | `drible` | if | condição: passa ou não |
| `CARRINHO` | `carrinho` | else | caminho alternativo |
| `PRORROGACAO` | `prorrogacao` | while | jogo continua |
| `GOL` | `gol` | return | resultado devolvido |
| `ASSISTENCIA` | `assistencia` | chamada de função | passe que aciona a jogada |
| `NARRA` | `narra` | print | narrador anuncia |
| `ID` | qualquer nome | identificador | nomes do programador |
| `NUM_INT` | `10`, `118` | inteiro | literal inteiro |
| `NUM_FLOAT` | `9.5`, `0.97` | float | literal decimal |
| `LIT_TEXTO` | `"Neymar Jr"` | string literal | texto entre aspas |

---

## 8. Fluxo completo com exemplo

Código (`input.txt`):
```
partida camisa10 somarGols(camisa10 a, camisa10 b) {
    camisa10 total = a + b;
    gol total;
}
neymar() {
    camisa10 resultado = assistencia somarGols(118, 136);
    narra(resultado);
}
```

**Léxico:** reconhece 30+ tokens — `PARTIDA`, `CAMISA10`, `ID(somarGols)`, `LPAREN`, `CAMISA10`, `ID(a)`, ...

**Sintático:** valida estrutura — `partida tipo ID ( params ) bloco` ✅

**Semântico:**
- `somarGols` entra na tabela como partida `camisa10` com params `[camisa10, camisa10]`
- `assistencia somarGols(118, 136)` — verifica: existe ✅, aridade 2==2 ✅, tipos camisa10==camisa10 ✅
- `resultado` recebe tipo `camisa10` (mesmo retorno de somarGols) ✅

**Saída:** `GOOOOOL!! programa aceito sem erros lex/sint/sem.`
