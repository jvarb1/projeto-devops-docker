# Projeto DevOps - Ambiente Multi-Container com Docker

Este projeto implementa uma aplicação CRUD completa utilizando FastAPI e PostgreSQL, configurada com Docker Compose, volumes persistentes, rede customizada e variáveis de ambiente.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Configuração](#configuração)
- [Executando a Aplicação](#executando-a-aplicação)
- [Testando a API](#testando-a-api)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Recursos Implementados](#recursos-implementados)
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
┌─────────────────────────────────────────────────┐
│           Docker Compose Network                │
│              (taskapp-network)                  │
│                                                 │
│  ┌──────────────┐       ┌──────────────┐       │
│  │              │       │              │       │
│  │   API App    │◄──────┤  PostgreSQL  │       │
│  │  (FastAPI)   │       │  (db:5432)   │       │
│  │  Port: 8000  │       │              │       │
│  │              │       │              │       │
│  └──────────────┘       └──────────────┘       │
│         │                        │              │
│         │                        │              │
│         └────────┬───────────────┘              │
│                  │                              │
│            Volume Mounts                       │
│  ┌─────────────────────────────────────────┐  │
│  │  postgres_data: /var/lib/postgresql/data │  │
│  └─────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
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

## 📝 Notas Adicionais

- A aplicação cria automaticamente as tabelas no primeiro acesso
- O banco é inicializado com o script `init-db.sql` na primeira criação
- Logs são exibidos em tempo real via `docker-compose logs`
- Health checks garantem que a aplicação só inicie quando o banco estiver pronto

## 🤝 Contribuindo

Este é um projeto acadêmico desenvolvido para demonstrar conhecimentos em Docker e DevOps.

## 📄 Licença

Este projeto é para fins acadêmicos.

---

**Desenvolvido para o curso de DevOps** | **2024**

