import java.io.*;
import java.util.*;
import java_cup.runtime.Symbol;

/**
 *  NeymarLang - driver de integracao Scanner + Parser.
 *  Modos:
 *     java Main --lex   arquivo.njr     so analise lexica
 *     java Main --parse arquivo.njr     analise lex + sintatica + semantica
 *     java Main         arquivo.njr     mesmo que --parse (default)
 */
public class Main {

    private static final String[] NOMES_TOKENS = construirNomesTokens();

    public static void main(String[] args) throws Exception {
        String modo = "parse";
        String arquivo = null;

        for (String a : args) {
            if (a.equals("--lex"))        modo = "lex";
            else if (a.equals("--parse")) modo = "parse";
            else                          arquivo = a;
        }
        if (arquivo == null) {
            System.err.println("Uso: java Main [--lex|--parse] <arquivo.njr>");
            System.exit(1);
        }

        banner(arquivo);
        String fonte = lerArquivo(arquivo);

        if (modo.equals("lex")) {
            executarLex(fonte);
        } else {
            executarLex(new String(fonte));
            executarParse(fonte);
        }
    }

    /* ============================================================
       Etapa 1: Lex - mostra todos os tokens
       ============================================================ */
    private static void executarLex(String fonte) throws Exception {
        System.out.println("\n============================================================");
        System.out.println(" ETAPA 1 - ANALISE LEXICA (Scanner JFlex)");
        System.out.println("============================================================");
        System.out.printf(" %-6s %-6s %-22s %s%n", "LINHA", "COL", "TOKEN", "LEXEMA/VALOR");
        System.out.println(" ----- ----- ---------------------- -----------------------");

        Lexer lex = new Lexer(new StringReader(fonte));
        int total = 0;
        while (true) {
            Symbol s = lex.next_token();
            if (s == null || s.sym == sym.EOF) break;
            String nome = nomeToken(s.sym);
            String val  = s.value == null ? "" : s.value.toString();
            System.out.printf(" %-6d %-6d %-22s %s%n", s.left, s.right, nome, val);
            total++;
        }
        System.out.println(" ----- ----- ---------------------- -----------------------");
        System.out.println(" total de tokens: " + total);
    }

    /* ============================================================
       Etapa 2/3: parse + semantica
       ============================================================ */
    private static void executarParse(String fonte) throws Exception {
        System.out.println("\n============================================================");
        System.out.println(" ETAPA 2 - ANALISE SINTATICA + SEMANTICA (CUP)");
        System.out.println("============================================================");

        Lexer lex = new Lexer(new StringReader(fonte));
        parser p  = new parser(lex);

        boolean ok = true;
        try {
            p.parse();
        } catch (Exception e) {
            ok = false;
            System.err.println("Excecao do parser: " + e.getMessage());
        }

        p.tabela.imprimir();

        System.out.println("\n============================================================");
        System.out.println(" ETAPA 3 - RELATORIO FINAL");
        System.out.println("============================================================");
        if (p.erros == 0 && ok) {
            System.out.println(" GOOOOOL!! programa aceito sem erros lex/sint/sem.");
        } else {
            System.out.println(" CARTAO VERMELHO - " + p.erros + " erro(s) encontrado(s):");
            for (String m : p.mensagensErro) System.out.println("   - " + m);
        }
    }

    /* ============================================================
       util
       ============================================================ */
    private static String lerArquivo(String path) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String l;
            while ((l = br.readLine()) != null) sb.append(l).append('\n');
        }
        return sb.toString();
    }

    private static void banner(String arquivo) {
        System.out.println("============================================================");
        System.out.println("   NeymarLang Compiler Front-end  (JFlex + CUP)");
        System.out.println("   arquivo de entrada: " + arquivo);
        System.out.println("============================================================");
    }

    /* mapeia codigo do simbolo CUP para nome legivel via reflection */
    private static String[] construirNomesTokens() {
        try {
            java.lang.reflect.Field[] fs = sym.class.getFields();
            int max = 0;
            for (java.lang.reflect.Field f : fs) {
                if (f.getType() == int.class) max = Math.max(max, f.getInt(null));
            }
            String[] arr = new String[max + 1];
            for (java.lang.reflect.Field f : fs) {
                if (f.getType() == int.class) arr[f.getInt(null)] = f.getName();
            }
            return arr;
        } catch (Exception e) {
            return new String[0];
        }
    }

    private static String nomeToken(int s) {
        if (s >= 0 && s < NOMES_TOKENS.length && NOMES_TOKENS[s] != null)
            return NOMES_TOKENS[s];
        return "T#" + s;
    }
}
