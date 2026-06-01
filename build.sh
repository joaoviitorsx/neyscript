#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB="$ROOT/lib"
SRC="$ROOT/src"
GEN="$ROOT/gen"
OUT="$ROOT/build"

JFLEX_JAR="$LIB/jflex-full-1.9.1.jar"
CUP_JAR="$LIB/java-cup-11b.jar"
CUP_RT="$LIB/java-cup-11b-runtime.jar"

mkdir -p "$GEN" "$OUT"

echo "[1/3] JFlex ......... gerando Lexer.java"
java -cp "$JFLEX_JAR:$CUP_RT" jflex.Main -d "$GEN" "$SRC/lexer.flex" >/dev/null

echo "[2/3] CUP ........... gerando parser.java + sym.java"
java -cp "$CUP_JAR" java_cup.Main -destdir "$GEN" -parser parser -symbols sym "$SRC/parser.cup"

echo "[3/3] javac ......... compilando classes"
javac -d "$OUT" -cp "$CUP_RT" \
      "$GEN/Lexer.java" "$GEN/parser.java" "$GEN/sym.java" "$SRC/Main.java"

echo "OK - build concluido em $OUT"
