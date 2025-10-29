#!/bin/sh
# Script para testar a API CRUD
# Este script executa testes básicos em todos os endpoints

API_URL="http://localhost:8000"

echo "🧪 Testando API de Tarefas..."
echo ""

# Verificar se a API está rodando
echo "1️⃣ Verificando saúde da API..."
if curl -s -f "${API_URL}/health" > /dev/null; then
    echo "✅ API está respondendo"
    curl -s "${API_URL}/health" | jq '.' || echo "   Resposta: $(curl -s ${API_URL}/health)"
else
    echo "❌ API não está respondendo. Certifique-se de que os containers estão rodando."
    echo "   Execute: docker-compose up -d"
    exit 1
fi

echo ""
echo "2️⃣ Criando uma nova tarefa..."
TASK_RESPONSE=$(curl -s -X POST "${API_URL}/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tarefa de Teste",
    "description": "Esta é uma tarefa criada pelo script de teste",
    "status": "pending"
  }')

TASK_ID=$(echo "$TASK_RESPONSE" | grep -o '"id":[0-9]*' | cut -d':' -f2 || echo "")

if [ -n "$TASK_ID" ]; then
    echo "✅ Tarefa criada com ID: $TASK_ID"
    echo "$TASK_RESPONSE" | jq '.' || echo "$TASK_RESPONSE"
else
    echo "❌ Erro ao criar tarefa"
    echo "$TASK_RESPONSE"
    exit 1
fi

echo ""
echo "3️⃣ Listando todas as tarefas..."
LIST_RESPONSE=$(curl -s "${API_URL}/tasks")
echo "$LIST_RESPONSE" | jq '.' || echo "$LIST_RESPONSE"

echo ""
echo "4️⃣ Obtendo tarefa específica (ID: $TASK_ID)..."
GET_RESPONSE=$(curl -s "${API_URL}/tasks/${TASK_ID}")
echo "$GET_RESPONSE" | jq '.' || echo "$GET_RESPONSE"

echo ""
echo "5️⃣ Atualizando tarefa (ID: $TASK_ID)..."
UPDATE_RESPONSE=$(curl -s -X PUT "${API_URL}/tasks/${TASK_ID}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tarefa de Teste - Atualizada",
    "status": "completed"
  }')
echo "$UPDATE_RESPONSE" | jq '.' || echo "$UPDATE_RESPONSE"

echo ""
echo "6️⃣ Deletando tarefa (ID: $TASK_ID)..."
DELETE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "${API_URL}/tasks/${TASK_ID}")
if [ "$DELETE_STATUS" = "204" ]; then
    echo "✅ Tarefa deletada com sucesso"
else
    echo "⚠️ Status HTTP: $DELETE_STATUS"
fi

echo ""
echo "✅ Todos os testes foram concluídos!"

