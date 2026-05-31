#!/usr/bin/env bash
# ============================================================
# run.sh - executa o compilador NeymarLang
# Uso:
#   ./run.sh                       -> input.txt em modo completo
#   ./run.sh --lex   arquivo.njr   -> apenas analise lexica
#   ./run.sh --parse arquivo.njr   -> lex + sintatica + semantica
# ============================================================
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB="$ROOT/lib"
OUT="$ROOT/build"
CUP_RT="$LIB/java-cup-11b-runtime.jar"

if [ ! -d "$OUT" ]; then
    echo "build/ nao existe. Executando build.sh primeiro..."
    "$ROOT/build.sh"
fi

ARGS=("$@")
if [ ${#ARGS[@]} -eq 0 ]; then
    ARGS=("$ROOT/input.txt")
fi

java -cp "$OUT:$CUP_RT" Main "${ARGS[@]}"
