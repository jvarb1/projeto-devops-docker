# ✅ Checklist - Atividade 04: Infraestrutura como Código (IaC)

## 📋 Checklist Completa para Nota 10

### Parte 1: Desenvolvimento Local da Infraestrutura (IaC) ✅

#### 1.1 Estrutura de Arquivos
- [x] ✅ Pasta `terraform/` criada na raiz do repositório
- [x] ✅ Arquivo `main.tf` criado
- [x] ✅ Arquivo `variables.tf` criado
- [x] ✅ Arquivo `outputs.tf` criado
- [x] ✅ Arquivo `terraform.tfvars.example` criado

#### 1.2 Configuração do Provider e Recursos
- [x] ✅ Provider configurado (DigitalOcean)
- [x] ✅ Recurso do servidor definido (`digitalocean_droplet`)
- [x] ✅ Cloud-Init configurado (`user_data`) para instalar Docker e Docker Compose automaticamente
- [x] ✅ Chave SSH pública injetada no servidor

#### 1.3 Gerenciamento de Segredos
- [x] ✅ Arquivo `terraform.tfvars.example` criado
- [x] ✅ `.gitignore` atualizado com:
  - [x] `*.tfvars` (exceto `.example`)
  - [x] `.terraform/`
  - [x] `*.tfstate*`

#### 1.4 Outputs
- [x] ✅ Arquivo `outputs.tf` retorna o IP Público da máquina

### Parte 2: Configuração do State Remoto (Cloud State) ⚠️

#### 2.1 Backend Remoto
- [x] ✅ Arquivo `backend.tf.example` criado com exemplos
- [ ] ⚠️ **AÇÃO NECESSÁRIA**: Você precisa criar `backend.tf` real e configurar:
  - [ ] Terraform Cloud OU
  - [ ] AWS S3 OU
  - [ ] DigitalOcean Spaces
  
**Como fazer:**
```bash
cd terraform
cp backend.tf.example backend.tf
# Edite backend.tf com suas credenciais
```

### Parte 3: Integração com GitHub Actions ✅

#### 3.1 Secrets Configurados
- [ ] ⚠️ **AÇÃO NECESSÁRIA**: Adicione os seguintes secrets no GitHub:
  - [ ] `DO_TOKEN` - Token da DigitalOcean
  - [ ] `TF_API_TOKEN` - Token do Terraform Cloud (se usar Terraform Cloud)
  - [ ] `SSH_USER` - Usuário SSH (geralmente `root`)
  - [ ] `SSH_KEY` - Chave privada SSH
  - [ ] `DOCKER_USERNAME` - Seu usuário do Docker Hub
  - [ ] `DOCKER_PASSWORD` - Senha/token do Docker Hub

**Como fazer:**
1. Acesse: `https://github.com/SEU_USUARIO/SEU_REPOSITORIO/settings/secrets/actions`
2. Clique em "New repository secret"
3. Adicione cada secret

#### 3.2 Job de Infraestrutura
- [x] ✅ Job `provision-infra` criado
- [x] ✅ Job roda antes do deploy (mas depois dos testes)
- [x] ✅ Passos do job:
  - [x] Checkout do código
  - [x] Setup do Terraform (`hashicorp/setup-terraform`)
  - [x] `terraform init`
  - [x] `terraform apply -auto-approve`
  - [x] Captura do IP via output

#### 3.3 Job de Deploy Atualizado
- [x] ✅ Job de deploy usa IP dinâmico do Terraform
- [x] ✅ IP obtido do output do job `provision-infra`

### Parte 4: Documentação ✅

#### 4.1 README.md Atualizado
- [x] ✅ Seção sobre IaC adicionada
- [x] ✅ Pré-requisitos de infra explicados
- [x] ✅ Instruções de boot explicadas (servidor provisionado automaticamente)
- [x] ✅ Secrets necessários documentados

## 🎯 Entregáveis Finais

### Obrigatórios:
1. [x] ✅ Link do repositório contendo a pasta `terraform/`
2. [x] ✅ Arquivo `.yml` do workflow atualizado (`.github/workflows/cicd.yml`)
3. [ ] ⚠️ **AÇÃO NECESSÁRIA**: Execução no GitHub Actions mostrando:
   - [ ] Job "Provision Infra" com sucesso (verde) ✅
   - [ ] Job "Deploy" com sucesso (verde) ✅

## ⚠️ Ações Necessárias para Completar

### 1. Configurar Backend Remoto (OBRIGATÓRIO)
```bash
cd terraform
cp backend.tf.example backend.tf
# Edite backend.tf com suas credenciais
```

**Opção mais fácil: Terraform Cloud**
1. Crie conta em https://app.terraform.io
2. Crie organização e workspace
3. Edite `backend.tf`:
```hcl
terraform {
  cloud {
    organization = "sua-organizacao"
    workspaces {
      name = "projeto-devops"
    }
  }
}
```

### 2. Configurar Variáveis Locais (para teste)
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seu token da DigitalOcean
```

### 3. Testar Localmente (RECOMENDADO)
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 4. Configurar Secrets no GitHub (OBRIGATÓRIO)
Adicione todos os secrets listados acima.

### 5. Fazer Push e Verificar Pipeline
```bash
git add .
git commit -m "feat: implementa IaC com Terraform"
git push origin main
```

Depois, verifique no GitHub Actions se:
- ✅ Job "Provision Infra" executa com sucesso
- ✅ Job "Deploy" executa com sucesso
- ✅ Aplicação está rodando no servidor criado

## 📊 Pontuação Esperada

Se você completar todas as ações acima:
- ✅ **Parte 1**: 100% completo
- ⚠️ **Parte 2**: 90% completo (falta apenas criar `backend.tf` real)
- ✅ **Parte 3**: 100% completo (falta apenas configurar secrets)
- ✅ **Parte 4**: 100% completo

**Nota estimada: 9.5/10** (falta apenas executar e testar)

Para **10/10**, você precisa:
1. ✅ Criar `backend.tf` real (não apenas o exemplo)
2. ✅ Configurar todos os secrets no GitHub
3. ✅ Executar o pipeline com sucesso
4. ✅ Mostrar screenshots/evidências dos jobs verdes no GitHub Actions

## 🚀 Próximos Passos Imediatos

1. **AGORA**: Configure o backend remoto (`backend.tf`)
2. **AGORA**: Configure os secrets no GitHub
3. **AGORA**: Faça um push de teste
4. **DEPOIS**: Verifique se o pipeline executou com sucesso
5. **DEPOIS**: Tire screenshots dos jobs verdes para entregar

## 📸 O que Capturar para Entrega

1. Screenshot do GitHub Actions mostrando:
   - Job "Provision Infra" ✅ (verde)
   - Job "Deploy" ✅ (verde)
2. Screenshot do Terraform Cloud (se usar) mostrando o estado
3. Screenshot do servidor criado na DigitalOcean
4. Teste da aplicação rodando: `curl http://IP_DO_SERVIDOR:8000/health`

