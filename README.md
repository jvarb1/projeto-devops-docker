# Projeto DevOps - Ambiente Multi-Container com Docker

Este projeto implementa uma aplicação CRUD completa utilizando FastAPI e PostgreSQL, configurada com Docker Compose, volumes persistentes, rede customizada e variáveis de ambiente.

> **Status do CI/CD**: Pipeline automatizado configurado e funcionando.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Configuração](#configuração)
- [Executando a Aplicação](#executando-a-aplicação)
- [Testando a API](#testando-a-api)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Recursos Implementados](#recursos-implementados)
- [CI/CD](#cicd)
- [Segurança](#segurança)
- [Troubleshooting](#troubleshooting)

## 🎯 Visão Geral

Este projeto demonstra a configuração de um ambiente multi-container usando:
- **FastAPI**: Framework Python para construção da API REST
- **PostgreSQL**: Banco de dados relacional
- **Docker**: Containerização da aplicação
- **Docker Compose**: Orquestração de múltiplos containers
- **Volumes**: Persistência de dados do banco
- **Redes Customizadas**: Comunicação isolada entre containers
- **Variáveis de Ambiente**: Configuração flexível e segura

## 🏗️ Arquitetura

```
┌────────────────────────────────────────────────┐
│           Docker Compose Network               │
│              (taskapp-network)                 │
│                                                │
│  ┌──────────────┐       ┌──────────────┐       │
│  │              │       │              │       │
│  │   API App    │◄──────┤  PostgreSQL  │       │
│  │  (FastAPI)   │       │  (db:5432)   │       │
│  │  Port: 8000  │       │              │       │
│  │              │       │              │       │
│  └──────────────┘       └──────────────┘       │
│         │                        │             │
│         │                        │             │
│         └────────┬───────────────┘             │
│                  │                             │
│            Volume Mounts                       │
│  ┌─────────────────────────────────────────┐   │
│  │ postgres_data: /var/lib/postgresql/data │   │
│  └─────────────────────────────────────────┘   │
└────────────────────────────────────────────────┘
```

## 📦 Pré-requisitos

Antes de executar o projeto, certifique-se de ter instalado:

- **Docker**: versão 20.10 ou superior
- **Docker Compose**: versão 2.0 ou superior
- **Git**: para clonar o repositório

### Verificando Instalação

```bash
docker --version
docker-compose --version
```

## ⚙️ Configuração

### 1. Configurar Variáveis de Ambiente

#### Windows (PowerShell)

```powershell
.\scripts\setup-env.ps1
```

#### Linux/macOS

```bash
chmod +x scripts/setup-env.sh
./scripts/setup-env.sh
```

Este script irá:
- Criar um arquivo `.env` baseado no `.env.example`
- Gerar uma senha aleatória segura para o banco de dados
- Configurar todas as variáveis necessárias

### 2. Personalizar Configurações (Opcional)

Edite o arquivo `.env` para ajustar:
- Credenciais do banco de dados
- Portas dos serviços
- Outras configurações específicas

**⚠️ Importante:** Nunca faça commit do arquivo `.env` no repositório!

### 3. Verificar Configuração

```bash
# Linux/macOS
./scripts/check-env.sh

# Windows (PowerShell)
# Verifique manualmente o arquivo .env
```

## 🚀 Executando a Aplicação

### Construir e Iniciar os Containers

```bash
docker-compose up -d --build
```

Este comando irá:
- Construir a imagem da aplicação (multi-stage build com Alpine)
- Criar a rede customizada `taskapp-network`
- Criar o volume `taskdb_data` para persistência
- Iniciar os containers do banco de dados e da aplicação

### Verificar Status dos Containers

```bash
docker-compose ps
```

### Visualizar Logs

```bash
# Logs de todos os serviços
docker-compose logs -f

# Logs apenas da aplicação
docker-compose logs -f app

# Logs apenas do banco de dados
docker-compose logs -f db
```

### Parar os Containers

```bash
docker-compose down
```

### Parar e Remover Volumes (⚠️ Isso apaga os dados!)

```bash
docker-compose down -v
```

## 🧪 Testando a API

### 1. Verificar Saúde da Aplicação

```bash
curl http://localhost:8000/health
```

Ou acesse no navegador: http://localhost:8000/health

### 2. Acessar Documentação Interativa

Acesse a documentação Swagger em:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### 3. Testar CRUD Completo

#### Criar uma Tarefa (POST)

```bash
curl -X POST "http://localhost:8000/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Estudar Docker",
    "description": "Aprender conceitos de Docker Compose e volumes",
    "status": "pending"
  }'
```

#### Listar Todas as Tarefas (GET)

```bash
curl http://localhost:8000/tasks
```

#### Obter uma Tarefa Específica (GET)

```bash
curl http://localhost:8000/tasks/1
```

#### Atualizar uma Tarefa (PUT)

```bash
curl -X PUT "http://localhost:8000/tasks/1" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Estudar Docker - Atualizado",
    "status": "completed"
  }'
```

#### Deletar uma Tarefa (DELETE)

```bash
curl -X DELETE http://localhost:8000/tasks/1
```

### 4. Testar Persistência de Dados

1. Crie algumas tarefas usando a API
2. Pare os containers: `docker-compose down`
3. Inicie novamente: `docker-compose up -d`
4. Liste as tarefas novamente - elas devem estar intactas!

### 5. Verificar Conexão entre Containers

```bash
# Executar comando dentro do container da aplicação
docker-compose exec app wget -qO- http://db:5432 || echo "Conexão OK"

# Verificar logs de conexão
docker-compose logs app | grep "Conectando ao banco"
```

## 📁 Estrutura do Projeto

```
ProjetoDevOps/
│
├── app/                      # Código da aplicação
│   ├── __init__.py
│   ├── main.py              # Aplicação FastAPI principal
│   ├── database.py          # Configuração do banco de dados
│   ├── models.py            # Modelos SQLAlchemy
│   └── schemas.py           # Schemas Pydantic para validação
│
├── scripts/                 # Scripts auxiliares
│   ├── setup-env.sh        # Configurar ambiente (Linux/macOS)
│   ├── setup-env.ps1       # Configurar ambiente (Windows)
│   └── check-env.sh        # Verificar variáveis de ambiente
│
├── logs/                    # Diretório para logs (criado automaticamente)
│
├── .dockerignore           # Arquivos ignorados no build Docker
├── .env.example            # Template de variáveis de ambiente
├── Dockerfile              # Dockerfile multi-stage com Alpine
├── docker-compose.yml      # Configuração Docker Compose
├── init-db.sql            # Script de inicialização do banco
├── requirements.txt       # Dependências Python
└── README.md              # Este arquivo
```

## ✨ Recursos Implementados

### ✅ Requisitos Obrigatórios

- [x] **Dockerfile Multi-stage**: Utiliza imagens Alpine em múltiplos estágios para otimização
- [x] **Docker Compose**: Configuração completa com 2 serviços (app + db)
- [x] **Volumes Persistentes**: Dados do PostgreSQL são persistidos em volume nomeado
- [x] **Rede Customizada**: Rede isolada `taskapp-network` para comunicação entre containers
- [x] **Variáveis de Ambiente**: Configuração flexível via arquivo `.env`
- [x] **CRUD Completo**: API REST completa com operações Create, Read, Update, Delete
- [x] **Segurança**: Usuário específico para aplicação (não usa root)
- [x] **Documentação**: README.md completo e detalhado
- [x] **CI/CD**: Pipeline automatizado com GitHub Actions
- [x] **Testes Unitários**: Cobertura completa das rotas CRUD

### 🔒 Segurança Implementada

1. **Usuário Dedicado no Banco**: 
   - Usuário `taskuser` criado com permissões mínimas necessárias
   - Não utiliza o usuário `postgres` (root) para a aplicação

2. **Usuário Não-Root no Container**:
   - Aplicação executa como usuário `appuser` (UID 1000)
   - Reduz a superfície de ataque

3. **Variáveis de Ambiente**:
   - Senhas e credenciais não hardcoded
   - Arquivo `.env` ignorado pelo Git

4. **Health Checks**:
   - Containers monitoram sua própria saúde
   - Aplicação só inicia quando o banco está pronto

## 🔍 Detalhes Técnicos

### Dockerfile Multi-stage

O Dockerfile utiliza dois estágios:

1. **Builder**: Instala dependências de compilação e Python packages
2. **Runtime**: Imagem final leve com apenas runtime dependencies

**Vantagens:**
- Imagem final ~50% menor
- Maior segurança (menos ferramentas de build)
- Build mais rápido em cache hits

### Volumes

- **postgres_data**: Volume nomeado persistente para dados do PostgreSQL
- **logs**: Volume bind mount para logs da aplicação (desenvolvimento)

### Rede Customizada

- **taskapp-network**: Rede bridge isolada
- Containers se comunicam pelo nome do serviço (`db`, `app`)
- Isolamento de outras aplicações Docker

### Variáveis de Ambiente

Principais variáveis configuráveis:

```env
DB_HOST=db              # Host do banco (nome do serviço)
DB_PORT=5432            # Porta do PostgreSQL
DB_NAME=taskdb          # Nome do banco
DB_USER=taskuser        # Usuário da aplicação
DB_PASSWORD=...         # Senha (gerada automaticamente)
APP_PORT=8000           # Porta da aplicação
```

## 🐛 Troubleshooting

### Problema: Container não inicia

**Solução:**
```bash
# Verificar logs detalhados
docker-compose logs app

# Verificar se as portas estão livres
netstat -an | grep 8000
netstat -an | grep 5432
```

### Problema: Erro de conexão com banco

**Solução:**
```bash
# Verificar se o banco está saudável
docker-compose exec db pg_isready -U taskuser -d taskdb

# Verificar variáveis de ambiente
docker-compose exec app env | grep DB_
```

### Problema: Dados não persistem

**Solução:**
```bash
# Verificar se o volume existe
docker volume ls | grep taskdb_data

# Verificar montagem do volume
docker-compose exec db df -h /var/lib/postgresql/data
```

### Problema: Porta já em uso

**Solução:**
Altere as portas no arquivo `.env`:
```env
APP_PORT=8001
DB_PORT=5433
```

## 📚 Comandos Úteis

### Gerenciamento de Containers

```bash
# Iniciar em background
docker-compose up -d

# Reconstruir imagens
docker-compose build --no-cache

# Reiniciar apenas um serviço
docker-compose restart app

# Executar comando no container
docker-compose exec app sh
docker-compose exec db psql -U taskuser -d taskdb

# Ver uso de recursos
docker stats
```

### Limpeza

```bash
# Parar e remover containers
docker-compose down

# Remover volumes também
docker-compose down -v

# Remover imagens
docker-compose down --rmi all

# Limpeza completa do Docker (cuidado!)
docker system prune -a --volumes
```

### Inspeção

```bash
# Ver configuração completa
docker-compose config

# Listar redes
docker network ls

# Listar volumes
docker volume ls

# Inspecionar rede
docker network inspect taskapp-network
```

## 🔄 Fluxo de Trabalho Típico

1. **Primeira Execução:**
   ```bash
   ./scripts/setup-env.sh      # Configurar ambiente
   docker-compose up -d --build # Construir e iniciar
   ```

2. **Desenvolvimento:**
   ```bash
   docker-compose up           # Ver logs em tempo real
   # ... fazer alterações no código ...
   docker-compose restart app  # Reiniciar apenas app
   ```

3. **Testes:**
   ```bash
   curl http://localhost:8000/docs  # Testar via Swagger
   ```

4. **Manutenção:**
   ```bash
   docker-compose logs -f      # Monitorar logs
   docker-compose ps           # Ver status
   ```

## 🚀 CI/CD

![CI/CD Pipeline](https://github.com/jvarb1/projeto-devops-docker/workflows/CI/CD%20Pipeline/badge.svg)

Este projeto implementa um pipeline completo de Integração Contínua (CI) e Entrega Contínua (CD) usando GitHub Actions.

### Pipeline de CI/CD

O pipeline é executado automaticamente a cada push na branch `main` e realiza as seguintes etapas:

1. **Testes Unitários** (`test`)
   - Executa todos os testes unitários usando pytest
   - Valida que todas as rotas CRUD estão funcionando corretamente
   - Falha no pipeline se algum teste não passar

2. **Build e Push da Imagem Docker** (`build-and-push`)
   - Constrói a imagem Docker da aplicação
   - Marca a imagem com o SHA do commit e `latest`
   - Envia a imagem para o Docker Hub
   - Só executa se os testes passarem

3. **Deploy Automático** (`deploy`)
   - Conecta-se ao servidor de produção via SSH
   - Atualiza o código do repositório
   - Baixa a nova imagem do Docker Hub
   - Reinicia os containers com a nova versão
   - Verifica se o deploy foi bem-sucedido

### Configuração de Secrets

Para que o pipeline funcione, você precisa configurar os seguintes secrets no GitHub:

1. **DOCKER_USERNAME**: Seu usuário do Docker Hub
2. **DOCKER_PASSWORD**: Sua senha ou token de acesso do Docker Hub
3. **SSH_HOST**: IP ou domínio do seu servidor de produção
4. **SSH_USER**: Usuário para conexão SSH no servidor
5. **SSH_KEY**: Chave privada SSH para autenticação
6. **SSH_PORT**: Porta SSH (padrão: 22, opcional)

#### Como configurar os Secrets:

1. Acesse: `https://github.com/SEU_USUARIO/projeto-devops-docker/settings/secrets/actions`
2. Clique em "New repository secret"
3. Adicione cada secret com seu respectivo valor
4. Salve

### Configuração Inicial do Servidor

Antes do primeiro deploy, você precisa configurar o servidor manualmente. Este guia foi testado em **Oracle Linux 9** com **VM.Standard.E2.1.Micro** (1 OCPU, 1GB RAM).

#### 1. Conectar ao servidor via SSH

```bash
ssh -i ~/.ssh/sua-chave.pem opc@IP_DO_SERVIDOR
```

#### 2. Criar Swap (IMPORTANTE para VMs com pouca memória)

VMs com 1GB de RAM precisam de swap para evitar que processos sejam "Killed" por falta de memória:

```bash
# Criar arquivo de swap de 2GB
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Tornar o swap permanente
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Verificar
free -h
```

#### 3. Instalar Git, Podman e Docker Compose

**Para Oracle Linux 9** (usa Podman como emulador do Docker):

```bash
# Instalar Git (com repositórios limitados para economizar memória)
sudo dnf install git --disablerepo="*" --enablerepo="ol9_baseos*" --enablerepo="ol9_appstream*" -y

# Instalar Podman (emula Docker)
sudo dnf install docker --disablerepo="*" --enablerepo="ol9_baseos*" --enablerepo="ol9_appstream*" -y

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalações
git --version
docker --version
docker-compose --version
```

#### 4. Habilitar Socket do Podman (IMPORTANTE)

O Podman precisa do socket habilitado para funcionar com docker-compose:

```bash
# Habilitar lingering (permite serviços do usuário sem login)
sudo loginctl enable-linger opc

# Habilitar o socket do Podman
systemctl --user enable --now podman.socket

# Verificar se está funcionando
systemctl --user status podman.socket
docker ps
```

#### 5. Adicionar Chave SSH do GitHub Actions

Adicione a chave pública que será usada pelo GitHub Actions ao arquivo `authorized_keys`:

```bash
cat >> ~/.ssh/authorized_keys << 'EOF'
SUA_CHAVE_PUBLICA_AQUI
EOF
```

#### 6. Clonar o Repositório

```bash
cd ~
git clone https://github.com/jvarb1/projeto-devops-docker.git
cd projeto-devops-docker
```

#### 7. Criar arquivo `.env` de produção

```bash
cat > .env << 'EOF'
DB_NAME=taskdb
DB_USER=taskuser
DB_PASSWORD=SenhaSegura123
DB_PORT=5432
APP_PORT=8000
DOCKER_USERNAME=jvarb1
IMAGE_TAG=latest
EOF
```

> ⚠️ **IMPORTANTE**: Este arquivo contém senhas e NÃO deve ser commitado no repositório!

#### 8. Testar manualmente (primeira vez)

```bash
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml ps
```

### Observações Importantes para Oracle Linux 9

1. **Podman vs Docker**: Oracle Linux 9 usa Podman como substituto do Docker. O pacote `podman-docker` fornece compatibilidade com comandos `docker`.

2. **Socket do Podman**: É necessário habilitar `podman.socket` para que o docker-compose funcione corretamente.

3. **Lingering**: O comando `loginctl enable-linger` permite que os serviços do usuário continuem rodando mesmo após logout.

4. **Swap**: VMs com pouca memória (1GB) precisam de swap para evitar que o OOM Killer mate processos durante instalações.

5. **Locale do PostgreSQL**: O arquivo `docker-compose.prod.yml` usa `--locale=C` em vez de `pt_BR.UTF-8` porque a imagem Alpine não possui locales brasileiros.

### Estrutura do Pipeline

```
Push para main
    ↓
[1] Testes Unitários
    ├─ Instala dependências
    ├─ Executa pytest
    └─ ✅ Passa ou ❌ Falha
    ↓ (se passar)
[2] Build & Push Docker
    ├─ Build da imagem
    ├─ Tag com SHA do commit
    └─ Push para Docker Hub
    ↓ (se sucesso)
[3] Deploy Automático
    ├─ SSH no servidor
    ├─ Git pull
    ├─ Pull da nova imagem
    └─ Restart dos containers
    ↓
✅ Aplicação atualizada!
```

### Executar Testes Localmente

Para executar os testes antes de fazer push:

```bash
# Instalar dependências de teste
pip install -r requirements.txt

# Executar todos os testes
pytest tests/ -v

# Executar um teste específico
pytest tests/test_tasks.py::test_create_task -v
```

### Monitoramento do Pipeline

- Acesse a aba **Actions** no GitHub para ver o status do pipeline
- Badge de status no topo do README mostra o status atual
- Logs detalhados disponíveis em cada execução do workflow

## 📝 Notas Adicionais

- A aplicação cria automaticamente as tabelas no primeiro acesso via SQLAlchemy
- Logs são exibidos em tempo real via `docker-compose logs`
- Health checks garantem que a aplicação só inicie quando o banco estiver pronto
- O pipeline de CI/CD garante que apenas código testado seja deployado em produção
- Em produção, usamos Podman como runtime de containers (compatível com Docker)
- O deploy é feito automaticamente a cada push na branch `main`

## 🔧 Troubleshooting de Deploy

### Erro: "Killed" durante instalação de pacotes
**Causa**: VM com pouca memória (OOM Killer)
**Solução**: Criar swap de 2GB conforme instruções acima

### Erro: "Cannot connect to Docker daemon" com Podman
**Causa**: Socket do Podman não está habilitado
**Solução**: 
```bash
sudo loginctl enable-linger $USER
systemctl --user enable --now podman.socket
```

### Erro: "Permission denied" no init-db.sql
**Causa**: Podman rootless tem restrições de permissão em volumes
**Solução**: O arquivo `docker-compose.prod.yml` não monta o `init-db.sql` em produção

### Erro: Locale "pt_BR.UTF-8" não encontrado
**Causa**: Imagem Alpine do PostgreSQL não possui locales brasileiros
**Solução**: Usamos `--locale=C` no `docker-compose.prod.yml`

## 🤝 Contribuindo

Este é um projeto acadêmico desenvolvido para demonstrar conhecimentos em Docker e DevOps.

## 📄 Licença

Este projeto é para fins acadêmicos.

**Desenvolvido por:**

**João Victor Araujo Rocha Brito | SI - IFAL Arapiraca | Desenvolvedor CDBAR Ambev**

