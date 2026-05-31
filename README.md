# NeyScript — Compilador Front-end (JFlex + CUP)

> Trabalho 3 — Aspectos de Compiladores
> Linguagem de programação 100% tematizada no **Neymar Jr.** 🇧🇷⚽
> Repositório: https://github.com/joaoviitorsx/neyscript

Front-end completo (Léxico + Sintático + Semântico) construído com
**JFlex 1.9.1** e **CUP 11b**. O compilador lê um programa-fonte em NeyScript,
gera o fluxo de tokens, valida a gramática e realiza checagens semânticas
(tabela de símbolos com escopos, declaração-antes-de-uso, compatibilidade
de tipos, conferência de retorno).

---

## 1. Estrutura do projeto

```
Compilador/
├── lib/                            # dependencias (jars)
│   ├── jflex-full-1.9.1.jar
│   ├── java-cup-11b.jar
│   └── java-cup-11b-runtime.jar
├── src/
│   ├── lexer.flex                  # especificacao JFlex
│   ├── parser.cup                  # especificacao CUP (sintatico + semantico)
│   └── Main.java                   # driver de integracao
├── gen/                            # gerados: Lexer.java, parser.java, sym.java
├── build/                          # .class compilados
├── input.txt                       # programa-exemplo valido
├── input_erros.txt                 # programa com erros (demo)
├── build.sh                        # gera + compila tudo
├── run.sh                          # executa o compilador
└── README.md
```

---

## 2. Tokens da linguagem NeyScript

| Token         | Lexema                      | Equivalente          | Justificativa temática                                                     |
|---------------|-----------------------------|----------------------|----------------------------------------------------------------------------|
| `NEYMAR`      | `neymar`                    | `main`               | Representa o personagem central do programa, como a função principal       |
| `CAMISA10`    | `camisa10`                  | `int`                | Tipo inteiro; associado ao número clássico de craques                      |
| `OUSADIA`     | `ousadia`                   | `float`              | Tipo real; representa valores de precisão, habilidade, nota ou estatística |
| `TORCIDA`     | `canto`                   | `string`             | Tipo texto; a “canto” canta frases (cadeias de caracteres)               |
| `SEM_GOL`     | `semGol`                    | `void`               | Função sem retorno, ou seja, sem “gol” produzido                           |
| `PARTIDA`     | `partida`                   | declaração de função | Uma função vira uma “partida” executável                                   |
| `NARRA`       | `narra`                     | `print`              | O narrador anuncia/imprime um valor na tela                                |
| `SE_JOGAR`    | `seJogar`                   | `if`                 | Condição: “se jogar”, executa o bloco                                      |
| `BANCO`       | `banco`                     | `else`               | Caminho alternativo: se não entrou em campo, ficou no banco                |
| `REPLAY`      | `replay`                    | `while`              | Repetição: revê a jogada enquanto a condição vale                          |
| `GOL`         | `gol`                       | `return`             | Resultado final devolvido pela função                                      |
| `ASSISTENCIA` | `assistencia`               | chamada de função    | Chamada de outra jogada/função                                             |
| `CAMPEAO`     | `campeao`                   | `true` (1)           | Literal booleano verdadeiro; o campeão sempre vence                        |
| `VICE`        | `vice`                      | `false` (0)          | Literal booleano falso; vice não ganhou                                    |
| `ID`          | `gols`, `placar`, `jogos`   | identificador        | Nomes definidos pelo programador                                           |
| `NUM_INT`     | `10`, `2`, `7`              | inteiro              | Literais inteiros                                                          |
| `NUM_FLOAT`   | `9.5`, `10.0`               | real                 | Literais decimais                                                          |
| `LIT_TEXTO`   | `”Neymar Jr”`               | string literal       | Literais de texto entre aspas                                              |

Tokens auxiliares (operadores e delimitadores):
`+  -  *  /  ==  !=  <  >  <=  >=  =  ;  ,  (  )  {  }`
Comentários: `// linha` e `/* bloco */`

---

## 3. Como compilar e executar

Requisitos: **JDK 11+** (testado em OpenJDK 23) e `bash`.

```bash
# 1) compila o front-end
./build.sh

# 2) executa o pipeline completo sobre input.txt
./run.sh

# variantes
./run.sh input.txt              # input qualquer
./run.sh --lex input.txt        # apenas analise lexica
./run.sh --parse input.txt      # lex + sintatica + semantica (default)
./run.sh input_erros.txt        # demo dos diagnosticos semanticos
```

O `build.sh` executa três passos:

1. `JFlex` gera `gen/Lexer.java` a partir de `src/lexer.flex`
2. `CUP` gera `gen/parser.java` + `gen/sym.java` a partir de `src/parser.cup`
3. `javac` compila tudo em `build/`

---

## 4. Programa de exemplo (`input.txt`)

```c
partida camisa10 somarGols(camisa10 a, camisa10 b) {
    camisa10 total = a + b;
    gol total;
}

partida ousadia mediaGols(camisa10 gols, camisa10 jogos) {
    ousadia media = 0.0;
    seJogar (jogos > 0) {
        media = gols / jogos;
    } banco {
        media = 0.0;
    }
    gol media;
}

partida semGol anunciar(canto nome) {
    narra("Em campo: ");
    narra(nome);
    gol ;
}

neymar() {
    canto  jogador    = "Neymar Jr";
    camisa10 totalGols  = 0;
    ousadia  media      = 0.0;

    totalGols = assistencia somarGols(118, 136);
    media     = assistencia mediaGols(totalGols, 250);

    assistencia anunciar(jogador);
    narra("Gols totais: ");
    narra(totalGols);

    seJogar (totalGols >= 250) {
        narra("LENDA DO FUTEBOL!");
    } banco {
        narra("ainda em construcao");
    }

    canto grito = "OLE" + "OLE";   // concatenacao de canto
    narra(grito);

    gol totalGols;
}
```

---

## 5. Saída esperada (resumo)

```
ETAPA 1 - ANALISE LEXICA (Scanner JFlex)
  ... 237 tokens listados (linha · coluna · classe · lexema) ...

ETAPA 2 - ANALISE SINTATICA + SEMANTICA (CUP)
>> programa analisado com sucesso.

=== TABELA DE SIMBOLOS (escopo global) ===
somarGols   camisa10   partida   14   [camisa10, camisa10]
mediaGols   ousadia    partida   20   [camisa10, camisa10]
anunciar    semGol     partida   31   [canto]
neymar      camisa10   partida   38   []

ETAPA 3 - RELATORIO FINAL
 GOOOOOL!! programa aceito sem erros lex/sint/sem.
```

Para `input_erros.txt` o compilador detecta **11 erros semânticos**
(redeclaração de partida, `semGol` retornando valor, redeclaração de
variável, atribuição incompatível, ID não declarado, variável `semGol`,
operação inválida `canto + camisa10`, **aridade de argumentos errada**,
**tipo de argumento errado**, partida inexistente, ID usado como partida).

---

## 6. Checagens semânticas implementadas

* **Tabela de símbolos com escopos aninhados** (`abrirEscopo`/`fecharEscopo`)
* **Declaração antes do uso** para variáveis e partidas
* **Detecção de redeclaração** no mesmo escopo
* **Compatibilidade de tipos** em atribuições, com coerção `camisa10 → ousadia`
* **Operadores aritméticos** exigem operandos numéricos; `+` concatena `canto`
* **Operadores relacionais** retornam `camisa10` (0/1, estilo C)
* **Condições** de `seJogar` e `replay` devem ser numéricas
* **`assistencia`** confere existência, categoria, **aridade e tipos dos argumentos**
* **Retorno (`gol`)** confere compatibilidade com tipo declarado da partida
* **Partidas `semGol`** não podem retornar valor nem aparecer em expressões
* **`narra`** (print) aceita qualquer valor exceto `semGol`

---

## 7. Demonstração em vídeo

Link: **[adicionar URL aqui]**

(Conteúdo do vídeo: explicação de `lexer.flex`, `parser.cup`, do driver
`Main.java`, execução de `input.txt` e `input_erros.txt`.)
