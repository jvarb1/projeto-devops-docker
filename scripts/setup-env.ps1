# Script PowerShell para configurar variaveis de ambiente
# Este script cria um arquivo .env baseado no .env.example

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$EnvExample = Join-Path $ProjectRoot ".env.example"
$EnvFile = Join-Path $ProjectRoot ".env"

Write-Host "[INFO] Configurando variaveis de ambiente..." -ForegroundColor Cyan

# Verificar se .env.example existe
if (-not (Test-Path $EnvExample)) {
    Write-Host "[ERRO] Arquivo .env.example nao encontrado!" -ForegroundColor Red
    exit 1
}

# Verificar se .env ja existe
if (Test-Path $EnvFile) {
    Write-Host "[AVISO] Arquivo .env ja existe." -ForegroundColor Yellow
    $response = Read-Host "Deseja sobrescrever? (s/N)"
    if ($response -ne "s" -and $response -ne "S") {
        Write-Host "Operacao cancelada." -ForegroundColor Yellow
        exit 0
    }
}

# Copiar .env.example para .env
Copy-Item $EnvExample $EnvFile -Force

# Gerar senha aleatoria para o banco de dados
Write-Host "[INFO] Gerando senha aleatoria para o banco de dados..." -ForegroundColor Cyan
$RandomPassword = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 25 | ForEach-Object {[char]$_})
(Get-Content $EnvFile) -replace 'DB_PASSWORD=taskpassword', "DB_PASSWORD=$RandomPassword" | Set-Content $EnvFile

Write-Host "[SUCESSO] Arquivo .env criado com sucesso!" -ForegroundColor Green
Write-Host "[INFO] Localizacao: $EnvFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "[AVISO] Importante: Revise o arquivo .env e ajuste as configuracoes conforme necessario." -ForegroundColor Yellow
Write-Host "[AVISO] Nao commit o arquivo .env no controle de versao!" -ForegroundColor Yellow

