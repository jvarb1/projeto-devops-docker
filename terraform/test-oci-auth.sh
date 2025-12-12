#!/bin/bash
# Script para testar autenticação OCI
# Este script verifica se as credenciais OCI estão corretas

echo "Testando autenticação OCI..."
echo ""

# Verificar se a chave privada está no formato correto
if [ -z "$TF_VAR_private_key" ]; then
  echo "❌ ERRO: TF_VAR_private_key não está definida"
  exit 1
fi

# Verificar se contém BEGIN e END
if echo "$TF_VAR_private_key" | grep -q "BEGIN"; then
  echo "✅ Chave privada contém BEGIN"
else
  echo "❌ ERRO: Chave privada NÃO contém BEGIN"
  exit 1
fi

if echo "$TF_VAR_private_key" | grep -q "END"; then
  echo "✅ Chave privada contém END"
else
  echo "❌ ERRO: Chave privada NÃO contém END"
  exit 1
fi

# Contar linhas
LINES=$(echo "$TF_VAR_private_key" | wc -l)
echo "📊 Linhas na chave: $LINES"

# Verificar outros parâmetros
if [ -z "$TF_VAR_tenancy_ocid" ]; then
  echo "❌ ERRO: TF_VAR_tenancy_ocid não está definida"
  exit 1
fi

if [ -z "$TF_VAR_user_ocid" ]; then
  echo "❌ ERRO: TF_VAR_user_ocid não está definida"
  exit 1
fi

if [ -z "$TF_VAR_fingerprint" ]; then
  echo "❌ ERRO: TF_VAR_fingerprint não está definida"
  exit 1
fi

echo ""
echo "✅ Todas as variáveis obrigatórias estão definidas"
echo "Tenancy OCID: ${TF_VAR_tenancy_ocid:0:20}..."
echo "User OCID: ${TF_VAR_user_ocid:0:20}..."
echo "Fingerprint: $TF_VAR_fingerprint"


