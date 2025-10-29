#!/bin/sh
# Script para verificar se as variáveis de ambiente estão configuradas corretamente

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_ROOT/.env"

echo "🔍 Verificando configurações de ambiente..."

# Verificar se .env existe
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Arquivo .env não encontrado!"
    echo "💡 Execute: ./scripts/setup-env.sh para criar o arquivo .env"
    exit 1
fi

# Carregar variáveis do .env
. "$ENV_FILE"

# Lista de variáveis obrigatórias
REQUIRED_VARS="DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWORD APP_PORT"

MISSING_VARS=""
for var in $REQUIRED_VARS; do
    eval value=\$$var
    if [ -z "$value" ]; then
        MISSING_VARS="$MISSING_VARS $var"
    fi
done

if [ -n "$MISSING_VARS" ]; then
    echo "❌ Variáveis obrigatórias não definidas:$MISSING_VARS"
    exit 1
fi

# Verificar valores
echo "✅ Variáveis de ambiente configuradas:"
echo "   DB_HOST: $DB_HOST"
echo "   DB_PORT: $DB_PORT"
echo "   DB_NAME: $DB_NAME"
echo "   DB_USER: $DB_USER"
echo "   DB_PASSWORD: ${DB_PASSWORD:0:5}***** (oculto)"
echo "   APP_PORT: $APP_PORT"
echo ""
echo "✅ Configuração válida!"

