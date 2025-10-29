# Script PowerShell para testar a API CRUD
# Este script executa testes basicos em todos os endpoints

$API_URL = "http://localhost:8000"

Write-Host "[TESTE] Testando API de Tarefas..." -ForegroundColor Cyan
Write-Host ""

# Verificar se a API esta rodando
Write-Host "[1/6] Verificando saude da API..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "${API_URL}/health" -Method Get -ErrorAction Stop
    Write-Host "[OK] API esta respondendo" -ForegroundColor Green
    $healthResponse | ConvertTo-Json
} catch {
    Write-Host "[ERRO] API nao esta respondendo. Certifique-se de que os containers estao rodando." -ForegroundColor Red
    Write-Host "       Execute: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "[2/6] Criando uma nova tarefa..." -ForegroundColor Yellow
try {
    $taskBody = @{
        title = "Tarefa de Teste"
        description = "Esta e uma tarefa criada pelo script de teste"
        status = "pending"
    } | ConvertTo-Json

    $createResponse = Invoke-RestMethod -Uri "${API_URL}/tasks" -Method Post -Body $taskBody -ContentType "application/json" -ErrorAction Stop
    $taskId = $createResponse.id
    Write-Host "[OK] Tarefa criada com ID: $taskId" -ForegroundColor Green
    $createResponse | ConvertTo-Json -Depth 5
} catch {
    Write-Host "[ERRO] Erro ao criar tarefa" -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}

Write-Host ""
Write-Host "[3/6] Listando todas as tarefas..." -ForegroundColor Yellow
try {
    $listResponse = Invoke-RestMethod -Uri "${API_URL}/tasks" -Method Get -ErrorAction Stop
    $listResponse | ConvertTo-Json -Depth 5
} catch {
    Write-Host "[AVISO] Erro ao listar tarefas: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[4/6] Obtendo tarefa especifica (ID: $taskId)..." -ForegroundColor Yellow
try {
    $getResponse = Invoke-RestMethod -Uri "${API_URL}/tasks/$taskId" -Method Get -ErrorAction Stop
    $getResponse | ConvertTo-Json -Depth 5
} catch {
    Write-Host "[AVISO] Erro ao obter tarefa: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[5/6] Atualizando tarefa (ID: $taskId)..." -ForegroundColor Yellow
try {
    $updateBody = @{
        title = "Tarefa de Teste - Atualizada"
        status = "completed"
    } | ConvertTo-Json

    $updateResponse = Invoke-RestMethod -Uri "${API_URL}/tasks/$taskId" -Method Put -Body $updateBody -ContentType "application/json" -ErrorAction Stop
    $updateResponse | ConvertTo-Json -Depth 5
} catch {
    Write-Host "[AVISO] Erro ao atualizar tarefa: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[6/6] Deletando tarefa (ID: $taskId)..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "${API_URL}/tasks/$taskId" -Method Delete -ErrorAction Stop
    Write-Host "[OK] Tarefa deletada com sucesso" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 204) {
        Write-Host "[OK] Tarefa deletada com sucesso" -ForegroundColor Green
    } else {
        Write-Host "[AVISO] Erro ao deletar tarefa: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "[SUCESSO] Todos os testes foram concluidos!" -ForegroundColor Green

