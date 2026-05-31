/* ====================================================================
   NeyScript - Analisador Lexico (JFlex)
   Linguagem tematizada Neymar Jr.
   ==================================================================== */

import java_cup.runtime.*;

%%

%public
%class Lexer
%cup
%line
%column
%unicode

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline + 1, yycolumn + 1);
    }
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline + 1, yycolumn + 1, value);
    }
    public int getLine()   { return yyline + 1; }
    public int getColumn() { return yycolumn + 1; }
%}

/* ---------- macros ---------- */
LineTerminator   = \r|\n|\r\n
WhiteSpace       = {LineTerminator} | [ \t\f]
Digit            = [0-9]
Letter           = [a-zA-Z_]
Identifier       = {Letter}({Letter}|{Digit})*
IntegerLiteral   = {Digit}+
FloatLiteral     = {Digit}+ "." {Digit}+
StringLiteral    = \"([^\"\\\n]|\\.)*\"

CommentSingle    = "//" [^\r\n]*
CommentMulti     = "/*" ~"*/"
Comment          = {CommentSingle} | {CommentMulti}

%%

/* ---------- regras ---------- */

<YYINITIAL> {

  /* palavras-chave NeyScript (devem vir antes de {Identifier}) */
  "neymar"         { return symbol(sym.NEYMAR);       }   /* main         */
  "camisa10"       { return symbol(sym.CAMISA10);     }   /* int          */
  "ousadia"        { return symbol(sym.OUSADIA);      }   /* float        */
  "torcida"        { return symbol(sym.TORCIDA);      }   /* string       */
  "semGol"         { return symbol(sym.SEM_GOL);      }   /* void         */
  "narra"          { return symbol(sym.NARRA);        }   /* print        */
  "partida"        { return symbol(sym.PARTIDA);      }   /* function     */
  "drible"         { return symbol(sym.DRIBLE);       }   /* if           */
  "carrinho"       { return symbol(sym.CARRINHO);     }   /* else         */
  "prorrogacao"    { return symbol(sym.PRORROGACAO);  }   /* while        */
  "gol"            { return symbol(sym.GOL);          }   /* return       */
  "assistencia"    { return symbol(sym.ASSISTENCIA);  }   /* call prefix  */

  /* literais numericos */
  {FloatLiteral}   { return symbol(sym.NUM_FLOAT, Double.parseDouble(yytext())); }
  {IntegerLiteral} { return symbol(sym.NUM_INT,   Integer.parseInt(yytext()));   }

  /* literal de texto (string) */
  {StringLiteral}  {
                     String s = yytext();
                     return symbol(sym.LIT_TEXTO, s.substring(1, s.length()-1));
                   }

  /* operadores aritmeticos */
  "+"   { return symbol(sym.PLUS);  }
  "-"   { return symbol(sym.MINUS); }
  "*"   { return symbol(sym.MULT);  }
  "/"   { return symbol(sym.DIV);   }

  /* operadores relacionais */
  "=="  { return symbol(sym.EQ);   }
  "!="  { return symbol(sym.NEQ);  }
  "<="  { return symbol(sym.LEQ);  }
  ">="  { return symbol(sym.GEQ);  }
  "<"   { return symbol(sym.LT);   }
  ">"   { return symbol(sym.GT);   }

  /* atribuicao */
  "="   { return symbol(sym.ASSIGN); }

  /* delimitadores */
  ";"   { return symbol(sym.SEMI);   }
  ","   { return symbol(sym.COMMA);  }
  "("   { return symbol(sym.LPAREN); }
  ")"   { return symbol(sym.RPAREN); }
  "{"   { return symbol(sym.LBRACE); }
  "}"   { return symbol(sym.RBRACE); }

  /* identificadores */
  {Identifier}     { return symbol(sym.ID, yytext()); }

  /* ignorados */
  {Comment}        { /* descarta */ }
  {WhiteSpace}     { /* descarta */ }
}

/* caractere ilegal */
[^]    { throw new RuntimeException(
            "ERRO LEXICO: caractere invalido '" + yytext()
            + "' linha " + (yyline+1) + " col " + (yycolumn+1));
       }
