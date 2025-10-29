#!/bin/sh
# Script para configurar variáveis de ambiente
# Este script cria um arquivo .env baseado no .env.example

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_EXAMPLE="$PROJECT_ROOT/.env.example"
ENV_FILE="$PROJECT_ROOT/.env"

echo "🚀 Configurando variáveis de ambiente..."

# Verificar se .env.example existe
if [ ! -f "$ENV_EXAMPLE" ]; then
    echo "❌ Erro: Arquivo .env.example não encontrado!"
    exit 1
fi

# Verificar se .env já existe
if [ -f "$ENV_FILE" ]; then
    echo "⚠️  Arquivo .env já existe."
    read -p "Deseja sobrescrever? (s/N): " -r
    if [ "$REPLY" != "s" ] && [ "$REPLY" != "S" ]; then
        echo "Operação cancelada."
        exit 0
    fi
fi

# Copiar .env.example para .env
cp "$ENV_EXAMPLE" "$ENV_FILE"

# Gerar senha aleatória para o banco de dados se não estiver definida
if grep -q "taskpassword" "$ENV_FILE"; then
    echo "🔐 Gerando senha aleatória para o banco de dados..."
    RANDOM_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    if [ "$(uname)" = "Darwin" ]; then
        # macOS
        sed -i '' "s/DB_PASSWORD=taskpassword/DB_PASSWORD=$RANDOM_PASSWORD/" "$ENV_FILE"
    else
        # Linux
        sed -i "s/DB_PASSWORD=taskpassword/DB_PASSWORD=$RANDOM_PASSWORD/" "$ENV_FILE"
    fi
fi

echo "✅ Arquivo .env criado com sucesso!"
echo "📝 Localização: $ENV_FILE"
echo ""
echo "⚠️  Importante: Revise o arquivo .env e ajuste as configurações conforme necessário."
echo "🔒 Não commit o arquivo .env no controle de versão!"

